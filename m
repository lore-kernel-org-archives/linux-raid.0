From: Jeff Hill <jhill@hrpost.com>
Subject: Re: Removing a Raid Partition? How-to?
Date: Fri, 17 May 2002 05:17:01 +0000 (UTC)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <5.1.0.14.0.20020606010151.01f86e00@205.233.215.4>
References: <5.1.0.14.0.20020514171826.01f64070@205.233.215.4>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.33.0205151051560.23601-100000@kopernikus.tux-we
 b.de>
To: "Gernot A. Weber" <gernot@tux-web.de>, Jeff Hill <jhill@hronline.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I was playing around with a test system and tried your method with one 
drive rather than just zeroing the superblock as Neil Brown suggested. It 
might just be something flaky with my scsi drive, but I couldn't fdisk the 
thing afterwards, kept getting scsi parity errors when I tried to write a 
new partition table.

I tried doing low level formats with the Adaptec controller, no luck.  I 
tried scsitools, etc., and eventually had to get Seagate's seatools to do a 
low-level format in order to be able to use fdisk again (I also tried 
cfdisk, etc.).

Not saying your method wouldn't work for most, but thought I should  note 
what happened to me.

Regards,

Jeff

At 10:54 AM 15/05/2002 +0200, Gernot A. Weber wrote:
>Hi,
>
>try a "dd if=/dev/zero of=/dev/sda" if your disk is the first SCSI disk.
>Replace sda with the right devive name. Don't enter a partition number -
>just the device name. dd should overwrite the MBR and the partition table.
>
>Good luck
>
>    Gernot Weber
>
>--
>Gernot A. Weber
>http://www.tux-web.de
>
>Only wimps use tape backup: _real_ men just upload their important stuff
>on ftp, and let the rest of the world mirror it.
>
>                               Linus Torvalds, after a hard drive crash
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

