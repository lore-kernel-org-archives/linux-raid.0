From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Force parity resync on raid5?
Date: Wed, 11 Aug 2004 12:28:05 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16665.33845.170965.226004@cse.unsw.edu.au>
References: <4118B9A8.2040102@corp.texas.net>
	<16664.49686.253255.828936@cse.unsw.edu.au>
	<4118DBFA.6020607@corp.texas.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Philip Molter on Tuesday August 10
To: Philip Molter <philip@corp.texas.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday August 10, philip@corp.texas.net wrote:
> Neil Brown wrote:
> 
> > On Tuesday August 10, philip@corp.texas.net wrote:
> > 
> >>Linux RAID *has* to have sort of way to force a parity resync.  If it
> >>doesn't have one, it needs one.  That's a glaring omission to make.
> > 
> > Well, you get what you pay for.....
> 
> Tell me where to send the checks.  Seriously.  I know you guys work hard 
> on this stuff and I will gladly donate to the fund to have important (to 
> me) features implemented.

Hmmm. Awkward.
I'm not averse to doing a bit of contracting at times (taking un-paid
leave or similar from my day job), but having a fund that people can
donate to might be a bit more awkward...


> 
> > The easiest way to force a resync would be to re-create the array.
> > 
> >  - Note the exact order of the drives in the array, and the chunk size.
> >  - Stop the array.
> >  - Create the array with mdadm using --force.  That bit is important.
> 
> Do I need to note the parity algorithm, too?

Yes, though I strongly suspect the array was created with the default
parity algorithm, so it shouldn't make any difference.

> 
> >     mdadm --create /dev/mdX --level=5 --force --disks=whatever \
> >        --chunksize=64k  /dev/sda1 /dev/sdb1 .....
> > 
> >  Remember the --force.  If you don't have it, you will get a recovery
> >  cycle that rebuilds one drive against the others rather than a resync
> >  that checks and corrects parity.
> > 
> >  This will recreate the array (almost) exactly as it currently is, but
> >  it will not be marked 'clean', so a parity check-and-correct will
> >  happen.
> 
> Does this destroy the data on the array?  I seem to remember getting 
> this advice a while back when encountering a similar problem and seeing 
> my data go up in smoke.  I could easily have done something wrong, though.

No, it doesn't destroy the data - provided you have the configuration
exactly the same as before.  It will only update the superblocks and
correct all parity blocks.  Data blocks won't be changed.

However I have just release mdadm 1.7.0 which supports
   --assemble --update=resync

which will cause an array to resync immediately after being
assembling.  This don't help you for an array with a root filesystem
on it, but should do want you want for any other array.

NeilBrown
