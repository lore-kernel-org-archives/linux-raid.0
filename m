From: Pallai Roland <dap@mail.index.hu>
Subject: Re: [PATCH] proactive raid5 disk replacement for 2.6.11, updated
Date: Thu, 18 Aug 2005 16:13:03 +0200
Message-ID: <1124374384.21362.114.camel@localhost.localdomain>
References: <1124322731.3810.77.camel@localhost.localdomain>
	 <17156.7305.638579.812295@cse.unsw.edu.au>
	 <20050818102458.GJ13344@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050818102458.GJ13344@marowsky-bree.de>
Sender: linux-raid-owner@vger.kernel.org
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Thu, 2005-08-18 at 12:24 +0200, Lars Marowsky-Bree wrote:
> On 2005-08-18T15:28:41, Neil Brown <neilb@cse.unsw.edu.au> wrote:
> > To handle read failures, I would like the first step to be to re-write
> > the failed block.  I believe most (all?) drives will relocate the
> > block if a write cannot succeed at the normal location, so this will
> > often fix the problem.  
> 
> Yes. This would be highly useful.
 yes, but I'm not sure that should be handled immediately, see my
previous mail

> > This possible doesn't handle the possibility of a write failing very
> > well, but I'm not sure what your approach does in that case.  Could
> > you explain that?
> 
> I think a failed write can't really be handled - it might be retried
> once or twice, but then the way to proceed is to kick the drive and
> rebuild the array.
 I'm not sure that's a fatal error if that sector isn't readable too.
badblock tolerance comes to play there..

> > It also means that if the raid1 rebuild hits a read-error it cannot
> > cope whereas your code would just reconstruct the block from the rest
> > of the raid5.
> 
> Good point. One way to fix this would be to have a callback to one level
> up "Hi, I can't read this section, can you reconstruct and give it to
> me?". (Which is a pretty ugly hack.)
 I think it's simpler, just issue a generic read request to the parent,
special callback isn't needed

> However, that would also assume that the data on the disk which _can_ be
> read still can be trusted. I'm not sure I'd buy that myself, untrusted.
> But a periodic background consistency check for RAID might help convince
> users that this is indeed the case ;-)
> If you can no longer pro-actively reconstruct the disk because it has
> indeed failed, maybe treating it like a failed disk and rebuilding the
> array in the "classic" fashion isn't the worst idea, though.
 yes, the chance for that will have been forever of course


-- 
 dap

