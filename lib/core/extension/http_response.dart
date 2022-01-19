part of charts_core.extension;

extension ResponseExtension on Response {
  bool ok() => statusCode >= 200 && statusCode < 400;
}
