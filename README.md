# TaskTracker

**HW06 for CS4550: Web Development**

This is a simple task tracking app. The two main general features are manipulating users and tasks. One can register a new user by entering an email and name to be associated with the account. That user account can then be modified, deleted, or simply displayed. Once a user account has been registered, that user can log-in to the app.

Once logged in, the user will be redirected to the "tasks board" page, which lists all of the created tasks and includes a form for creating a new task. The board only lists tasks that are completed, as indicated by the *Completed* flag. Tasks can be displayed, created, modified, and deleted.

When logged in, there are three links at the top of the page under the "Log out" button that redirect to other pages. Users can use these links to quickly access the board, tasks, and users pages.

For creating new tasks, there are six fields: *User, Assigned, Title, Description, Duration, and Completed*. The *User* field is defaulted to be the current user, so the user doesn't have to unnecessarily fill out that input. The *Assigned* field is the name of the user to assign the new task to. Users can enter the name of the user to assign the task to instead of their ID because it is more convenient to remember the name. The *Duration* field is increased in 15 minute increments and only accepts inputs divisible by 15.