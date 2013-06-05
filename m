From: Drew <drew.kay@gmail.com>
Subject: Re: RAID5 recovery
Date: Wed, 5 Jun 2013 06:20:47 -0700
Message-ID: <CACJz6QsrCbghMBvVP7iQAWtS-BRYkDQYZ=hpOifOA-+Nhxvseg@mail.gmail.com>
References: <51AF28F2.3010701@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51AF28F2.3010701@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Philipp Frauenfelder <philipp.frauenfelder@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Phillip,

The experts will no doubt chime in quite quickly but I'm going to jump
in myself. Just glancing it over, I hope your friend has backups
because this one is messy at best.

> My RAIDs run well but one of my colleague in a Synology has failed. It was a
> 4-disk RAID5 and the hot-spare disk and one of the used disks (the middle
> one) failed. Unfortunately, he returned the disks to the vendor the get new
> ones.

Looking at the raid.status, this is a 4 disk RAID-5, there is no "hot
spare". RAID5 integrates the parity data across all disks so that
fourth disk is part of the array.

> So, we ended up with 2 out of 4 disks and trying to get the data of the
> disks now. My colleague copied the disks and we were trying to rebuild the
> RAID5 on the copies. We tried to do the rebuild on a PC runing a fairly
> recent Knoppix:

RAID-5 can only withstand a single disk failure. Losing two disks
together means the array is IMHO hosed. The first disk lost can be
recreated as the parity is distributed across the other disks. Once
you lose the second disk, there's no way to recreate the data from
parity and the stripes are essentially gone.

> root@Microknoppix:~# mdadm --create --assume-clean --level=5
> --raid-devices=4 --size=1948662272 /dev/md2 missing /dev/sda3 missing
> /dev/sdb3
> mdadm: /dev/sda3 appears to be part of a raid array:
>     level=raid5 devices=4 ctime=Thu May  9 22:47:08 2013
> mdadm: /dev/sdb3 appears to be part of a raid array:
>     level=raid5 devices=4 ctime=Thu May  9 22:47:08 2013
> Continue creating array? y
> mdadm: Defaulting to version 1.2 metadata
> mdadm: RUN_ARRAY failed: Input/output error
>
> Apparently, this did not work. :-(

For one, you can't create a 4 disk RAID5 with two missing disks. Even
if a third disk had been available, that command is extremely
dangerous as it overwrites the RAID superblock. In this case it
overwrote a 1.1 metadata array with a 1.2 which most likely toasted
any partitions or filesystem superblocks on the existing array.

> In the RAID wiki, it says one should ask here before trying a destroying to
> much, that's why I am asking here....

You probably read the info at:
https://raid.wiki.kernel.org/index.php/RAID_Recovery The --create
statement is very dangerous as it does overwrite existing data. You
did however capture the previous RAID info so if one of the experts
can help, you've got the info they'll need.

The better choice for recovery (from the wiki) is:
https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID

> Btw, attached is the raid.status and the dmesg output.
>
> Is there a hint what we need to do?

Pull out those backups. Hopefully one of the experts knows some magic
to recovering a two disk failure of RAID5 but I don't.


-- 
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie

"This started out as a hobby and spun horribly out of control."
-Unknown
