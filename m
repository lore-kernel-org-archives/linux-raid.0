From: Dimitris Zilaskos <dzila@tassadar.physics.auth.gr>
Subject: Re: recover data from linear raid
Date: Mon, 26 Jun 2006 16:48:10 +0300 (EEST)
Message-ID: <Pine.LNX.4.64.0606261640330.16450@tassadar.physics.auth.gr>
References: <Pine.LNX.4.64.0606242233000.32322@tassadar.physics.auth.gr>
	<17566.13544.15613.709664@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <ext3-users-bounces@redhat.com>
In-Reply-To: <17566.13544.15613.709664@cse.unsw.edu.au>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/ext3-users>,
	<mailto:ext3-users-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/ext3-users>
List-Post: <mailto:ext3-users@redhat.com>
List-Help: <mailto:ext3-users-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/ext3-users>,
	<mailto:ext3-users-request@redhat.com?subject=subscribe>
Sender: ext3-users-bounces@redhat.com
Errors-To: ext3-users-bounces@redhat.com
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, ext3-users@redhat.com
List-Id: linux-raid.ids

>
> As Christian said, specific error message help a lot.
> Assume the two devices are hdc and hde,
>
>  fdisk -l /dev/hdc
>  fdisk -l /dev/hde
>  mdadm -E /dev/hdc
>  mdadm -E /dev/hde
>
> and my best guess
>
>   mdadm --build /dev/md0 --level linear --raid-disks 2 /dev/hdc /dev/hde
>   fsck -n /dev/md0
>
> (and linux-raid@vger.kernel.org might be a better mailing list for
> this particular sort of problem).

Disk /dev/hdb: 250.0 GB, 250059350016 bytes
255 heads, 63 sectors/track, 30401 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

    Device Boot    Start       End    Blocks   Id  System
[root@node004 root]# fdisk -l /dev/hdc

Disk /dev/hdc: 300.0 GB, 300090728448 bytes
255 heads, 63 sectors/track, 36483 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

    Device Boot    Start       End    Blocks   Id  System
[root@node004 root]# mdadm -E /dev/hdb
/dev/hdb:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 293be3e8:5a7ac6e7:adefc469:84f8aefb
   Creation Time : Fri Jun 23 15:47:10 2006
      Raid Level : linear
     Device Size : 244198464 (232.89 GiB 250.06 GB)
    Raid Devices : 2
   Total Devices : 2
Preferred Minor : 0

     Update Time : Fri Jun 23 15:48:43 2006
           State : clean, no-errors
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0
        Checksum : f790e07f - correct
          Events : 0.2

        Rounding : 32K

       Number   Major   Minor   RaidDevice State
this     0       3       64        0      active sync   /dev/hdb
    0     0       3       64        0      active sync   /dev/hdb
    1     1      22        0        1      active sync   /dev/hdc
[root@node004 root]# mdadm -E /dev/hdc
/dev/hdc:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 293be3e8:5a7ac6e7:adefc469:84f8aefb
   Creation Time : Fri Jun 23 15:47:10 2006
      Raid Level : linear
     Device Size : 244198464 (232.89 GiB 250.06 GB)
    Raid Devices : 2
   Total Devices : 2
Preferred Minor : 0

     Update Time : Fri Jun 23 15:48:43 2006
           State : clean, no-errors
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0
        Checksum : f790e054 - correct
          Events : 0.2

        Rounding : 32K

       Number   Major   Minor   RaidDevice State
this     1      22        0        1      active sync   /dev/hdc
    0     0       3       64        0      active sync   /dev/hdb
    1     1      22        0        1      active sync   /dev/hdc
[root@node004 root]# mdadm --build /dev/md0 --level linear --raid-disks 2 
/dev/hdb /dev/hdc
mdadm: array /dev/md0 built and started.

fsck -n /dev/md0
fsck 1.32 (09-Nov-2002)
e2fsck 1.32 (09-Nov-2002)
Couldn't find ext2 superblock, trying backup blocks...
fsck.ext2: Bad magic number in super-block while trying to open /dev/md0

The superblock could not be read or does not describe a correct ext2
filesystem.  If the device is valid and it really contains an ext2
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate superblock:
     e2fsck -b 8193 <device>

fsck -b 8193 /dev/md0
fsck 1.32 (09-Nov-2002)
e2fsck 1.32 (09-Nov-2002)
fsck.ext2: Bad magic number in super-block while trying to open /dev/md0

The superblock could not be read or does not describe a correct ext2
filesystem.  If the device is valid and it really contains an ext2
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate superblock:
     e2fsck -b 8193 <device>


 	During a recovery attemp today by mistake I created a mirror array 
with hdb as the primary and hdc as the secondary. I interrupted the array 
creation almost immediately, but part of the hdc was overwritten. However 
the array never held more than 70 gbytes of data, so I hope everything is 
intact on hdb :/


 	Thank you all for your kind help:)
--
============================================================================

Dimitris Zilaskos

Department of Physics @ Aristotle University of Thessaloniki , Greece
PGP key : http://tassadar.physics.auth.gr/~dzila/pgp_public_key.asc
 	  http://egnatia.ee.auth.gr/~dzila/pgp_public_key.asc
MD5sum  : de2bd8f73d545f0e4caf3096894ad83f  pgp_public_key.asc
============================================================================
