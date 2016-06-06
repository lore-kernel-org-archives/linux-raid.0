From: Bryan Hepworth <bryan.hepworth@newcastle.ac.uk>
Subject: restarting raid arrays with uuid
Date: Mon, 6 Jun 2016 18:54:47 +0000
Message-ID: <DB5PR07MB1287703757699A1962149D82D55C0@DB5PR07MB1287.eurprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi All

I'm not entirely sure this is rescuable. This is an old system that was kept on for scratch storage space, unfortunately it was discovered some data hadn't moved out of this area. The arrays disappeared after taking them offline and rebooting the machine.

I've checked /etc/mdadm.conf
And mdadm --examine across all of the disks
I've assembled from uuid
Ran /proc/mdstat

Any suggestions as to what to try next?

Thanks

Bryan

[root@igmimager dev]# cat /etc/mdadm.conf
ARRAY /dev/md0 metadata=1.2 name=igmimager.ncl.ac.uk:129 UUID=1dc7f560:edbfe144:0531da73:f239c583
ARRAY /dev/md1 metadata=1.2 name=inscribe_data1 UUID=2b00561d:25e97d49:65d13ea0:63aba0b7
ARRAY /dev/md2 metadata=1.2 name=igmimager.ncl.ac.uk:128 UUID=3aee46d0:ced811c7:287c9e2e:c9fcb98d
ARRAY /dev/md3 metadata=1.2 name=inscribe_data5 UUID=4108db00:e338d0eb:64f1c8c0:7c5dd4d2
ARRAY /dev/md4 metadata=1.2 name=igmimager.ncl.ac.uk:0 UUID=bc69e915:891c1a98:083d6b8d:8d99151f
ARRAY /dev/md5 metadata=1.2 name=inscribe_data4 UUID=f83ae16b:c7cf278a:199a0085:d8f68936
[root@igmimager dev]#

[root@igmimager etc]# mdadm --assemble /dev/md0 --uuid 1dc7f560:edbfe144:0531da73:f239c583
[root@igmimager etc]# mdadm --assemble /dev/md1 --uuid 2b00561d:25e97d49:65d13ea0:63aba0b7
[root@igmimager etc]# mdadm --assemble /dev/md2 --uuid 3aee46d0:ced811c7:287c9e2e:c9fcb98d
[root@igmimager etc]# mdadm --assemble /dev/md3 --uuid 4108db00:e338d0eb:64f1c8c0:7c5dd4d2
[root@igmimager etc]# mdadm --assemble /dev/md4 --uuid bc69e915:891c1a98:083d8f68936
mdadm: Bad uuid: bc69e915:891c1a98:083d8f68936
[root@igmimager etc]# mdadm --assemble /dev/md4 --uuid bc69e915:891c1a98:083d6b8d:8d99151f
mdadm: Found some drive for an array that is already active: /dev/md4
mdadm: giving up.
[root@igmimager etc]# mdadm --assemble /dev/md5 --uuid f83ae16b:c7cf278a:199a0085:d8f68936
[root@igmimager etc]# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md3 : active raid5 sdi1[0] sdl1[4] sdk1[2] sdj1[1]
      5860142592 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/4] [UUUU]
      bitmap: 0/15 pages [0KB], 65536KB chunk

md4 : active raid5 sdn[2] sdp[0] sdo[1]
      5860148736 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/3] [UUU_]
      bitmap: 9/15 pages [36KB], 65536KB chunk

unused devices: <none>

