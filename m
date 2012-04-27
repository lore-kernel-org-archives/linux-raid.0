From: Salatiel Filho <salatiel.filho@gmail.com>
Subject: Help to assemble raid5 - no superblock!
Date: Fri, 27 Apr 2012 07:24:01 -0300
Message-ID: <CAGmni9ogttmRiWqFkXz=wC=fqy7QFwDtuBYGL1kBenusQtB42g@mail.gmail.com>
References: <CAGmni9oPLr6xg07gn0kVpKM2ysOzM5x+Dx-kBTz2ZDdqV0-VOg@mail.gmail.com>
 <20120404214749.0988c792@notabene.brown> <CAGmni9pRk4qO88VvUMQ2VpnmzokhxCbfwsA9LpnD1Jsa0KMKgg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGmni9pRk4qO88VvUMQ2VpnmzokhxCbfwsA9LpnD1Jsa0KMKgg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

A little help again. After being able to successfully mount in the
mips machine now that i am trying to mount in a x86 machine it is not
working.

# =A0root@eeepc:~# mdadm -A =A0--update=3Dbyteorder /dev/md1 /dev/sdc2
/dev/sdd2 /dev/sde2
mdadm: failed to add /dev/sdd2 to /dev/md1: Invalid argument
mdadm: failed to add /dev/sde2 to /dev/md1: Invalid argument
mdadm: failed to add /dev/sdc2 to /dev/md1: Invalid argument
mdadm: /dev/md1 assembled from 0 drives - not enough to start the array=
=2E


root@eeepc:~# =A0 mdadm -E =A0/dev/sdc2
/dev/sdc2:
=A0 =A0 =A0 =A0 =A0Magic : a92b4efc
=A0 =A0 =A0 =A0Version : 0.90.00
=A0 =A0 =A0 =A0 =A0 UUID : 9ef886db:6d1ad183:a547ee43:0d984338
=A0Creation Time : Thu Mar 29 11:50:27 2012
=A0 =A0 Raid Level : raid5
=A0Used Dev Size : 1360279872 (1297.26 GiB 1392.93 GB)
=A0 =A0 Array Size : 2720559744 (2594.53 GiB 2785.85 GB)
=A0 Raid Devices : 3
=A0Total Devices : 3
Preferred Minor : 1

=A0 =A0Update Time : Thu Apr 26 20:01:51 2012
=A0 =A0 =A0 =A0 =A0State : clean
=A0Active Devices : 3
Working Devices : 3
=A0Failed Devices : 0
=A0Spare Devices : 0
=A0 =A0 =A0 Checksum : 5844783d - expected 5844773d
=A0 =A0 =A0 =A0 Events : 65223

=A0 =A0 =A0 =A0 Layout : left-symmetric
=A0 =A0 Chunk Size : 64K

=A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
this =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 =A02 =A0 =A0 =A0 =A00 =A0 =A0 =
=A0active sync =A0 /dev/sda2

=A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 =A02 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sda2
=A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 18 =A0 =A0 =A0 =A01 =A0 =A0 =A0=
active sync =A0 /dev/sdb2
=A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 34 =A0 =A0 =A0 =A02 =A0 =A0 =A0=
active sync =A0 /dev/sdc2

root@eeepc:~# =A0 mdadm -E =A0/dev/sdd2
/dev/sdd2:
=A0 =A0 =A0 =A0 =A0Magic : a92b4efc
=A0 =A0 =A0 =A0Version : 0.90.00
=A0 =A0 =A0 =A0 =A0 UUID : 9ef886db:6d1ad183:a547ee43:0d984338
=A0Creation Time : Thu Mar 29 11:50:27 2012
=A0 =A0 Raid Level : raid5
=A0Used Dev Size : 1360279872 (1297.26 GiB 1392.93 GB)
=A0 =A0 Array Size : 2720559744 (2594.53 GiB 2785.85 GB)
=A0 Raid Devices : 3
=A0Total Devices : 3
Preferred Minor : 1

=A0 =A0Update Time : Thu Apr 26 20:01:51 2012
=A0 =A0 =A0 =A0 =A0State : clean
=A0Active Devices : 3
Working Devices : 3
=A0Failed Devices : 0
=A0Spare Devices : 0
=A0 =A0 =A0 Checksum : 5844784f - expected 5844774f
=A0 =A0 =A0 =A0 Events : 65223

=A0 =A0 =A0 =A0 Layout : left-symmetric
=A0 =A0 Chunk Size : 64K

=A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
this =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 18 =A0 =A0 =A0 =A01 =A0 =A0 =A0=
active sync =A0 /dev/sdb2

