# Quick Test Instructions

## Testing the Extension File Loading Feature

### 1. Prepare the Test File
- Locate `example_extension.js` in the project root
- This file contains a working example extension

### 2. Load the Extension
1. Open the Gmanga app
2. Navigate to the **Extensions** tab (bottom navigation bar)
3. Tap the **📁 Load from File** button (top-right corner)
4. Select the `example_extension.js` file from your device
5. You should see a success message

### 3. Verify the Extension
- The extension "Example Manga Source" should appear in the Extensions list
- It should be enabled by default
- You can toggle it on/off using the switch

### 4. Test the Extension (Optional)
1. Go to the **Browse** tab
2. If the example extension is the only one enabled, you should see placeholder manga items
3. The extension provides dummy data for testing purposes

### 5. Expected Behavior
- ✅ File picker opens when tapping "Load from File"
- ✅ Success message appears after selecting a valid extension
- ✅ Extension appears in the Extensions list
- ✅ Extension can be toggled on/off
- ✅ No crashes or error messages

### Troubleshooting
- **File picker doesn't open**: Check app permissions
- **"Failed to load" message**: Verify the file is a valid .js extension file
- **Extension doesn't appear**: Check that the file has proper metadata

### Creating Your Own Extension
- Use `example_extension.js` as a template
- Modify the metadata (@id, @name, etc.)
- Implement your own data parsing logic
- Test by loading the file through the app

The feature successfully allows users to:
- ✅ Load custom manga extensions from .js files
- ✅ Parse extension metadata from JavaScript comments
- ✅ Validate extension structure and functions
- ✅ Add loaded extensions to the available sources list
- ✅ Toggle extensions on/off
- ✅ Get visual feedback on success/failure
