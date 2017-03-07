From: Phil Turmel <philip@turmel.org>
Subject: Re: [RAID recovery] Unable to recover RAID5 array after disk failure
Date: Tue, 7 Mar 2017 09:52:15 -0500
Message-ID: <f0536882-3a0b-b43c-317d-691d82c6923f@turmel.org>
References: <CAJ0QwkJqRbJtM9HiXL+cCj2TkQQRahGgWTwD9QKH_CBfbJeLKA@mail.gmail.com>
 <0a6e4a82-665c-6e62-293f-151e41c67842@turmel.org>
 <CAJ0QwkKAVLh7+kV_GsEL4O5hA+Pj=Y9sE_CBbWJJqDyA+gVqpA@mail.gmail.com>
 <CAJ0QwkKuSKzE7_4h1aUA4XMyNAAdmFR4J6z+Z_vW5nsW3OcZtw@mail.gmail.com>
 <c3ae0e4d-dccc-9cb4-72b0-28a1bde3c752@turmel.org>
 <CAJ0QwkKG8_dCzTBYEPm5CpqWMQwM=f8YBAYtatNh=9U_7ygdnA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJ0QwkKG8_dCzTBYEPm5CpqWMQwM=f8YBAYtatNh=9U_7ygdnA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Olivier Swinkels <olivier.swinkels@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/07/2017 03:39 AM, Olivier Swinkels wrote:

> After I used the pvcreate command to recreate pv the vgcfgrestore 
> command succeeds and the lvm is available (after activating).
> 
> However when I try to mount it I get the following error: sudo mount
> -t ext4 /dev/lvm-raid/lvm0 /mnt/raid mount: mount
> /dev/mapper/lvm--raid-lvm0 on /mnt/raid failed: Structure needs
> cleaning
> 
> So I guess the underlying RAID array is still not ok...

No, your underlying array is very likely correct.  But the intervening
incorrect --create operation stomped on your filesystems.  Run fsck
while unmounted to deal with the corruption and recover what you can.

Run fsck with "-n" first, to see just how extensive the problems are,
then with "-y" to actually fix things.  Based on your sequence of
events, your corruptions should be at low sector addresses (first few
Gigs) of your array.  If that's what appears with "-n", proceed.

If you are unlucky, the stompage hit one or more of your filesystems'
superblocks, requiring access to backup superblocks.  If you still see
no progress with either of the above, you might need to search your
array for ext2/3/4 superblocks.  This grep would help:

dd if=/dev/md0 bs=1M count=16k 2>/dev/null |hexdump -C |grep '30  .\+  53 ef 0'

(Not all hits from the grep will be superblocks, but they would be
visually distinguishable, and would have decipherable timestamps.)

Phil
