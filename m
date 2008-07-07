From: "Gustavo Melo" <gmelo@yellowstreet.pt>
Subject: can't mount RAID 5  md0
Date: Mon, 7 Jul 2008 11:31:55 +0100
Message-ID: <6u8fbr$ac2ov@smtp2.artelecom.pt>
Reply-To: <gmelo@yellowstreet.pt>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
 
I have a server with 4 HDs:
 
- a 20GB holding a fedora 7 installation;
- 3 160GB forming a RAID 5 3 disk array.
 
The first, 20GB HD went south the other day, so I replaced it with another
20GB HD with a fedora 8 installation and tried to mount the RAID array.
 
I get the following error:
 
        [root@Fileserver log]# mount /dev/md0 /files

        mount: wrong fs type, bad option, bad superblock on /dev/md0,
        missing codepage or helper program, or other error
        In some cases useful info is found in syslog - try
        dmesg | tail  or so

        [root@Fileserver log]# dmesg | tail
        EXT3-fs error (device md0): ext3_check_descriptors: Block bitmap for
group 1920 not in group (block 32800)!
        EXT3-fs: group descriptors corrupted!

 
everything with the array itself seems to be ok:
 
        [root@Fileserver log]# cat /proc/mdstat
        Personalities : [raid6] [raid5] [raid4] 
        md0 : active raid5 sdb1[0] sdd1[2] sdc1[1]
        320159104 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
      
        unused devices: <none>

 
        [root@Fileserver log]# mdadm --examine /dev/sdb1 /dev/sdc1 /dev/sdd1
 
/dev/sdb1:
        Magic : a92b4efc
        Version : 00.90.00
        UUID : c8aac6bd:221f01ad:3a41d058:d5801b62
        Creation Time : Fri Jul  4 09:45:44 2008
        Raid Level : raid5
        Used Dev Size : 160079552 (152.66 GiB 163.92 GB)
        Array Size : 320159104 (305.33 GiB 327.84 GB)
        Raid Devices : 3
        Total Devices : 3
        Preferred Minor : 0
 
        Update Time : Fri Jul  4 15:17:05 2008
        State : clean
        Active Devices : 3
        Working Devices : 3
        Failed Devices : 0
        Spare Devices : 0
        Checksum : 3e1eb720 - correct
        Events : 0.2
 
        Layout : left-symmetric
        Chunk Size : 64K
 
        Number   Major   Minor   RaidDevice State
        this     0       8       17        0      active sync   /dev/sdb1
 
        0     0       8       17        0      active sync   /dev/sdb1
        1     1       8       33        1      active sync   /dev/sdc1
        2     2       8       49        2      active sync   /dev/sdd1

/dev/sdc1:
        Magic : a92b4efc
        Version : 00.90.00
        UUID : c8aac6bd:221f01ad:3a41d058:d5801b62
        Creation Time : Fri Jul  4 09:45:44 2008
        Raid Level : raid5
        Used Dev Size : 160079552 (152.66 GiB 163.92 GB)
        Array Size : 320159104 (305.33 GiB 327.84 GB)
        Raid Devices : 3
        Total Devices : 3
        Preferred Minor : 0
 
        Update Time : Fri Jul  4 15:17:05 2008
        State : clean
        Active Devices : 3
        Working Devices : 3
        Failed Devices : 0
        Spare Devices : 0
        Checksum : 3e1eb732 - correct
        Events : 0.2
 
        Layout : left-symmetric
        Chunk Size : 64K
 
        Number   Major   Minor   RaidDevice State
        this     1       8       33        1      active sync   /dev/sdc1
 
        0     0       8       17        0      active sync   /dev/sdb1
        1     1       8       33        1      active sync   /dev/sdc1
        2     2       8       49        2      active sync   /dev/sdd1

/dev/sdd1:
        Magic : a92b4efc
        Version : 00.90.00
        UUID : c8aac6bd:221f01ad:3a41d058:d5801b62
        Creation Time : Fri Jul  4 09:45:44 2008
        Raid Level : raid5
        Used Dev Size : 160079552 (152.66 GiB 163.92 GB)
        Array Size : 320159104 (305.33 GiB 327.84 GB)
        Raid Devices : 3
        Total Devices : 3
        Preferred Minor : 0
 
        Update Time : Fri Jul  4 15:17:05 2008
        State : clean
        Active Devices : 3
        Working Devices : 3
        Failed Devices : 0
        Spare Devices : 0
        Checksum : 3e1eb744 - correct
        Events : 0.2
 
        Layout : left-symmetric
        Chunk Size : 64K
 
        Number   Major   Minor   RaidDevice State
        this     2       8       49        2      active sync   /dev/sdd1
 
        0     0       8       17        0      active sync   /dev/sdb1
        1     1       8       33        1      active sync   /dev/sdc1
        2     2       8       49        2      active sync   /dev/sdd1

 
but not with the file system:
 
 
    [root@Fileserver log]# fsck -n /dev/md0

    fsck 1.40.4 (31-Dec-2007)
    e2fsck 1.40.4 (31-Dec-2007)
    fsck.ext3: Group descriptors look bad... trying backup blocks...
    fsck.ext3: Bad magic number in super-block while trying to open /dev/md0
 
    The superblock could not be read or does not describe a correct ext2
    filesystem.  If the device is valid and it really contains an ext2
    filesystem (and not swap or ufs or something else), then the superblock
    is corrupt, and you might try running e2fsck with an alternate
superblock:
    e2fsck -b 8193 <device>

 
        [root@Fileserver log]# mke2fs -n /dev/md0

        mke2fs 1.40.4 (31-Dec-2007)
        Filesystem label=
        OS type: Linux
        Block size=4096 (log=2)
        Fragment size=4096 (log=2)
        40026112 inodes, 80039776 blocks
        4001988 blocks (5.00%) reserved for the super user
        First data block=0
        Maximum filesystem blocks=0
        2443 block groups
        32768 blocks per group, 32768 fragments per group
        16384 inodes per group
        Superblock backups stored on blocks: 
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632,
2654208, 
        4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 78675968

 
 
I'm hoping you guys can save my day, because I'm way out of my league,
here...
 
TIA,
 
Gustavo Melo

