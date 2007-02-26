From: jahammonds prost <gmitch64@yahoo.com>
Subject: Re: trouble creating array
Date: Mon, 26 Feb 2007 03:40:32 -0800 (PST)
Message-ID: <455743.17233.qm@web55801.mail.re3.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ah ha....

# ls -l /sys/block/*/holders/*
lrwxrwxrwx 1 root root 0 Feb 26 06:28 /sys/block/sdb/holders/dm-0 -> ../../../block/dm-0
lrwxrwxrwx 1 root root 0 Feb 26 06:28 /sys/block/sdc/holders/dm-0 -> ../../../block/dm-0

which I am assuming is dmraid? I did a quick check, and

# dmraid -r
No RAID disks

Doesn't look like there is anything defined.  I know that both sdb and sdc (as well as sda) are connected to SATA cards which support RAID under windows... However, I know there is no arrays defined on them on the cards (at least not by me)... I will bounce the server again and check.


Graham



----- Original Message ----
From: Neil Brown <neilb@suse.de>
To: jahammonds prost <gmitch64@yahoo.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>; linux-raid@vger.kernel.org
Sent: Sunday, 25 February, 2007 11:40:26 PM
Subject: Re: trouble creating array


On Sunday February 25, gmitch64@yahoo.com wrote:
> 
> 
> Any ideas how to find out what has it open? I can happily write all over the disk with dd... I can create and delete the partition, and it's all good... I will try deleting the sd{b,c}1 partitions, reboot, and see what happens.
> 

ls -l /sys/block/*/holders/* ??

NeilBrown


		
___________________________________________________________ 
The all-new Yahoo! Mail goes wherever you go - free your email address from your Internet provider. http://uk.docs.yahoo.com/nowyoucan.html
