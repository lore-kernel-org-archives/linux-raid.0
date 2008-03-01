From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: 2x6 or 3x4 raid10 arrays ?
Date: Sat, 1 Mar 2008 21:40:20 +0100
Message-ID: <20080301204020.GC10278@rap.rap.dk>
References: <1204195554.16924.16.camel@franck-gusty> <loom.20080228T223023-79@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <loom.20080228T223023-79@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Nat Makarevitch <nat@makarevitch.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Feb 28, 2008 at 10:36:22PM +0000, Nat Makarevitch wrote:
> Franck Routier <franck.routier <at> axege.com> writes:
> 
> > database (postgresql) server.
> 
> AFAIK if the average size of an I/O operation as long as the corresponding
> variance are low... go for a single RAID10,f2 with a stripe size slightly
> superior to this average. This way you will have most requests mobilizing only a
> single spindle and all your spindles acting in parallel. If this average size
> varies upon tables one may create a RAID (with the adequate stripe size) per
> database partition.

I believe that a full chunk is read for each read access.
Or, at least, if one operation can be done within one chunk,
not more than that chunk is operated upon.

And chunks are recommended to be between 256 kiB and 1 MiB.
Most random database reads are much smaller than 256 kiB.
So the probability that one random read can be done with just one 
seek + read operation is very high, as far as I understand it.

This would lead to that it is not important whether to use 
two arrays of 6 disks each, or 3 arrays of 4 disks each. 
Or for that sake 1 array of 12 disks.

Some other factors may be more important: such as the ability to survive
disk crashes. raid10,f2 is good for surviving 1 disk crash. If you have
3 raids of 4 disks, it can survive a disk crash in each of these raids.
Furthermore some combinations of crashes of 2 disks within a raid can
also be survived. There are 16 combinations of failing disksi, with 0 to
4 disks failing:

   0000 Y  0001 Y 0010 Y  0011 N 0100 Y 0101 N 0110 Y 0111 N
   1000 Y  1001 Y 1010 N  1011 N 1100 N 1101 N 1110 N 1111 N

So if 2 disks fails, then in 2 out of 6 cases this would be ok,
given a succes rates of 1.33 for surviving one or two disk crashes.
For 3 raid sets of 4 drives each, this should be able to survive 4
(3 * 1.33) disks malfunctioning on average, while it is only guaranteed
to survive 1 bad disk.

With more disks in the array, more combinations would be possible to
survive. I do not have a formula for it, but surely it should exist.
Maybe arrays with an odd number of drives would have better chances of
surviving, given that in the 4-drive example a number of combinations
of failing drives were fatal because all even chunks were distributed on
disks 1 and 3, while odd chunks were on disks 2 and 4). 
I would like to know if somebody could come up with a
formula, and what results one would get for  a 2 x 6 disk array, and 1 x
12 disks array. 

Another more important item could be speed: especially for average seek
times. More disks in an array would for raid10,f2 reduce the max and
average seek times as searching on each disks would be reduced in time,
for n disks in a raid only 1/n of each disk will be used for reading. 
   

Best regards
keld
