From: "Calvin D. Webster" <cwebster@ec.rr.com>
Subject: Re: Software RAID Stopped Working With Aurora Kernel
Date: Tue, 21 May 2002 18:12:52 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3CEAC664.8D738EC2@ec.rr.com>
References: <15594.14625.624567.495812@notabene.cse.unsw.edu.au>
		<NDBBIAKEEKGGEIKCBKNAEENACPAA.kc130iseo@coastalnet.com> <15594.45618.113616.670740@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown wrote:
> 
> On Tuesday May 21, kc130iseo@coastalnet.com wrote:
> >
> > mdadm --examine --sparc2.2update /dev/sda1
> >
>    mdadm --examine /dev/sda1
> should show the correct superblock.

Very Slick! All went well.

> > ## Assemble the array (use raid device order):
> > ## Only assemble active devices, not spare.
> >
> > mdadm --assemble /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdf1 /dev/sdd1 /dev/sde1

mdadm: /dev/md0 has been started with 5 drives.

> > ## Verify that raid is running
> >
> > cat /proc/mdstat

Personalities : [raid5] 
read_ahead 1024 sectors
md0 : active raid5 sde1[3] sdd1[2] sdf1[1] sdb1[0] sda1[4]
      70726656 blocks level 5, 128k chunk, algorithm 0 [5/5] [UUUUU]
      
unused devices: <none>

## There's something fishy here.^

> > ## Verify that data is intact

## Excerpt from /etc/fstab

----------------------------------------------------------------
/dev/md0                /usr/local/archive      ext2    defaults       
1 2
/usr/local/archive/shares/redhat/redhat-7.2/enigma-i386-disc1.iso
/home/ftp/pub/redhat/redhat-7.2/disc1	iso9660	defaults,loop,ro	0 0
/usr/local/archive/shares/redhat/redhat-7.2/enigma-i386-disc2.iso
/home/ftp/pub/redhat/redhat-7.2/disc2	iso9660	defaults,loop,ro	0 0
----------------------------------------------------------------

## Mount RAID filesystems:

----------------------------------------------------------------
[root@winggear root]# mount /usr/local/archive/
[root@winggear root]# mount /home/ftp/pub/redhat/redhat-7.2/disc1
[root@winggear root]# mount /home/ftp/pub/redhat/redhat-7.2/disc2
----------------------------------------------------------------

## See that we can list mounted filesystems

-------------------------------------------------------------------------------
[root@winggear /]# ls /usr/local/archive/shares/
admin  applications  Av8bigtd-Gold  Development  Pvcs Archive  redhat 
users

[root@winggear /]# ls /home/ftp/pub/redhat/redhat-7.2/disc1
autorun   images     README.fr  RedHat            RELEASE-NOTES.fr 
RPM-GPG-KEY
boot.cat  README     README.it  RELEASE-NOTES     RELEASE-NOTES.it 
TRANS.TBL
COPYING   README.de  README.ja  RELEASE-NOTES.de  RELEASE-NOTES.ja
dosutils  README.es  README.ko  RELEASE-NOTES.es  RELEASE-NOTES.ko

[root@winggear /]# ls /usr/local/archive/shares/
admin  applications  Av8bigtd-Gold  Development  Pvcs Archive  redhat 
users
-------------------------------------------------------------------------------

### This is fabulous!!! ###

Thank you so.............. much!

There is only one thing that doesn't look right to me. That is the
contents of "/proc/mdstat".
The device numbers seem mismatched to their device names.

Also, different from what I'm used to seeing, is that the spare drive
(sdc1) is not shown in the "active" list as it was before.

## /proc/mdstat before (with 2.2 kernel):

----------------------------------------------------------------------------------
Personalities : [raid5]
read_ahead 1024 sectors
md0 : active raid5 sdf1[5] sde1[4] sdd1[3] sdc1[2] sdb1[1] sda1[0]
70726656 bloc
ks level 5, 128k chunk, algorithm 0 [5/5] [UUUUU]
unused devices: <none>
----------------------------------------------------------------------------------

## /proc/mdstat after (with 2.4 kernel, fixed with mdadm):

----------------------------------------------------------------------------------
Personalities : [raid5] 
read_ahead 1024 sectors
md0 : active raid5 sda1[4] sde1[3] sdd1[2] sdf1[1] sdb1[0]
      70726656 blocks level 5, 128k chunk, algorithm 0 [5/5] [UUUUU]
      
unused devices: <none>
----------------------------------------------------------------------------------

## Superblocks look fine

------------------[ mdadm --examine /dev/sda1 ]------------------

/dev/sda1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 494dd54f:15e7b548:90bae5c3:532ac910
  Creation Time : Thu Apr 26 12:29:38 2001
     Raid Level : raid5
    Device Size : 17681664 (16.86 GiB 18.15 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 0

    Update Time : Tue May 21 18:05:13 2002
          State : dirty, no-errors
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 652969c1 - correct
         Events : 0.178

         Layout : left-asymmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     4       8        1        0      active sync   /dev/sda1
   0     0       8       17        1      active sync   /dev/sdb1
   1     1       8       81        2      active sync   /dev/sdf1
   2     2       8       49        3      active sync   /dev/sdd1
   3     3       8       65        4      active sync   /dev/sde1
   4     4       8        1        0      active sync   /dev/sda1
-----------------------------------------------------------------


Other than these minor things, IT'S PERFECT!

--Cal Webster
