From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Performance of a software raid 5
Date: Tue, 21 Apr 2009 00:46:54 +0100
Message-ID: <49ED096E.1000002@anonymous.org.uk>
References: <a5cd9eed0904201012o67503049laa50f4cb5b8d88de@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a5cd9eed0904201012o67503049laa50f4cb5b8d88de@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Johannes Segitz <johannes.segitz@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 20/04/2009 18:12, Johannes Segitz wrote:
> i'm currently trying to create a raid 5 out of three 1 TB hdd. For now
> there is one hdd missing so i get 3 TB of usable space.
[...]
> Stride and stripe-width will be correct when i add another two hdd of
> which one will carry data. Can someone please give me a hint why i
> could get such bad performance especially while reading?

I would have thought it's because you're running in degraded mode and 
one in 3 sectors is having to be regenerated from the parity. It still 
seems a bit slow, though.

Here I have a 3-disc RAID-5 of similar drives:

# hdparm -i /dev/sda
/dev/sda:

  Model=SAMSUNG HD103UJ                         , FwRev=1AA01112, 
SerialNo=S1PVJ1CQ602164
  Config={ Fixed }
  RawCHS=16383/16/63, TrkSize=34902, SectSize=554, ECCbytes=4
  BuffType=DualPortCache, BuffSize=32767kB, MaxMultSect=16, MultSect=?0?
  CurCHS=16383/16/63, CurSects=16514064, LBA=yes, LBAsects=268435455
  IORDY=on/off, tPIO={min:120,w/IORDY:120}, tDMA={min:120,rec:120}
  PIO modes:  pio0 pio1 pio2 pio3 pio4
  DMA modes:  mdma0 mdma1 mdma2
  UDMA modes: udma0 udma1 udma2
  AdvancedPM=yes: disabled (255) WriteCache=enabled
  Drive conforms to: unknown:  ATA/ATAPI-3 ATA/ATAPI-4 ATA/ATAPI-5 
ATA/ATAPI-6 ATA/ATAPI-7

# mdadm --detail /dev/md1
/dev/md1:
         Version : 00.90.03
   Creation Time : Mon Jul 28 15:49:09 2008
      Raid Level : raid5
      Array Size : 1953310720 (1862.82 GiB 2000.19 GB)
   Used Dev Size : 976655360 (931.41 GiB 1000.10 GB)
    Raid Devices : 3
   Total Devices : 3
Preferred Minor : 1
     Persistence : Superblock is persistent

   Intent Bitmap : Internal

     Update Time : Tue Apr 21 00:35:26 2009
           State : active
  Active Devices : 3
Working Devices : 3
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 256K

            UUID : d8c57a89:166ee722:23adec48:1574b5fc
          Events : 0.6134

     Number   Major   Minor   RaidDevice State
        0       8        2        0      active sync   /dev/sda2
        1       8       18        1      active sync   /dev/sdb2
        2       8       34        2      active sync   /dev/sdc2

It has LVM and an ext3 filesystem on it. Here are my timings:

# time dd if=/dev/zero of=big_file bs=4096 count=2560000
2560000+0 records in
2560000+0 records out
10485760000 bytes (10 GB) copied, 264.448 seconds, 39.7 MB/s

real    4m25.740s
user    0m2.272s
sys     0m34.470s

# time dd if=big_file of=/dev/null bs=4096 count=2560000
2560000+0 records in
2560000+0 records out
10485760000 bytes (10 GB) copied, 53.9577 seconds, 194 MB/s

real    0m54.026s
user    0m0.556s
sys     0m4.944s

I'm not quite sure whether I should be disappointed at my writes being 
so slow. Certainly there's a lot of rattling during writing, which 
probably indicates lots of seeks to write ext3's journal. But reads are 
roughly what I expected, at about three times the single-disc throughput.

Cheers,

John.

