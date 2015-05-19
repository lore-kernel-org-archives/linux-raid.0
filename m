From: "Wilson, Jonathan" <piercing_male@hotmail.com>
Subject: Backup raid, power down questions.
Date: Tue, 19 May 2015 13:36:43 +0100
Message-ID: <BLU437-SMTP474BC966B5944E3445207D98C30@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am looking to create a second raid6 set which will only be used to do
periodical backups of the main raid6, probably using rsync. (all drives
will be tler'able WD reds)

Obviously when the system boots all the raids will start up, but I am
looking to run some kind of script that will force the drives into a
"hard sleep" for want of a better term.

At the moment none of the drives have any sleep or power down timers
set, in part to fix the idle3 bug increasing the load cycles count and
this will be applied to the new drives as well.

My questions are:

1) I am using EXT4, will I need to "do something" to make sure that it
flushes all changes to disk (which I assume means "flush to MD layer"),
if so what?

2) Likewise with the MD layer, is there any command that forces it to
flush to disk any cached changes?

3) I am guessing that I need to issue a hdparm to each disk in the raid
set to send it either to sleep or spin down or some such state, as the
backup raid will not be accessed except during backup writes or data
recovery it can go into the most "asleep" state available. 2 questions,
what hdparm setting? also is there a smartctl equivalent?

4) As the drives might take a length of time to waken, does this need to
be considered by the /sys/class/scsi_device/*/device/timeout value to
prevent that layer deciding the disk has gone walkabout if it takes to
long to wake up?

5) If there isn't any easy way to make sure the raid/file system has
flushed any changes would a reasonable method be to unmount the file
system, then stop the raid, then send the drives to sleep? 

6) Obviously if this (5) is the only way or best way I am guessing the
backup script would just need to assemble the array to start it (--scan
--assemble --uuid=) which should wake up the drives and then mount the
file system, then call the script that performs the unmount,stop,sleep?

7) does sending a drive "to sleep" make sure that everything in the
drive cache is sent to disk?

8) I am using debian jessie, and the smartd checks for changes in smart
values (temp is the one that is listed most, almost exclusively,
in /var/log/syslog) will this cause my drives to wake up or is it clever
enough to see the drive is sleeping so won't wake it?

Finally, does anyone else do something similar or do most users either
just leave the backup array running, which seems a bit of a waste both
in power and drive lifespan terms especially if backups are fairly
infrequent (this won't be daily, probably weekly or monthly at most, so
not having to sleep/wake drives on a daily basis putting a different
type of wear on them)?

Jon

