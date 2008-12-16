From: Neil Brown <neilb@suse.de>
Subject: Re: detection/correction of corruption with raid6
Date: Tue, 16 Dec 2008 13:33:26 +1100
Message-ID: <18759.4982.86181.792757@notabene.brown>
References: <1228510833.16555.76.camel@localhost>
	<alpine.DEB.1.10.0812051602110.17806@p34.internal.lan>
	<1228511195.16555.78.camel@localhost>
	<alpine.DEB.1.10.0812051607100.17806@p34.internal.lan>
	<1228511558.16555.84.camel@localhost>
	<6c4602af0812051330o4220cbf1g8b969cd4b9843d3a@mail.gmail.com>
	<1229095884.16555.144.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Redeeman on Friday December 12
Sender: linux-raid-owner@vger.kernel.org
To: Redeeman <redeeman@metanurb.dk>
Cc: =?iso-8859-2?Q?Micha=B3_Przy=B3uski?= <mikylie@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday December 12, redeeman@metanurb.dk wrote:
> > 
> > It is possible (by the theory of Q syndrome, per the article you
> > linked) to detect which drive is doing a silent corruption with raid6
> > (and with some extra assumption, that just one drive is doing that).
> > But it's not implemented.
> 
> thats a shame, it seems like a KILLER feature, but i guess its not too
> simple to do, or it would have been done already :)

The reason that it hasn't been done is not that it is difficult.
Certainly it is not trivial, but more complicated things have been
implemented.

The reason that it is not even on my TODO list is that I don't think
it is justifiable.

As has been said elsewhere in this thread, silent corruption is rarely
if ever caused by the storage device.  They tend to have strong CRCs
etc which detect bit-flips with greater reliability than the RAID6
algorithm would detect them.

If the silent corruption comes from anywhere else in the system, it is
not clear what if anything should be done.
e.g. if the corruption was due to bad memory, there is no behaviour
that will reliably do the "right" thing.

In that case, the best that can be done is simply to log any error
that is found and let some human figure it out.  That is part of the
motivation for a monthly 'check'.

I like to think about raid in a similar way to thinking about security
issues (after all, we are dealing with data security).

So before implementing any mechanism that might enhance security, I
need to have a clear understanding of what the threat model is.  In
this case, what is the source of corruption.
Then I need a clear understanding on how the enhancement neutralises
or logs the threat, and a credible explanation of why it won't increase
the risk from some other threat.

If silent corruption is an issue for you then you really need to be
doing checks at a much higher level than the md level.  A filesystem
that does checksums on all blocks (e.g. btrfs), or an application that
does them an all files (tripwire) are much more likely to be
beneficial than trying to leverage a side-effect of raid6.

I have a similar attitude to 3-way raid1 and voting on the result.  I
simply don't think it is the right solution.

NeilBrown
