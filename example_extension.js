/**
 * Example Manga Extension for Gmanga
 * @id example_manga
 * @name Example Manga Source
 * @version 1.0.0
 * @lang en
 * @author Your Name
 * @description A template extension for testing file loading functionality
 */

// Extension Constructor
function ExampleMangaSource() {
  this.baseUrl = 'https://api.example.com';
  this.name = 'Example Manga Source';
}

// HTTP Headers (optional)
ExampleMangaSource.prototype.getHttpHeaders = function (url) {
  try {
    var headers = {
      'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
      'Accept': 'application/json, text/plain, */*',
      'Accept-Language': 'en-US,en;q=0.9'
    };
    return JSON.stringify(headers);
  } catch (e) {
    console.log('Error in getHttpHeaders:', e.message);
    return JSON.stringify({});
  }
};

// Get Popular Manga URL (Required)
ExampleMangaSource.prototype.getPopularUrl = function (page) {
  try {
    console.log('ExampleManga getPopularUrl called with page:', page);
    var url = this.baseUrl + '/popular?page=' + page;
    console.log('ExampleManga URL:', url);
    return JSON.stringify({ url: url });
  } catch (e) {
    console.log('Error in getPopularUrl:', e.message);
    return JSON.stringify({ url: '' });
  }
};

// Parse Popular Manga Response (Required)
ExampleMangaSource.prototype.parsePopular = function (httpResponse, page) {
  try {
    console.log('ExampleManga parsePopular called with page:', page);
    console.log('HTTP response received, length:', httpResponse.length);
    
    // Example: Return some dummy data for testing
    var mangaList = [
      {
        id: 'example-manga-1',
        title: 'Example Manga Title 1',
        thumbnailUrl: 'https://via.placeholder.com/300x400/FF6B6B/FFFFFF?text=Manga+1'
      },
      {
        id: 'example-manga-2',
        title: 'Example Manga Title 2',
        thumbnailUrl: 'https://via.placeholder.com/300x400/4ECDC4/FFFFFF?text=Manga+2'
      },
      {
        id: 'example-manga-3',
        title: 'Example Manga Title 3',
        thumbnailUrl: 'https://via.placeholder.com/300x400/45B7D1/FFFFFF?text=Manga+3'
      }
    ];
    
    console.log('SUCCESS: Returning', mangaList.length, 'manga items from ExampleManga');
    return JSON.stringify(mangaList);
  } catch (e) {
    console.log('Error in parsePopular:', e.message);
    return JSON.stringify([]);
  }
};

// Get Latest Manga URL (Optional)
ExampleMangaSource.prototype.getLatestUrl = function (page) {
  try {
    console.log('ExampleManga getLatestUrl called with page:', page);
    var url = this.baseUrl + '/latest?page=' + page;
    return JSON.stringify({ url: url });
  } catch (e) {
    console.log('Error in getLatestUrl:', e.message);
    return JSON.stringify({ url: '' });
  }
};

// Parse Latest Manga Response (Optional)
ExampleMangaSource.prototype.parseLatest = function (httpResponse, page) {
  try {
    console.log('ExampleManga parseLatest called with page:', page);
    
    // Return same dummy data as popular for simplicity
    return this.parsePopular(httpResponse, page);
  } catch (e) {
    console.log('Error in parseLatest:', e.message);
    return JSON.stringify([]);
  }
};

// Get Search URL (Optional)
ExampleMangaSource.prototype.getSearchUrl = function (query, page) {
  try {
    console.log('ExampleManga getSearchUrl called with query:', query, 'page:', page);
    var encodedQuery = encodeURIComponent(query);
    var url = this.baseUrl + '/search?q=' + encodedQuery + '&page=' + page;
    return JSON.stringify({ url: url });
  } catch (e) {
    console.log('Error in getSearchUrl:', e.message);
    return JSON.stringify({ url: '' });
  }
};

// Parse Search Results (Optional)
ExampleMangaSource.prototype.parseSearch = function (httpResponse, query, page) {
  try {
    console.log('ExampleManga parseSearch called with query:', query, 'page:', page);
    
    // Return filtered dummy data for search
    var searchResults = [
      {
        id: 'search-result-1',
        title: 'Search Result: ' + query + ' #1',
        thumbnailUrl: 'https://via.placeholder.com/300x400/FF9999/FFFFFF?text=Search+1'
      }
    ];
    
    return JSON.stringify(searchResults);
  } catch (e) {
    console.log('Error in parseSearch:', e.message);
    return JSON.stringify([]);
  }
};

