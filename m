From: Phil Turmel <philip@turmel.org>
Subject: Re: Please Help! RAID5 -> 6 reshapre gone bad
Date: Mon, 06 Feb 2012 21:15:27 -0500
Message-ID: <4F30893F.4000709@turmel.org>
References: <CAOANJV-V8ZTXBvQxxMnEnv24p8A-fAas-6x65ifW5yp35ZqHnA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOANJV-V8ZTXBvQxxMnEnv24p8A-fAas-6x65ifW5yp35ZqHnA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Herd <2001oddity@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Richard,

On 02/06/2012 08:34 PM, Richard Herd wrote:
> Hey guys,
> 
> I'm in a bit of a pickle here and if any mdadm kings could step in and
> throw some advice my way I'd be very grateful :-)
> 
> Quick bit of background - little NAS based on an AMD E350 running
> Ubuntu 10.04. Running a software RAID 5 from 5x2TB disks.  Every few
> months one of the drives would fail a request and get kicked from the
> array (as is becoming common for these larger multi TB drives they
> tolerate the occasional bad sector by reallocating from a pool of
> spares (but that's a whole other story)).  This happened across a
> variety of brands and two different controllers. I'd simply add the
> disk that got popped back in and let it re-sync.  SMART tests always
> in good health.

Some more detail on the actual devices would help, especially the
output of lsdrv [1] to document what device serial numbers are which,
for future reference.

I also suspect you have problems with your drive's error recovery
control, also known as time-limited error recovery.  Simple sector
errors should *not* be kicking out your drives.  Mdadm knows to
reconstruct from parity and rewrite when a read error is encountered.
That either succeeds directly, or causes the drive to remap.

You say that the SMART tests are good, so read errors are probably
escalating into link timeouts, and the drive ignores the attempt to
reconstruct.  *That* kicks the drive out.

"smartctl -x" reports for all of your drives would help identify if
you have this problem.  You *cannot* safely run raid arrays with drives
that don't (or won't) report errors in a timely fashion (a few seconds).

> It did make me nervous though.  So I decided I'd add a second disk for
> a bit of extra redundancy, making the array a RAID 6 - the thinking
> was the occasional disk getting kicked and re-added from a RAID 6
> array wouldn't present as much risk as a single disk getting kicked
> from a RAID 5.
> 
> So first off, I added the 6th disk as a hotspare to the RAID5 array.
> So I now had my 5 disk RAID 5 + hotspare.
> 
> I then found that mdadm 2.6.7 (in the repositories) isn't actually
> capable of a 5->6 reshape.  So I pulled the latest 3.2.3 sources and
> compiled myself a new version of mdadm.
> 
> With the newer version of mdadm, it was happy to do the reshape - so I
> set it off on it's merry way, using an esata HD (mounted at /usb :-P)
> for the backupfile:
> 
> root@raven:/# mdadm --grow /dev/md0 --level=6 --raid-devices=6
> --backup-file=/usb/md0.backup
> 
> It would take a week to reshape, but it was ona UPS & happily ticking
> along.  The array would be online the whole time so I was in no rush.
> Content, I went to get some shut-eye.
> 
> I got up this morning and took a quick look in /proc/mdstat to see how
> things were going and saw things had failed spectacularly.  At least
> two disks had been kicked from the array and the whole thing had
> crumbled.

Do you still have the dmesg for this?

> Ouch.
> 
> I tried to assembe the array, to see if it would continue the reshape:
> 
> root@raven:/# mdadm -Avv --backup-file=/usb/md0.backup /dev/md0
> /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sdf1 /dev/sdg1
> 
> Unfortunately mdadm had decided that the backup-file was out of date
> (timestamps didn't match) and was erroring with: Failed to restore
> critical section for reshape, sorry..
> 
> Chances are things were in such a mess that backup file wasn't going
> to be used anyway, so I blocked the timestamp check with: export
> MDADM_GROW_ALLOW_OLD=1
> 
> That allowed me to assemble the array, but not run it as there were
> not enough disks to start it.
> 
> This is the current state of the array:
> 
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> md0 : inactive sdb1[1] sdd1[5] sdf1[4] sda1[2]
>       7814047744 blocks super 0.91
> 
> unused devices: <none>
> 
> root@raven:/# mdadm --detail /dev/md0
> /dev/md0:
>         Version : 0.91
>   Creation Time : Tue Jul 12 23:05:01 2011
>      Raid Level : raid6
>   Used Dev Size : 1953511936 (1863.01 GiB 2000.40 GB)
>    Raid Devices : 6
>   Total Devices : 4
> Preferred Minor : 0
>     Persistence : Superblock is persistent
> 
>     Update Time : Tue Feb  7 09:32:29 2012
>           State : active, FAILED, Not Started
>  Active Devices : 3
> Working Devices : 4
>  Failed Devices : 0
>   Spare Devices : 1
> 
>          Layout : left-symmetric-6
>      Chunk Size : 64K
> 
>      New Layout : left-symmetric
> 
>            UUID : 9a76d1bd:2aabd685:1fc5fe0e:7751cfd7 (local to host raven)
>          Events : 0.1848341
> 
>     Number   Major   Minor   RaidDevice State
>        0       0        0        0      removed
>        1       8       17        1      active sync   /dev/sdb1
>        2       8        1        2      active sync   /dev/sda1
>        3       0        0        3      removed
>        4       8       81        4      active sync   /dev/sdf1
>        5       8       49        5      spare rebuilding   /dev/sdd1
> 
> The two removed disks:
> [ 3020.998529] md: kicking non-fresh sdc1 from array!
> [ 3021.012672] md: kicking non-fresh sdg1 from array!
> 
> Attempted to re-add the disks (same for both):
> root@raven:/# mdadm /dev/md0 --add /dev/sdg1
> mdadm: /dev/sdg1 reports being an active member for /dev/md0, but a
> --re-add fails.
> mdadm: not performing --add as that would convert /dev/sdg1 in to a spare.
> mdadm: To make this a spare, use "mdadm --zero-superblock /dev/sdg1" first.
> 
> With a failed array the last thing we want to do is add spares and
> trigger a resync so obviously I haven't zeroed the superblocks and
> added yet.

That would be catastrophic.

> Checked and two disks really are out of sync:
> root@raven:/# mdadm --examine /dev/sd[a-h]1 | grep Event
>          Events : 1848341
>          Events : 1848341
>          Events : 1848333
>          Events : 1848341
>          Events : 1848341
>          Events : 1772921

So /dev/sdg1 dropped out first, and /dev/sdc1 followed and killed the
array.

> I'll post the output of --examine on all the disks below - if anyone
> has any advice I'd really appreciate it (Neil Brown doesn't read these
> forums does he?!?).  I would usually move next to recreating the array
> and using assume-clean but since it's right in the middle of a reshape
> I'm not inclined to try.

Neil absolutely reads this mailing list, and is likely to pitch in if
I don't offer precisely correct advice :-)

He's in an Australian time zone though, so latency might vary.  I'm on the
U.S. east coast, fwiw.

In any case, with a re-shape in progress, "--create --assume-clean" is
not an option.

> Critical stuff is of course backed up, but there is some user data not
> covered by backups that I'd like to try and restore if at all
> possible.

Hope is not all lost.  If we can get your ERC adjusted, the next step
would be to disconnect /dev/sdg from the system, and assemble with
--force and MDADM_GROW_ALLOW_OLD=1

That'll let the reshape finish, leaving you with a single-degraded
raid6.  Then you fsck and make critical backups.  Then you --zero- and
--add /dev/sdg.

If your drives don't support ERC, I can't recommend you continue until
you've ddrescue'd your drives onto new ones that do support ERC.

HTH,

Phil

[1] http://github.com/pturmel/lsdrv
