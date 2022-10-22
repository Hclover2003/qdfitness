# qdfitness

qdfitness is an offline calorie tracking, diary app designed to make counting your calories a quick and simple part of your day.

It is meant to be a guideline, rather than a strict regime. It has a small ingredient-based library, rather than a comprehensive library of dishes. To create a primarily tap-based interface, quantities are tracked through number of fistfuls, rather than as typed numbers. In doing so, it trades detail and accuracy for time and ease of use.

My goal with this app was to make it as hassle-free and casual as possible. The calorie and quantity tracking is not meant to be strict and precise, but rather give you an overall estimate to guide your food and exercise choices.

## Instructions to use

Sign up for an account with an email & password or your google account. 
There are 3 main pages on the bottom menu: Home, LogFood, and LogExercise.

### Home
This displays your current food calories, current exercise calories, and current total calories. It also gives a number of your goal amount of daily calories, that is automatically calculated based on your age, height, weight, daily activity level, and goal. You can click on the edit button to go to your profile to change this.

### Profile
You can see the basic info of your account here: name, age, height, current weight, daily activity level, and goal (lose/maintain/gain weight). You can change any of these factors to update a new daily calorie goal. Or, you can manually edit your daily calorie goal as well. 

### LogFood
The number of calories for each food type here are found from the USDA food calorie database. 

- long press on each food choice to view the calorie info and serving size. Most of them will be 100g, which is about a fistful. 
- To log a food, first make sure that you have selected the proper meal label: breakfast, lunch, dinner, or snack.
- Then, tap on a circle for the # of servings you had of each ingredient. (recall that serving size can be seen with a long hold, and it's typically 100g or 1 fistful). You can delete a food item by tapping on the minus or trash can buttons on the circle.
- As you add foods, you will notice the menu update with blue tiles. This is because you have not actually "saved" these foods yet. Once you have selected everything, tap on the "save" button and the tiles will now turn white. You have now saved your items.
- To delete a saved log, swipe right on a tile. 
- To delete all unsaved logs, you can press the "clear all" button.

### LogExercise
The number of calories burned for each exercise is calculated using the MET scale. There are 5 options of intensity for each exercise: very light, light, moderate, intense, very intense. Not all exercise have all of these intensity levels; you can long hold on the circles to see which intensity level they correspond to.

1. Choose an exercise: Tap on one of the execise circles. Once selected, there will be a checkmark on that exercise.
2. Choose an intensity level: Since you have already selected an exercise, you should see the bar above update with the available intensity levels for that exercise. Tap on the one that's relevant. 
3. Choose time spent: Tap on the # of minutes button beside the intensity bar, and choose the # of minutes you exercised for.

Finally, save this exercise with the "save" button. As you were editing the previous steps, you should notice that a new blue tile is added to the menu, with the calorie count changing to reflect your choices. 

Similar to food logs, to deselect the exercise, you can press the "clear all" button.

## Goals

1. Quickly Log
   Logging a food entry/exercise entry should take less than 60 seconds
2. Transparent Data
   The daily summary should be the first thing the user sees, laid out in a very comprehensible, simple, direct manner.
3. Lightweight Navigation
   Structure content to have minimal loading times, smooth controls to navigate between views, not too overflowed with content, with fun, customizable colours.
