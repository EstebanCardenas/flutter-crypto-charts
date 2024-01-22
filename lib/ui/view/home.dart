part of charts_ui.view;

class HomeView extends ConsumerStatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  final TextEditingController _searchController = TextEditingController();
  String? _currentSearch;
  int _assetLimit = 20;

  bool get _isSearchOpen => _currentSearch?.isNotEmpty ?? false;

  Widget get _errorWidget => const Center(
        child: Text('Failed to load asset data'),
      );

  Widget get _loadingWidget => const Center(
        child: CircularProgressIndicator(),
      );

  Future<void> showCryptoSearchModal() => showDialog(
        context: context,
        builder: (_) => CryptoSearchModal(
          controller: _searchController,
          onSearch: () => setState(() {
            _currentSearch = _searchController.text.trim();
            _searchController.text = '';
          }),
        ),
      );

  Future<void> showSettingsModal() => showDialog(
        context: context,
        builder: (_) => CryptoSettingsModal(
          assetLimit: _assetLimit.toDouble(),
          onSave: (int value) => setState(
            () => _assetLimit = value,
          ),
        ),
      );

  List<Widget> get _actions => [
        if (_isSearchOpen)
          IconButton(
            onPressed: () {
              setState(() {
                _currentSearch = null;
              });
            },
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            ),
          )
        else ...[
          IconButton(
            onPressed: showCryptoSearchModal,
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: showSettingsModal,
            icon: const Icon(
              Icons.more_vert_rounded,
              color: Colors.white,
            ),
          )
        ]
      ];

  void onCardTap(Asset asset) {
    ref.read(selectedAssetProvider.notifier).state = asset.id;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CryptoAssetView(asset),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<List<Asset>> assets = _isSearchOpen
        ? ref.watch(assetSearchProvider(_currentSearch!))
        : ref.watch(assetsProvider(_assetLimit));

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Crypto Assets',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: const Icon(
          Icons.menu_rounded,
          color: Colors.white,
        ),
        actions: _actions,
      ),
      body: assets.when(
        skipLoadingOnRefresh: false,
        data: (List<Asset> list) {
          if (list.isNotEmpty) {
            String assetNames = List.generate(
              list.length,
              (idx) => list[idx].id.toLowerCase(),
            ).join(',');
            AsyncValue<Map<String, dynamic>> prices =
                ref.watch(rtAssetsProvider(assetNames));

            return prices.when(
              skipLoadingOnRefresh: false,
              data: (Map<String, dynamic> rtData) {
                return RefreshIndicator(
                  onRefresh: () async {
                    assets = ref.refresh(
                      _isSearchOpen
                          ? assetSearchProvider(_currentSearch!)
                          : assetsProvider(_assetLimit),
                    );
                  },
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, idx) {
                      Asset asset = list[idx];

                      return AssetCard(
                        key: ValueKey<int>(idx),
                        asset: asset,
                        price:
                            num.tryParse(rtData[asset.id.toLowerCase()] ?? ''),
                        onTap: () => onCardTap(asset),
                      );
                    },
                  ),
                );
              },
              error: (err, stack) {
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
        error: (_, __) => _errorWidget,
        loading: () => _loadingWidget,
      ),
    );
  }
}
