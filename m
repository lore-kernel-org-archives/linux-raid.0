From: Neil Brown <neilb@suse.de>
Subject: Re: raid5 performance question
Date: Wed, 8 Mar 2006 10:03:18 +1100
Message-ID: <17422.4406.887200.421869@cse.unsw.edu.au>
References: <5d96567b0603060346r768a0ee1i8d8170cf9ba4bac1@mail.gmail.com>
	<17420.46746.365629.168649@cse.unsw.edu.au>
	<5d96567b0603070040t114334cbm858147afe551f719@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Raz Ben-Jehuda(caro) on Tuesday March 7
Sender: linux-raid-owner@vger.kernel.org
To: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tuesday March 7, raziebe@gmail.com wrote:
> Neil.
> what is the stripe_cache exacly ?

In order to ensure correctness of data, all IO operations on a raid5
pass through the 'stripe cache'  This is a cache of stripes where each
stripe is one page wide across all devices.

e.g. to write a block, we allocate one stripe in the cache to cover
that block, pre-read anything that might be needed, copy in the new
data and update parity, and write out anything that has changed.

Similarly to read, we allocate a stripe to cover the block, read in
the requires parts, and copy out of the stripe cache into the
destination.

Requiring all reads to pass through the stripe cache is not strictly
necessary, but it keeps the code a lot easier to manage (fewer special
cases).   Bypassing the cache for simple read requests when the array
is non-degraded is on my list....


> 
> First , here are some numbers.
> 
> Setting it to 1024 gives me 85 MB/s.
> Setting it to 4096 gives me 105 MB/s.
> Setting it to 8192 gives me 115 MB/s.

Not surprisingly, a larger cache gives better throughput as it allows
more parallelism.  There is probably a link between optimal cache size
and chunk size.

> 
> the md.txt does not say much about it just that it is the number of
> entries.

No.  I should fix that.

> 
> here are some tests i have made:
> 
> test1:
> when i set the stripe_cache to zero and run:

Setting it to zero is a no-op.  Only values from 17 to 32768 are
permitted.

> 
>   "dd if=/dev/md1 of=/dev/zero bs=1M count=100000 skip=630000"
>  i am getting 120MB/s.
>  when i set the stripe cache to 4096 and : issue the same command i am
> getting 120 MB/s
> as well.

This sort of operation will causes the kernel's read-ahead to keep the
drives reading constantly.  Providing the stripe cache is large enough
to hold 2 full chunk-sized stripes, you should get very good
throughput.


> 
> test 2:
> I would describe what this tester does:
> 
> It opens N descriptors over a device.
> It issues N IOs to the target and waits for the completion of each IO.
> When the IO is completed the tester has two choices:
> 
>   1. calculate a new seek posistion over the target.
> 
>   2. move sequetially to the next position. meaning , if one reads 1MB
> buffer, the next
>       position is current+1M.
> 
>   I am using direct IO and asynchrnous IO.
> 
> option 1 simulates non contigous files. option 2 simulates contiguous files.
> the above numbers were made with option 2.
> if i am using option 1 i am getting 95 MB/s with stripe_size=4096.
> 
> A single disk in this manner ( option 1 ) gives ~28 MB/s.
> A single disk in scenario 2 gives ~30 MB/s.
> 
> I understand the a question of the IO distribution is something to talk
> about. but i am submitting 250 IOs so i suppose to be heavy on the raid.
> 
> Questions
> 1. how can the stripe size cache gives me a boost when i have total
> random access
>     to the disk ?

It doesn't give you a boost exactly.  It is just that a small cache
can get in your way by reducing the possibly parallelism.

> 
> 2. Does direct IO passes this cache ?

Yes.  Everything does.

> 
> 3. How can a dd of 1 MB over 1MB chunck size acheive this high
> throughputs of 4 disks
>    even if does not get the stripe cache benifits ?

read-ahead performed by the kernel.


NeilBrown