=A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 =A02 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sda2
=A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 18 =A0 =A0 =A0 =A01 =A0 =A0 =A0=
active sync =A0 /dev/sdb2
=A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 34 =A0 =A0 =A0 =A02 =A0 =A0 =A0=
active sync =A0 /dev/sdc2
root@eeepc:~# =A0 mdadm -E =A0/dev/sde2
/dev/sde2:
=A0 =A0 =A0 =A0 =A0Magic : a92b4efc
=A0 =A0 =A0 =A0Version : 0.90.00
=A0 =A0 =A0 =A0 =A0 UUID : 9ef886db:6d1ad183:a547ee43:0d984338
=A0Creation Time : Thu Mar 29 11:50:27 2012
=A0 =A0 Raid Level : raid5
=A0Used Dev Size : 1360279872 (1297.26 GiB 1392.93 GB)
=A0 =A0 Array Size : 2720559744 (2594.53 GiB 2785.85 GB)
=A0 Raid Devices : 3
=A0Total Devices : 3
Preferred Minor : 1

=A0 =A0Update Time : Thu Apr 26 20:01:51 2012
=A0 =A0 =A0 =A0 =A0State : clean
=A0Active Devices : 3
Working Devices : 3
=A0Failed Devices : 0
=A0Spare Devices : 0
=A0 =A0 =A0 Checksum : 58447861 - expected 58447761
=A0 =A0 =A0 =A0 Events : 65223
=A0 =A0 =A0 =A0 Layout : left-symmetric
=A0 =A0 Chunk Size : 64K

=A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State
this =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 34 =A0 =A0 =A0 =A02 =A0 =A0 =A0=
active sync =A0 /dev/sdc2

=A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 =A02 =A0 =A0 =A0 =A00 =A0 =A0=
 =A0active sync =A0 /dev/sda2
=A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 18 =A0 =A0 =A0 =A01 =A0 =A0 =A0=
active sync =A0 /dev/sdb2
=A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 34 =A0 =A0 =A0 =A02 =A0 =A0 =A0=
active sync =A0 /dev/sdc2


Apparently i am getting checksum error.


root@eeepc:~# dmesg

=2E..
[ 2102.169124] md: invalid superblock checksum on sde2
[ 2102.169133] md: sde2 does not have a valid v0.90 superblock, not imp=
orting!
[ 2102.169152] md: md_import_device returned -22
[ 2102.170490] md: invalid superblock checksum on sdc2
[ 2102.170499] md: sdc2 does not have a valid v0.90 superblock, not imp=
orting!
[ 2102.170513] md: md_import_device returned -22
[ 2133.642956] scsi_verify_blk_ioctl: 24 callbacks suppressed
[ 2133.642964] mdadm: sending ioctl 800c0910 to a partition!
[ 2133.642971] mdadm: sending ioctl 800c0910 to a partition!
[ 2133.642988] mdadm: sending ioctl 1261 to a partition!
[ 2133.642993] mdadm: sending ioctl 1261 to a partition!
[ 2133.643682] mdadm: sending ioctl 1261 to a partition!
[ 2133.643689] mdadm: sending ioctl 1261 to a partition!
[ 2133.648251] mdadm: sending ioctl 1261 to a partition!
[ 2133.648258] mdadm: sending ioctl 1261 to a partition!
[ 2133.648732] mdadm: sending ioctl 1261 to a partition!
[ 2133.648738] mdadm: sending ioctl 1261 to a partition!
[ 2260.925012] scsi_verify_blk_ioctl: 8 callbacks suppressed
=2E..

root@eeepc:~# mdadm --version
mdadm - v3.2.3 - 23rd December 2011


any ideas how to fix this ?





[]'s
Salatiel


