From: Neil Brown <neilb@suse.de>
Subject: Re: limits on raid
Date: Sat, 16 Jun 2007 07:59:29 +1000
Message-ID: <18035.3009.568832.785308@notabene.brown>
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm>
	<18034.479.256870.600360@notabene.brown>
	<Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm>
	<18034.3676.477575.490448@notabene.brown>
	<467273AB.9010202@argo.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Avi Kivity on Friday June 15
Sender: linux-raid-owner@vger.kernel.org
To: Avi Kivity <avi@argo.co.il>
Cc: david@lang.hm, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday June 15, avi@argo.co.il wrote:
> Neil Brown wrote:
> >   
> >> while I consider zfs to be ~80% hype, one advantage it could have (but I 
> >> don't know if it has) is that since the filesystem an raid are integrated 
> >> into one layer they can optimize the case where files are being written 
> >> onto unallocated space and instead of reading blocks from disk to 
> >> calculate the parity they could just put zeros in the unallocated space, 
> >> potentially speeding up the system by reducing the amount of disk I/O.
> >>     
> >
> > Certainly.  But the raid doesn't need to be tightly integrated
> > into the filesystem to achieve this.  The filesystem need only know
> > the geometry of the RAID and when it comes to write, it tries to write
> > full stripes at a time.  If that means writing some extra blocks full
> > of zeros, it can try to do that.  This would require a little bit
> > better communication between filesystem and raid, but not much.  If
> > anyone has a filesystem that they want to be able to talk to raid
> > better, they need only ask...
> >   
> 
> Some things are not achievable with block-level raid.  For example, with
> redundancy integrated into the filesystem, you can have three copies for
> metadata, two copies for small files, and parity blocks for large files,
> effectively using different raid levels for different types of data on
> the same filesystem.

Absolutely.  And doing that is a very good idea quite independent of
underlying RAID.  Even ext2 stores multiple copies of the superblock.

Having the filesystem duplicate data, store checksums, and be able to
find a different copy if the first one it chose was bad is very
sensible and cannot be done by just putting the filesystem on RAID.

Having the filesystem keep multiple copies of each data block so that
when one drive dies, another block is used does not excite me quite so
much.  If you are going to do that, then you want to be able to
reconstruct the data that should be on a failed drive onto a new
drive.
For a RAID system, that reconstruction can go at the full speed of the
drive subsystem - but needs to copy every block, whether used or not.
For in-filesystem duplication, it is easy to imagine that being quite
slow and complex.  It would depend a lot on how you arrange data,
and maybe there is some clever approach to data layout that I haven't
thought of.  But I think that sort of thing is much easier to do in a
RAID layer below the filesystem.

Combining these thoughts, it would make a lot of sense for the
filesystem to be able to say to the block device "That blocks looks
wrong - can you find me another copy to try?".  That is an example of
the sort of closer integration between filesystem and RAID that would
make sense.

NeilBrown
