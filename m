From: Andrew Burgess <aab@cichlid.com>
Subject: Re: help!
Date: Tue, 15 Nov 2005 06:29:42 -0800
Message-ID: <200511151429.jAFETgfK014238@cichlid.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>> >I had an mdadm device running fine, and had created my own scripts for 
>> >shutting it down and such. I upgraded my distro, and all of a sudden it 
>> >decided to start initializing md devices on it's own, which include one 
>> >that I want removed.
>>
>They were indeed set to raid autodetect. I was unaware of what that 
>actually did, I think I must have followed that step in a how-to when I 
>originally set it up. The odd thing is that these are the partition 
>pairs that were being mounted:
>sda sdb
>sda1 sdb1
>sdc1 sdd1
>The last 2 are the ones I actually wanted, but the first one was 
>something I had done when I was first playing around with it, if memory 
>serves me correct. Is that possible, or does it point to some other issue?

If changing the partition type does not work then you might try
zeroing the superblock with 'mdadm --zero-superblock /dev/sda'
etc.

AFAIK the superblock and the mdadm.conf file are mdadms only
information sources. Remove them both and it should be impossible
for the unwanted raid devices to start.

A funny thing here is that I believe the superblock for sda and
sda1 are in exactly the same place, at the end of the disk, so I
can't see how it would find two different raid devices. What
version superblocks are you using? I think v1 superblocks are at
the beginning of the device and I'm not sure if the first disk
block for sda is the same as the first block for sda1...

HTH (and it could be all wrong)