On Wed, Apr 4, 2012 at 08:47, NeilBrown <neilb@suse.de> wrote:
> On Wed, 4 Apr 2012 08:15:57 -0300 Salatiel Filho <salatiel.filho@gmai=
l.com>
> wrote:
>
>> I am having a big problem trying to assemble my raid.
>> I can assemble just fine in the old machine (LINUX ARM) where i buil=
t
>> the raid in the first place, but i am just unable to do in other
>> machine (Linux mips). I have no mdadm.conf in both machines.
>> I got the following error:
>>
>> # mdadm =A0-A /dev/md0 /dev/sda2 /dev/sdb2 /dev/sdc2
>> mdadm: no recogniseable superblock on /dev/sda2
>> mdadm: /dev/sda2 has no superblock - assembly aborted
>>
>> # cat /var/log/messages | tail
>>
>> Apr =A04 08:08:32 (none) kernel: [ 8577.010000] scsi_verify_blk_ioct=
l: 4
>> callbacks suppressed
>> Apr =A04 08:08:32 (none) kernel: [ 8577.020000] mdadm: sending ioctl
>> 400c0910 to a partition!
>> Apr =A04 08:08:32 (none) kernel: [ 8577.020000] mdadm: sending ioctl
>> 400c0910 to a partition!
>> Apr =A04 08:08:32 (none) kernel: [ 8577.030000] mdadm: sending ioctl
>> 20001261 to a partition!
>> Apr =A04 08:08:32 (none) kernel: [ 8577.040000] mdadm: sending ioctl
>> 20001261 to a partition!
>> Apr =A04 08:08:32 (none) kernel: [ 8577.050000] mdadm: sending ioctl
>> 20001261 to a partition!
>> Apr =A04 08:08:32 (none) kernel: [ 8577.050000] mdadm: sending ioctl
>> 20001261 to a partition!
>> Apr =A04 08:08:32 (none) kernel: [ 8577.270000] mdadm: sending ioctl
>> 20001261 to a partition!
>> Apr =A04 08:08:32 (none) kernel: [ 8577.280000] mdadm: sending ioctl
>> 20001261 to a partition!
>> Apr =A04 08:08:33 (none) kernel: [ 8577.290000] mdadm: sending ioctl
>> 20001261 to a partition!
>> Apr =A04 08:08:33 (none) kernel: [ 8577.290000] mdadm: sending ioctl
>> 20001261 to a partition!
>>
>> # fdisk -l =A0/dev/sda
>>
>> Disk /dev/sda: 1500.3 GB, 1500301910016 bytes
>> 255 heads, 63 sectors/track, 182401 cylinders
>> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
>>
>> =A0 =A0Device Boot =A0 =A0 =A0Start =A0 =A0 =A0 =A0 End =A0 =A0 =A0B=
locks =A0Id System
>> /dev/sda1 =A0 =A0 =A0 =A0 =A0 =A0 =A0 1 =A0 =A0 =A0 13055 =A0 104857=
600 =A083 Linux
>> /dev/sda2 =A0 =A0 =A0 =A0 =A0 13055 =A0 =A0 =A0182402 =A01360279960 =
=A0fd Linux raid autodetect
>>
>>
>> # fdisk -l =A0/dev/sdb
>>
>> Disk /dev/sdb: 1500.3 GB, 1500301910016 bytes
>> 255 heads, 63 sectors/track, 182401 cylinders
>> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
>>
>> =A0 =A0Device Boot =A0 =A0 =A0Start =A0 =A0 =A0 =A0 End =A0 =A0 =A0B=
locks =A0Id System
>> /dev/sdb1 =A0 =A0 =A0 =A0 =A0 =A0 =A0 1 =A0 =A0 =A0 13055 =A0 104857=
600 =A083 Linux
>> Partition 1 does not end on cylinder boundary
>> /dev/sdb2 =A0 =A0 =A0 =A0 =A0 13055 =A0 =A0 =A0182402 =A01360279960 =
=A0fd Linux raid autodetect
>> Partition 2 does not end on cylinder boundary
>>
>> # fdisk -l /dev/sdc
>>
>> Disk /dev/sdc: 1500.3 GB, 1500301910016 bytes
>> 255 heads, 63 sectors/track, 182401 cylinders
>> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
>>
>> =A0 =A0Device Boot =A0 =A0 =A0Start =A0 =A0 =A0 =A0 End =A0 =A0 =A0B=
locks =A0Id System
>> /dev/sdc1 =A0 =A0 =A0 =A0 =A0 =A0 =A0 1 =A0 =A0 =A0 13055 =A0 104857=
600 =A083 Linux
>> /dev/sdc2 =A0 =A0 =A0 =A0 =A0 13055 =A0 =A0 =A0182402 =A01360279960 =
=A0fd Linux raid autodetect
>>
>>
>> # cat /proc/mdstat
>> Personalities : [raid1] [raid6] [raid5] [raid4]
>> unused devices: <none>
>>
>>
>>
>> # lsmod | grep -i 'md\|raid'
>> raid456 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A047584 =A00
>> async_raid6_recov =A0 =A0 =A0 =A0896 =A01 raid456
>> async_pq =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A01536 =A01 raid456
>> raid6_pq =A0 =A0 =A0 =A0 =A0 =A0 =A0 74752 =A02 async_raid6_recov,as=
ync_pq
>> async_xor =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0976 =A02 raid456,async_pq
>> async_memcpy =A0 =A0 =A0 =A0 =A0 =A0 560 =A01 raid456
>> async_tx =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 832 =A05
>> raid456,async_raid6_recov,async_pq,async_xor,async_memcpy
>> raid1 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A024304 =A00
>> md_mod =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 88816 =A02 raid456,raid1
>> md5 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 1424 =A00
>> crypto_hash =A0 =A0 =A0 =A0 =A0 =A0 7888 =A03 dm_crypt,sha1_generic,=
md5
>>
>>
>>
>> # uname -a
>>
>> Linux router 3.2.9 #16 Sun Mar 25 16:31:49 BRT 2012 mips GNU/Linux
>>
>>
>> Any help ?
>
> ARM is little-endian
> MIPS ?? is that bigendian?
>
> What does
> =A0 mdadm -E --metadata=3D0.swap /dev/sda2
> report?
>
>
> If it is something useful, then try adding
> =A0 --update=3Dbyteorder
> to the "mdadm -A" command.
>
> NeilBrown
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
