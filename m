From: "Peter T. Breuer" <ptb@inv.it.uc3m.es>
Subject: Re: remark and RFC
Date: Wed, 16 Aug 2006 18:10:57 +0200 (MET DST)
Message-ID: <200608161610.k7GGAvu17532@inv.it.uc3m.es>
References: <62b0912f0608160759u37879015hec81eaaf8439e68d@mail.gmail.com>
Reply-To: ptb@inv.it.uc3m.es
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <62b0912f0608160759u37879015hec81eaaf8439e68d@mail.gmail.com> from
 "Molle Bestefich" at "Aug 16, 2006 04:59:53 pm"
Sender: linux-raid-owner@vger.kernel.org
To: Molle Bestefich <molle.bestefich@gmail.com>
Cc: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

"Also sprach Molle Bestefich:"
> Peter T. Breuer wrote:
> > I would like raid request retries to be done with exponential
> > delays, so that we get a chance to overcome network brownouts.
> 
> Hmm, I don't think MD even does retries of requests.

I had a "robust read" patch in FR1, and I thought Neil extended that to
"robust write".  In robust read, we try to make up for a failed read
with info from elsewhere, and then we rewrite the inferred data onto the
failed device, in an attempt to fix a possible defect.  In robust write,
a failed write is retried.  But robust read is enough to cause a retry
(as a write).

> It does write-back as a (very successful! Thanks Neil :-D) attempt to
> fix bad blocks, but that's a different thing.

Apparently not different :).

> Is that what you meant?

Plozzziby.

> Or is there something sandwiched between MD and ENBD that performs retries...

Could be too. Dunno.

Peter
