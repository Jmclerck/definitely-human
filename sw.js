const CACHE_NAME = "definite-human-v5";
const urlsToCache = ["/", "index.html"];
self.addEventListener("install", function(event) {
  self.skipWaiting();
  event.waitUntil(
    caches
      .keys()
      .then(keys =>
        Promise.all(
          keys.map(key => {
            if (!CACHE_NAME.includes(key)) {
              return caches.delete(key);
            }
          })
        )
      )
      .then(() =>
        caches.open(CACHE_NAME).then(cache => {
          return cache.addAll(urlsToCache);
        })
      )
  );
});
self.addEventListener("fetch", event => {
  event.respondWith(
    caches.match(event.request).then(response => {
      if (response) {
        return response;
      }
      return fetch(event.request).then(response => {
        if (!response || !response.ok) {
          return response;
        }
        const responseToCache = response.clone();
        caches.open(CACHE_NAME).then(cache => {
          cache.put(event.request, responseToCache);
        });
        return response;
      });
    })
  );
});