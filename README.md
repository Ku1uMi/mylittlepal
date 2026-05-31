# Documentation

**About Your Little Pal:**
This is a virtual pet mobile app that allows users to take care of their digital companion by feeding, watering, washing and playing with them. Users can also dress them and visit the shop as well. This app supports English, Spanish and Traditional Chinese.

**Build Instructions**
Installing:
Use git to clone yourlittlepal
```
git clone git@gitlab.cs.washington.edu:cse340-26sp-students/as-final-vickyh04-kachoi.git
cd yourlittlepal
flutter pub get
flutter run
```
Dependencies:
- provider: state management
- shared_preferences: data persisting pet state and setting state
- geolocator: GPS location for weather api
- http: requesting weather api
- screen_brightness: adjusting screen brightness
- flutter_localizations: in-app localization
- intl: message translation
- google_fonts: Pixelify Sans font

API:
This app uses api.weather.gov which required location permission to fetch local weather but no API key.

**Project Layout**
```bash
lib/
main.dart: route flow, theme data, setting up pet,weather and position provider
weather_checker.dart fetch weather using GPS and http 
    l10n/
    app_localizations.dart :load the right lanuage and maps Locale to currect class
    app_localizations_en.dart :English string
    app_localizations_es.dart :Spanish string
    app_localizations_zh.dart :Chinese(zh and zh_TW) string
    
    models/
    pet_state.dart : store PetType enum and all pet data
    pet_info.dart : store information like names, descriptions, favourite foods, favourite toys of each pet
    outfit.dart : store current top, current bottom and update

    providers/
    pet_provider.dart : load pet data, restore setting and start timer to decrease health and closeness
    pet_logic.dart: logic of the game like how the stat increase/decrease
    weather_provider.dart : store current temperature and weather condition

    views/
    start_view.dart : show the start screen with continue game and start button
    select_view.dart : show two pets for users to choose
    game_view.dart : show main game page where users interact with pet
    outfit_view.dart : users can drag clothes to pet to dress pet and save their outfit
    shop_view.dart : show food and toy items for users to buy with coins
    settings_view.dart : let users to change app language and brightness

    widgets/
    pet_view.dart : show pet with current outfit and bubbles when wash button is pressed
    dialogue.dart : show dialogue frame with changing dialogue
    stat_bar.dart : two bars showing health and closeness
    bottom_bar.dart : six buttons(feed, water,wash,play,outfit,shop)
    artion_sheet.dart : bottom sheet for feed and play to show different food or toy
    food_sheet.dart : show food name and quantity users own
    toy_sheet.dart : show toy name that users own

    assets/
    backgrounds/ : background image of the app
    effects/ : bubble for wash button
    fonts/ : file for Pixelify Sans font
    outfits/ 
        tops/ : images of top
        bottoms/ images of bottoms
    icons/ : all the icons shown in the app
    pets/ : two pet images
```