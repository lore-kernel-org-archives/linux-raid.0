From: Joe Landman <joe.landman@gmail.com>
Subject: interesting MD-xfs bug
Date: Thu, 09 Apr 2015 17:02:33 -0400
Message-ID: <5526E8E9.3030805@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: xfs <xfs@oss.sgi.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

If I build an MD raid0 with a non power of 2 chunk size, it appears that 
I can mkfs.xfs a file system, but it doesn't show up in blkid and is not 
mountable.  Yet, using a power of 2 chunk size, this does work 
correctly.   This is kernel 3.18.9.


For example, non-power of 2 chunk:

root@unison:~# wipefs -a /dev/sdb
4 bytes were erased at offset 0x1000 (linux_raid_member)
they were: fc 4e 2b a9
root@unison:~# wipefs -a /dev/sda
4 bytes were erased at offset 0x1000 (linux_raid_member)
they were: fc 4e 2b a9
root@unison:~# mdadm --create /dev/md20 --level=0 --metadata=1.2 
--chunk=1152 --auto=yes --raid-disks=2 /dev/sd[ab]
mdadm: array /dev/md20 started.

root@unison:~# mkfs.xfs /dev/md20
log stripe unit (1179648 bytes) is too large (maximum is 256KiB)
log stripe unit adjusted to 32KiB
meta-data=/dev/md20              isize=256    agcount=50, 
agsize=268435296 blks
          =                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=4096   blocks=13164865984, imaxpct=5
          =                       sunit=288    swidth=576 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=521728, version=2
          =                       sectsz=512   sunit=8 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

root@unison:~# blkid | grep xfs
root@unison:~#


Same system, with power of 2 chunk size:

root@unison:~# mdadm -S /dev/md20
mdadm: stopped /dev/md20
root@unison:~# wipefs -a /dev/sda
4 bytes were erased at offset 0x1000 (linux_raid_member)
they were: fc 4e 2b a9
root@unison:~# wipefs -a /dev/sdb
4 bytes were erased at offset 0x1000 (linux_raid_member)
they were: fc 4e 2b a9
root@unison:~# mdadm --create /dev/md20 --level=0 --metadata=1.2 
--chunk=1024 --auto=yes --raid-disks=2 /dev/sd[ab]
mdadm: array /dev/md20 started.
root@unison:~# mkfs.xfs /dev/md20
log stripe unit (1048576 bytes) is too large (maximum is 256KiB)
log stripe unit adjusted to 32KiB
meta-data=/dev/md20              isize=256    agcount=50, 
agsize=268435200 blks
          =                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=4096   blocks=13164866048, imaxpct=5
          =                       sunit=256    swidth=512 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=521728, version=2
          =                       sectsz=512   sunit=8 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
root@unison:~# blkid | grep xfs
/dev/md20: UUID="5e965ae7-198e-4e58-8920-a65c4b6bbe60" TYPE="xfs"

I am not sure which code base might be at "fault" or even if there is a 
"fault" (beyond simply saying "don't do non-power-of-two chunks").  If 
its the latter, happy to work on a warning message patch for mdadm if 
needed.  If it should work, then happy to poke around if someone can 
give me a pointer where something might be relevant.

