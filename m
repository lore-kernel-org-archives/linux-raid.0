From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: RAID 1 | Test Booting from /dev/sdb
Date: Tue, 5 May 2020 10:39:03 +0200
Message-ID: <3e8685c3-a0a6-4614-073a-afe7bb67d2eb@thelounge.net>
References: <221092f3-5b8a-5d95-01d9-261e6449f747@peter-speer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <221092f3-5b8a-5d95-01d9-261e6449f747@peter-speer.de>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Stefanie Leisestreichler <stefanie.leisestreichler@peter-speer.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Am 05.05.20 um 10:11 schrieb Stefanie Leisestreichler:
> I want to test if grub is installed on both of the HDs which are part of
> my raid1 array. I wonder which would be the best solution to do so.
> 
> I think I will archive that when I shutdown the computer, make /dev/sda
> powerless and see if it is able to boot from /dev/sdb.
> 
> If it is not booting /dev/sdb will have no changes, I would shutdown,
> connect /dev/sda with power again, turn it on and do a "grub-install
> /dev/sdb". Depending on the state of the array (I guess it will need
> recovery) I would do a "mdadm /dev/md0 --add /dev/sdb1". After recovery
> I would try it again.

grub is *before* the RAID partitions and you need to run "grub2-install
/dev/sda" as well as "grub2-install /dev/sdb"

and you have to repeat that every time a disk fails and is replaced

the boot loader is in front of the first partition and that was the
reason a few years ago that you had to make sure there are 2 MB instead
of the old 512 KB by switch to grub2 on machines dating back to 2008 or
so where the default was smaller

> If it is booting from /dev/sdb this HD will have "more" data because of
> the one boot process than /dev/sda. I am not sure if it is a good idea
> to shutdown and just connect /dev/sda with power again, boot (assuming
> /dev/sda is the standard boot medium) because I do not know in which
> state the array will be. What to do in case I do not want to loose data
> from the last boot process with /dev/sdb? Change boot medium to /dev/sdb
> and do a "mdadm /dev/md0 --add /dev/sda1" to get it recovered again
> without loosing the "added" data (i.e. in /var/log) from booting? Also
> device identifiers could change I guess. Even if I am fine with loosing
> the "added" data from booting with /dev/sdb, will - when booting again
> from /dev/sda - /dev/sda be the master in the array again?
> 
> It is not clear to me if I understood correctly in which case which
> array member will be the master which will be the base for recovery. Is
> it always the HD one booted from?
> 
> Could you please help me with that?

you shouldn't remove disks and put them back without a good reason and
verify booting is not a good one

just change the boot order, switch the cables or explicit select both
disks in BIOS