[root@igmimager dev]# ls
autofs           MAKEDEV             sda   sg18      tty22  tty6
block            mapper              sdb   sg19      tty23  tty60
bsg              mcelog              sdc   sg2       tty24  tty61
bus              md                  sdd   sg20      tty25  tty62
cdrom            md3                 sde   sg21      tty26  tty63
cdrw             md4                 sdf   sg22      tty27  tty7
char             mem                 sdg   sg23      tty28  tty8
console          mpt2ctl             sdh   sg24      tty29  tty9
core             net                 sdi   sg25      tty3   ttyS0
cpu              network_latency     sdi1  sg26      tty30  ttyS1
cpu_dma_latency  network_throughput  sdj   sg27      tty31  ttyS2
crash            null                sdj1  sg3       tty32  ttyS3
disk             nvram               sdk   sg4       tty33  uinput
dm-0             oldmem              sdk1  sg5       tty34  urandom
dm-1             parport0            sdl   sg6       tty35  usbmon0
dm-2             port                sdl1  sg7       tty36  usbmon1
dvd              ppp                 sdm   sg8       tty37  usbmon2
dvdrw            ptmx                sdn   sg9       tty38  usbmon3
fb               pts                 sdo   shm       tty39  vcs
fb0              ram0                sdp   snapshot  tty4   vcs1
fd               ram1                sdq   sr0       tty40  vcs2
full             ram10               sdr   stderr    tty41  vcs3
fuse             ram11               sds   stdin     tty42  vcs4
hpet             ram12               sdt   stdout    tty43  vcs5
hugepages        ram13               sdu   systty    tty44  vcs6
hvc0             ram14               sdv   tty       tty45  vcs7
input            ram15               sdw   tty0      tty46  vcsa
kmsg             ram2                sdx   tty1      tty47  vcsa1
log              ram3                sdy   tty10     tty48  vcsa2
loop0            ram4                sdy1  tty11     tty49  vcsa3
loop1            ram5                sdy2  tty12     tty5   vcsa4
loop2            ram6                sg0   tty13     tty50  vcsa5
loop3            ram7                sg1   tty14     tty51  vcsa6
loop4            ram8                sg10  tty15     tty52  vcsa7
loop5            ram9                sg11  tty16     tty53  vga_arbiter
loop6            random              sg12  tty17     tty54  vg_igmimager
loop7            raw                 sg13  tty18     tty55  watchdog
lp0              root                sg14  tty19     tty56  zero
lp1              rtc                 sg15  tty2      tty57
lp2              rtc0                sg16  tty20     tty58
lp3              scd0                sg17  tty21     tty59
[root@igmimager dev]# mdadm --examine /dev/sda
/dev/sda:
   MBR Magic : aa55
Partition[0] :   3907029167 sectors at            1 (type ee)
[root@igmimager dev]# mdadm --examine /dev/sdb
/dev/sdb:
   MBR Magic : aa55
Partition[0] :   3907029167 sectors at            1 (type ee)
[root@igmimager dev]# mdadm --examine /dev/sdc
/dev/sdc:
   MBR Magic : aa55
Partition[0] :   3907029167 sectors at            1 (type ee)
[root@igmimager dev]# mdadm --examine /dev/sdd
/dev/sdd:
   MBR Magic : aa55
Partition[0] :   3907029167 sectors at            1 (type ee)
[root@igmimager dev]# mdadm --examine /dev/sde
/dev/sde:
   MBR Magic : aa55
Partition[0] :   1953525167 sectors at            1 (type ee)
[root@igmimager dev]# mdadm --examine /dev/sdf
/dev/sdf:
   MBR Magic : aa55
Partition[0] :   1953525167 sectors at            1 (type ee)
[root@igmimager dev]# mdadm --examine /dev/sdg
/dev/sdg:
   MBR Magic : aa55
Partition[0] :   1953525167 sectors at            1 (type ee)
[root@igmimager dev]# mdadm --examine /dev/sdh
/dev/sdh:
   MBR Magic : aa55
Partition[0] :   1953525167 sectors at            1 (type ee)
[root@igmimager dev]# mdadm --examine /dev/sdi
/dev/sdi:
   MBR Magic : aa55
