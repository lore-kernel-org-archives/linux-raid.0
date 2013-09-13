From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: mdadm 3.3 fails to kick out non fresh disk
Date: Sat, 14 Sep 2013 00:35:47 +0200
Message-ID: <CAC9WiBhbyV6Xpu=7HvKUK1hXNw1uC+QZcDOM0R9zUCMrR7WNtQ@mail.gmail.com>
References: <CAC9WiBgGgKGHqcwrVo7J_peS8YiH-KBF8T1uGbwJrve_7aa3cw@mail.gmail.com>
	<20130914064305.0baadc69@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130914064305.0baadc69@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

On Fri, Sep 13, 2013 at 10:43 PM, NeilBrown <neilb@suse.de> wrote:
> On Fri, 13 Sep 2013 15:22:20 +0200 Francis Moreau <francis.moro@gmail.com>
> wrote:
>
>> Hi Neil,
>>
>> I'm probably doing something wrong since it's a pretty critical bug
>> but can't see what.
>>
>> I'm creating a RAID1 array with 1.2 metadata. After that I stop the
>> array, and restart the array with only one disk. I write random data
>> on the array and then stop it again:
>>
>> # mkfs.ext4 /dev/md125
>> # mdadm --stop /dev/md125
>> # mdadm -IRs /dev/loop0
>> # mount /dev/md125 /mnt/
>> # date >/mnt/foo
>> # umount /mnt
>> # mdadm --stop /dev/md125
>>
>> Finally I restart the array with the 2 disks (one disk is outdated)
>> and mdadm happily activates the array without error. Note that I add
>> the outdated disk first in that case:
>>
>> # mdadm -IRs /dev/loop1
>> mdadm: /dev/loop1 attached to /dev/md/array1, which has been started.
>> # mdadm -IRs /dev/loop0
>> mdadm: /dev/loop0 attached to /dev/md/array1 which is already active.
>
> That's a worry.  I'm not sure how to fix it.
>
> I would probably suggest you don't use "-IR" to add devices.  That would make
> it a lot less likely to happen.
>

Well I'm not sure how I should start an array...

For example doing:

# mdadm -I /dev/loop0
# mdadm -I /dev/loop1
# mdadm -R /dev/md125

works for array using metadata 1.2 but doesn't if the array is using
DDF (mdmon not started). To workaround this issue you suggested to use
-IRs:

# mdadm -IRs /dev/loop0
# mdadm -IRs /dev/loop1

but now mdadm can't detect outdated disk anymore.

Could you suggest something to start an array which would work in all
cases (ddf or 1.2, add non-fresh disk...) ?

>
>> # cat /proc/mdstat
>> Personalities : [raid1]
>> md125 : active raid1 loop0[0] loop1[1]
>>       117056 blocks super 1.2 [2/2] [UU]
>> # mount /dev/md125 /mnt
>> # ls /mnt/
>> [  457.321771] EXT4-fs error (device md125): ext4_lookup:1047: inode
>> #2: comm ls: deleted inode referenced: 12
>> ls: cannot access /mnt/1: Input/output error
>>
>> If I add the outdated disk last I got this:
>> # mdadm -IRs /dev/loop0
>> mdadm: /dev/loop0 attached to /dev/md/array1, which has been started.
>> # mdadm -IRs /dev/loop1
>> mdadm: can only add /dev/loop1 to /dev/md/array1 as a spare, and
>> force-spare is not set.
>> mdadm: failed to add /dev/loop1 to existing array /dev/md/array1:
>> Invalid argument.
>>
>> which didn't tell me the reason why loop1 must be a spare.
>
> It  must be a spare because it is out of date.
>

Yes but I think mdadm should tell the reason, no  ?

Thanks
-- 
Francis
