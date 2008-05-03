From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: Sharing disks amoung multiple software RAIDs
Date: Sat, 3 May 2008 12:13:02 +0200
Message-ID: <20080503101302.GB10819@rap.rap.dk>
References: <A20315AE59B5C34585629E258D76A97C335960@34093-C3-EVS3.exchange.rackspace.com> <824925.21830.qm@web50201.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <824925.21830.qm@web50201.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alex Davis <alex14641@yahoo.com>
Cc: Kasper Sandberg <lkml@metanurb.dk>, David Greaves <david@dgreaves.com>, David Lethe <david@santools.com>, David Rees <drees76@gmail.com>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Fri, May 02, 2008 at 05:44:18PM -0700, Alex Davis wrote:
> 
> 
> I code, therefore I am
> 
> 
> --- On Fri, 5/2/08, David Lethe <david@santools.com> wrote:
> [snipped]
> > I was being too literal. md is a good solution (I use it
> > myself).  However, the OP wanted to "Make sure that if
> > one disk dies, the data is still in tact".  
> I was also concerned about performance. It seems that if the RAIDs will 
> be used heavily and independent of each other, and performance is a 
> concern, then dedicated disks (and possibly dedicated controllers)
> are the better option.

My understanding of having multiple, possibly differnet types of RAID
partitions say on two drives, are that performance-wise this are the
same considerations as for a single drive. You can worry about head
movement and seek times and transfer rates, but the problems are the
same for raid and non-raid. IMHO architecturally multiple RAIDs on same disks
do not introduce additional performance issues compared with single disk
solutions, nor with one-raid-per-set-of-drives solutions.

The above statement on having separate disks per raid is more or less the
same as saying that the more disks you have, the better.

If performance is an issue, then I am recommending my pet
raid10,f2 layout, which has a 30 - 80 % increased performance over
traditional RAID1, because it uses only the outer faster tracks on the
disk, and it has reduced seek time only searching on half of the disk
(and this the again the outer part, so that the head movement is reduced
to about 1/3). 

Best regards
keld