Partition[0] :   3907024002 sectors at           63 (type fd)
[root@igmimager dev]# mdadm --examine /dev/sdi1
/dev/sdi1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 4108db00:e338d0eb:64f1c8c0:7c5dd4d2
           Name : inscribe_data5
  Creation Time : Tue Nov  4 14:29:13 2014
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3906761858 (1862.89 GiB 2000.26 GB)
     Array Size : 5860142592 (5588.67 GiB 6000.79 GB)
  Used Dev Size : 3906761728 (1862.89 GiB 2000.26 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=130 sectors
          State : clean
    Device UUID : dacbe3a5:6eaa2eb8:af08f6e1:4c328ba0

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon Jun  6 09:23:33 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : c47214c8 - correct
         Events : 4082

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)
[root@igmimager dev]# mdadm --examine /dev/sdj
/dev/sdj:
   MBR Magic : aa55
Partition[0] :   3907024002 sectors at           63 (type fd)
[root@igmimager dev]# mdadm --examine /dev/sdj1
/dev/sdj1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 4108db00:e338d0eb:64f1c8c0:7c5dd4d2
           Name : inscribe_data5
  Creation Time : Tue Nov  4 14:29:13 2014
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3906761858 (1862.89 GiB 2000.26 GB)
     Array Size : 5860142592 (5588.67 GiB 6000.79 GB)
  Used Dev Size : 3906761728 (1862.89 GiB 2000.26 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=130 sectors
          State : clean
    Device UUID : cf8bb995:c90196ed:3596b09b:daaf0e95

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon Jun  6 09:23:33 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 97ed372d - correct
         Events : 4082

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)
[root@igmimager dev]# mdadm --examine /dev/sdk
/dev/sdk:
   MBR Magic : aa55
Partition[0] :   3907024002 sectors at           63 (type fd)
[root@igmimager dev]# mdadm --examine /dev/sdk1
/dev/sdk1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 4108db00:e338d0eb:64f1c8c0:7c5dd4d2
           Name : inscribe_data5
  Creation Time : Tue Nov  4 14:29:13 2014
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3906761858 (1862.89 GiB 2000.26 GB)
     Array Size : 5860142592 (5588.67 GiB 6000.79 GB)
  Used Dev Size : 3906761728 (1862.89 GiB 2000.26 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=130 sectors
          State : clean
    Device UUID : bb4bec12:c5ab5c9d:c06e01aa:bff93d27

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon Jun  6 09:23:33 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 6566c385 - correct
         Events : 4082

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)
[root@igmimager dev]# mdadm --examine /dev/sdl
/dev/sdl:
   MBR Magic : aa55
