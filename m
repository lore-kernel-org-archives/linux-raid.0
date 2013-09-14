From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: mdadm 3.3 fails to kick out non fresh disk
Date: Sat, 14 Sep 2013 16:33:55 +0200
Message-ID: <CAC9WiBh9EOFKx99fTH2yYN62A5CAg4_mqpNtxj6jZOZE+_Raww@mail.gmail.com>
References: <CAC9WiBgGgKGHqcwrVo7J_peS8YiH-KBF8T1uGbwJrve_7aa3cw@mail.gmail.com>
	<20130914064305.0baadc69@notabene.brown>
	<CAC9WiBhbyV6Xpu=7HvKUK1hXNw1uC+QZcDOM0R9zUCMrR7WNtQ@mail.gmail.com>
	<20130914203800.385466b2@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130914203800.385466b2@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Sep 14, 2013 at 12:38 PM, NeilBrown <neilb@suse.de> wrote:
> On Sat, 14 Sep 2013 00:35:47 +0200 Francis Moreau <francis.moro@gmail.com>
> wrote:
>
>> Hi Neil,
>>
>> On Fri, Sep 13, 2013 at 10:43 PM, NeilBrown <neilb@suse.de> wrote:
>> > On Fri, 13 Sep 2013 15:22:20 +0200 Francis Moreau <francis.moro@gmail.com>
>> > wrote:
>> >
>> >> Hi Neil,
>> >>
>> >> I'm probably doing something wrong since it's a pretty critical bug
>> >> but can't see what.
>> >>
>> >> I'm creating a RAID1 array with 1.2 metadata. After that I stop the
>> >> array, and restart the array with only one disk. I write random data
>> >> on the array and then stop it again:
>> >>
>> >> # mkfs.ext4 /dev/md125
>> >> # mdadm --stop /dev/md125
>> >> # mdadm -IRs /dev/loop0
>> >> # mount /dev/md125 /mnt/
>> >> # date >/mnt/foo
>> >> # umount /mnt
>> >> # mdadm --stop /dev/md125
>> >>
>> >> Finally I restart the array with the 2 disks (one disk is outdated)
>> >> and mdadm happily activates the array without error. Note that I add
>> >> the outdated disk first in that case:
>> >>
>> >> # mdadm -IRs /dev/loop1
>> >> mdadm: /dev/loop1 attached to /dev/md/array1, which has been started.
>> >> # mdadm -IRs /dev/loop0
>> >> mdadm: /dev/loop0 attached to /dev/md/array1 which is already active.
>> >
>> > That's a worry.  I'm not sure how to fix it.
>> >
>> > I would probably suggest you don't use "-IR" to add devices.  That would make
>> > it a lot less likely to happen.
>> >
>>
>> Well I'm not sure how I should start an array...
>>
>> For example doing:
>>
>> # mdadm -I /dev/loop0
>> # mdadm -I /dev/loop1
>> # mdadm -R /dev/md125
>>
>> works for array using metadata 1.2 but doesn't if the array is using
>> DDF (mdmon not started). To workaround this issue you suggested to use
>> -IRs:
>>
>> # mdadm -IRs /dev/loop0
>> # mdadm -IRs /dev/loop1
>
> This isn't what I meant.
> I mean that after you had run
>   mdadm -I /dev/foo
> for all devices, you then run
>   mdadm -IRs
> to start any that are degraded.

oh sorry I misunderstood what you previously wrote. Using '-I' to add
devices make mdadm to notice that one disk is outdated.

>
> BTW I think I've fixed the issue with mdadm -R /dev/md125 for DDF.
> Try the latest git.

It seems it fixes the issue: mdmon is now correctly started with a
degraded DDF array.

However, after using the system with only one disk (sda), sdb is now
outdated. I rebooted the system with 2 disks but mdadm doesn't seem to
notice that sdb is outdated:

# mdadm -I /dev/sda
mdadm: container /dev/md/ddf0 now has 1 device
mdadm: /dev/md/array1_0 assembled with 1 device but not started
# mdadm -I /dev/sdb
mdadm: container /dev/md/ddf0 now has 2 devices
mdadm: Started /dev/md/array1_0 with 2 devices (1 new)
# cat /proc/mdstat
Personalities : [raid1]
md126 : active (auto-read-only) raid1 sdb[1] sda[0]
      2064384 blocks super external:/md127/0 [2/2] [UU]

md127 : inactive sdb[1](S) sda[0](S)
      65536 blocks super external:ddf

So this time mdadm fails to kick out non fresh disk (when using '-I')
but with DDF.

Thanks
-- 
Francis
