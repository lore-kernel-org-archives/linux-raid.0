From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Creating partitionable raid on existing disk (was: Re: Partitioned raid and major number)
Date: Wed, 10 Mar 2004 13:41:53 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16462.32881.567684.761787@notabene.cse.unsw.edu.au>
References: <20040225145624.GA1513@cistron.nl>
	<16445.12026.812778.621025@notabene.cse.unsw.edu.au>
	<20040226215144.GC11831@drinkel.cistron.nl>
	<16446.36226.591283.495194@notabene.cse.unsw.edu.au>
	<16446.39583.968782.41221@notabene.cse.unsw.edu.au>
	<20040227165614.GO23988@traveler.cistron.net>
	<16450.32963.829675.526061@notabene.cse.unsw.edu.au>
	<20040301004256.GI14194@drinkel.cistron.nl>
	<16450.36145.988988.684449@notabene.cse.unsw.edu.au>
	<20040309153223.GI3084@traveler.cistron.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Miquel van Smoorenburg on Tuesday March 9
To: Miquel van Smoorenburg <miquels@cistron.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday March 9, miquels@cistron.nl wrote:
> On 2004.03.01 02:09, Neil Brown wrote:
> > On Monday March 1, miquels@cistron.nl wrote:
> > > 
> > > What do you think of that approach ? Converting from a 1 disk setup
> > > to a 2-disk RAID1 setup on an existing system is something that lots
> > > of people want to do, seeing that the software raid howto even has
> > > a few paragraphs dedicated to it.
> > 
> > What I am thinking of doing is allowing:
> > 
> >    md=0,1,/dev/sda
> > 
> > to assemble a raid1 array without a superblock which uses just
> > /dev/sda.
...
> 
> Any progress on this?

No, not yet.

> 
> The right thing to do would probably be to check if the device actually has
> partitions - refuse to reduce the size of the device if it doesn't have
> any partitions, or if any partition overlaps with the MD superblock.
> That should be easy enough I think.

Certainly do-able.  But I'm not sure it is completely correct.
Suppose the device isn't partitioned, and has a single filesystem on
it, which is smaller then the whole.  Why not shrink it then?

I really want some general interface to find out how much of a drive
is in-use.  Maybe if "bd_claim" to a parameter which said how much was
being claimed.....

Or maybe claimants should reducde i_size of the block device.  

> 
> But it would take changes in both userlevel tools (add --grow to mdadm) and
> the kernel, right ? So in the short run, I'll be better off by booting a
> Knoppix CD and running mdadm from there, I suppose.

Yes, there is a bit of work to be done before you can use this
approach.

> 
> Are you interested in the patch I made to be able to initialize (but not run!)
> an array on a disk that is otherwise busy (i.e. can't be bd_claim()ed) ?
> Basically it just adds a SET_ARRAY_INFO_CONFONLY ioctl. I have patches for
> both the kernel and mkraid, and they're pretty simple.

Not really.  If it just writes out a superblock, then it can be done
entirely in user-space - no kernel patch should be needed.

NeilBrown
