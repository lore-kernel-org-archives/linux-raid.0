From: Arun Khan <knura9@gmail.com>
Subject: CentOS 6.2 on partition able RAID1 (md_d0) - kernel panic with either
 disk not present
Date: Wed, 3 Oct 2012 16:47:09 +0530
Message-ID: <CAHhM8gBsxgYUwqOiVePKFb-epbTQwZDRH50HQy9PPaOMOY=Brw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux MDADM Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I had posted the following in the CentOS General mailing list but the
problem remains unresolved.

Here is the link to the CentOS thread:
<http://lists.centos.org/pipermail/centos/2012-June/126927.html>

I am posting it here in the hope that some one will be able to help me
pinpoint the "gotcha" and fix it.

In case you are able to help, please read all the postings in the
above thread, to see what others have suggested and what I have
already tried, so as to avoid repetition of questions and answers.

My server environment:
CentOS 6.2 amd64 (min. server install)
2 virtual hard disks of 10GB each
Running as Linux KVM guest OS

Following the instructions on CentOS Wiki
<http://wiki.centos.org/HowTos/Install_On_Partitionable_RAID1>

I  installed a min. server in Linux KVM setup (script shown below)

<script>
#!/bin/bash
nic_mac_addr0=00:07:43:53:2b:bb

kvm \
-vga std \
-m 1024 \
-cpu core2duo \
-smp 2,cores=2 \
-drive file=/home/arunk/KVM/vdisks/centos62.raid1.disk1.img \
-drive file=/home/arunk/KVM/vdisks/centos62.raid1.disk2.img \
-net nic,vlan=1,model=e1000,macaddr=${nic_mac_addr0} \
-net tap,vlan=1,ifname=tap0,script=no,downscript=no \

</script>

The system boots fine when *both* disks are online.

However, when I remove either of the disks (delete the -drive file= line), the
system boots to a point wherein the GRUB menu is displayed and the
progress bar displays for a while till the white bar reaches about
halfway point and then it:

Kernel panic - not syncing: Attempted to kill init!

I am doing this testing on a VM environment before deploying such a
setup on bare metal.
The disk failure test is failing.   My understanding is that such a
setup should work the same whether it is VM or bare metal.

Any suggestions/ideas as to what I may doing incorrectly?

FWIW, outputs from "fdisk -l"  and "df -hT"

<fdisk -l>
root@centos62-raid1 ~ >
# fdisk -l

Disk /dev/sda: 10.7 GB, 10737418240 bytes
255 heads, 63 sectors/track, 1305 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x000e8353

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *           1         523     4194304   83  Linux
Partition 1 does not end on cylinder boundary.
/dev/sda2             523        1045     4194304   83  Linux
/dev/sda3            1045        1176     1048576   82  Linux swap / Solaris

Disk /dev/sdb: 10.7 GB, 10737418240 bytes
255 heads, 63 sectors/track, 1305 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x000e8353

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1   *           1         523     4194304   83  Linux
Partition 1 does not end on cylinder boundary.
/dev/sdb2             523        1045     4194304   83  Linux
/dev/sdb3            1045        1176     1048576   82  Linux swap / Solaris

Disk /dev/md_d0: 10.7 GB, 10737352704 bytes
2 heads, 4 sectors/track, 2621424 cylinders
Units = cylinders of 8 * 512 = 4096 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x000e8353

      Device Boot      Start         End      Blocks   Id  System
/dev/md_d0p1   *         257     1048832     4194304   83  Linux
Partition 1 does not end on cylinder boundary.
/dev/md_d0p2         1048833     2097408     4194304   83  Linux
Partition 2 does not end on cylinder boundary.
/dev/md_d0p3         2097409     2359552     1048576   82  Linux swap / Solaris
Partition 3 does not end on cylinder boundary

</fdisk -l>

<df -hT>

# df -hT
Filesystem    Type    Size  Used Avail Use% Mounted on
/dev/md_d0p1  ext4    4.0G  1.9G  1.9G  50% /
tmpfs        tmpfs    499M     0  499M   0% /dev/shm
/dev/md_d0p2  ext4    4.0G  136M  3.7G   4% /home

</df -hT>

Thanks.
-- Arun Khan
