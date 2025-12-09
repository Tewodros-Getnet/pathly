class YoutubeHelper {
  /// Extract clean video ID from any YouTube link
  static String extractVideoId(String url) {
    try {
      if (url.contains("youtu.be/")) {
        return url.split("youtu.be/")[1].split("?")[0];
      }
      if (url.contains("watch?v=")) {
        return url.split("v=")[1].split("&")[0];
      }
      if (url.contains("shorts/")) {
        return url.split("shorts/")[1].split("?")[0];
      }
      if (url.contains("/embed/")) {
        return url.split("/embed/")[1].split("?")[0];
      }
    } catch (_) {}

    return ""; // fallback
  }

  /// Thumbnail URL
  static String thumbnailUrl(String url) {
    final id = extractVideoId(url);
    return "https://img.youtube.com/vi/$id/hqdefault.jpg";
  }
}
