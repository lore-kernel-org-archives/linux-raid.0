From: Joachim Otahal <Jou@gmx.net>
Subject: Re: RAID1 On 3 Drives
Date: Sat, 13 Mar 2010 23:30:19 +0100
Message-ID: <4B9C11FB.7040604@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Mar 14, 2010 at 12:06 AM, Carlos Mennens<carloswill@gmail.com>  wrote:
>  I was told by my distributions Wiki page that Grub doesn't support
>  RAID 5 or RAID 6 so I would need to create a volume with three disks
>  and set the level to RAID 1:
>
>  # mdadm --create /dev/md1 --level=1 --raid-devices=3 /dev/sda1
>  /dev/sdb1 /dev/sdc1 --spare-devices=1 /dev/sdd1
>
>  Is this possible to mirror three identical drive partitions? I was
>  talking to some co-workers and was told that I could only pair two
>  drives on RAID 1.
>
>  Can anyone please help me understand this?

/boot must be RAID1 (or a normal partition), everything else can be RAIDwhatever. Grub has no problems reading /boot from a mirrors.

It is possible to make RAID1 to use more than two drives and keep the all active. In your case it is a matter of "believe" whether a spare is better or actually using all four actively in your raid, I prefer the latter.
I have heavily tested more than two only with files via loopback yet, two drive, three drives, four drives and more. It does work, the testfile generated out of urandom kept the correct hash value throughout all my sick testings.
The quick test with three SATA drives worked too, but it was just for the fun to see whether grub pukes or works (works if you don't forget the grub setup for drive 2, 3 etc).
My plan is: Use RAID1 with 4 drives (quad-mirroring) for /boot or / and raid10 or raid5 for the data upon my next linux server upgrade.

Joachim Otahal


