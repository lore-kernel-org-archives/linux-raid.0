From: Jon Nelson <jnelson-linux-raid@jamponi.net>
Subject: Regarding odd RAID5 I/O patterns
Date: Wed, 6 Jun 2007 23:53:04 -0500 (CDT)
Message-ID: <Pine.LNX.4.64.0706062327420.5806@gheavc.wnzcbav.cig>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


What I've got:
openSUSE 10.2 running 2.6.18.8-0.3-default on x86_64 (3600+, dual core)
with a 3 component raid5:

md0 : active raid5 sdc4[2] sda4[0] sdb4[1]
      613409664 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]

I was testing sequential writes speeds with dd:

dd if=/dev/zero of=/dev/raid/test bs=192K 

with and without oflag=direct, and various bitmap choices.

with varying blocksizes.

What I'm observing I simply can't explain.

1. if I use an external bitmap, and using the page cache (without 
   oflag=direct), I seem to be able to get up to 116MB/s writes. The I/O 
   patterns as reported by iostat/dstat are reasonable (0 B/S reads, 
   high 60's (with some fluxuation, but not much) MB/s writes, very 
   consistent across all three drives):

   --dsk/sda-- --dsk/sdb-- --dsk/sdc-- --dsk/hda--
    read  writ: read  writ: read  writ: read  writ
      0    67M:  16k   71M:  52k   69M:   0   272k
      0    67M:  20k   65M:   0    69M:   0   320k

2. now, if I use oflag=direct, the I/O patterns are very strange:
   0 (zero) reads from sda or sdb, and 2-3MB/s worth of reads from sdc.
   11-12 MB/s writes to sda, and 8-9MB/s writes to sdb and sdc.

   --dsk/sda-- --dsk/sdb-- --dsk/sdc-- --dsk/hda--
    read  writ: read  writ: read  writ: read  writ
      0    11M:4096B 8448k:2824k 8448k:   0   132k
      0    12M:   0  9024k:3008k 9024k:   0   152k

   Why is /dev/sdc getting so many reads? This only happens with 
   multiples of 192K for blocksizes. For every other blocksize I tried,
   the reads are spread across all three disks.

3. Why can't I find a blocksize that doesn't require reading from any 
   device? Theoretically, if the chunk size is 64KB, then writing 128KB 
   *should* result in 3 writes and 0 reads, right?

4. When using the page cache (no oflag=direct), even with 192KB 
   blocksizes, there are (except for noise) *no* reads from the devices, 
   as expected.  Why does bypassing the page cache, plus the 
   combination of 192KB blocks cause such strange behavior?

5. If I use an 'internal' bitmap, the write performance is *terrible*. I 
   can't seem to sqeeze more than 8-12MB/s out of it (no page cache) or 
   60MB/s (page cache allowed). When not using the page cache, the reads 
   are spread across all three disks to the tune of 2-4MB per second. 
   The bitmap "file" is only 150KB or so in size, why does storing it 
   internally cause such a huge performance problem?

--
Jon Nelson <jnelson-linux-raid@jamponi.net>
