From: Carlos Mennens <carloswill@gmail.com>
Subject: Re: RAID Configuration For New Home Server
Date: Wed, 2 Jun 2010 09:00:04 -0400
Message-ID: <AANLkTilAzPKlOMecKpQLIEPOqAhFDglR5STq3_QP_caW@mail.gmail.com>
References: <C5.28.17309.03BF50C4@cdptpa-omtalb.mail.rr.com>
	<e35643473b05cc946fc35c0df2e85fcd.squirrel@mail.monkii.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e35643473b05cc946fc35c0df2e85fcd.squirrel@mail.monkii.net>
Sender: linux-raid-owner@vger.kernel.org
To: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Jun 2, 2010 at 3:54 AM,  <tron@monkii.net> wrote:
> There are about as many answers to this as there are people using your
> setup so let's all agree that there's no "one way" of doing things.

Thanks for all the suggestions and you guys are right. There will no
right or wrong answer here but I just want to make sure I am not doing
anything that will hinder / limit performance in my system. At most my
system will simply idle and do nothing more than store a few files for
me so I think RAID5 is going to be my selection for my / file system.
I have 4 identical drives and need to partition them all the same to
avoid any inconsistencies across the RAID array. Since Grub doesn't
support RAID5 for /boot, I will need to make a 4 disk RAID1 for /boot
& do the same for Swap. Does this look reasonable to you guys?

Partitioning the 1st disk below:

/dev/sda1 100 MB - RAID (bootable)
/dev/sda2     2 GB - RAID
/dev/sda3 320 GB - RAID

Do that same partition schema above for all 4 drives and then create my RAID:

/
mdadm --create /dev/md0 --level=5 --raid-devices=4 /dev/sda3 /dev/sdb3
/dev/sdc3 /dev/sdd3

/boot
mdadm --create /dev/md1 --level=1 --raid-devices=4 /dev/sda1 /dev/sdb1
/dev/sdc1 /dev/sdd1

Swap
mdadm --create /dev/md2 --level=1 --raid-devices=4 /dev/sda2 /dev/sdb2
/dev/sdc2 /dev/sdd2

Would you guys change anything in my partition or 'mdadm' command?
