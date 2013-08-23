From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: Accesses to not yet running array
Date: Fri, 23 Aug 2013 12:00:56 +0200
Message-ID: <CAC9WiBjBGD0J5vSe+q7y+UVGp2+++Ac++zeQ_=LUz9eQ-kCffA@mail.gmail.com>
References: <CAC9WiBgjEQxe_uymD6WW3Oj5Bm6aYD-RBD-8m3G40c1y3HUb0Q@mail.gmail.com>
	<20130821090634.413491d8@notabene.brown>
	<CAC9WiBiYYOjCVaa5tKVC7Lnkz7fcB2wHM0v2wdQUi=1Ufku5gA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC9WiBiYYOjCVaa5tKVC7Lnkz7fcB2wHM0v2wdQUi=1Ufku5gA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, Martin Wilck <mwilck@arcor.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

[ adding Martin in CC since it seems related to DDF... ]

On Wed, Aug 21, 2013 at 3:57 PM, Francis Moreau <francis.moro@gmail.com> wrote:
> Hello,
>
> On Wed, Aug 21, 2013 at 1:06 AM, NeilBrown <neilb@suse.de> wrote:
>> On Tue, 20 Aug 2013 16:08:47 +0200 Francis Moreau <francis.moro@gmail.com>
>> wrote:
>>
>>> hi,
>>>
>>> It looks like a process wait uninterruptibly when it tries to access
>>> an array which is not running yet.
>>>
>>> Furthermore once the process is waiting, I can't start/stop the array anymore.
>>>
>>> So I need to reboot my system and be sure next time that any processes
>>> don't try to access a not yet running array.
>>>
>>> Is that expected ?
>>>
>>
>> No.
>>
>> To be able to say more I would need lots more details.
>> What is the exact state of the array (cat /proc/mdstat ;mdadm -D ...)
>> Where is the process waiting (cat /proc/PID/stack)
>> What sort of "access"
>> How did the array get to the "not running yet" state?
>> Any kernel messages?
>> Anything else that might be relevant.
>>
>
> please find some details below:
>
> # uname -r
> 3.9.5-301.fc19.x86_64
>
> # mdadm --version
> mdadm - v3.2.6 - 25th October 2012
>
> # mdadm -I /dev/sda
> mdadm: container /dev/md/ddf0 now has 1 device
> mdadm: /dev/md/126 assembled with 1 device but not started
>
> # cat /proc/mdstat
> Personalities : [raid1]
> md126 : inactive sda[0]
>       8355840 blocks super external:/md127/0
>
> md127 : inactive sda[0](S)
>       32768 blocks super external:ddf
>
> unused devices: <none>
>
> # mdadm -R /dev/md126
> mdadm: started /dev/md126
>
> # cat /proc/mdstat
> Personalities : [raid1]
> md126 : active raid1 sda[0]
>       8355840 blocks super external:/md127/0 [2/1] [U_]
>
> md127 : inactive sda[0](S)
>       32768 blocks super external:ddf
>
> unused devices: <none>
>
> # mount /dev/md126p3 /mnt
> <stucks>
>
> # ps aux | grep mount
> root      1543  0.1  0.1 123404  1324 tty1     D+   09:43   0:00 mount
> /dev/md126p3 /mnt
>
> # cat /proc/1543/stack
> [<ffffffff814ce285>] md_write_start+0xb5/0x1a0
> [<ffffffffa0222b76>] make_request+0x46/0xc30 [raid1]
> [<ffffffff814c4403>] md_make_request+0xd3/0x230
> [<ffffffff812cdee2>] generic_make_request+0xc2/0x110
> [<ffffffff812cdfa3>] submit_bio+0x73/0x160
> [<ffffffff811ca544>] submit_bh+0x114/0x1e0
> [<ffffffff811cb263>] __sync_dirty_buffer+0x53/0xe0
> [<ffffffff811cb303>] sync_dirty_buffer+0x13/0x20
> [<ffffffff8123dd38>] ext4_commit_super+0x198/0x230
> [<ffffffff81240015>] ext4_setup_super+0x125/0x1a0
> [<ffffffff8124353e>] ext4_fill_super+0x265e/0x2dc0
> [<ffffffff8119cce5>] mount_bdev+0x1b5/0x1f0
> [<ffffffff81232d35>] ext4_mount+0x15/0x20
> [<ffffffff8119d5e9>] mount_fs+0x39/0x1b0
> [<ffffffff811b679f>] vfs_kern_mount+0x5f/0xf0
> [<ffffffff811b8a6e>] do_mount+0x23e/0xa20
> [<ffffffff811b92d3>] sys_mount+0x83/0xc0
> [<ffffffff8164e799>] system_call_fastpath+0x16/0x1b
> [<ffffffffffffffff>] 0xffffffffffffffff
>
> # mdadm -D /dev/md126
> /dev/md126:
>       Container : /dev/md/ddf0, member 0
>      Raid Level : raid1
>      Array Size : 8355840 (7.97 GiB 8.56 GB)
>   Used Dev Size : 8355840 (7.97 GiB 8.56 GB)
>    Raid Devices : 2
>   Total Devices : 1
>
>           State : active, degraded
>  Active Devices : 1
> Working Devices : 1
>  Failed Devices : 0
>   Spare Devices : 0
>
>     Number   Major   Minor   RaidDevice State
>        0       8        0        0      active sync   /dev/sda
>        1       0        0        1      removed
>
> # mdadm -D /dev/md127
> /dev/md127:
>         Version : ddf
>      Raid Level : container
>   Total Devices : 1
>
> Working Devices : 1
>
>   Member Arrays : /dev/md/126
>
>     Number   Major   Minor   RaidDevice
>
>        0       8        0        -        /dev/sda
>
> # mdadm -R /dev/md126
> mdadm: failed to run array /dev/md126: Device or resource busy
>

This issue doesn't exist if I'm using the linux native format 1.2.

Martin, any idea about this issue which seems related to DDF ?

Thanks
-- 
Francis
