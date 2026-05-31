Data Design
The app uses a simple but effective way to keep track of your progress and your pet's information.

PetState Model: I created a "PetState" model that acts as a digital notebook. It stores everything about your pet, such as its name, its health and happiness levels, and what clothes it is currently wearing.

Saving Data: The app saves this "notebook" as a JSON file. This allows the app to store your progress on your phone so that your pet and its items are still there when you open the app again later.

Simple Names: Instead of saving long, complicated file paths for images, I save simple nicknames for items (like 'navy_top'). This makes the app much more stable and prevents errors when loading outfits.

Data Flow
The app uses a "Provider" framework to make sure the screen always shows the most current information.

The PetProvider is the main "brain" of the app. Whenever you change something—like feeding your pet or changing its clothes—the provider updates the information inside the "notebook".

Automatic Updates: As soon as the information in the "notebook" changes, the provider tells the screen to update itself. This is why your pet’s outfit changes the moment you select a new item.

Saving to Disk: Every time you make a change, the app automatically saves that update to your phone’s storage. This ensures your data is always safe, even if you close the app.

Background Tasks: The app uses a timer to automatically lower your pet’s stats over time, even when you aren't actively playing. This keeps the game feel "alive" and responsive.
