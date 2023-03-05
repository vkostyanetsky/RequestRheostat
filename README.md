# ⏱️ ✖️ ⚙️ Outgoing Requests Limiter

Sometimes you need to limit the number of requests which your application makes to some external resource per second. It's obviously how to deal with it if you have only one place where you make requests (a scheduled job, for instance), but there can be many of them: for instance, a lot of background jobs.

There is example how the task can be solved. The implementation is in a `RequestsServer` common module; have a look at procedure `StickToMaximumRequestsNumberPerSecond()`. The other part of the configuration is a sort of user interface to test that limitation works fine.

## Usage

The configuration doesn't really make requests, but it writes every attempt to do it to the `Requests` information register. You can play with parameters on the right part of the form and see how many requests the application is going to make per second according to what you choose. 

The "Exceedings" list down below is intended to warn you if there are moments when a number of requests made trespasses the limitation you set.

![Interface](Images/interface.png)