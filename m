From: "John Doe" <public_address_911@hotmail.com>
Subject: Re: Problem converting raid-5 array from 2.2.17 into 2.4.22
Date: Wed, 03 Sep 2003 18:47:44 +0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Law12-F118KjtgZe0J600017bf2@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
To: public_address_911@hotmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Problem solved!

Using mdadm, I discovered that the superblock's checksum was supposed to
be something else, but it was - zero! So, I wondered, what the heck, maybe
if I'd use some hex editor and change the actual checksum to be what it
expects... and turns out that it worked!

So it appears that there is a bug in "mkraid --upgrade" that leaves the 
checksum
being zero, while it should (re)calculate the checksum and set it to its 
correct
value after upgrading. I used the raidtools version 0.90.x which comes with 
debian
stable, though; I don't know it the problem exists if you upgrade with 
raidtools
1.00.x. I can provide details if someone is interested.

If someone else has experienced this, I recommend lde (linux disk editor) 
for editing
the raid root block. Block numbers I found from an old syslog (where it says 
that
raid disk cannot be due to invalid superblock checksum)

Phew!

-J

>From: "John Doe" <public_address_911@hotmail.com>
>To: linux-raid@vger.kernel.org
>Subject: Re: Problem converting raid-5 array from 2.2.17 into 2.4.22
>Date: Wed, 03 Sep 2003 16:47:14 +0300
>
>># mdtab entry for /dev/md0
>>/dev/md0        raid5,128k,0,93fa4522   /dev/hda3 /dev/hdb1 /dev/hdc1 
>>/dev/hdd1
>>
>># /etc/raidtab:
>>raiddev /dev/md0
>>        raid-level      5
>>        nr-raid-disks   4
>>        nr-spare-disks  0
>>        persistent-superblock   1
>>        parity-algorithm        left-symmetric
>>        chunk-size      32
>[...]
>>This one was copied straight from Software-RAID HOWTO, unfortunately I 
>>noticed only afterwards that the chunk-size was different than it was 
>>before.
>
>I also reproduced the situation on a different machine and different disks,
>with this time the right chunk-size (128 kb). And it didn't work either!
>
>So it seems that "mkraid --upgrade" will *always* break a raid5 setup, at 
>least
>if it's me doing the conversion :)
>
>This sounds pretty alarming.
>
>I hope there is some way to reconstruct the superblocks or change their
>checksums or something. Next I'm going to spend a few hours investigating 
>if
>mdadm and newer raidtools have options for doing this.
>
>-J
>
>_________________________________________________________________
>Get MSN 8 and help protect your children with advanced parental controls.  
>http://join.msn.com/?page=features/parental
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

_________________________________________________________________
Get MSN 8 and enjoy automatic e-mail virus protection.    
http://join.msn.com/?page=features/virus

