/**
 * This is the Apps Script write using 'tools > Apps Script'
 * from the Slide google file UI.
 * You must to create a 'Service Account Credential JSON(JWT)'
 * and also add the email on the 'Service Account Details' on the
 * Google console as editor of the Slide File.
 */
const DEFAULT_SLIDE_ID = "1BsDnE-ikCmO2-vX1nulAuMX2aQomkUi2Eorblo04zNs";

/**
 * Web App endpoint to update text content of a specific shape on a Google Slide.
 *
 * @param {Object} e - The request event object.
 * @return {ContentService.Output} The JSON response.
 */
function doPost(e) {
  var params = JSON.parse(e.postData.contents);

  // Check if required parameters are provided
  if (!params.slideId || !params.shapeId || !params.newText) {
    console.log("slide id ==> ", params);
    return ContentService.createTextOutput(
      JSON.stringify({
        error: "Missing required parameters",
        parameters: params
      })
    ).setMimeType(ContentService.MimeType.JSON);
  }

  // Get parameters from the request
  var slideId = params.slideId;
  var shapeId = params.shapeId;
  var newText = params.newText;

  try {
    // Open the Google Slides file by its ID
    var slideFile = SlidesApp.openById(DEFAULT_SLIDE_ID);

    // Get the slide and the shape
    var slide = slideFile.getSlides()[0]; // Assuming the shape is on the first slide
    var shape = slide.getShapes()[0];

    if (shape) {
      // Update the text content of the shape
      shape.getText().setText(newText);

      // Return success response
      return ContentService.createTextOutput(
        JSON.stringify({ status: "success", message: "Text content updated" })
      ).setMimeType(ContentService.MimeType.JSON);
    } else {
      return ContentService.createTextOutput(
        JSON.stringify({ error: "Shape not found" })
      ).setMimeType(ContentService.MimeType.JSON);
    }
  } catch (error) {
    return ContentService.createTextOutput(
      JSON.stringify({ error: "error.message" })
    ).setMimeType(ContentService.MimeType.JSON);
  }
}

/**
 * Set up the Google Apps Script project to serve as a web app.
 */
function doGet() {
  try {
    // Open the Google Slides file by its ID
    var slideFile = SlidesApp.openById(DEFAULT_SLIDE_ID);

    // Get the slide and the shape
    var slide = slideFile.getSlides()[0]; // Assuming the shape is on the first slide
    var shape = slide.getShapes()[0];

    if (shape) {
      // Update the text content of the shape
      let headerText = shape.getText().asString();
      headerText = headerText.slice(0, headerText.length - 1);

      // Return success response
      return ContentService.createTextOutput()
        .setMimeType(ContentService.MimeType.JSON)
        .append(
          JSON.stringify({
            status: "success",
            message: "Slide header retrieved",
            data: { header: headerText }
          })
        );
    } else {
      return ContentService.createTextOutput(
        JSON.stringify({ error: "Shape not found" })
      ).setMimeType(ContentService.MimeType.JSON);
    }
  } catch (error) {
    return ContentService.createTextOutput(
      JSON.stringify({ error: error.message })
    ).setMimeType(ContentService.MimeType.JSON);
  }
}
