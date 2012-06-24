From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Stacked array data recovery
Date: Sun, 24 Jun 2012 09:12:35 -0500
Message-ID: <4FE72053.4040101@hardwarefreak.com>
References: <js083q$kdu$1@dough.gmane.org> <js1vuk$9k8$2@dough.gmane.org> <4FE5B213.5010503@hardwarefreak.com> <js70ce$fgv$1@dough.gmane.org>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <js70ce$fgv$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Ramon Hofer <ramonhofer@bluewin.ch>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 6/24/2012 7:15 AM, Ramon Hofer wrote:
> On Sat, 23 Jun 2012 07:09:55 -0500, Stan Hoeppner wrote:

>> You should have run an "xfs_repair -n" before mounting.  "-n" means no
>> modify, making it a check operation.  If it finds errors then rerun it
>> without the "-n" so it can make necessary repairs.  Then remount.  Sorry
>> I forgot to mention this, or remind you, whichever is the case. :)
> 
> Thanks you!
> 
> You have mentioned but I forgot to do it.
> I did it now and still everything looks good.
> At least with the WD blacks and the Samsung drives.

Fantastic.

> One WD green was again marked faulty when I tried to create an array with 
> them.
> 
> This is the output of dmesg:
> http://pastebin.com/raw.php?i=5aukYJa8

This shows you have 3 bad sectors that have not been reallocated.  This
may be correctable, maybe not.  It depends whether this drive has
exhausted its spare sector pool.

197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Always
      -       3

If the spare sector pool has not been exhausted, you could try to
overwrite each bad block manually and then sync to force the drive to
reallocate the sectors.  But at this point, given it's a WD20EARS, and
has some hours under its belt, you may be better off writing zeros to
the entire OS visible portion of the drive.  This will tend to flush out
any other bad sectors or problems with the drive, and if there are none
should repair the 3 bad sectors by reallocating them (replacing them
with spare blocks).  This operation will take up to an hour, or more, to
complete.  Read this entire email before you run any commands.

~$ dd if=/dev/zero of=/dev/sdk bs=1M; sync

WARNING:  THIS COMMAND WILL ERASE A DISK DRIVE.  Be very careful.
WARNING:  THIS COMMAND WILL ERASE A DISK DRIVE.  Be very careful.

> This seems to be not good:
> [61142.466334] md/raid:md9: read error not correctable (sector 3758190680 
> on sdk).
> [61142.466338] md/raid:md9: Disk failure on sdk, disabling device.

This is one of the 3 bad sectors.

> What could the reason of this issue be?
> Is it because the disk is broken or not suited for raid use?

No, just platter surface defects.  Common with very large drives.

> I'm now running smartctl -t long /dev/sdk.
> I have no clue if this helps in any way...
> 
> Here's the output of smartctl -a /dev/sdk:
> http://pastebin.com/raw.php?i=2ULrx6du

It identified the same bad sector listed in the md failure: 3758190680

# 1  Extended offline    Completed: read failure       90%      5174
     3758190680

But you have two other bad sectors as well, apparently, that this self
test didn't pick up.  They were however previously logged.

> Should I bring the disc to my dealer or is it an issue of using it with 
> mdadm?

That's premature.  If you don't have any irreplaceable data on md9 yet,
I'd recommend erasing all 4 EARS drives with the dd command so you have
a "fresh start".  You can do this in parallel so they complete at the
~same time:

The easiest way is to simply put and ampersand at the end of each
command, which puts each process in the background and frees up the
command line for the next command.  I don't know which device names
those WDs are so I'm using fictional examples:

~$ dd if=/dev/zero of=/dev/sdw bs=1M &
~$ dd if=/dev/zero of=/dev/sdx bs=1M &
~$ dd if=/dev/zero of=/dev/sdy bs=1M &
~$ dd if=/dev/zero of=/dev/sdz bs=1M &

WARNING:  THESES COMMANDS WILL ERASE DISK DRIVES.  Be very careful.
WARNING:  THESES COMMANDS WILL ERASE DISK DRIVES.  Be very careful.


MAKE SURE YOU ENTER THE CORRECT DRIVE DEVICE NAMES.  If you enter the
name of a WD Black, you will erase the Black drive.

After they all finish you'll see something like this 4 times but the
values will be immensely larger:

1+0 records in
1+0 records out
1048576 bytes (1.0 MB) copied, 0.0164695 s, 63.7 MB/s

After you see 4 of those, issue a sync to force any remaining pending
writes out of the buffer cache and drive caches:

~$ sync

There will be no output from the sync command.  Wait until the drive
lights for these 4 drives stop flashing.  Then create the md array again.

If you get any errors from the dd commands for /dev/sdk, or any of the
drives, don't create the md array.  Post the errors here first.  The
errors may indicate you need to replace a drive.  So you need to know
that before trying to create the array again.

-- 
Stan
