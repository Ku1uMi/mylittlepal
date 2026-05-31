1. Identify which of the course topics you applied (e.g. secure data persistence) and describe how you applied them. In addition to the list of topics enumerated above, you must also describe how your app design reflects what you learned about the design principles we discussed in our Inclusive Design lecture (Lecture 9: Designing for Accessibility)

* State Management (Provider): We used the `Provider` package to separate our app's logic from the UI. `PetProvider` holds the data and uses `notifyListeners()` to tell the app when to refresh the screen, saving us from passing data manually through every single widget.

* Saving Data (SharedPreferences): To keep the pet's progress from deleting when the app closes, we used `SharedPreferences`. We turn the pet's data into JSON text (`toJson()`) and save it to the device so your coins, items, and outfits are still there when you reopen the app.

* Async Code & APIs: Loading files, checking location coordinates (`geolocator`), and grabbing data from the weather API take time. We used `Future` and async code to handle these tasks in the background so the app doesn't freeze while waiting for data.

* Timers: We used `Timer.periodic` to run a clock loop every 10 minutes in the background. This automatically lowers the pet's health and happiness stats over time even if the player isn't actively pressing buttons.

* *Layouts and Stacking: To put clothes on our pet, we layered multiple pixel-art images directly on top of each other using `Stack` and `Positioned.fill`. We used `FilterQuality.none` to keep the pixel art looking crisp and sharp.

2. Cite anything (website or other resource) or anyone that assisted you in creating your solution to this assignment, Remember to include all resources you used to solve this assignment.
You do not need to include links to lecture/section material or flutter docs. However you do need to mention which Flutter classes or packages you viewed.
You must include links to all StackOverflow, Medium, blogs, or other articles you used.

I have read the doc about TimeOfDay class, clamp method, shared prederences, cancel method, changenotifierprovider,copywith method, ui library, FractionallySizedBox, SafeArea class, SizedBox, adaptice_action_sheet, MainMxisAlignment, showModalBottomSheet, Overlay, onPan, RenderBox,rootBundle, LayoutBuilder, ValueListenableBuilder, internalization, ThemeData, Navigation and routing, 
List of links: 
https://www.geeksforgeeks.org/flutter/read-and-write-data-in-flutter-using-sharedpreferences/
https://stackoverflow.com/questions/49952901/flutter-timer-issue-during-testing 
https://stackoverflow.com/questions/72876222/flutter-positioning-multiple-widgets-or-images
https://codewithandrea.com/tips/stack-fractionally-sized-box/ 
https://stackoverflow.com/questions/53850149/flutter-crossaxisalignment-vs-mainaxisalignment
https://codewithandrea.com/articles/parse-json-dart/ 
https://medium.com/@enrico.ori/getting-to-know-flutter-advanced-use-of-modalbottomsheet-38e5ef55d561
https://stackoverflow.com/questions/51609421/how-to-use-rootbundle-in-flutter-to-load-images
https://stackoverflow.com/questions/51609421/how-to-use-rootbundle-in-flutter-to-load-images 
https://pub.dev/packages/geolocator 
https://pub.dev/packages/weather
https://medium.com/@debjeetdas1012/valuenotifier-valuelistenablebuilder-in-flutter-6b1fe7b9b025
https://medium.com/@wassimsakri/understanding-widgetsbinding-instance-addpostframecallback-in-flutter-86860d5266ff
https://flutteris.com/blog/en/addpostframecallback 
https://www.digitalocean.com/community/tutorials/flutter-widget-communication
https://pub.dev/packages/flutter_localization 

3. If you used any Generative AI (ChatGPT, Gemini, CodePilot, or the like), please include the prompt(s) you used and how the result was or was not helpful.
If you did not use any resources beyond classroom/flutter docs, please state so explicitly.


## 3. If you used any Generative AI (ChatGPT, Gemini, CodePilot, or the like), please include the prompt(s) you used and how the result was or was not helpful. If you did not use any resources beyond classroom/flutter docs, please state so explicitly.

Prompts:
    1. "How can I use an immutable state copy pattern in Dart to fix data updating bugs in my provider?"
    2. "What is the standard Flutter approach for changing a simple grid tap selection menu into a drag-and-drop system?"
    3. "I am getting an error because a nested object cannot find an update method. Should I change the data fields directly or make a brand new copy of the object?"
    4. "What is the difference between tracking screen touch points with an onPan gesture versus using Draggable and DragTarget widgets?"

How it Helped: The AI acted as a helpful tutor for our app's setup. It helped us think through how data should flow. It explained that changing variables directly inside an existing object stops Flutter from noticing the update, which guided us to use clean data copies instead. It also broke down why using Flutter's built-in `Draggable` and `DragTarget` widgets is much simpler and more reliable than writing our own custom pixel-tracking math with `onPan`, helping us build a much better bubble-washing experience.



4. Discuss how doing this project challenged and/or deepened each of your understanding of the technical methods or topics relevant to your project, including the six (or more) required techniques you used

This project taught us a lot about how data moves through an app. At first, we tried changing variables (like coins or clothing paths) directly inside our existing data objects. This caused bugs where the screen wouldn't update because the app didn't notice the data changed. We fixed this by learning how to make a clean copy of our data using an `.update()` method. We also learned how to handle background timers and saving functions without causing the app screen to stutter or lag.

1. Querying web services using APIs: We integrated external network endpoints using the `weather` package to fetch real-world local environmental metrics.
2. Accessing phone sensors: We leveraged geographic coordinate tracking via the `geolocator` package to bind physical device locations into our application features.
3. Data persistence: We used `SharedPreferences` along with JSON serialization (`jsonEncode`/`jsonDecode`) to safely write and load state configuration blocks directly onto local device disk storage.
4. Gesture Detection (using more than just onTap): We upgraded our clothing wardrobe layout into a drag-and-drop workflow by utilizing advanced item data payloads with custom drag detection overlays.
5. Undo and Redo:We designed an application history pipeline inside our model layout (`_state.undo` and `_state.redo`) allowing players to cycle seamlessly backward and forward through styling steps.
6. Internationalization:We added language code parsing and locale asset mapping variables to ensure our text layouts can adapt smoothly across different regional systems.


Describe what changed from your original concept to your final implementation and explain why your group made those changes from your original design vision. 

- Our original plan was to let players tap an item in a list to change their pet's clothes. When we tested it, it felt a bit boring. We decided to change it to a drag-and-drop system where you pick up a clothing item and pull it over to the pet. This required us to change our UI layout entirely, but it made dressing up the pet feel much more interactive and fun. We also added an undo/redo button so players can easily cycle back and forth through clothes they just tried on.

Areas of Future Work:

- More Clothing Slots: Right now, we only have simple tops and bottoms. We want to expand this so players can layer items like jackets over shirts, or add glasses and shoes at the same time without things overlapping

- Local Peer-to-Peer Interaction: We want to implement a local connection feature where two players can bring their pets together on the same screen using local network or Bluetooth sensors. This would allow pets to play mini-games together, share clothing items, or swap coins, making the app much more social.








