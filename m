From: pg_lxra@lxra.for.sabi.co.UK (Peter Grandi)
Subject: Re: RAID5 to RAID6 reshape?
Date: Mon, 25 Feb 2008 00:10:07 +0000
Message-ID: <18370.1887.177853.198054@tree.ty.sabi.co.UK>
References: <aebf5d970802161958x17a9da92r25663703dc0df05f@mail.gmail.com>
	<18360.8065.335494.142060@tree.ty.sabi.co.UK>
	<20080217074526.29d3c5c5@hardcode42.net>
	<18361.55006.23018.546040@tree.ty.sabi.co.UK>
	<20080220073915.a1f3s54ua8ckk8gk@cakebox.homeunix.net>
	<18366.33809.731697.907687@tree.ty.sabi.co.UK>
	<20080223214008.hd9t63ddm0oosc8g@cakebox.homeunix.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080223214008.hd9t63ddm0oosc8g@cakebox.homeunix.net>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>> On Sat, 23 Feb 2008 21:40:08 +0100, Nagilum
>>> <nagilum@nagilum.org> said:

[ ... ]

>> * Doing unaligned writes on a 13+1 or 12+2 is catastrophically
>> slow because of the RMW cycle. This is of course independent
>> of how one got to the something like 13+1 or a 12+2.

nagilum> Changing a single byte in a 2+1 raid5 or a 13+1 raid5
nagilum> requires exactly two 512byte blocks to be read and
nagilum> written from two different disks. Changing two bytes
nagilum> which are unaligned (the last and first byte of two
nagilum> consecutive stripes) doubles those figures, but more
nagilum> disks are involved.

Here you are using the astute misdirection of talking about
unaunaligned *byte* *updates* when the issue is unaligned
*stripe* *writes*.

If one used your scheme to write a 13+1 stripe one block at a
time would take 26R+26W operations (about half of which could be
cached) instead of 14W which are what is required when doing
aligned stripe writes, which is what good file systems try to
achieve.

Well, 26R+26W may be a caricature, but the problem is that even
if one bunches updates of N blocks into a read N blocks+parity,
write N blocks+parity operation is still RMW, just a smaller RMW
than a full stripe RMW.

And reading before writing can kill write performance, because
it is a two-pass algorithm and a two-pass algorithm is pretty
bad news for disk work, and even more so, given most OS and disk
elevator algorithms, for one pass of reads and one of writes
dependent on the reads.

But enough of talking about absurd cases, let's do a good clear
example of why a 13+1 is bad bad bad when doing unaligned writes.

Consider writing to a 2+1 and an 13+1 just 15 blocks in 4+4+4+3
bunches, starting with block 0 (so aligned start, unaligned
bunch length, unaligned total length), a random case but quite
illustrative:

  2+1:
	00 01 P1 03 04 P2 06 07 P3 09 10 P4
        00 01    02 03    04 05    06 07   
        ------**-------** ------**-------**
        12 13 P5 15 16 P6 18 19 P7 21 22 P8
        08 09    10 11    12 13    14
        ------**-------** ------**---    **

	write D00 D01 DP1
	write D03 D04 DP2

	write D06 D07 DP3
	write D09 D10 DP4

	write D12 D13 DP5
	write D15 D16 DP6

	write D18 D19 DP7
	read  D21 DP8
	write D21 DP8

        Total:
	  IOP: 01 reads, 08 writes
	  NLK: 02 reads, 23 writes
	  XOR: 28 reads, 15 writes

 13+1:
	00 01 02 03 04 05 06 07 08 09 10 11 12 P1
        00 01 02 03 04 05 06 07 08 09 10 11 12
        ----------- ----------- ----------- -- **
	
        14 15 16 17 18 19 20 21 22 23 24 25 26 P2
	13 14
	-----                                  **

	read  D00 D01 D02 D03 DP1
	write D00 D01 D02 D03 DP1

	read  D04 D05 D06 D07 DP1
	write D04 D05 D06 D07 DP1

	read  D08 D09 D10 D11 DP1
	write D08 D09 D10 D11 DP1

	read  D12 DP1 D14 D15 DP2
	write D12 DP1 D14 D15 DP2

        Total:
	  IOP: 04 reads, 04 writes
	  BLK: 20 reads, 20 writes
	  XOR: 34 reads, 10 writes

The short stripe size means that one does not need to RMW in
many cases, just W; and this despite that much higher redundancy
of 2+1. it also means that there are lots of parity blocks to
compute and write. With a 4 block operation length a 3+1 or even
more a 4+1 would be flattered here, but I wanted to exemplify
two extremes.

