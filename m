From: Redeeman <redeeman@metanurb.dk>
Subject: Re: detection/correction of corruption with raid6
Date: Tue, 16 Dec 2008 07:33:36 +0100
Message-ID: <1229409216.22331.40.camel@localhost>
References: <1228510833.16555.76.camel@localhost>
	 <alpine.DEB.1.10.0812051602110.17806@p34.internal.lan>
	 <1228511195.16555.78.camel@localhost>
	 <alpine.DEB.1.10.0812051607100.17806@p34.internal.lan>
	 <1228511558.16555.84.camel@localhost>
	 <6c4602af0812051330o4220cbf1g8b969cd4b9843d3a@mail.gmail.com>
	 <1229095884.16555.144.camel@localhost>
	 <18759.4982.86181.792757@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18759.4982.86181.792757@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: =?iso-8859-2?Q?Micha=B3_Przy=B3uski?= <mikylie@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2008-12-16 at 13:33 +1100, Neil Brown wrote:
> On Friday December 12, redeeman@metanurb.dk wrote:
> > > 
> > > It is possible (by the theory of Q syndrome, per the article you
> > > linked) to detect which drive is doing a silent corruption with raid6
> > > (and with some extra assumption, that just one drive is doing that).
> > > But it's not implemented.
> > 
> > thats a shame, it seems like a KILLER feature, but i guess its not too
> > simple to do, or it would have been done already :)
> 
> The reason that it hasn't been done is not that it is difficult.
> Certainly it is not trivial, but more complicated things have been
> implemented.
> 
> The reason that it is not even on my TODO list is that I don't think
> it is justifiable.
> 
> As has been said elsewhere in this thread, silent corruption is rarely
> if ever caused by the storage device.  They tend to have strong CRCs
> etc which detect bit-flips with greater reliability than the RAID6
> algorithm would detect them.
> 
> If the silent corruption comes from anywhere else in the system, it is
> not clear what if anything should be done.
> e.g. if the corruption was due to bad memory, there is no behaviour
> that will reliably do the "right" thing.

I respectfully disagree. Consider this example(and please correct me if
my assumptions are wrong)

you have a raid1 setup, with 3 disks, or just for the example, say... 5
disks.

You then force a check, which detects that 4 disks have identical data,
while 1 disk differs. Chance would dictate, that the data is SOMEHOW
wrong on 1 disk, now, that may well be the fault of the pci bus, ram, or
anything, but in my mind, it is very reasonable to assume that the right
thing, is to duplicate the data which is identical on 4/5 disks, onto
the next disk.

I would also argue, that in the case of raid1, if you 2/5 disks had
identical data, and the remaining 3 had differing data, that it still
makes for the best choice to "restore" the data which is identical most
times, and certainly, i cannot see any reason why it would be a worse
thing to do, than just randomly selecting a dataset to "trust".

Granted, if these instances occurs, its something to be very concerned
about, and surely requires a human to figure out what is causing it, but
that still doesnt mean it shouldnt try to do all it can to keep the
users data intact.

As for raid6, as i understand it, you have the ability, with parity and
Q syndrome etc, to arrive at the final data in 3 ways, involving
different disks, this still allows it to be 2/3 versus 1/3 with correct
data, and i would still argue that its much more reasonable to conclude
that 1 disk SOMEHOW has wrong data, versus two disks having the SAME
wrong data.

I do however get your point, if the corruption is in the controller etc
that may actually occur, that 2 disks have same corruption, however, i
would still argue that in general, this scheme would be better on
average, and since its not possibly to know 100% what causes stuff, i'd
say this is the most logical and reasonable action to take.

Am i wrong?

> 
> In that case, the best that can be done is simply to log any error
> that is found and let some human figure it out.  That is part of the
> motivation for a monthly 'check'.
> 
> I like to think about raid in a similar way to thinking about security
> issues (after all, we are dealing with data security).
> 
> So before implementing any mechanism that might enhance security, I
> need to have a clear understanding of what the threat model is.  In
> this case, what is the source of corruption.
> Then I need a clear understanding on how the enhancement neutralises
> or logs the threat, and a credible explanation of why it won't increase
> the risk from some other threat.
> 
> If silent corruption is an issue for you then you really need to be
> doing checks at a much higher level than the md level.  A filesystem
> that does checksums on all blocks (e.g. btrfs), or an application that
> does them an all files (tripwire) are much more likely to be
> beneficial than trying to leverage a side-effect of raid6.
> 
> I have a similar attitude to 3-way raid1 and voting on the result.  I
> simply don't think it is the right solution.
> 
> NeilBrown
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

