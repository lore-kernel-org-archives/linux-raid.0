From: Stefanie Leisestreichler <stefanie.leisestreichler@peter-speer.de>
Subject: Re: Setup Recommendation on UEFI/GRUB/RAID1/LVM
Date: Tue, 14 Apr 2020 17:12:02 +0200
Message-ID: <13a3bc12-67f7-46d5-7e6a-c6880ace4b1c@peter-speer.de>
References: <fc12df3c-aac9-4aa8-a596-f13225161e22@peter-speer.de>
 <5E95C698.1030307@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5E95C698.1030307@youngman.org.uk>
Content-Language: de-DE
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On 14.04.20 16:20, Wols Lists wrote:
> okay. sda1 is vfat for EFI and is your /boot. configure sdb the same,
> and you'll need to manually copy across every time you update (or make
> it a v0.9/v1.0 raid array and only change it from inside linux - tricky)
If I would like to stay with my intial thought and use GRUB, does this 
mean, I have to have one native partition for the UEFI System Partition 
formated with vfat on each disk? If this works and I will create an raid 
array (mdadm --create ... level=1 /dev/sda1 /dev/sda2) from these 2 
partitions, will I still have the need to cross copy after a kernel 
update or not?

> 
> sda2 - swap. I'd make its size equal to ram - and as I said, same on sdb
> configured in linux as equal priority to give me a raid-0.
Thanks for this tip, I would prefer swap and application safety which 
comes with raid1 in this case. Later I will try to optimize swappiness.

> 
> sda3 / sdb3 - the remaining space, less your 100M, raided together. You
> then sit lvm on top in which you put your remaining volumes, /, /home,
> /var/lib/mysql and /var/lib/images.
OK. Does this mean that I have to partition my both drives first and 
after that create the raid arrays, which will end in /dev/md0 for ESP 
(mount point /boot), /dev/md1 (swap), /dev/md2 for the rest?

What Partition Type do I have to use for /dev/sd[a|b]3? Will it be LVM 
or RAID?

> 
> Again, personally, I'd make /tmp a tmpfs rather than a partition of its
> own, the spec says that the system should*expect*  /tmp to disappear at
> any time and especially on reboot... while tmpfs defaults to half ram,
> you can specify what size you want, and it'll make use of your swap space.
Agreed, no LV for /tmp.

Thanks,
Steffi
