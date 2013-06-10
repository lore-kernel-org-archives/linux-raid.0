From: Phil Turmel <philip@turmel.org>
Subject: Re: Fwd: Help with failed RAID-5 -> 6 migration
Date: Mon, 10 Jun 2013 15:35:38 -0400
Message-ID: <51B62A8A.9070108@turmel.org>
References: <CAASLJ=5ewoeNPV1-fwRm3o6rCxQjCYxuJTZ5M9g7p-vFpgDW-w@mail.gmail.com> <51B3B7FF.9080800@turmel.org> <CAASLJ=5JkQ8L9fbrOSUKH8Y-a7PZgkTcCsi6PW=rhzsUPRF6ow@mail.gmail.com> <CAASLJ=7NyJHSMhfhmOFFVR8-7OT5sOp24_WJs-kd6zX54fOG7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAASLJ=7NyJHSMhfhmOFFVR8-7OT5sOp24_WJs-kd6zX54fOG7w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Keith Phillips <spootsy.ootsy@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/10/2013 12:16 PM, Keith Phillips wrote:
> Apologies, Phil, if this is the second time you've got this now, but I
> just realised I dropped the linux-raid group from the email.

It's ok.  I was busy yesterday and today.

> I'm still looking at a degraded array that won't start, so any input
> would be greatly appreciated.
> 
> ---------- Forwarded message ----------
> From: Keith Phillips <spootsy.ootsy@gmail.com>
> Date: Sun, Jun 9, 2013 at 3:33 PM
> Subject: Re: Help with failed RAID-5 -> 6 migration
> To: Phil Turmel <philip@turmel.org>
> 
> 
> Thanks for the response, Phil.
> 
> *snip*
> 
>> That's unfortunate.  I'm going to guess you'd still be getting errors if
>> the array was running.  If you get more, please save them and report.
> 
> Entirely possible - if I can get the array started again I suppose
> we'll see. All I can remember of it is an I/O error on something like
> '/dev/md/0/8', with a big stack trace.

A big stack trace suggests other problems in your system.  Not that you
don't have potential I/O error issues, but there might be a kernel problem.

Please show "uname -a" and "mdadm --version".

>> Please elaborate on your recent "check".  What method did you use, and
>> did you get any I/O errors in you logs at that time?
> 
> There was Ubuntu's default monthly "check of redundancy data" -
> admittedly I hadn't looked at this to see what it actually does, but I
> was assuming it would verify the parity data for each stripe. mdadm is
> configured to email me on detection of errors.

The key thing to look for is a nonzero mismatch count in sysfs for that
array.  I'm not familiar with Ubuntu's script, so you might want to look
by hand at some future point.

> Also, I installed the new drive a day prior to actually adding it to
> the array, and for some reason when I powered the machine back on the
> existing array started rebuilding itself (took about 6 hours and
> finished happily - no errors reported anywhere). Not a deliberate
> process, but I assumed (wrongly?) that one of those would've issued
> some warnings/errors if there was a problem.

There have been some conflicts between various distro scripts and MD's
requirements at shutdown, opening the possibility of unsaved
superblocks.  I believe these are all fixed in current kernels.

>> Not sure yet.  But unless the new drive is truly bad, there's no
>> significant difference in going forward vs. going back.
>>
>>> The backup-file doesn't exist, and the stats on the array are as follows:
>>
>> Losing the backup file may cause some data loss, regardless of
>> conversion direction.
> 
> I'm okay with a bit of data loss - most of the data isn't critical.
> It'd be a real hassle to lose it all, though.

The backup file holds only a stripe's worth of data that can't be
juggled in place.  And it isn't always needed.

>> Meanwhile, report what you know about "error recovery control".  If it
>> is "nothing", you may need to do some googling in this list's archives.
>>  Suitable keywords would include: "scterc", "ure", "timeout", and "error
>> recovery".
>>
>> Phil
> 
> Prior to looking through this list yesterday: absolutely nothing. Now:
> almost nothing :)

Well, it bite many people.  From the smartctl data below, not you.  Yet.

> According to smartctl, none of my drives support it. Not surprising as
> they're all "green" desktop versions. When buying them I wasn't aware
> of this deficiency. By my limited understanding, lack of support just
> means the drives are likely to drop out of the array unnecessarily,
> correct? Maybe this was the cause of the unexpected rebuild after I
> added the new drive...
> 
> *edited forward* Actually, on reflection that wouldn't be it, would
> it? If the drive was dropped for not responding due to it's lack of
> scterc, I think I would have had to manually re-add it, which I didn't
> do.

Drives are dropped immediately on write errors.  Small numbers of read
errors are tolerated, and if correctable from redundancy, rewritten with
correct data.  Consumer drives become unresponsive on read error due to
their aggressive error recovery algorithms, that can take a couple
minutes.  Linux doesn't wait that long by default, and MD's attempt to
correct the bad data hits an unresponsive drive.  ==> write error.
Boom.  Single read error has turned into an array-killing write error.

> Requested info follows. FYI the new drive is now showing as
> "/dev/sde/" rather than "/dev/sda".

Ok.  Adjust suggestions as appropriate.

> Also, while poking yesterday I noticed I was getting warnings of the
> form "Device has wrong state in superblock but /dev/sde seems ok", so
> I tried a forced assemble:
> mdadm --assemble /dev/md0 --force
> 
> Looks like it updated some info in the superblocks (and yes, I forgot
> to save the original output first!), but the array remains inactive. I
> have now sworn off poking around by myself, because I've no idea what
> to do from here.

Please show /proc/mdstat again, along with "mdadm -D /dev/md0".

[trim /]

> for x in /sys/block/sd[acde]/device/timeout ; do echo $x $(< $x) ; done
> ----------------------------
> /sys/block/sdb/device/timeout 30
> /sys/block/sdc/device/timeout 30
> /sys/block/sdd/device/timeout 30
> /sys/block/sde/device/timeout 30

Due to your green drives, you cannot leave these timeouts at 30 seconds.
 I recommend 180 seconds:

for x in /sys/block/sd[bcde]/device/timeout ; do echo 180 >$x ; done

(You should do this ASAP.  On the run is fine.)

You will need your system to do this at every boot.  Most distros have
rc.local or a similar scripting mechanism you can use.

Phil
