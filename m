From: Nick Black <dankamongmen@gmail.com>
Subject: Re: data loss+inode recovery using RAID6 write journal
Date: Tue, 25 Oct 2016 09:16:41 -0400
Message-ID: <20161025131641.dxsflwodnaesdni3@schwarzgerat.orthanc>
References: <20161024235505.rb4fucq24ybbn5aq@schwarzgerat.orthanc>
 <580F51DC.3010308@youngman.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="53jqnqygalryealg"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <580F51DC.3010308@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--53jqnqygalryealg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Wols Lists left as an exercise for the reader:
> I can't see what filesystem you're using. It could easily be down to that.

as noted, both source and destination filesystems were ext4 without any
unorthodox options. I wouldn't normally think it was due to mdraid, as I've
never had a problem from it before, but the new write-journal code does
seem a very possible culprit, especially as it appeared to be attempting
to flush data from the SSD during the interruption.

if people don't think it due to raid, i'm not going to say it was. i'll
probably refrain from using the write journal for a bit, though, just on
a hunch.

Destination array details:

[schwarzgerat](0) $ sudo mdadm --detail /dev/md126
/dev/md126:
        Version : 1.2
  Creation Time : Fri Oct 14 21:31:31 2016
     Raid Level : raid6
     Array Size : 23441316864 (22355.38 GiB 24003.91 GB)
  Used Dev Size : 3906886144 (3725.90 GiB 4000.65 GB)
   Raid Devices : 8
  Total Devices : 9
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Mon Oct 24 18:27:09 2016
          State : clean=20
 Active Devices : 8
Working Devices : 9
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

           Name : schwarzgerat:126  (local to host schwarzgerat)
           UUID : e16ec7ec:77f523c8:243e7ba0:08c5a591
         Events : 15092

    Number   Major   Minor   RaidDevice State
       0       8        1        -      journal   /dev/sda1
       1       8       17        0      active sync   /dev/sdb1
       2       8       33        1      active sync   /dev/sdc1
       3       8       49        2      active sync   /dev/sdd1
       4       8       65        3      active sync   /dev/sde1
       5       8       81        4      active sync   /dev/sdf1
       6       8       97        5      active sync   /dev/sdg1
       7       8      113        6      active sync   /dev/sdh1
       8       8      129        7      active sync   /dev/sdi1
[schwarzgerat](0) $=20

Destination filesystem details:

[schwarzgerat](0) $ sudo dumpe2fs /dev/md126
dumpe2fs 1.43.3 (04-Sep-2016)
Filesystem volume name:   <none>
Last mounted on:          /media/trap
Filesystem UUID:          7f7404cc-9a9c-4a92-98b7-159646f5b355
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr dir_index filetype needs_rec=
overy extent 64bit flex_bg sparse_super large_file huge_file dir_nlink extr=
a_isize metadata_csum
Filesystem flags:         signed_directory_hash=20
Default mount options:    user_xattr acl
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              366272512
Block count:              5860329216
Reserved block count:     293016460
Free blocks:              2255006201
Free inodes:              363288750
First block:              0
Block size:               4096
Fragment size:            4096
Group descriptor size:    64
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         2048
Inode blocks per group:   128
RAID stride:              128
RAID stripe width:        768
Flex block group size:    16
Filesystem created:       Tue Oct 18 01:37:04 2016
Last mount time:          Mon Oct 24 18:26:39 2016
Last write time:          Mon Oct 24 18:26:39 2016
Mount count:              13
Maximum mount count:      -1
Last checked:             Tue Oct 18 01:37:04 2016
Check interval:           0 (<none>)
Lifetime writes:          16 TB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:	          256
Required extra isize:     32
Desired extra isize:      32
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      88fcabd6-4bf3-4817-9eaa-92746a2d4295
Journal backup:           inode blocks
Checksum type:            crc32c
Checksum:                 0xeaeb1fb3
Journal features:         journal_incompat_revoke journal_64bit journal_che=
cksum_v3
Journal size:             1024M
Journal length:           262144
Journal sequence:         0x0000bb9e
Journal start:            1
Journal checksum type:    crc32c
Journal checksum:         0xe8d0e4bd

Source array details:

[schwarzgerat](0) $ sudo mdadm --detail /dev/md127
/dev/md127:
        Version : 1.2
  Creation Time : Wed Oct 12 20:56:39 2016
     Raid Level : raid1
     Array Size : 369607744 (352.49 GiB 378.48 GB)
  Used Dev Size : 369607744 (352.49 GiB 378.48 GB)
   Raid Devices : 2
  Total Devices : 2
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Tue Oct 25 09:11:04 2016
          State : clean=20
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           Name : debian:intel 750 nvme
           UUID : 6a826e91:5bf8c1de:56be717d:e55077d9
         Events : 149

    Number   Major   Minor   RaidDevice State
       0     259        6        0      active sync   /dev/nvme0n1p3
       1     259        2        1      active sync   /dev/nvme1n1p3
[schwarzgerat](0) $=20

Source filesystem details:

[schwarzgerat](0) $ sudo dumpe2fs /dev/md127p2
dumpe2fs 1.43.3 (04-Sep-2016)
Filesystem volume name:   <none>
Last mounted on:          /home
Filesystem UUID:          2509ff02-8976-4051-a074-4c8457512e9e
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index
filetype needs_recovery extent 64bit flex_bg sparse_super large_file
huge_file dir_nlink extra_isize metadata_csum
Filesystem flags:         signed_directory_hash=20
Default mount options:    user_xattr acl
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              18907136
Block count:              75624459
Reserved block count:     3781222
Free blocks:              67197022
Free inodes:              18742837
First block:              0
Block size:               4096
Fragment size:            4096
Group descriptor size:    64
Reserved GDT blocks:      1024
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
Flex block group size:    16
Filesystem created:       Fri Oct 14 19:47:30 2016
Last mount time:          Mon Oct 24 18:26:38 2016
Last write time:          Mon Oct 24 18:26:38 2016
Mount count:              16
Maximum mount count:      -1
Last checked:             Fri Oct 14 19:47:30 2016
Check interval:           0 (<none>)
Lifetime writes:          1123 MB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     32
Desired extra isize:      32
Journal inode:            8
First orphan inode:       15729268
Default directory hash:   half_md4
Directory Hash Seed:      67c455a5-d48e-4244-9acd-0b01dbd67730
Journal backup:           inode blocks
Checksum type:            crc32c
Checksum:                 0xabd72e7b
Journal features:         journal_incompat_revoke journal_64bit
journal_checksum_v3
Journal size:             1024M
Journal length:           262144
Journal sequence:         0x00001886
Journal start:            1
Journal checksum type:    crc32c
Journal checksum:         0x1519be37


--=20
nick black -=3D- http://www.nick-black.com
to make an apple pie from scratch, you need first invent a universe.

--53jqnqygalryealg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iEYEABECAAYFAlgPWzUACgkQzjCRTpolKGuwqACfaCUjjHijUIUJiGwiLMM6ztTO
VgcAn2aTVD+IdyOK14alL4135Chl0IUn
=/4qI
-----END PGP SIGNATURE-----

--53jqnqygalryealg--
