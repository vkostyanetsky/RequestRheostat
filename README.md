# Outgoing Requests Limiter

Sometimes you need to limit the number of requests which your application makes to some external resource. It's obviously easy to solve if you have only one place where you make requests (a scheduled job, for instance), but there can be many of them: for instance, a lot of background jobs.

There is example how the task can be solved. The implementation is in a `RequestsServer` common module; have a look at procedure `StickToMaximumRequestsNumberPerSecond()`. The other part of the configuration is a sort of user interface to test that limitation works fine.