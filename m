From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH md 4 of 4] "Faulty" personality of md
Date: Wed, 3 Nov 2004 10:30:42 +1100
Message-ID: <16776.6306.381919.647984@cse.unsw.edu.au>
References: <20041102143440.12019.patches@notabene>
	<E1COpUP-000396-JF@notabene.cse.unsw.edu.au>
	<20041102093141.GH32712@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Lars Marowsky-Bree on Tuesday November 2
Sender: linux-raid-owner@vger.kernel.org
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: Andrew Morton <akpm@osdl.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday November 2, lmb@suse.de wrote:
> On 2004-11-02T14:37:45, NeilBrown <neilb@cse.unsw.edu.au> wrote:
> 
> > The 'faulty' personality provides a layer over any block device
> > in which errors may be synthesised.
> > 
> > A variety of errors are possible including transient and persistent
> > read and write errors, and read errors that persist until the next
> > write.
> > 
> > There error mode can be changed on a live array.
> 
> Duplicates functionality already present with the device-mapper error
> target, or functionality present with the (not yet merged) flakey dm
> target.

so this means you won't need to merge your "flakey" dm target??
(I couldn't find the "error' target after a quick look).

> 
> I think we should strive for convergence, not for more duplication.

Why? (genuine question)

And if we should, why does dm support raid1 and multipath?
(Actually I would be quite happy to discard the md/multipath code).

I'm somewhat ambivalent about convergence, but if you think is it a
good thing and want to work towards it, I'm open to co-operation.

However, that doesn't involve saying "We've already done that" with (I
think) an implication that what I had submitted therefore isn't
wanted.
Rather, it involves saying "how can we unite what we have" and making
some practical suggestions.

As I said, I'm open to suggestions, but it isn't something that I
particularly want to push.

NeilBrown
