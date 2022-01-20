part of charts_ui.view;

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _searchController = TextEditingController();
  String? currentSearch;
  int _assetLimit = 20;

  bool get _isSearchOpen => currentSearch != null && currentSearch!.isNotEmpty;

  Widget get _errorWidget => const Center(
        child: Text('Failed to load asset data'),
      );

  Widget get _loadingWidget => const Center(
        child: CircularProgressIndicator(),
      );

  List<Widget> get _actions {
    if (_isSearchOpen) {
      return [
        IconButton(
          onPressed: () {
            setState(() {
              currentSearch = null;
            });
          },
          icon: const Icon(Icons.close),
        ),
      ];
    } else {
      return [
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => CryptoSearchModal(
                controller: _searchController,
                onSearch: () => setState(() {
                  currentSearch = _searchController.text.trim();
                  _searchController.text = '';
                }),
              ),
            );
          },
          icon: const Icon(Icons.search),
        ),
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => CryptoSettingsModal(
                assetLimit: _assetLimit.toDouble(),
                onSave: (int value) => setState(
                  () {
                    _assetLimit = value;
                  },
                ),
              ),
            );
          },
          icon: const Icon(Icons.more_vert_rounded),
        )
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        AsyncValue<List<Asset>> assets = _isSearchOpen
            ? ref.watch(assetSearchProvider(currentSearch!))
            : ref.watch(assetsProvider(_assetLimit));
        return Scaffold(
          appBar: AppBar(
            title: const Text('Crypto Assets'),
            leading: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.menu_rounded),
            ),
            actions: _actions,
          ),
          body: assets.when(
            data: (List<Asset> list) {
              if (list.isNotEmpty) {
                String assetNames = List.generate(
                  list.length,
                  (idx) => list[idx].id.toLowerCase(),
                ).join(',');
                ref.read(selectedAssetNames.notifier).state = assetNames;
                AsyncValue<Map<String, dynamic>> prices =
                    ref.watch(rtAssetsProvider(assetNames));
                return prices.when(
                  data: (rtData) {
                    return RefreshIndicator(
                      child: ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, idx) {
                          Asset asset = list[idx];
                          return AssetCard(
                            key: ValueKey<int>(idx),
                            asset: asset,
                            price: num.tryParse(
                                rtData[asset.id.toLowerCase()] ?? ''),
                          );
                        },
                      ),
                      onRefresh: () async {
                        assets = ref.refresh(_isSearchOpen
                            ? assetSearchProvider(currentSearch!)
                            : assetsProvider(_assetLimit));
                      },
                    );
                  },
                  error: (err, stack) {
                    debugPrint(err.toString());
                    debugPrint(stack.toString());
                    return _errorWidget;
                  },
                  loading: () => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _loadingWidget,
                      const SizedBox(height: 24),
                      const Text('Connecting to real time asset stream'),
                    ],
                  ),
                );
              } else {
                return LayoutBuilder(
                  builder: (_, BoxConstraints constraints) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: constraints.maxHeight / 6,
                        ),
                        const SizedBox(height: 4),
                        const Text('Could not find any assets with that search')
                      ],
                    ),
                  ),
                );
              }
            },
            error: (err, stack) {
              debugPrint(err.toString());
              debugPrint(stack.toString());
              return _errorWidget;
            },
            loading: () => _loadingWidget,
          ),
        );
      },
    );
  }
}
