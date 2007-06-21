From: David Chinner <dgc@sgi.com>
Subject: Re: limits on raid
Date: Thu, 21 Jun 2007 16:39:36 +1000
Message-ID: <20070621063936.GT85884050@sgi.com>
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm> <18034.479.256870.600360@notabene.brown> <Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm> <18034.3676.477575.490448@notabene.brown> <467273AB.9010202@argo.co.il> <18035.3009.568832.785308@notabene.brown> <20070618045759.GD85884050@sgi.com> <18041.59628.370832.633244@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18041.59628.370832.633244@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: David Chinner <dgc@sgi.com>, Avi Kivity <avi@argo.co.il>, david@lang.hm, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jun 21, 2007 at 12:56:44PM +1000, Neil Brown wrote:
> On Monday June 18, dgc@sgi.com wrote:
> > On Sat, Jun 16, 2007 at 07:59:29AM +1000, Neil Brown wrote:
> > > Combining these thoughts, it would make a lot of sense for the
> > > filesystem to be able to say to the block device "That blocks looks
> > > wrong - can you find me another copy to try?".  That is an example of
> > > the sort of closer integration between filesystem and RAID that would
> > > make sense.
> > 
> > I think that this would only be useful on devices that store
> > discrete copies of the blocks on different devices i.e. mirrors. If
> > it's an XOR based RAID, you don't have another copy you can
> > retreive....
> 
> You could reconstruct the block in question from all the other blocks
> (including parity) and see if that differs from the data block read
> from disk...  For RAID6, there would be a number of different ways to
> calculate alternate blocks.   Not convinced that it is actually
> something we want to do, but it is a possibility.

Agreed - it's not as straight forward as a mirror, and it kind of assumes
that you have software RAID.

/me had his head stuck in hw raid land ;)

> I have that - apparently naive - idea that drives use strong checksum,
> and will never return bad data, only good data or an error.  If this
> isn't right, then it would really help to understand what the cause of
> other failures are before working out how to handle them....

The drive is not the only source of errors, though.  You could
have a path problem that is corrupting random bits between the drive
and the filesystem. So the data on the disk might be fine, and
reading it via a redundant path might be all that is needed.

Yeah, so I can see how having a different retry semantic would be a
good idea. i.e. if we do a READ_VERIFY I/O, the underlying device
attempts to verify the data is good in as many ways as possible
before returning the verified data or an error.

I guess a filesystem read would become something like this:

	verified = 0
	error = read(block)
	if (error) {
read_verify:
		error = read_verify(block)
		if (error) {
			OMG THE SKY IS FALLING
			return error
		}
		verified = 1
	}
	/* check contents */
	if (contents are bad) {
		if (!verified)
			goto read_verify
		OMG THE SKY HAS FALLEN
		return -EIO
	}

Is this the sort of erro handling and re-issuing of
I/O that you had in mind?

FWIW, I don't think this really removes the need for a filesystem to
be able to keep multiple copies of stuff about. If the copy(s) on a
device are gone, you've still got to have another copy somewhere
else to get it back...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
