From: Neil Brown <neilb@suse.de>
Subject: Re: Regarding odd RAID5 I/O patterns
Date: Thu, 7 Jun 2007 15:24:54 +1000
Message-ID: <18023.38566.170057.94416@notabene.brown>
References: <Pine.LNX.4.64.0706062327420.5806@gheavc.wnzcbav.cig>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jon Nelson on Wednesday June 6
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday June 6, jnelson-linux-raid@jamponi.net wrote:
> 
> 2. now, if I use oflag=direct, the I/O patterns are very strange:
>    0 (zero) reads from sda or sdb, and 2-3MB/s worth of reads from sdc.
>    11-12 MB/s writes to sda, and 8-9MB/s writes to sdb and sdc.
> 
>    --dsk/sda-- --dsk/sdb-- --dsk/sdc-- --dsk/hda--
>     read  writ: read  writ: read  writ: read  writ
>       0    11M:4096B 8448k:2824k 8448k:   0   132k
>       0    12M:   0  9024k:3008k 9024k:   0   152k
> 
>    Why is /dev/sdc getting so many reads? This only happens with 
>    multiples of 192K for blocksizes. For every other blocksize I tried,
>    the reads are spread across all three disks.

Where letters are 64K chunks, and digits are 64K parity chunks, and
columns are individual drives, your data is laid out something like
this:

    A   B   1
    C   2   D
    3   E   F

Your first 192K write contains data for A, B, and C.
To generate 1 no read is needed.
To generate '2', it needs to read either C or D.  It chooses D.
So you get a read from the third drive, and writes to all.

Your next 192K write contains data for D, E, and F.
The update '2' it finds that C is already in cache and doesn't need to
read anything.  To generate '3', E and F are both available, so no
read is needed.

This pattern repeats.


> 
> 3. Why can't I find a blocksize that doesn't require reading from any 
>    device? Theoretically, if the chunk size is 64KB, then writing 128KB 
>    *should* result in 3 writes and 0 reads, right?

With oflag=direct 128KB should work.  What do you get?
Without oflag=direct, you have less control.  The VM will flush data
whenever it wants to and it doesn't know about raid5 alignment
requirements.

> 
> 4. When using the page cache (no oflag=direct), even with 192KB 
>    blocksizes, there are (except for noise) *no* reads from the devices, 
>    as expected.  Why does bypassing the page cache, plus the 
>    combination of 192KB blocks cause such strange behavior?

Hmm... this isn't what I get... maybe I misunderstood exactly what you
were asking in '2' abovec??


> 
> 5. If I use an 'internal' bitmap, the write performance is *terrible*. I 
>    can't seem to sqeeze more than 8-12MB/s out of it (no page cache) or 
>    60MB/s (page cache allowed). When not using the page cache, the reads 
>    are spread across all three disks to the tune of 2-4MB per second. 
>    The bitmap "file" is only 150KB or so in size, why does storing it 
>    internally cause such a huge performance problem?

If the bitmap is internal, you have to keep seeking to the end of the
devices to update the bitmap.  If the bitmap is external and on a
different device, it seeks independently of the data writes.

NeilBrown
