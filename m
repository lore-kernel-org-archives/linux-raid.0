From: Phil Ingram <pingram.au@gmail.com>
Subject: Thanks for the awesome
Date: Mon, 23 Mar 2015 22:04:06 +1030
Message-ID: <CACHsUB1s5E2=pqENvaMZtANVrzVuaH+-ebtpL4qAjETUCp-51g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

To all who have contributed to mdadm I thank you.  Last week for the
third time in my life I was able to recover from certain disaster.
This time it was a 4 disk complex raid10 that had lost 1 disk and
thrown another.  Smartctl said that one disk was genuinely faulty and
in replacing the drive I hadn't appropriately re-secured the sata
cable to the drive above it.  Long story short is the array started,
but disk 4 was flakey.  Metadata was updated on 2 drives and upon
reboot (after seeing critical messages echoed to my screen about XFS
saying "nope") the array couldn't be automatically started.

mdadm --misc -E /dev/sdb and I could forcibly re-create the array,
after following the iteratively scary recovery guide on your wiki.  I
wasn't writing to the array when it became corrupted so felt confident
in my decision - well, my choices were to either definitely lose
approx 4-5 TB of data or go for a seat of my pants hail mary...

I got to thank Neil in person at LCA 2013 in Canberra, but I had to
extend my thanks to the wider community after this third miracle.  I
can't imagine such a recovery with a hardware based solution.  i
probably wouldn't have had this issue with a proper drive array, but
this is a re-purposed pc->server conversion..


Thanks :)

p.s. the other 2 miracles were recovering a RAID5 that had thrown 2
disks (bad PSU) and reshaping a 2 disk RAID 1 array to a 3 disk RAID
5; amazing!!
