From: "John Doe" <public_address_911@hotmail.com>
Subject: Re: Problem converting raid-5 array from 2.2.17 into 2.4.22
Date: Wed, 03 Sep 2003 16:47:14 +0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Law12-F108KH6ddsaTf0002401d@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

># mdtab entry for /dev/md0
>/dev/md0        raid5,128k,0,93fa4522   /dev/hda3 /dev/hdb1 /dev/hdc1 
>/dev/hdd1
>
># /etc/raidtab:
>raiddev /dev/md0
>        raid-level      5
>        nr-raid-disks   4
>        nr-spare-disks  0
>        persistent-superblock   1
>        parity-algorithm        left-symmetric
>        chunk-size      32
[...]
>This one was copied straight from Software-RAID HOWTO, unfortunately I 
>noticed only afterwards that the chunk-size was different than it was 
>before.

I also reproduced the situation on a different machine and different disks,
with this time the right chunk-size (128 kb). And it didn't work either!

So it seems that "mkraid --upgrade" will *always* break a raid5 setup, at 
least
if it's me doing the conversion :)

This sounds pretty alarming.

I hope there is some way to reconstruct the superblocks or change their
checksums or something. Next I'm going to spend a few hours investigating if
mdadm and newer raidtools have options for doing this.

-J

_________________________________________________________________
Get MSN 8 and help protect your children with advanced parental controls.  
http://join.msn.com/?page=features/parental

