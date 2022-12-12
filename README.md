# Simple iOS App (Assessment Application)
The SimpleiOSApp is an application built for a coding assessment .

## Project Description
This Application makes requests for user data from the GitHub API. It helps to easily fetch user profile names, their avatar_urls and the type for the user.

## Architectural Decision
The MVC Pattern was used in the design of this application. The containing folders and files in the repository are structured in groups following the MVC pattern.

The Resources folder contains the APICaller Class which handles network calls for fetching the data from GitHub API. The class has internal variables that keep track of instances where it has been called and seeing that there's only one instance needed in the whole application, several functions have been included in the class to keep track of the network calls. The first is the page count function that keeps track of the number of times the function is called during a scrollview in order to make more network requests to the API for loading more pages. This class can be refactored to a singleton. The second is the increasePageCount function to ensure that more pages are loaded conditionally. And the resetPageCount which is initiated when the view has been popped from the ResultsViewController navigation to the MainViewController.

The Model folder contains the Struct for Decoding JSON and a Constants Struct File which holds the base class for the network call.

The Views Folder Manages the ResultTableViewCell for the tableView dequeReusable cell and contains the configuration function (configure cell with model:) for each cell according to the SearchResults Model. The Views Folder also contains the DetailsHeader view for the DetailsTableView in the DetailsViewController. This handles the configuration for the headerView of the DetailsTableView using the SearchResults Model. The DetailsTableViewCell handles configuration for the DetailsViewTableView in the DeatailsViewController.

The Controllers Folder handles all the Controller files that supply the views data according to the SearchResults Model received form Network calls


## Unit Tests
The Unit Tests have been written to ensure that the network calls which are a major functionality for the application do what is required according to the various functionalities in them - each step of the network call process


## Download
Clone this repository using the bash:
```bash
git clone git@github.com:Temitayo65/LPAssessment.git
```

Or download the zip file from:  [github.com/Temitayo65/LPAssessment.git](https://github.com/Temitayo65/LPAssessment.git)

## Usage
After download, build and run the Application on your Xcode IDE

## Contributing
Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
MIT License

Copyright (c) 2022 LPAssessment

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
