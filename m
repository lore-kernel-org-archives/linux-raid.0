From: Pascal Nobus <pascal@nobus.be>
Subject: Raid MBR
Date: Fri, 17 Sep 2010 10:12:51 +0200
Message-ID: <4C932303.5010706@nobus.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

After some succesfull and some not succesfull recovery's from Raid-1 
rashes, I finally want to understand the whole raid/mbr/lilo thing.
In the last 3 days I read so many page's about raid lilo mbr that my 
head is going to explode.
So I'll ask my questions here:

We normally use this
OS:	Slackware (10.1 - 13.0)
Disks	SATA (hot swappable Supermicro)
Raid	Raid-1 configured manually in /etc/raidtab
Bootlader: LILO looks like this
boot = /dev/md0
raid-extra-boot = mbr
image = /boot/vmlinuz
root = /dev/md0

Assumptions (please correct me if I'm wrong)
-Bios looks voor bootable media (order can be changed in Bios)
-The Bios names this disk 0x80, later on the kernel says it's sda (or da).
-Bios will see in sector 0x80 the partitioning of the disk, and will 
mount the first bootable Primary Partition.

And now the Questions:
Q: when I do a lilo -v, 3 MBR's got updated (/dev/md0 /dev/sda /dev/sdb)
Is this all the same data? In /boot I can see boot.0800 boot.0810 and 
boot.0900. It is not the same (used diff for that), so I presume I may 
not change the boot-order in the bios, or not swap disks physicaly?

Q: when boot = /dev/md0, will BIOS read from /dev/md0 (then how does it 
know from which devices it is assembled), or does it not look at 
/dev/md0 and just uses the first bootable primary partition (/dev/sda1)

Q: /dev/md0 is made of /dev/sda1 and /dev/sdb2, and sda breaks.
Now you pullout the broken disk and reboot. Now the good disk (sdb) will 
become sda, but it won't boot because the root-partition is not found on 
/dev/sda1 (it's on the second one with this disk)

Q: If I would throw away /dev/md2, (unmount it, and remove it from 
/etc/raidtab), it is not possible to re-assmeble /dev/md2 from another 
partition of that drive, I have to use a never used one before 
(/dev/md4). Where is this info stored (superblock?)

Q: For being totaly safe I need to
- put the boot partition from both disk always at the same place 
(sda1/sdb1 or sda2/sdb2 or sda3/sdb3)
- use this option boot = /dev/md0, raid-extra-boot = mbr
- never physicaly swap disks, or change boot-order in BIOS
- when one disks breaks, replace it by an empty one, partition it, then 
restore the raid (raidhotadd), do lilo -v, reboot.

Q: Is there a real benefit of using mdadm.conf over raidtab.conf?

Thanks in advance!
Pascal
