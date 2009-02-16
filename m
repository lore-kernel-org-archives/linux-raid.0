From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 00/18] Assorted md patches headed for 2.6.30
Date: Mon, 16 Feb 2009 16:35:52 +1100
Message-ID: <18840.64312.247580.780346@notabene.brown>
References: <20090212031009.23983.14496.stgit@notabene.brown>
	<20090212081148.GD9439@rap.rap.dk>
	<4993E82D.1020309@fairbairn-family.com>
	<20090212094604.GA11981@rap.rap.dk>
	<alpine.LRH.2.00.0902120003100.3470@taurus.cesta.com>
	<4995A5AE.8020301@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bill Davidsen on Friday February 13
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Julian Cowley <julian@lava.net>, =?ISO-8859-15?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday February 13, davidsen@tmr.com wrote:
> Julian Cowley wrote:
> And in this case locking the bard door after the horse has left is 
> probably a path of least confusion.
> 
> > Perhaps instead the documentation in mdadm(8) and md(4) could be 
> > updated to mention that raid10 is a combination of the concepts in 
> > RAID 1 and RAID 0, but is generalized enough so that it can be done 
> > with just two drives at a minimum.  That would have caught my eye, at 
> > least.
> 
> Good idea.

Patches gladly accepted.


> 
> Ob. plug for raid5E: the advantages of raid5E are two-fold. The most 
> obvious is that head motion is spread over N+2 drives (N being number of 
> data drives) which improves performance quite a bit in the common small 
> business case of 4-5 drive setups. It also puts some use on each drive, 
> so you don't suddenly start using a drive which may have been spun down 
> for a month, may have developed issues since SMART was last run, etc.
> 

Are you thinking of raid5e, where all the spare space is at the end of
the devices, or raid5ee where it is more evenly distributed?

So raid5e is just a normal raid5 where you don't use all of the space.
When a failure happens, you reshape to n-1 drives, thus absorbing the
space.

raid5ee is much like raid6, but you don't read or write the Q block.
If you lose a drive, you rebuild it in the space were the Q block
lives. 

So would you just use raid6 normally and transition to a contorted
raid5 on device failure?  Or would you really want to leave those
blocks fallow?

I guess I could implement that by using 8bits in the 'layout' number
to indicate which device in the array is 'failed', and run a reshape
pass that changes the layout, being careful not to re-write blocks
that hadn't changed....

Not impossible, but I would much rather someone else wrote (and
tested) the code while I watched...

> While the distributed spare idea could be extended to raid6 and raid10, 
> the mapping gets complex. Since Neil is currently adding code to allow 
> for orders other than sequential in raid6, being able to quickly deploy 
> the spare on a once-per-stripe basis might at least get him to rethink 
> the concept.

I think raid6e is trivial and raid6ee would be quite straight forward.

For raid10, if you used a far=3 layout but only use the first two
copies, you would effectively have raid10e.
If you used a near=3 layout but only used 2 copies, you would have
something like a raid10ee, but if you have 3 or 6 drives, all the
spare space would be on the 1 (or 2) device(s).



NeilBrown
