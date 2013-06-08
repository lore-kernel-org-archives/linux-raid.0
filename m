From: Phil Turmel <philip@turmel.org>
Subject: Re: Help with failed RAID-5 -> 6 migration
Date: Sat, 08 Jun 2013 19:02:23 -0400
Message-ID: <51B3B7FF.9080800@turmel.org>
References: <CAASLJ=5ewoeNPV1-fwRm3o6rCxQjCYxuJTZ5M9g7p-vFpgDW-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAASLJ=5ewoeNPV1-fwRm3o6rCxQjCYxuJTZ5M9g7p-vFpgDW-w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Keith Phillips <spootsy.ootsy@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Whoops.  A bit click-happy.

On 06/07/2013 11:02 PM, Keith Phillips wrote:
> Hi,
> 
> I have a problem. I'm worried I may have borked my array :/

Not yet.  But you do have problems.

> I've been running a 3x2TB RAID-5 array and I recently got another 2TB
> drive, intending to bump it up to a 4x2TB RAID-6 array.
> 
> I stuck the new disk in and added it to the RAID array, as follows
> ("/files" is on a non-RAID disk):
> mdadm --manage /dev/md0 --add /dev/sda
> mdadm --grow /dev/md0 --raid-devices 4 --level 6
> --backup-file=/files/mdadm-backup

Good so far.

> It seemed to work and the grow process started okay, reporting about 3
> days to completion (at ~8MB/s) which seemed really slow, but I left it
> anyway. Next morning, time to complete was several years and the
> kernel had spat out a bunch of I/O errors (lost those logs, sorry).

That's unfortunate.  I'm going to guess you'd still be getting errors if
the array was running.  If you get more, please save them and report.

> I figured the new disk must be at fault, because I'd done an array
> check recently and the others seemed okay.

Please elaborate on your recent "check".  What method did you use, and
did you get any I/O errors in you logs at that time?

{Your problem is extraordinarily unlikely to be the fault of your new
drive, since almost all traffic to it would be *writes*, and a failed
write will kick a drive out of an array immediately.)

> Hoping it might abort the
> grow, I failed the new disk:
> mdadm --manage /dev/md0 --fail /dev/sda

No, that won't (and didn't) abort the grow.  Your array details show the
old and new layouts in progress.

> But mdadm kept reporting years to completion. So I rebooted.
> 
> Now I'd like to know - what state is my array in? If possible I'd like
> to get back to a working 3 disk RAID-5 configuration while I test the
> new disk and figure out what to do with it.

Not sure yet.  But unless the new drive is truly bad, there's no
significant difference in going forward vs. going back.

> The backup-file doesn't exist, and the stats on the array are as follows:

Losing the backup file may cause some data loss, regardless of
conversion direction.

[trim /]

> Any advice greatly appreciated.

More data is needed:

1) output of "mdadm -E /dev/sd[acde]"

2) output of "for x in /dev/sd[acde] ; do smartctl -x $x ; done"

3) trimmed output of "ls -l /dev/disk/by-id" showing serial number vs.
device name for the subject disks.

4) output of "for x in /sys/block/sd[acde]/device/timeout ; do echo $x
$(< $x) ; done"

Meanwhile, report what you know about "error recovery control".  If it
is "nothing", you may need to do some googling in this list's archives.
 Suitable keywords would include: "scterc", "ure", "timeout", and "error
recovery".

Phil
