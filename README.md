# flutter_workout_tracker

## App for recording gym workouts

---

## Instruction
To add a muscle group or exercise, press the **‘+’** in the top menu while being on the respective **muscle group/exercise selection screen**.  
To move to the next form field/submit it, you can use the keyboard. This also applies to saving/editing sets, rest time, and weight increment.  
To make the keyboard disappear, tap anywhere on the screen (except the **TabBar**).  
To edit/delete a set, tap its entry in **‘Recorded Sets’**.  
You can tap on chart points to view information about them.  
To change the rest time between sets for a specific exercise, click the **blue clock button**. It is only available when there is no active countdown to a notification.

---

## Screens
*   **Exercise selection screens**: list of muscle groups → list of exercises for a given muscle group  
*   **Screen for recording sets** (of a previously selected exercise)  
*   **History screen for a selected exercise** – list of all sets for the exercise (weight, repetitions, date)  
*   **History screen for a selected exercise** – weight chart over time  

---

## User Stories
*   As a user, I can add my own **muscle group**  
*   As a user, I can add my own **exercise**  
*   As a user, I can **set/change the rest time** between sets (for a specific exercise)  
*   As a user, I can **record exercise sets** from the current database (predefined + added by me)  
*   As a user, I can **edit or delete sets** of the **current (today’s) workout**  
*   As a user, I can **see how much time is left** until the notification for the next set  
*   As a user, I can **change the rest time** until the notification for the next set  
*   As a user, I can **change weight increments**, i.e., how many kg the **‘–’ / ‘+’** buttons change the weight by (for a specific exercise)  
*   As a user, I can **view all sets** of a specific exercise (in history)  
*   As a user, I can **see a weight chart over time** for a specific exercise  

---

## Integrations
*   `audioplayers`: ^5.2.1  
*   `fl_chart`: ^0.65.0  
*   `shared_preferences`: ^2.2.2  

---

## Screens – Screenshots


![Screenshot_2024-02-19-11-06-40-29_b2e6ddb98ad5498950d6bb58f30ad800](https://github.com/glowacz/flutter_workout_tracker/assets/94084660/80a07861-8b2c-4598-b2dc-9c46edb09250)
![Screenshot_2024-02-19-11-06-48-14_b2e6ddb98ad5498950d6bb58f30ad800](https://github.com/glowacz/flutter_workout_tracker/assets/94084660/289b1341-60a3-4f36-a85c-f9043911be1d)
![Screenshot_2024-02-19-11-06-51-69_b2e6ddb98ad5498950d6bb58f30ad800](https://github.com/glowacz/flutter_workout_tracker/assets/94084660/8e8fed3c-8cdb-4210-ac13-79a0c6147876)
![Screenshot_2024-02-19-11-07-00-09_b2e6ddb98ad5498950d6bb58f30ad800](https://github.com/glowacz/flutter_workout_tracker/assets/94084660/72729766-a4e6-4079-8653-109c180f5ebf)
![Screenshot_2024-02-19-11-07-12-03_b2e6ddb98ad5498950d6bb58f30ad800](https://github.com/glowacz/flutter_workout_tracker/assets/94084660/c2fb382d-6be6-43cb-a036-3e957a83bf30)
![Screenshot_2024-02-19-11-07-44-09_b2e6ddb98ad5498950d6bb58f30ad800](https://github.com/glowacz/flutter_workout_tracker/assets/94084660/e14d400c-ea26-42f7-b415-3d30ba3627f3)
![Screenshot_2024-02-19-11-08-00-16_b2e6ddb98ad5498950d6bb58f30ad800](https://github.com/glowacz/flutter_workout_tracker/assets/94084660/3e884f50-556d-4ee5-b745-e4063e92c99f)
![Screenshot_2024-02-19-11-08-20-09_b2e6ddb98ad5498950d6bb58f30ad800](https://github.com/glowacz/flutter_workout_tracker/assets/94084660/6e21b10c-030f-4a6c-85bd-c2893475bc01)
![Screenshot_2024-02-19-11-08-23-82_b2e6ddb98ad5498950d6bb58f30ad800](https://github.com/glowacz/flutter_workout_tracker/assets/94084660/7447c841-4276-4528-98a3-bbaffe65c4f7)
