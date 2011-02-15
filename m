From: Andras Korn <korn@raidlist.elan.rulez.org>
Subject: Re: write-behind has no measurable effect?
Date: Tue, 15 Feb 2011 03:19:00 +0100
Message-ID: <20110215021900.GB13135@hellgate.intra.guy>
References: <20110214213817.GG836@hellgate.intra.guy>
 <20110215095042.51ef7e0a@notabene.brown>
 <20110214225754.GK19990@hellgate.intra.guy>
 <20110215104109.06b12b33@notabene.brown>
 <20110215010052.GA13135@hellgate.intra.guy>
 <4D59D4A5.9050106@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D59D4A5.9050106@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Feb 15, 2011 at 01:19:33AM +0000, John Robinson wrote:

> >Another approach to take would be to mark as dirty, on the fast devices, all
> >areas being written to, and in the background continuously synch them to the
> >slow devices, sequentially (marking as clean synched-and-as-yet-unwritten-to
> >areas); so that the array would be resyncing continually, but be very fast
> >for random writes. This would of course also require the bitmap to only be
> >synchronously updated on the fast devices.
> >
> >Otoh, this is really a different mechanism from the current write-behind,
> >aimed at a different use-case, so maybe it could be implemented
> >orthogonally. (Patches welcome, I'm sure; it's times like these I hate not
> >being a coder.)
> 
> I wonder whether bcache might do roughly what you want? I haven't

It only does very roughly what I want (the idea there is to _cache_ a much
larger spinning disk using a relatively small SSD, whereas I basically want
them both to be the same size, with the disk eventually mirroring the
contents of the SSD); also, development of bcache has stalled (it doesn't
even compile with recent kernels and the developer has stated that he's
taking a break).

I also know of flashcache, which is similar to bcache and is more actively
developed, but is still lagging quite a few versions behind (the latest
kernel it works with is 2.6.32, I think; it certainly doesn't compile with
2.6.38).

So, while both of these may actually be good at what they do, neither of
them does what I have in mind and I also can't use either of them because I
need a newer kernel than what they support.

But thanks anyway.

-- 
                     Andras Korn <korn at elan.rulez.org>
                 I'm not nearly as think as you confused I am.
