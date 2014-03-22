Malicious Time Traveler
========================================

A tool for Apple Time Machine backup analysis and modification, MTT aims to provide effective means to evaluate changes in a filesystem over time while also providing the means to alter content for extended ranges of time.

Due to the way in which Time Machine works, content that has not been modified since a previous backup is simply hard-linked to the already existing backup. Should that content be modified on the Time Machine volume, the modification of one backup will mean the modification of all those hard-linked to it. Additionally, one can filter out hard-linked content to formulate a timeline of changes made by looking at, for example, logs. 

For example, let's say that Firefox is backed up using Time Machine and that its files do not change for a few months. By adding a backdoor to one of the Firefox backups, I have effectively modified all backed up copies of Firefox for that stretch of time. Should any of those backups be restored in the future, the backdoored version of Firefox will be restored as opposed to the original.