// Get Manga Details URL (Optional)
ExampleMangaSource.prototype.getDetailsUrl = function (mangaId) {
  try {
    console.log('ExampleManga getDetailsUrl called for ID:', mangaId);
    var url = this.baseUrl + '/manga/' + mangaId;
    return JSON.stringify({ url: url });
  } catch (e) {
    console.log('Error in getDetailsUrl:', e.message);
    return JSON.stringify({ url: '' });
  }
};

// Parse Manga Details (Optional)
ExampleMangaSource.prototype.parseDetails = function (httpResponse, mangaId) {
  try {
    console.log('ExampleManga parseDetails called for ID:', mangaId);
    
    var details = {
      id: mangaId,
      title: 'Example Manga Details',
      description: 'This is an example manga created for testing the extension loading system.',
      author: 'Test Author',
      artist: 'Test Artist',
      status: 'Ongoing',
      genres: ['Action', 'Adventure', 'Comedy'],
      thumbnailUrl: 'https://via.placeholder.com/300x400/96CEB4/FFFFFF?text=Details'
    };
    
    return JSON.stringify(details);
  } catch (e) {
    console.log('Error in parseDetails:', e.message);
    return JSON.stringify({});
  }
};

// Get Chapters URL (Optional)
ExampleMangaSource.prototype.getChaptersUrl = function (mangaId) {
  try {
    console.log('ExampleManga getChaptersUrl called for ID:', mangaId);
    var url = this.baseUrl + '/manga/' + mangaId + '/chapters';
    return JSON.stringify({ url: url });
  } catch (e) {
    console.log('Error in getChaptersUrl:', e.message);
    return JSON.stringify({ url: '' });
  }
};

// Parse Chapters List (Optional)
ExampleMangaSource.prototype.parseChapters = function (httpResponse, mangaId) {
  try {
    console.log('ExampleManga parseChapters called for ID:', mangaId);
    
    var chapters = [
      {
        id: mangaId + '/chapter-1',
        title: 'Chapter 1: The Beginning',
        number: 1,
        uploadDate: new Date().toISOString()
      },
      {
        id: mangaId + '/chapter-2',
        title: 'Chapter 2: The Adventure Continues',
        number: 2,
        uploadDate: new Date().toISOString()
      }
    ];
    
    return JSON.stringify(chapters);
  } catch (e) {
    console.log('Error in parseChapters:', e.message);
    return JSON.stringify([]);
  }
};

// Get Pages URL (Optional)
ExampleMangaSource.prototype.getPagesUrl = function (chapterId) {
  try {
    console.log('ExampleManga getPagesUrl called for chapter:', chapterId);
    var url = this.baseUrl + '/chapter/' + chapterId + '/pages';
    return JSON.stringify({ url: url });
  } catch (e) {
    console.log('Error in getPagesUrl:', e.message);
    return JSON.stringify({ url: '' });
  }
};

// Parse Pages (Optional)
ExampleMangaSource.prototype.parsePages = function (httpResponse, chapterId) {
  try {
    console.log('ExampleManga parsePages called for chapter:', chapterId);
    
    var pages = [
      'https://via.placeholder.com/800x1200/FFB3BA/000000?text=Page+1',
      'https://via.placeholder.com/800x1200/BAFFC9/000000?text=Page+2',
      'https://via.placeholder.com/800x1200/BAE1FF/000000?text=Page+3',
      'https://via.placeholder.com/800x1200/FFFFBA/000000?text=Page+4',
      'https://via.placeholder.com/800x1200/FFDFBA/000000?text=Page+5'
    ];
    
    return JSON.stringify(pages);
  } catch (e) {
    console.log('Error in parsePages:', e.message);
    return JSON.stringify([]);
  }
};

// Utility function for safe JSON parsing (Optional)
ExampleMangaSource.prototype._safeParse = function (txt) {
  try {
    return JSON.parse(txt);
  } catch (e) {
    console.log('JSON parse error:', e.message);
    return null;
  }
};

// Status mapping utility (Optional)
ExampleMangaSource.prototype._status = function (code) {
  switch (String(code)) {
    case '1': return 'Ongoing';
    case '2': return 'Completed';
    case '3': return 'Hiatus';
    default: return 'Unknown';
  }
};
