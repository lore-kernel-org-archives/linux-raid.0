From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: [LSF/MM TOPIC] De-clustered RAID with MD
Date: Sat, 3 Feb 2018 17:16:19 +0000
Message-ID: <5A75EE63.8040606@youngman.org.uk>
References: <mqdvafkhep0.fsf@linux-x5ow.site>
 <5A6F4CA6.5060802@youngman.org.uk> <87fu6o5o83.fsf@notabene.neil.brown.name>
 <5A704C59.4000705@youngman.org.uk> <87372n613s.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <87372n613s.fsf@notabene.neil.brown.name>
Sender: linux-block-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, lsf-pc@lists.linux-foundation.org
Cc: linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

On 30/01/18 11:24, NeilBrown wrote:
> When Ax are a logical stripe and Bx are the next,  then you have a
> slightly better distribution.  If device XX fails then the reads needed
> for the first stripe mostly come from different drives than those for
> the second stripe, which are mostly different again for the 3rd stripe.

Having got myself thoroughly confused, I think I've got my head
straight. There's actually an incredibly simple algorithm for this, I think.

First of all, let's state that we're defining a new complex raid here,
people get confused between linux-raid-10 and raid-1+0, so ...

I was originally thinking about about raid-61, mirroring raid-6 across a
random number of drives. I think here we're actually talking about
raid-60 - doing a raid-6 across a random number of drives. Can we prefix
whatever raid level we call it with an "L" so it's not confused with
standard raid-6+0?

Okay. Let's say we have a five-disk raid-6 smeared across seven drives.
Let's call it Raid-L60. That gives us 35 blocks per disk stripe.

A1 A2 A3 A4 A5 B1 B2
B3 B4 B5 C1 C2 C3 C4
C5 D1 D2 D3 D4 D5 E1
E2 E3 E4 E5 F1 F2 F3
F4 F5 G1 G2 G3 G4 G5

That gives us a logical disk stripe 35 wide, that we just need to scramble.

Position * Prime mod Disks.

The problem, of course, is that this is going to scramble each logical
stripe the same. So as we've got 5 stripes, can we use a table of 5
different primes? The snag, of course, is that we mustn't use a prime
that is a factor of the number of disks, as this will blow up with a
vengeance. It makes sense also to avoid a prime that's a factor of the
logical disks, I suspect. So here, I'd use 2,3,11,13,17

I'd like to add the logical stripe number in rather than use multiple
primes, but I don't think that'll work ...

Cheers,
Wol
