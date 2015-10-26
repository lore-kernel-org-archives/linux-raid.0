From: Anugraha Sinha <asinha.mailinglist@gmail.com>
Subject: Re: Converting 4 disk RAID10 to RAID5
Date: Mon, 26 Oct 2015 23:09:20 +0900
Message-ID: <562E3410.3080701@gmail.com>
References: <562D8142.80507@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <562D8142.80507@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Adam

On 10/26/2015 10:26 AM, Adam Goryachev wrote:
> 1) fail two drives from the array:
> mdadm --manage /dev/md0 --fail /dev/sdb1
> mdadm --manage /dev/md0 --remove /dev/sdb1
> mdadm --manage /dev/md0 --fail /dev/sdd1
> mdadm --manage /dev/md0 --remove /dev/sdd1
> mdadm --misc --zero-superblock /dev/sdb1
> mdadm --misc --zero-superblock /dev/sdd1
>
> It seems that RAID10 device number is in order:
> sdb1 device0
> sdc1 device1
> sdd1 device2
> sde1 device3
> Therefore, I can fail device 0 (sdb1) and device 2 (sdd1) without losing
> any data.
>
> 2) create a 3 disk RAID5 with one disk missing.
> mdadm --create /dev/md1 --level=5 --raid-devices=3 /dev/sdb1 /dev/sdd1
> missing
>
> 3) Then copy all of the existing data across
> unmount partitions, stop LVM/etc
> dd bs=16M if=/dev/md0 of=/dev/md1

I dont know why this would be necessary.

>
> 4) Finally, stop the md0, and add the two devices to the new raid5, and
> then grow the array to use the space on the 4th drive.
> mdadm --manage --stop /dev/md0
> mdadm --misc --zero-superblock /dev/sdc1
> mdadm --manage /dev/md1 --add /dev/sdc1
> mdadm --misc --zero-superblock /dev/sde1
> mdadm --manage /dev/md1 --add /dev/sde1
> mdadm --grow /dev/md1 --raid-devices=4
>
> 5) Add the space to my LVM
> pvresize /dev/md1
>
> 6) Start up LVM, mount LV's, etc

I tried your method on a local system, and it seemed to worked.

The reason why I said that dd would'nt be necessary, as it is raid 
syncing would work. You just need to be careful that you should not 
start doing remove/add and other changing aspects of raid till the time 
syncing is going on.
Finally when you grow your raid in RAID5 also syncing would happen.

Regards
Anugraha Sinha
