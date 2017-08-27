From: Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: Re: I/O hangs after resuming from suspend-to-ram
Date: Sun, 27 Aug 2017 09:43:52 +0200
Message-ID: <4174287.OjL0pO8MRx@natalenko.name>
References: <3926917.BCSovyVWdL@natalenko.name> <1579257.t1hTzJa9iD@natalenko.name> <20170827060200.GA30521@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170827060200.GA30521@ming.t460p>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Shaohua Li <shli@kernel.org>
List-Id: linux-raid.ids

Hi.

Here is disk setup for QEMU VM:

=3D=3D=3D
[root@archmq ~]# smartctl -i /dev/sda
=E2=80=A6
Device Model:     QEMU HARDDISK
Serial Number:    QM00001
=46irmware Version: 2.5+
User Capacity:    4,294,967,296 bytes [4.29 GB]
Sector Size:      512 bytes logical/physical
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ATA/ATAPI-7, ATA/ATAPI-5 published, ANSI NCITS 340-2000
Local Time is:    Sun Aug 27 09:31:54 2017 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

[root@archmq ~]# lsblk
NAME                MAJ:MIN RM  SIZE RO TYPE   MOUNTPOINT
sda                   8:0    0    4G  0 disk  =20
`-sda1                8:1    0    4G  0 part  =20
  `-md0               9:0    0    4G  0 raid10=20
    `-system        253:0    0    4G  0 crypt =20
      |-system-boot 253:1    0  512M  0 lvm    /boot
      |-system-swap 253:2    0  512M  0 lvm    [SWAP]
      `-system-root 253:3    0    3G  0 lvm    /
sdb                   8:16   0    4G  0 disk  =20
`-sdb1                8:17   0    4G  0 part  =20
  `-md0               9:0    0    4G  0 raid10=20
    `-system        253:0    0    4G  0 crypt =20
      |-system-boot 253:1    0  512M  0 lvm    /boot
      |-system-swap 253:2    0  512M  0 lvm    [SWAP]
      `-system-root 253:3    0    3G  0 lvm    /
sr0                  11:0    1 1024M  0 rom

[root@archmq ~]# mdadm --misc --detail /dev/md0
/dev/md0:
        Version : 1.2
  Creation Time : Sat Jul 29 16:37:05 2017
     Raid Level : raid10
     Array Size : 4191232 (4.00 GiB 4.29 GB)
  Used Dev Size : 4191232 (4.00 GiB 4.29 GB)
   Raid Devices : 2
  Total Devices : 2
    Persistence : Superblock is persistent

    Update Time : Sun Aug 27 09:30:33 2017
          State : clean=20
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

         Layout : far=3D2
     Chunk Size : 512K

           Name : archiso:0
           UUID : 43f4be59:c8d2fa0a:a94acdff:1c7f2f4e
         Events : 485

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
=3D=3D=3D

In words: 2 virtual disks, RAID10 setup with far-2 layout, LUKS on it, then=
=20
LVM, then ext4 for boot, swap and btrfs for /.

I couldn't reproduce the issue with single disk without RAID.

On ned=C4=9Ble 27. srpna 2017 8:02:00 CEST Ming Lei wrote:
> On Sat, Aug 26, 2017 at 12:48:01PM +0200, Oleksandr Natalenko wrote:
> > Quick update: reproduced on both v4.12.7 and v4.13.0-rc6.
>=20
> BTW, given it hangs during resume, it isn't easy to collect debug
> info, and there should have been lots useful info there.
>=20
> You mentioned that you can reproduce it on QEMU, could you
> share the exact raid10 setting? such as which disks behind
> the raid10.
>=20
> Or can you reproduce the issue without raid10 involved?
>=20
> I will try to reproduce it in my VM if you may provide the
> above info.
>=20
> Thanks,
> Ming
