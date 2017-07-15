From: Jean-Pierre Human <jphuman@gmail.com>
Subject: Superblocks lost on all disks in array.
Date: Sat, 15 Jul 2017 19:09:08 +0200
Message-ID: <CAH_1ubwzXd9C8OBheZv+Z5oFTVt2rG+RATHrhKy6uiVv84y_SA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi

I have a 4 disk Raid10 array in an Ubuntu16.04.2 Server (/dev/md2)
which seems to have lost the superblocks on all 4 disks.

The server has two other arrays in it a 3 disk Raid5 (/dev/md1) and
another 4 disk Raid10 (/dev/md0), these arrays are fine. This is not
due to mechanical failure or disk issues. The array did not come up
after a reboot of the server.

A bit more info, the failed array /dev/md2 was 100% assigned to a
logical volume which was shared via ISCSI to a Microsoft server. I
mention this as I have a feeling this could somehow be the reason the
superblocks disappeared? These disks were part of a ZFS pool before
this, I see lsdrv picks this up...

As there are no superblocks I cannot assemble the array. I feel my
only option is to create --assume-clean the array to get new
superblocks written. The server is fairly new and software versions
etc have not changed. I have the original commands I used to create
the array which have the disk order in them.

What I am looking for is any advice on how I should proceed.
Presuming I must --create,  Should I use the "file overlay" method to
allow me to roll back? I do not really understand how this works and
if it is relevant for my situation.

Would anyone know what could have caused this?

System info below:
Ubuntu 16.04.2 LTS

The array was setup with the below commands:
#mdadm --create --verbose /dev/md2 --level=3D10 --raid-devices=3D4
/dev/sdj /dev/sdk /dev/sdl /dev/sdi
#update-initramfs -u

smartctl --xall produced too much output please let me know if you
need this. I see no errors or issues in this output.

root@store02:~# mdadm --examine /dev/sd[iklj]
/dev/sdi:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdj:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdk:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdl:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)

root@store02:~# mdadm -Q /dev/sd[iklj]
/dev/sdi: is not an md array
/dev/sdj: is not an md array
/dev/sdk: is not an md array
/dev/sdl: is not an md array

root@store02:~# cat /proc/mdstat
Personalities : [raid10] [raid6] [raid5] [raid4] [linear] [multipath]
[raid0] [raid1]
md0 : active raid10 sdd[3] sdb[2] sde[1] sdc[0]
      7813774336 blocks super 1.2 512K chunks 2 near-copies [4/4] [UUUU]
      bitmap: 2/59 pages [8KB], 65536KB chunk

md1 : active raid5 sdf[1] sdg[3] sda[0]
      3906766848 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3] [U=
UU]
      bitmap: 0/15 pages [0KB], 65536KB chunk

unused devices: <none>


