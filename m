From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [RFCI] How best to partition MD/raid devices in 2.6
Date: Fri, 14 Nov 2003 16:30:42 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16308.26754.867801.131463@notabene.cse.unsw.edu.au>
References: <16308.18387.142415.469027@notabene.cse.unsw.edu.au>
	<1068787304.4157.8.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Daniel Gryniewicz on Friday November 14
To: Daniel Gryniewicz <dang@fprintf.net>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday November 14, dang@fprintf.net wrote:
> On Thu, 2003-11-13 at 22:11, Neil Brown wrote:
> > RFCI == Request For Clever Ideas.
> > 
> > Hi all..
> > 
> >  I want be able to partition "md" raid arrays.
> >  e.g. I want to be able to use RAID1 to mirror sda and sdb as whole
> >  drives, and then partitions that into root, swap, other (or whatever
> >  suits the particular situation).
> 
> <snip>
> 
> Can't LVM do this?  I have a raid array (mirror) that is LVM'd into
> multiple partitions.  It currently runs 2.4, but it should work fine
> with 2.6, right?  All the rest of my boxes have 2.6 and LVM, but no raid
> (no duplicate hard drives).

Fair question.
I want it to work with "standard" partition tables such as MSDOS
partitions etc.
I would like to be able to take a single drive that is being used and
has partitions on it, and to add an identical drive beside it, mirror
them, and get a mirrored pair that looked much like the original
drive.
There are issues with the raid superblock but assuming they can be
solved, I want partitioning to work easily.

Can LVM work happily with 'legacy' partitioning information?

NeilBrown
