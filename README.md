check_mcqs
==========
``check_mcqs`` is a Nagios / Icinga plugin for checking HP MC/ServiceGuard quorum server states

Requirements
============
- *HP ServiceGuard Quorum Server* Product (**B8467BA**): [[click me!]](https://h20392.www2.hp.com/portal/swdepot/displayProductInfo.do?productNumber=B8467BA)

Usage
=====
By default the plugin checks whether the `qsc` binary is running and listening for requests on port `tcp/1238`.

You can also specify particular cluster nodes that need to be connected to the quorum server. In this case the plugin will return ``CRITICAL`` events if one of those nodes are disconnected from the quorum server.

Examples
========
Check whether the `qsc` binary is running and accpeting connections:
```
$ ./check_mcqs
OK - quorum server online
```

Check whether particular nodes are connected to the quorum server:
```
$ ./check_mcqs srvsap01,srvsap02,srvsap03
CRITICAL - not all required cluster nodes are connected to quorum server! Missing: srvsap03
```
