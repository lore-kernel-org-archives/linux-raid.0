From: Johannes Segitz <johannes.segitz@gmail.com>
Subject: Performance of a software raid 5
Date: Mon, 20 Apr 2009 19:12:05 +0200
Message-ID: <a5cd9eed0904201012o67503049laa50f4cb5b8d88de@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

[first of all i'm not really sure if i'm right here. If this is the
wrong place then please just
tell me what to rtfm or where to post]

i'm currently trying to create a raid 5 out of three 1 TB hdd. For now
there is one hdd missing so i get 3 TB of usable space.

One hdd is connected to
00:07.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller (rev f3)

the other two to
04:00.0 RAID bus controller: Silicon Image, Inc. SiI 3132 Serial ATA
Raid II Controller (rev 01)

The CPU is a AMD X2 4200+ and the system has 2 GB RAM.

The performance of the array is underwhelming.
time dd if=/dev/zero of=big_file bs=4096 count=2560000
10485760000 bytes (10 GB) copied, 187.691 s, 55.9 MB/s
dd if=/dev/zero of=big_file bs=4096 count=2560000 0.70s user 26.05s
system 14% cpu 3:08.12 total

time dd if=big_file of=/dev/null bs=4096 count=2560000
10485760000 bytes (10 GB) copied, 297.345 s, 35.3 MB/s
dd if=big_file of=/dev/null bs=4096 count=2560000 0.50s user 10.60s
system 3% cpu 4:57.35 total

So i get a write performance of 55 MB/s and a read speed of 35 MB/s. The hdd

 Model=SAMSUNG HD103UJ                         , FwRev=1AA01113,
SerialNo=S13PJDWS250990
 Config={ Fixed }
 RawCHS=16383/16/63, TrkSize=34902, SectSize=554, ECCbytes=4
 BuffType=DualPortCache, BuffSize=32767kB, MaxMultSect=16, MultSect=?16?
 CurCHS=16383/16/63, CurSects=16514064, LBA=yes, LBAsects=1953525168
 IORDY=on/off, tPIO={min:120,w/IORDY:120}, tDMA={min:120,rec:120}
 PIO modes:  pio0 pio1 pio2 pio3 pio4
 DMA modes:  mdma0 mdma1 mdma2
 UDMA modes: udma0 udma1 udma2 udma3 udma4 *udma5 udma6
 AdvancedPM=yes: unknown setting WriteCache=enabled
 Drive conforms to: unknown:  ATA/ATAPI-3,4,5,6,7

are all the same and get ~70 MB/s when used alone.

The details for the raid device:
/dev/md6:
        Version : 00.90
  Creation Time : Sun Apr 19 22:30:23 2009
     Raid Level : raid5
     Array Size : 2930279424 (2794.53 GiB 3000.61 GB)
  Used Dev Size : 976759808 (931.51 GiB 1000.20 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 6
    Persistence : Superblock is persistent

    Update Time : Mon Apr 20 14:45:32 2009
          State : clean, degraded
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 256K

           UUID : 584a0f66:3c075c23:9cae9464:25382498 (local to host
johannes-desktop)
         Events : 0.21396

    Number   Major   Minor   RaidDevice State
       0       8       97        0      active sync   /dev/sdg1
       1       8      145        1      active sync   /dev/sdj1
       2       8      161        2      active sync   /dev/sdk1
       3       0        0        3      removed

On top of the raid device there is a crypto layer
cryptsetup --verify-passphrase -c aes-cbc-essiv:sha256 -y -s 256
luksFormat /dev/md6
and then ext4
mkfs.ext4 -v -b 4096 -E lazy_itable_init,stride=64,stripe-width=256 -O
large_file,dir_index,extent,sparse_super,uninit_bg -m0
/dev/mapper/data
I use kernel 2.6.29.1

Stride and stripe-width will be correct when i add another two hdd of
which one will carry data. Can someone please give me a hint why i
could get such bad performance especially while reading? I don't think
its the crypto layer since kcryptd doesn't go over 50% cpu and having
two cores should prevent other processes from starving. The stride and
stripe-width aren't correct right now but can it degrade performance
like that? I would expect at least 100+ MB/s on reading and writing.

Thanks