The narrow parallelism thus short stripe length of 2+1 means
that a lot less blocks get transferred because of almost no RM,
but it does 9 IOPs and 13+1 does one less at 8 (wider
parallelism); but then the 2+1 IOPs are mostly in back-to-back
write pairs, while the 13+1 are in read-rewrite pairs, which is
a significant disadvantage (often greatly underestimated).

Never mind that the number of IOPs is almost the same despite
the large difference in width, and that can do with the same
disks as a 13+1 something like 4 2+1/3+1 arrays, thus gaining a
lot of parallelism across threads, if there is such to be
obtained. And if one really wants to write long stripes, one
should use RAID10 of course, not long stripes with a single (or
two) parity blocks.

In the above example the length of the transfer is not aligned
with either the 2+1 or 13+1 stripe length; if the starting block
is unaligned too, then things look worse for 2+1, but that is a
pathologically bad case (and at the same time a pathologically
good case for 13+1):

  2+1:
	00 01 P1|03 04 P2|06 07 P3|09 10 P4|12
           00   |01 02   |03 04   |05 06   |07
           ---**|------**|-- ---**|------**|--
        13 P5|15 16 P6|18 19 P7|21 22 P8
        08   |09 10   |11 12   |13 14
        ---**|------**|-- ---**|------**

	read  D01 DP1
	read  D06 DP3
	write D01 DP1
	write D03 D04 DP2
        write D06 DP3

	read  D07 DP3
	read  D12 DP5
	write D07 DP3
	write D09 D10 DP4
	write D12 DP5

	read  D13 DP5
	read  D18 DP7
	write D13 DP5
	write D15 D16 DP6
	write D18 DP7

	read  D19 DP7
	write D19 DP7
	write D15 D16 DP6

        Total:
	  IOP: 07 reads, 11 writes
	  BLK: 14 reads, 26 writes
	  XOR: 36 reads, 18 writes

 13+1:
	00 01 02 03 04 05 06 07 08 09 10 11 12 P1|
           00 01 02 03 04 05 06 07 08 09 10 11   |
           ----------- ----------- ----------- **|
	
        14 15 16 17 18 19 20 21 22 23 24 25 26 P2
	12 13 14
	--------                               **

	read  D01 D02 D03 D04 DP1
	write D01 D02 D03 D04 DP1

	read  D05 D06 D07 D08 DP1
	write D05 D06 D07 D08 DP1

	read  D09 D10 D11 D12 DP1
	write D09 D10 D11 D12 DP1

	read  D14 D15 D16 DP2
	write D14 D15 D16 DP2

	Total:
	  IOP: 04 reads, 04 writes
	  BLK: 18 reads, 18 writes
	  XOR: 38 reads, 08 writes

Here 2+1 does only a bit over twice as many IOPs as 13+1, even
if the latter has much wider potential parallelism, because the
latter cannot take advantage of that. However in both cases the
cost of RMW is large.

Never mind that finding the chances of putting in the IO request
stream a set of back-to-back logical writes to 13 contiguous
blocks aligned starting on a 13 block multiple are bound to be
lower than those of get a set of of 2 or 3 blocks, and even
worse with a filesystem mostly built for the wrong stripe
alignment.

>> * Unfortunately the frequency of unaligned writes *does*
>>   usually depend on how dementedly one got to the 13+1 or
>>   12+2 case: because a filesystem that lays out files so that
>>   misalignment is minimised with a 2+1 stripe just about
>>   guarantees that when one switches to a 3+1 stripe all
>>   previously written data is misaligned, and so on -- and
>>   never mind that every time one adds a disk a reshape is
>>   done that shuffles stuff around.

nagilum> One can usually do away with specifying 2*Chunksize.

Following the same logic to the extreme one can use a linear
concatenation to avoid the problem, where stripes are written
consecutively on each disk and then the following disk. This
avoids any problems with unaligned stripe writes :-).

In general large chunksizes are not such a brilliant idea, even
if ill-considered benchmarks may show some small advantage with
somewhat larger chunksizes.


My general conclusion is that reshapes are a risky, bad for
performance, expensive operation that is available, like RAID5
in general (and especially RAID5 above 2+1 or in a pinch 3+1)
only for special cases when one cannot do otherwise and knows
exactly what the downside is (which seems somewhat rare).

I think that defending the concept of growing a 2+1 into a 13+1
via as many as 11 successive reshapes is quite ridiculous, even
more so when using fatuous arguments about 1 or 2 byte updates.

It is even worse than coming up with that idea itself, which is
itself worse than that of building a 13+1 to start with.

But hey, lots of people know better -- do you feel lucky? :-)