Partition[0] :   3907024002 sectors at           63 (type fd)
[root@igmimager dev]# mdadm --examine /dev/sdl1
/dev/sdl1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 4108db00:e338d0eb:64f1c8c0:7c5dd4d2
           Name : inscribe_data5
  Creation Time : Tue Nov  4 14:29:13 2014
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3906761858 (1862.89 GiB 2000.26 GB)
     Array Size : 5860142592 (5588.67 GiB 6000.79 GB)
  Used Dev Size : 3906761728 (1862.89 GiB 2000.26 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=130 sectors
          State : clean
    Device UUID : bd44fe34:7e930cb8:833ca67b:feb4479a

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon Jun  6 09:23:33 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : e6d73254 - correct
         Events : 4082

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)
[root@igmimager dev]# mdadm --examine /dev/sdm
/dev/sdm:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : bc69e915:891c1a98:083d6b8d:8d99151f
           Name : igmimager.ncl.ac.uk:0  (local to host igmimager.ncl.ac.uk)
  Creation Time : Fri Aug 15 10:07:25 2014
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
     Array Size : 5860148736 (5588.67 GiB 6000.79 GB)
  Used Dev Size : 3906765824 (1862.89 GiB 2000.26 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=1200 sectors
          State : clean
    Device UUID : 5c9e7c6d:1c153f07:dda9dbe8:4b5ee6ae

Internal Bitmap : 8 sectors from superblock
    Update Time : Thu May 28 11:23:56 2015
       Checksum : 5b0ecf59 - correct
         Events : 293

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)
[root@igmimager dev]# mdadm --examine /dev/sdn
/dev/sdn:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : bc69e915:891c1a98:083d6b8d:8d99151f
           Name : igmimager.ncl.ac.uk:0  (local to host igmimager.ncl.ac.uk)
  Creation Time : Fri Aug 15 10:07:25 2014
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
     Array Size : 5860148736 (5588.67 GiB 6000.79 GB)
  Used Dev Size : 3906765824 (1862.89 GiB 2000.26 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=1200 sectors
          State : clean
    Device UUID : 6565a1ae:3964efa8:8c17f442:dd1afbec

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon Jun  6 09:24:00 2016
       Checksum : d800f44f - correct
         Events : 40791

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAA. ('A' == active, '.' == missing, 'R' == replacing)
[root@igmimager dev]# mdadm --examine /dev/sdo
/dev/sdo:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : bc69e915:891c1a98:083d6b8d:8d99151f
           Name : igmimager.ncl.ac.uk:0  (local to host igmimager.ncl.ac.uk)
  Creation Time : Fri Aug 15 10:07:25 2014
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
     Array Size : 5860148736 (5588.67 GiB 6000.79 GB)
  Used Dev Size : 3906765824 (1862.89 GiB 2000.26 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=1200 sectors
          State : clean
    Device UUID : 4db2ac90:09cf877c:11544b5b:deb24f24

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon Jun  6 09:24:00 2016
       Checksum : dd50808b - correct
         Events : 40791

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAA. ('A' == active, '.' == missing, 'R' == replacing)
[root@igmimager dev]# mdadm --examine /dev/sdp
/dev/sdp:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : bc69e915:891c1a98:083d6b8d:8d99151f
           Name : igmimager.ncl.ac.uk:0  (local to host igmimager.ncl.ac.uk)
  Creation Time : Fri Aug 15 10:07:25 2014
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
     Array Size : 5860148736 (5588.67 GiB 6000.79 GB)
  Used Dev Size : 3906765824 (1862.89 GiB 2000.26 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262064 sectors, after=1200 sectors
          State : clean
    Device UUID : 7a8f2d04:b51d004e:bcdc3dbf:0ae37b15

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon Jun  6 09:24:00 2016
       Checksum : 7768653a - correct
         Events : 40791

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAA. ('A' == active, '.' == missing, 'R' == replacing)
[root@igmimager dev]# mdadm --examine /dev/sdq
/dev/sdq:
   MBR Magic : aa55
Partition[0] :   1953525167 sectors at            1 (type ee)
[root@igmimager dev]# mdadm --examine /dev/sdr
/dev/sdr:
   MBR Magic : aa55
Partition[0] :   1953525167 sectors at            1 (type ee)
[root@igmimager dev]# mdadm --examine /dev/sds
/dev/sds:
   MBR Magic : aa55
Partition[0] :   3907029167 sectors at            1 (type ee)
[root@igmimager dev]# mdadm --examine /dev/sdt
/dev/sdt:
   MBR Magic : aa55
Partition[0] :   1953525167 sectors at            1 (type ee)
[root@igmimager dev]# mdadm --examine /dev/sdu
/dev/sdu:
   MBR Magic : aa55
Partition[0] :   3907029167 sectors at            1 (type ee)
[root@igmimager dev]# mdadm --examine /dev/sdv
/dev/sdv:
   MBR Magic : aa55
Partition[0] :   3907029167 sectors at            1 (type ee)
[root@igmimager dev]# mdadm --examine /dev/sdw
/dev/sdw:
   MBR Magic : aa55
Partition[0] :   3907029167 sectors at            1 (type ee)
[root@igmimager dev]# mdadm --examine /dev/sdx
/dev/sdx:
   MBR Magic : aa55
Partition[0] :   3907029167 sectors at            1 (type ee)
[root@igmimager dev]# mdadm --examine /dev/sdy
/dev/sdy:
   MBR Magic : aa55
Partition[0] :      1024000 sectors at         2048 (type 83)
Partition[1] :    487254016 sectors at      1026048 (type 8e)
[root@igmimager dev]# mdadm --examine /dev/sdy1
mdadm: No md superblock detected on /dev/sdy1.
[root@igmimager dev]# mdadm --examine /dev/sdy2
mdadm: No md superblock detected on /dev/sdy2.
[root@igmimager dev]#

