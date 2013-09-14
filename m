From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID 5 3-drive array failed 2 disks at once - can anything be
 saved?
Date: Sat, 14 Sep 2013 10:24:20 -0400
Message-ID: <52347194.7010602@turmel.org>
References: <52332763.30901@schultzfamily.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52332763.30901@schultzfamily.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Robert Schultz <rob@schultzfamily.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good morning Robert,

On 09/13/2013 10:55 AM, Robert Schultz wrote:
> Heeding the advice to ask questions before messing things up even worse,
> here goes.
> 
> I have a PC running BackupPC.
> 
> The system contains 4 disks:
> boot & system: 1x WD 20GB IDE
> backup data: RAID 5 array containing 3 x Seagate 2TB SATA drives
>     ST32000542AS    /dev/sdb
>     ST2000DM001     /dev/sdc
>     ST32000542AS    /dev/sdd
> 
> Two days ago the system alerted me to a problem with the array:
> 
> A Fail event had been detected on md device /dev/md0.
> 
> It could be related to component device /dev/sdd1.
> 
> Faithfully yours, etc.

You can probably save everything.  From the drive models given, you are
certainly suffering from timeout mismatch on desktop drives.  Such
drives are not suitable for use in raid arrays "out of the box".  For
many explanations of this, please search the list archives for various
combinations of "scterc", "error recovery", "device/timeout", and/or "URE".

Please provide a bit more information:

1) Redo your "mdadm -E /dec/sdd1", as you cut off part of its output.

2) show "for x in /sys/block/*/device/timeout ; do echo $x $(< $x) ;
done" to see your driver timeouts.

3) show "for x in sdb sdc sdd ; do echo $s ; smartctl -x /dev/$x ; done"
so we can see your drive health in detail, and the scterc capability.
(Sure to be none for the ST2000DM001 -- I have a couple of those.)

If I'm correct, saving your array will be the following steps:

1) Set long driver timeouts:
   for x in /sys/block/*/device/timeout ; do echo 180 > $x ; done

2) Stop the array, then force assembly:
   mdadm -S /dev/md0
   mdadm -A --force /dev/md0 /dev/sd[bcd]1

3) Start a "check" scrub on your array:
   echo check >/sys/block/md0/md/sync_action

The kernel MD driver only allows fixing 10 read errors per hour (after
20 in the first hour) before kicking a drive out anyways.  If you've
accumulated many pending errors, your check may not finish.  Simply
repeat "2" & "3" to get through.

4) If "mismatch_cnt" is non-zero at the end, also run a "repair" scrub.

5) Use "fsck -y" on your filesystem to fix any remaining errors, then
mount your filesystem.

6) Make a backup while you can.

7) Add "1" to your rc.local script so it is set on every reboot.

8) Add "3" to a weekly cron job so you don't let pending disk errors
accumulate.

HTH,

Phil
