From: Sandro Dentella <sandro.dentella@tin.it>
Subject: Re: Autodetect problem w/ SCSI
Date: Tue, 1 Jun 2004 23:09:16 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040601210915.GA23295@bluff>
References: <20040601183951.GA22078@bluff> <20040601204516.24507.qmail@web61004.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20040601204516.24507.qmail@web61004.mail.yahoo.com>
To: M K <maheshext3@yahoo.com>
Cc: Sandro Dentella <sandro.dentella@tin.it>, Linux Raid List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Jun 01, 2004 at 01:45:16PM -0700, M K wrote:
> Can you send the exact command used to create the
> array, the raidtabs or mdadm.conf file and the fdisk
> -l listing of each drive thats part of the raid?

I used mdadm w/ (approxymantely, it's a script "mdadm --create $Md  -l1 -n2 $part $part2")

 mdadm --create /dev/md/0  -l1 -n2 /dev/scsi/host0/bus0/target0/lun0/part6 /dev/scsi/host0/bus0/target1/lun0/part6

From a live CD after modprobe aic7xxx and "mdadm -A /dev/md4 /dev/sda1
/dev/sdb1" and "mdadm -A /dev/md0 /dev/sda6 /dev/sdb6"

####################################################
fdisk -l /dev/sda
root@argo-cd root # fdisk -l /dev/sda

Disk /dev/sda: 255 heads, 63 sectors, 2231 cylinders
Units = cylinders of 16065 * 512 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/sda1             1         3     24066   fd  Linux raid autodetect
/dev/sda2             4      2231  17896410    f  Win95 Ext'd (LBA)
/dev/sda5             4        68    522081   fd  Linux raid autodetect
/dev/sda6            69       323   2048256   fd  Linux raid autodetect
/dev/sda7           324      2231  15325978+  fd  Linux raid autodetect
root@argo-cd root # fdisk -l /dev/sdb

Disk /dev/sdb: 255 heads, 63 sectors, 2231 cylinders
Units = cylinders of 16065 * 512 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/sdb1             1         3     24066   fd  Linux raid autodetect
/dev/sdb2             4      2231  17896410    f  Win95 Ext'd (LBA)
/dev/sdb5             4        68    522081   fd  Linux raid autodetect
/dev/sdb6            69       323   2048256   fd  Linux raid autodetect
/dev/sdb7           324      2231  15325978+  fd  Linux raid autodetect


####################################################
root@argo-cd root # cat /proc/mdstat 
Personalities : [raid1] 
read_ahead 1024 sectors
md0 : active raid1 scsi/host0/bus0/target0/lun0/part6[0] scsi/host0/bus0/target1/lun0/part6[1]
      2048192 blocks [2/2] [UU]
      
md4 : active raid1 scsi/host0/bus0/target0/lun0/part1[0] scsi/host0/bus0/target1/lun0/part1[1]
      24000 blocks [2/2] [UU]
      
unused devices: <none>
####################################################
root@argo-cd root # mdadm -D /dev/md/0
/dev/md/0:
        Version : 00.90.00
  Creation Time : Tue Jun  1 19:02:24 2004
     Raid Level : raid1
     Array Size : 2048192 (2000.19 MiB 2097.35 MB)
    Device Size : 2048192 (2000.19 MiB 2097.35 MB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Tue Jun  1 23:00:22 2004
          State : dirty, no-errors
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0


    Number   Major   Minor   RaidDevice State
       0       8        6        0      active sync   /dev/scsi/host0/bus0/target0/lun0/part6
       1       8       22        1      active sync   /dev/scsi/host0/bus0/target1/lun0/part6
           UUID : 6f224ca0:92ecf8b5:bdf5d2b8:371b5bae
         Events : 0.2

####################################################
root@argo-cd root # mount /dev/md0 /tmp/6
root@argo-cd root # mount /dev/md4 /tmp/6/boot/
root@argo-cd root # df
Filesystem           1k-blocks      Used Available Use% Mounted on
rootfs                  425408    425408         0 100% /
/dev/cdroms/cdrom0      425408    425408         0 100% /
tmpfs                     6144      4160      1984  68% /etc
tmpfs                     6144      1600      4544  27% /var
tmpfs                     2048        12      2036   1% /var/tmp
/dev/md0               2048124    439932   1608192  22% /var/tmp/6
/dev/md4                 23239     18278      3761  83% /var/tmp/6/boot
####################################################


Thanks again
sandro
*:-)


PS: I notice that preferred minor does not correspond w/ (my interpretation
    of) real used minor. But I guess 'preferred' is not "compulsory"...