root@store02:~/lsdrv# ./lsdrv
PCI [mpt3sas] 02:00.0 Serial Attached SCSI controller: LSI Logic /
Symbios Logic SAS2008 PCI-Express Fusion-MPT SAS-2 [Falcon] (rev 03)
=E2=94=9Cscsi 0:0:0:0 ATA      WDC WD20EFRX-68E {WD-WCC4M2702612}
=E2=94=82=E2=94=94sda 1.82t [8:0] MD raid5 (0/3) (w/ sdf,sdg) in_sync 'rep0=
1:1'
{de8e78f6-509b-1457-fdd9-a86760d19963}
=E2=94=82 =E2=94=94md1 3.64t [9:1] MD v1.2 raid5 (3) clean, 512k Chunk
{de8e78f6:509b1457:fdd9a867:60d19963}
=E2=94=82                  ext4 {50ee08e4-fa03-49a5-a1c8-e123322dfd12}
=E2=94=9Cscsi 0:0:1:0 ATA      WDC WD4000F9YZ-0 {WD-WMC5D0D0W9D9}
=E2=94=82=E2=94=94sdb 3.64t [8:16] MD raid10,near2 (2/4) (w/ sdc,sdd,sde) i=
n_sync
'store02:0' {5552ee9a-b20b-3ad2-0e72-f2011a114ae7}
=E2=94=82 =E2=94=94md0 7.28t [9:0] MD v1.2 raid10,near2 (4) clean, 512k Chu=
nk
{5552ee9a:b20b3ad2:0e72f201:1a114ae7}
=E2=94=82  =E2=94=82               ext4 {bd712370-a142-4e7a-8539-0d0e60c464=
c3}
=E2=94=82  =E2=94=94Mounted as /dev/md0 @ /mnt/md0
=E2=94=9Cscsi 0:0:2:0 ATA      WDC WD4000F9YZ-0 {WD-WMC1F0D9LMDJ}
=E2=94=82=E2=94=94sdc 3.64t [8:32] MD raid10,near2 (0/4) (w/ sdb,sdd,sde) i=
n_sync
'store02:0' {5552ee9a-b20b-3ad2-0e72-f2011a114ae7}
=E2=94=82 =E2=94=94md0 7.28t [9:0] MD v1.2 raid10,near2 (4) clean, 512k Chu=
nk
{5552ee9a:b20b3ad2:0e72f201:1a114ae7}
=E2=94=82                  ext4 {bd712370-a142-4e7a-8539-0d0e60c464c3}
=E2=94=9Cscsi 0:0:3:0 ATA      WDC WD4000F9YZ-0 {WD-WMC5D0D7WP6N}
=E2=94=82=E2=94=94sdd 3.64t [8:48] MD raid10,near2 (3/4) (w/ sdb,sdc,sde) i=
n_sync
'store02:0' {5552ee9a-b20b-3ad2-0e72-f2011a114ae7}
=E2=94=82 =E2=94=94md0 7.28t [9:0] MD v1.2 raid10,near2 (4) clean, 512k Chu=
nk
{5552ee9a:b20b3ad2:0e72f201:1a114ae7}
=E2=94=82                  ext4 {bd712370-a142-4e7a-8539-0d0e60c464c3}
=E2=94=9Cscsi 0:0:4:0 ATA      WDC WD4000F9YZ-0 {WD-WMC5D0D1R7E0}
=E2=94=82=E2=94=94sde 3.64t [8:64] MD raid10,near2 (1/4) (w/ sdb,sdc,sdd) i=
n_sync
'store02:0' {5552ee9a-b20b-3ad2-0e72-f2011a114ae7}
=E2=94=82 =E2=94=94md0 7.28t [9:0] MD v1.2 raid10,near2 (4) clean, 512k Chu=
nk
{5552ee9a:b20b3ad2:0e72f201:1a114ae7}
=E2=94=82                  ext4 {bd712370-a142-4e7a-8539-0d0e60c464c3}
=E2=94=9Cscsi 0:0:5:0 ATA      WDC WD20EFRX-68A {WD-WCC1T0684483}
=E2=94=82=E2=94=94sdf 1.82t [8:80] MD raid5 (1/3) (w/ sda,sdg) in_sync 'rep=
01:1'
{de8e78f6-509b-1457-fdd9-a86760d19963}
=E2=94=82 =E2=94=94md1 3.64t [9:1] MD v1.2 raid5 (3) clean, 512k Chunk
{de8e78f6:509b1457:fdd9a867:60d19963}
=E2=94=82                  ext4 {50ee08e4-fa03-49a5-a1c8-e123322dfd12}
=E2=94=9Cscsi 0:0:6:0 ATA      WDC WD20EFRX-68A {WD-WCC1T0681728}
=E2=94=82=E2=94=94sdg 1.82t [8:96] MD raid5 (2/3) (w/ sda,sdf) in_sync 'rep=
01:1'
{de8e78f6-509b-1457-fdd9-a86760d19963}
=E2=94=82 =E2=94=94md1 3.64t [9:1] MD v1.2 raid5 (3) clean, 512k Chunk
{de8e78f6:509b1457:fdd9a867:60d19963}
=E2=94=82                  ext4 {50ee08e4-fa03-49a5-a1c8-e123322dfd12}
=E2=94=94scsi 0:x:x:x [Empty]
PCI [ahci] 00:1f.2 SATA controller: Intel Corporation 8 Series/C220
Series Chipset Family 6-port SATA Controller 1 [AHCI mode] (rev 05)
=E2=94=9Cscsi 1:0:0:0 ATA      Maximus-16GB     {152403701000}
=E2=94=82=E2=94=94sdh 14.75g [8:112] zfs_member
=E2=94=82 =E2=94=9Csdh1 14.34g [8:113] ext4 {5b7ca57a-9540-47fa-9146-c413d6=
49c5ba}
=E2=94=82 =E2=94=82=E2=94=94Mounted as /dev/sdh1 @ /
=E2=94=82 =E2=94=94sdh2 416.00m [8:114] swap {bfe8ede9-1ca4-4519-9916-3a894=
708f6a2}
=E2=94=9Cscsi 2:x:x:x [Empty]
=E2=94=9Cscsi 3:0:0:0 ATA      ST6000NM0115-1YZ {ZAD0RGY5}
=E2=94=82=E2=94=94sdi 5.46t [8:128] Partitioned (gpt)
=E2=94=9Cscsi 4:0:0:0 ATA      ST6000NM0115-1YZ {ZAD0RGCH}
=E2=94=82=E2=94=94sdj 5.46t [8:144] zfs_member
=E2=94=9Cscsi 5:0:0:0 ATA      ST6000NM0115-1YZ {ZAD0RHN3}
=E2=94=82=E2=94=94sdk 5.46t [8:160] zfs_member
=E2=94=94scsi 6:0:0:0 ATA      ST6000NM0115-1YZ {ZAD0RGQ6}
 =E2=94=94sdl 5.46t [8:176] Partitioned (gpt)
Other Block Devices
=E2=94=9Cloop0 0.00k [7:0] Empty/Unknown
=E2=94=9Cloop1 0.00k [7:1] Empty/Unknown
=E2=94=9Cloop2 0.00k [7:2] Empty/Unknown
=E2=94=9Cloop3 0.00k [7:3] Empty/Unknown
=E2=94=9Cloop4 0.00k [7:4] Empty/Unknown
=E2=94=9Cloop5 0.00k [7:5] Empty/Unknown
=E2=94=9Cloop6 0.00k [7:6] Empty/Unknown
=E2=94=94loop7 0.00k [7:7] Empty/Unknown

Any help or advice is appreciated.

Regards
J-P Human
