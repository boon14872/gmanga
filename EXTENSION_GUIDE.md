# Extension File Loading Guide

## Overview

The Gmanga app now supports loading custom manga extensions from JavaScript files. This allows you to add new manga sources without rebuilding the app.

## How to Load Extensions

### Method 1: Using the Extensions Screen

1. Open the Gmanga app
2. Navigate to the **Extensions** tab (bottom navigation)
3. Tap the **📁 Load from File** button in the top-right corner
4. Select your `.js` extension file from your device
5. The extension will be parsed and added to your available sources

### Method 2: File Requirements

Your extension file must be a `.js` (JavaScript) file with the following:

#### Required Metadata (at the top of the file)
```javascript
/**
 * @id your_extension_id
 * @name Your Extension Name
 * @version 1.0.0
 * @lang en
 * @author Your Name
 * @description Brief description of your extension
 */
```

#### Required Functions
Your extension must implement these core functions:

1. **Constructor Function**
```javascript
function YourExtensionSource() {
  this.baseUrl = 'https://your-manga-site.com';
}
```

2. **getPopularUrl** (Required)
```javascript
YourExtensionSource.prototype.getPopularUrl = function(page) {
  return JSON.stringify({ url: this.baseUrl + '/popular?page=' + page });
};
```

3. **parsePopular** (Required)  
```javascript
YourExtensionSource.prototype.parsePopular = function(httpResponse, page) {
  // Parse the HTTP response and return manga list
  var mangaList = [
    {
      id: 'manga-1',
      title: 'Manga Title',
      thumbnailUrl: 'https://example.com/thumbnail.jpg'
    }
  ];
  return JSON.stringify(mangaList);
};
```

## Example Extension File

See `example_extension.js` in the project root for a complete working example that demonstrates:

- ✅ Proper metadata format
- ✅ Required functions (getPopularUrl, parsePopular)
- ✅ Optional functions (getLatestUrl, parseLatest, getSearchUrl, etc.)
- ✅ Error handling
- ✅ HTTP headers configuration
- ✅ Sample data for testing

## Testing Your Extension

1. **Use the Example**: Start with `example_extension.js` and modify it for your source
2. **Test Metadata**: Ensure your metadata block is properly formatted
3. **Test Functions**: Verify getPopularUrl and parsePopular work correctly
4. **Load in App**: Use the file loading feature to test your extension

## Optional Functions

You can implement additional functions for more features:

- **getLatestUrl / parseLatest**: For latest manga updates
- **getSearchUrl / parseSearch**: For search functionality  
- **getDetailsUrl / parseDetails**: For detailed manga information
- **getChaptersUrl / parseChapters**: For chapter lists
- **getPagesUrl / parsePages**: For reading pages
- **getHttpHeaders**: For custom HTTP headers

## Troubleshooting

### Extension Not Loading
- ✅ Check file extension is `.js`
- ✅ Verify metadata block exists and is properly formatted
- ✅ Ensure required functions (getPopularUrl, parsePopular) are present
- ✅ Check JavaScript syntax for errors

### Extension Appears but Doesn't Work
- ✅ Test your URLs manually in a browser
- ✅ Check that parsePopular returns valid JSON
- ✅ Verify your HTTP responses match expected format
- ✅ Look at console logs for JavaScript errors

### Common Issues
1. **Missing @id in metadata**: Extension ID is required
2. **Missing @name in metadata**: Extension name is required  
3. **Missing @version in metadata**: Version is required
4. **Syntax errors**: Check your JavaScript syntax
5. **Wrong return format**: Functions must return JSON strings

## Extension Format Reference

### Metadata Fields
- `@id` (Required): Unique identifier (e.g., "my_manga_source")
- `@name` (Required): Display name (e.g., "My Manga Source")
- `@version` (Required): Version number (e.g., "1.0.0")
- `@lang` (Optional): Language code (default: "en")
- `@author` (Optional): Your name
- `@description` (Optional): Brief description

### Function Return Formats

**getPopularUrl, getLatestUrl, getSearchUrl, etc.**
```javascript
return JSON.stringify({ url: "https://example.com/api" });
```

**parsePopular, parseLatest, parseSearch**
```javascript
return JSON.stringify([
  {
    id: "manga-id",
    title: "Manga Title", 
    thumbnailUrl: "https://example.com/thumb.jpg"
  }
]);
```

**parseDetails**
```javascript
return JSON.stringify({
  id: "manga-id",
  title: "Manga Title",
  description: "Description...",
  author: "Author Name",
  status: "Ongoing"
});
```

**parseChapters**
```javascript
return JSON.stringify([
  {
    id: "chapter-id",
    title: "Chapter 1",
    number: 1,
    uploadDate: "2025-01-01T00:00:00.000Z"
  }
]);
```

**parsePages**
```javascript
return JSON.stringify([
  "https://example.com/page1.jpg",
  "https://example.com/page2.jpg"
]);
```

## Security Note

Only load extension files from trusted sources. Extensions can execute JavaScript code, so ensure you trust the source of any extension files you load.

## Need Help?

If you're having trouble creating or loading extensions:

1. Start with the provided `example_extension.js`
2. Check the console logs when testing your extension
3. Verify your extension follows the exact format shown in examples
4. Test each function individually to isolate issues
