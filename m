From: "Tiago Pinheiro" <tpinheiro@gmail.com>
Subject: Re: Resize / file system and create /home in existing raid 1
Date: Tue, 6 May 2008 15:58:00 +0200
Message-ID: <5a3dd2390805060658j38b7d5cfwf41991ef21525cf4@mail.gmail.com>
References: <5a3dd2390805051335s7b163505w5d94206dcb56b8a4@mail.gmail.com>
	 <18463.33260.564139.783585@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18463.33260.564139.783585@tree.ty.sabi.co.uk>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi there,

Thanks for your prompt answer!


> [ ... reshaping from ... ]
>
>
>  > - / is in a Raid 1 array (/dev/md0) consisting of two
>  >   partitions - sda1 and sdb1 (ca. 148 GB);
>  > - swap in Raid 0 (/dev/md1) - sda2 and sdb2 of ca. 1 GB each
>  >   giving me 2 GB in total:
>
>  [ ... to ... ]
>
>
>  > - resize the partition containing the / file system to 27 GB
>  >   keeping it in RAID 1 (/dev/md0);
>  > - create a new partition of 120GB to mount /home, also in RAID
>  >   1 (/dev/md2);
>  > - change swap from a RAID 0 to a RAID 1, resizing it to 2GB
>  >   (/dev/md1).

Yep, that's essentially it.


>  > Can this be done without reinstalling everything from scratch?
>
>  You have two mirrored disks so it is trivial.

Not so trivial to me... :)


>  Break the mirroring, repartition 'sdb' say into 'sdb[123]',
>  'mkfs' the 'sdb[13]' partitions, 'mkswap' the 'sdb2' partition,
>  copy stuff from 'sda1' to 'sdb1' and 'sdb3', reboot from 'sdb1'
>  without any RAID, repartition 'sda' in the same way as 'sdb',
>  then recreate new RAID mirrors ('md0' as 'sda1' and 'sdb1'
>  etc.). You can do much the same from a live CD eliminating the
>  obvious steps.

Let's suppose I use a live CD. It seems safer and less error prone.
Step by step, we have:
- break the mirroring: it is my perception that this would not be
necessary as the system would not be aware of any raid. The only
problem I see here is the fact that the drives are partitioned as RAID
auto detect, but I might be seeing a problem where it is not there;

- repartition the drive and create file systems: fine, will use parted
to do it in a non-destructive manner, shrink sdb1 (ext3) to 27GB,
delete sdb2 (swap), create new sdb2 (ext3) with 120GB and create sdb3
(swap) with 2GB; I will have to set them as RAID autodetect as well,
right?

- copy stuff from sda1 to sdb1 (/) and sdb2 (/home): fine; will do
something like this 'find . -depth -print0 | sudo cpio --null --sparse
-pvd /target/';

- reboot from sdb1 without any raid: how can I do that? change
something in GRUB, or merely physically disconnecting sda? in any
case, won't sdb's partitions be seen as they should belong to a RAID?

- repartition sda: fine;

- recreate the arrays: will this be non-destructive? do I have to
recreate them as degraded (starting with sdb[123]) and then add the
other partitions (sda[123])? would this be ok, or is there a better
way of doing it? 'mdadm --create --verbose /dev/md0 --level=1
--raid-devices=2  /dev/sda1 missing';

Am I going in the right direction here?
Thanks for all the help.


>
>  Resizing is dangerous, shrinking is very dangerous, and most
>  filesystems don't support shrinking anyhow.

Would that mean that it is not possible to do it?


>
>  > Output of /proc/mdstat: [ ... ]
>
>  Why so much pointless stuff...

Sorry about that. It's just that I was apparently unable to
distinguish what would be necessary and what was not.


Cheers,
Tiago
