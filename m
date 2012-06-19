From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
Subject: Creating recovery IMSM array
Date: Mon, 18 Jun 2012 23:03:28 -0400
Message-ID: <CALJXSJp51wooMmVsc=uk76PMrZvz5D6h-upRvGHjC=YSRafa3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I am trying to recover a defective RAID5 from 3 disk images attached
to loop devices.

Images are read write 230 GB images and assembling them using metadata
0.9 works but seems unaligned as NTFS reads the first file then a lot
of errors.

Trying to assemble an IMSM image I see it needs a RAID controller to
work, however, on many messages from the mailing list, I can see array
assembled from loop devices without any problem, what am I missing?
eg: http://permalink.gmane.org/gmane.linux.raid/32950

root@sysresccd /root % mdadm -V
mdadm - v3.1.4 - 31st August 2010

root@sysresccd /root % mdadm -CR /dev/md/imsm -e imsm -n3 /dev/loop[123=
]
mdadm: /dev/loop1 appears to be part of a raid array:
=C2=A0 =C2=A0 level=3Draid5 devices=3D3 ctime=3DMon Jun 18 23:37:54 201=
2
mdadm: metadata will over-write last partition on /dev/loop1.
mdadm: /dev/loop2 appears to be part of a raid array:
=C2=A0 =C2=A0 level=3Draid5 devices=3D3 ctime=3DMon Jun 18 23:37:54 201=
2
mdadm: imsm unable to enumerate platform support
=C2=A0 =C2=A0 array may not be compatible with hardware/firmware
mdadm: Failed to retrieve serial for /dev/loop1
mdadm: failed to retrieve scsi serial, aborting
zsh: abort =C2=A0 =C2=A0 =C2=A0mdadm -CR /dev/md/imsm -e imsm -n3 /dev/=
loop[123]

root@sysresccd /root/mdadm-3.2.5 % ./mdadm --verbose --create
/dev/md127 --metadata=3Dimsm --raid-devices=3D3 /dev/loop1 /dev/loop3
/dev/loop2
mdadm: /dev/loop1 is not attached to Intel(R) RAID controller.
mdadm: /dev/loop1 is not suitable for this array.
mdadm: /dev/loop3 is not attached to Intel(R) RAID controller.
mdadm: /dev/loop3 is not suitable for this array.
mdadm: /dev/loop2 is not attached to Intel(R) RAID controller.
mdadm: /dev/loop2 is not suitable for this array.
mdadm: create aborted


Here is the output of the original defective device from the defective =
computer:

root@sysresccd /root/mdadm-3.2.5 % mdadm -D /dev/md126
/dev/md126:
      Container : /dev/md/imsm0, member 0
     Raid Level : raid5
  Used Dev Size : 488384132 (465.76 GiB 500.11 GB)
   Raid Devices : 3
  Total Devices : 1

          State : active, FAILED, Not Started
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-asymmetric
     Chunk Size : 64K


           UUID : 229c46a1:7da20e30:428e1074:33162c6e
    Number   Major   Minor   RaidDevice State
       0       8        0        0      active sync   /dev/sda
       1       0        0        1      removed
       2       0        0        2      removed

root@sysresccd /root/mdadm-3.2.5 % mdadm -D /dev/md127
/dev/md127:
        Version : imsm
     Raid Level : container
  Total Devices : 1

Working Devices : 1


           UUID : 1efefd07:c453a7bd:d473f9bb:47cccc17
  Member Arrays :

    Number   Major   Minor   RaidDevice

       0       8        0        -        /dev/sda




Here is from the 0.9 metadata RAID:

root@sysresccd /root/mdadm-3.2.5 % losetup -a
/dev/loop1: [0020]:257 (sda.img) sizelimit=3D246960619520
/dev/loop2: [0020]:259 (sdb.img) sizelimit=3D246960619520
/dev/loop3: [0020]:265 (sde.img) sizelimit=3D246960619520

root@sysresccd /root/mdadm-3.2.5 % mdadm --create /dev/md0
--metadata=3D0.9 --level=3D5 --chunk=3D64 --raid-devices=3D3 /dev/loop1
missing /dev/loop2
mdadm: partition table exists on /dev/loop1 but will be lost or
       meaningless after creating array
Continue creating array? y
mdadm: array /dev/md0 started.
root@sysresccd /root/mdadm-3.2.5 % ntfsresize -i /dev/md0p1
ntfsresize v2012.1.15 (libntfs-3g)
Device name        : /dev/md0p1
NTFS volume version: 3.1
Cluster size       : 4096 bytes
Current volume size: 262147863040 bytes (262148 MB)
Current device size: 262147866624 bytes (262148 MB)
Checking filesystem consistency ...
Incomplete multi-sector transfer: magic: 0x454c4946  size: 1024
usa_ofs: 48  usa_count: 0  data: 283  usn: 1001: Input/output error
Incomplete multi-sector transfer: magic: 0x454c4946  size: 1024
usa_ofs: 48  usa_count: 0  data: 1001  usn: 12379: Input/output error
Incomplete multi-sector transfer: magic: 0x454c4946  size: 1024
usa_ofs: 48  usa_count: 0  data: 12379  usn: 283: Input/output error
Record 786121 has wrong SeqNo (198 <> 5)
Inode is corrupt (227): Input/output error
Record 19803 has wrong SeqNo (37 <> 24696)
Inode is corrupt (244): Input/output error
Record 781056 has wrong SeqNo (22243 <> 3092)
Inode is corrupt (394): Input/output error
Incomplete multi-sector transfer: magic: 0x454c4946  size: 1024
usa_ofs: 48  usa_count: 0  data: 168  usn: 254: Input/output error
Incomplete multi-sector transfer: magic: 0x454c4946  size: 1024
usa_ofs: 48  usa_count: 0  data: 254  usn: 135: Input/output error
Incomplete multi-sector transfer: magic: 0x454c4946  size: 1024
usa_ofs: 48  usa_count: 0  data: 135  usn: 168: Input/output error
Incomplete multi-sector transfer: magic: 0x454c4946  size: 1024
usa_ofs: 48  usa_count: 0  data: 2225  usn: 1702: Input/output error
Incomplete multi-sector transfer: magic: 0x454c4946  size: 1024
usa_ofs: 48  usa_count: 0  data: 1702  usn: 1556: Input/output error
Incomplete multi-sector transfer: magic: 0x454c4946  size: 1024
usa_ofs: 48  usa_count: 0  data: 1556  usn: 2225: Input/output error
Incomplete multi-sector transfer: magic: 0x454c4946  size: 1024
usa_ofs: 48  usa_count: 0  data: 1544  usn: 473: Input/output error
Incomplete multi-sector transfer: magic: 0x454c4946  size: 1024
usa_ofs: 48  usa_count: 0  data: 473  usn: 3: Input/output error
Incomplete multi-sector transfer: magic: 0x454c4946  size: 1024
usa_ofs: 48  usa_count: 0  data: 3  usn: 1544: Input/output error
Incomplete multi-sector transfer: magic: 0x454c4946  size: 1024
usa_ofs: 48  usa_count: 0  data: 79  usn: 686: Input/output error
Record 1749 has wrong SeqNo (14 <> 1)
Inode is corrupt (1685): Input/output error
=2E..
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
