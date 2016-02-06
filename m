From: =?UTF-8?Q?Andr=c3=a9_Teichert?= <andre_teichert@gmx.de>
Subject: Re: mdadm raid5 dropped 2 disks
Date: Sat, 6 Feb 2016 11:54:59 +0100
Message-ID: <56B5D103.8070908@gmx.de>
References: <56B479DD.7070600@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56B479DD.7070600@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Wol,
the raid is save now. I didnt work on the disks itself only with images.

dd if=/dev/sd[abc]1 of=/mnt/image[123].dd bs=1

losetup /dev/loop1 /mnt/image1.dd
losetup /dev/loop2 /mnt/image2.dd

mdadm --create /dev/md0 --raid-devices=3 --level=5 --assume-clean 
--size=976631296 --raid-devices=3 missing /dev/loop2 /dev/loop1

fsck without any errors. Data is back!

What I maybe did wrong in the first run?
1) I wrote the first backup of the disks to partitions, that were a 
little bigger than the original one. These were fresh drives with no 
data writen so far.
2) I did the create with the right order (missing loo2 loop1)  from 
mdadm -E "Device Role"

glad it worked. Will save lsdrv and hope never to use it. Create new 
backupplan!

cheers
