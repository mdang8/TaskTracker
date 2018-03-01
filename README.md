# TaskTracker

**HW06 for CS4550: Web Development**

## Part 1

This is a simple task tracking app. The two main general features are manipulating users and tasks. One can register a new user by entering an email and name to be associated with the account. That user account can then be modified, deleted, or simply displayed. Once a user account has been registered, that user can log-in to the app.

Once logged in, the user will be redirected to the "tasks board" page, which lists all of the created tasks and includes a form for creating a new task. The board only lists tasks that are completed, as indicated by the *Completed* flag. Tasks can be displayed, created, modified, and deleted.

When logged in, there are three links at the top of the page under the "Log out" button that redirect to other pages. Users can use these links to quickly access the board, tasks, and users pages.

For creating new tasks, there are six fields: *User, Assigned, Title, Description, Duration, and Completed*. The *User* field is defaulted to be the current user, so the user doesn't have to unnecessarily fill out that input. The *Assigned* field is the name of the user to assign the new task to. Users can enter the name of the user to assign the task to instead of their ID because it is more convenient to remember the name. The *Duration* field is increased in 15 minute increments and only accepts inputs divisible by 15.

## Part 2

There is now a manager-underling system. Each user can have many managers and many underlings. Managers have the ability to create new tasks and assign them to other users. They can also edit and delete tasks. On the users index page there are "Manage" buttons that toggle when clicked. These buttons allow a user to become a manager for another user. When clicking on "Show" for a user, there lists a name of that user's managers and underlings, if they have any. There is also another "Manage" button on their page that indicates whether or not the current user manages that user.

The board page has been turned into a "Task Report Board" page that allows the current user to see information about the uncompleted tasks that are assigned to them and their underlings. The tasks page lists all the tasks for all users. If the current user is a manager, they have the ability to create, edit, and delete tasks.

The duration field for tasks have been removed and replaced with time blocks. When creating and editing a task, users can enter a block of start and end times using a datetime_select input field. On the tasks index page there are *Start* and *End* buttons next to each task that has been assigned to the current user. Clicking the *Start* button creates a new time block with the current timestamp as the start time and the end time blank. Clicking the *End* button fills in the blank end time end completes that time block. Users can click the *Start* button multiple times consecutively. Then each subsequent *End* button click completes the oldest uncompleted time block.
