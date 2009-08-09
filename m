From: "NeilBrown" <neilb@suse.de>
Subject: Re: raid10 problem with spare disk
Date: Sun, 9 Aug 2009 20:43:34 +1000 (EST)
Message-ID: <4340507aed0605af55fbaf1f9f694cfb.squirrel@neil.brown.name>
References: <1249755852.5095.86.camel@ilievnet.com>
    <20b671d0bba986ff7c119757440a8c26.squirrel@neil.brown.name>
    <20090809105534.8cb0e649.daniel.iliev@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090809105534.8cb0e649.daniel.iliev@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Iliev <daniel.iliev@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, August 9, 2009 5:55 pm, Daniel Iliev wrote:
> On Sun, 9 Aug 2009 07:17:50 +1000 (EST)
> "NeilBrown" <neilb@suse.de> wrote:
>
>> On Sun, August 9, 2009 4:24 am, Daniel Iliev wrote:
> [--snip--]
>> >
>> >
>> > What happened is that I removed sdc3, mounted md2, saw the data,
>> > unmounted md2 and tried to "mdadm /dev/md2 --re-add /dev/sdc3", so I'd
>> > go trough the backup & restore routine later.
>>
>> Possibly md thought there had been some change in the array and it
>> was too late to re-add an old device.  If you have a bitmap that
>> might make it work better.
>>
>
> I guess so. Perhaps mount/unmount wrote something to the fs metadata and
> sdc
> became inconsistant with the rest of the raid. The bitmap is internal.
>
>>
>> >
>> > Unfortunately for some reason mdadm added sdc3 as spare. I stopped md2
>> > and tried to assemble it again, but this time mdadm said there wera no
>> > eneough drives to start the array and sdc3 was still marked as spare.
>>
>> Can you try assembling the array adding "--verbose" and post the full
>> output as well as the exact version of kernel and mdadm?
>>
>> NeilBrown
>
> uname:
> 2.6.30-gentoo-r4-core2 #1 SMP PREEMPT Fri Jul 24 08:21:44 EEST 2009 x86_64
> mdadm -V
> mdadm - v2.6.9 - 10th March 2009
>
> mdadm.conf:
> DEVICE /dev/sd[a-z][0-9]
> ARRAY /dev/md0 level=raid1 num-devices=4 metadata=0.90
> UUID=1b2398aa:d1563102:55dba985:94719c42
> ARRAY /dev/md1 level=raid10 num-devices=4 metadata=0.90
> UUID=b2be0688:d5b5f059:6507a68f:ecec3716
> ARRAY /dev/md2 level=raid10 num-devices=4 metadata=0.90
> UUID=28a0a8db:4120c890:175293b6:df3cd3b3
>
> ~ # mdadm -A /dev/md2 --verbose
> mdadm: looking for devices for /dev/md2
> mdadm: no RAID superblock on /dev/sde9
> mdadm: /dev/sde9 has wrong uuid.
> mdadm: no RAID superblock on /dev/sde8
> mdadm: /dev/sde8 has wrong uuid.
> mdadm: no RAID superblock on /dev/sde7
> mdadm: /dev/sde7 has wrong uuid.
> mdadm: no RAID superblock on /dev/sde6
> mdadm: /dev/sde6 has wrong uuid.
> mdadm: no RAID superblock on /dev/sde5
> mdadm: /dev/sde5 has wrong uuid.
> mdadm: no RAID superblock on /dev/sde1
> mdadm: /dev/sde1 has wrong uuid.
> mdadm: cannot open device /dev/sdd2: Device or resource busy
> mdadm: /dev/sdd2 has wrong uuid.
> mdadm: cannot open device /dev/sdd1: Device or resource busy
> mdadm: /dev/sdd1 has wrong uuid.
> mdadm: cannot open device /dev/sdc2: Device or resource busy
> mdadm: /dev/sdc2 has wrong uuid.
> mdadm: cannot open device /dev/sdc1: Device or resource busy
> mdadm: /dev/sdc1 has wrong uuid.
> mdadm: cannot open device /dev/sdb2: Device or resource busy
> mdadm: /dev/sdb2 has wrong uuid.
> mdadm: cannot open device /dev/sdb1: Device or resource busy
> mdadm: /dev/sdb1 has wrong uuid.

Here is the problem:
> mdadm: /dev/sdd3 is identified as a member of /dev/md2, slot 1.
> mdadm: /dev/sdc3 is identified as a member of /dev/md2, slot 4.
> mdadm: /dev/sdb3 is identified as a member of /dev/md2, slot 0.
> mdadm: added /dev/sdd3 to /dev/md2 as 1
> mdadm: no uptodate device for slot 2 of /dev/md2
> mdadm: no uptodate device for slot 3 of /dev/md2
> mdadm: added /dev/sdc3 to /dev/md2 as 4
> mdadm: added /dev/sdb3 to /dev/md2 as 0
> mdadm: /dev/md2 assembled from 2 drives and 1 spare - not enough to start
> the array.
>

The remaining drives: sdb and sdd, are slot '0' and '1' though I suspect
you expected them to be '1' and '3'.
As they are 0 and 1, they don't provide all of the data.
You need to figure out which slot sdc3 used to occupy and recreate
the array using 'missing' for the fourth drive and '--assume-clean'
to avoid resync.
 e.g. mdadm -S /dev/md2
      mdadm --create /dev/md2 --level 10 --layout f2 --assume-clean \
                /dev/sdb3 /dev/sdd3 missing /dev/sdc3
That is assuming that you figure out that sdc3 was slot '3' (counting
from 0).

The only way I can think of to find out where sdc3 was slot 2 or
slot 3 is to try each of them and then run a 'check' and see what
the mismatch count is.

So run the above --create command, but don't fsck or mount or anything
else to the device.
Then    echo check > /sys/block/md2/md/sync_action
and watch the value of
            /sys/block/md2/md/mismatch_cnt

if that keeps getting big, the we picked the wrong slot.
If it stays fairly small (maybe a few hundred) then we probably got the
right slot.
To try the other arrangement, use the same command except for the last
two words which should be swapped:   /dev/sdc3 missing

Once you have the array working again with 3 disks, choose a disk
to remove that will leave the array still functional.  For a 4 disk
raid10 in f2, you need either both even devices (0 and 2) or both
odd devices (1 and 3).

Then continue with your original plan.
--re-add should work if you have picked the right drive and have a
bitmap.


Good luck.

NeilBrown



