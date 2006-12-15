From: Bruno Costacurta <pubmb01@skynet.be>
Subject: What is this RAID status and level ?
Date: Fri, 15 Dec 2006 23:59:35 +0100
Message-ID: <200612152359.35544.pubmb01@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I expected to get a RAID setup after the installation a new Linux distro 
(Fedora FC6) but I'm confused about its status and level...
Please find hereafter some details about the config.

dmraid -r:
/dev/sda: isw, "isw_cfaabdceig", GROUP, ok, 312581806 sectors, data@ 0
/dev/sdb: isw, "isw_cfaabdceig", GROUP, ok, 320173054 sectors, data@ 0

mount :
/dev/mapper/VolGroup00-LogVol00 on / type ext3 (rw)
proc on /proc type proc (rw)
sysfs on /sys type sysfs (rw)
devpts on /dev/pts type devpts (rw,gid=5,mode=620)
/dev/mapper/isw_cfaabdceig_RAIDv0p1 on /boot type ext3 (rw)
tmpfs on /dev/shm type tmpfs (rw)
none on /proc/sys/fs/binfmt_misc type binfmt_misc (rw)
sunrpc on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw)

fdisk -l:
Disk /dev/sda: 160.0 GB, 160041885696 bytes
255 heads, 63 sectors/track, 19457 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

 Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *           1          13      104391   83  Linux
/dev/sda2              14       19189   154031220   8e  Linux LVM

Disk /dev/sdb: 163.9 GB, 163928604672 bytes
255 heads, 63 sectors/track, 19929 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1   *           1          13      104391   83  Linux
/dev/sdb2              14       19189   154031220   8e  Linux LVM

Thanks for advice.
Bye,
Bruno
