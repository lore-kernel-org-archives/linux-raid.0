From: LM <linux-raid@moellendorf.eu>
Subject: Level change from 4 disk RAID5 to 4 disk RAID6
Date: Sat, 8 Apr 2017 23:42:39 +0200
Message-ID: <20170408214239.GF10267@lars-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have a 4 disk RAID5, the used dev size is 640.05 GB. Now I want to
replace the 4 disks by 4 disks with a size of 2TB each.

As far as I understand the man page, this can be achieved by replacing
the devices one after another and for each device rebuild the degraded
array with:

   mdadm /dev/md0 --add /dev/sdX1

Then the level change can be done together with growing the array:

   mdadm --grow /dev/md0 --level=raid6 --backup-file=/root/backup-md0

Does this work?

I am asking if it works, because the man page also says:

> mdadm --grow /dev/md4 --level=6 --backup-file=/root/backup-md4
>        The array /dev/md4 which is currently a RAID5 array will
>        be converted to RAID6.  There should normally already be
>        a spare drive attached to the array as a RAID6 needs one
>        more drive than a matching RAID5.

And in my case only the size of disks is increased, not their number.

Thanks,
Lars
