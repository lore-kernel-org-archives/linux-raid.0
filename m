From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [LSF/MM TOPIC] De-clustered RAID with MD
Date: Wed, 31 Jan 2018 11:58:34 +0100
Message-ID: <mqdy3kewazp.fsf@linux-x5ow.site>
References: <mqdvafkhep0.fsf@linux-x5ow.site>
        <5A6F4CA6.5060802@youngman.org.uk>
        <87fu6o5o83.fsf@notabene.neil.brown.name>
        <5A71933B.1050908@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <5A71933B.1050908@hesbynett.no> (David Brown's message of "Wed,
        31 Jan 2018 10:58:19 +0100")
Sender: linux-block-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: NeilBrown <neilb@suse.com>, Wols Lists <antlists@youngman.org.uk>, lsf-pc@lists.linux-foundation.org, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

David Brown <david.brown@hesbynett.no> writes:
> That sounds smart.  I don't see that you need anything particularly
> complicated for how you distribute your data and parity drives across
> the 100 disks - you just need a fairly even spread.

Exactly.

> I would be more concerned with how you could deal with resizing such an
> array.  In particular, I think it is not unlikely that someone with a
> 100 drive array will one day want to add another bank of 24 disks (or
> whatever fits in a cabinet).  Making that work nicely would, I believe,
> be more important than making sure the rebuild load distribution is
> balanced evenly across 99 drives.

I don't think rebuilding is such a big deal, lets consider the following
hypothetical scenario:

6 Disks with 4 data blocks (3 replicas per block, could be RAID1 like
duplicates or RAID5 like data + parity, doesn't matter at all for this
example)

D1  D2  D3  D4  D5  D6
[A] [B] [C] [ ] [ ] [ ]
[ ] [ ] [ ] [A] [D] [B] 
[ ] [A] [B] [ ] [C] [ ]
[C] [ ] [ ] [D] [ ] [D]

Now we're adding one disk and rebalance:

D1  D2  D3  D4  D5  D6  D7
[A] [B] [C] [ ] [ ] [ ] [A]
[ ] [ ] [ ] [ ] [D] [B] [ ]
[ ] [A] [B] [ ] [ ] [ ] [C]
[C] [ ] [ ] [D] [ ] [D] [ ]

This moved the "A" from D4 and the "C" from D5 to D7. The whole
rebalancing affected only 3 disks (read from D4 and D5 write to D7).

> I would also be interested in how the data and parities are distributed
> across cabinets and disk controllers.  When you manually build from
> smaller raid sets, you can ensure that in set the data disks and the
> parity are all in different cabinets - that way if an entire cabinet
> goes up in smoke, you have lost one drive from each set, and your data
> is still there.  With a pseudo random layout, you have lost that.  (I
> don't know how often entire cabinets of disks die, but I once lost both
> disks of a raid1 mirror when the disk controller card died.)

Well this is something CRSUH takes care of. As I said earlier it's a
weighted decision tree. One of the weights could be to evenly spread all
blocks across two cabinets.

Taking this into account would require a non-trivial user interface and
I'm not sure if the benefits of this outnumber the costs (at least for
an initial implementation).

Byte,
        Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
