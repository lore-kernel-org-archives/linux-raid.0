From: NeilBrown <neilb@suse.de>
Subject: Re: RAID6 r-m-w, op-journaled fs, SSDs
Date: Mon, 2 May 2011 08:01:31 +1000
Message-ID: <20110502080131.02461482@notabene.brown>
References: <19900.10868.583555.849181@tree.ty.sabi.co.UK>
	<20110501082717.5116e575@notabene.brown>
	<ipjtup$47u$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ipjtup$47u$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 01 May 2011 17:24:09 +0200 David Brown <david.brown@hesbynett.no>
wrote:

> On 01/05/11 00:27, NeilBrown wrote:
> > On Sat, 30 Apr 2011 16:27:48 +0100 pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
> > wrote:
> >

> >>    * Can Linux MD do "abbreviated" read-modify-write RAID6
> >>      updates like for RAID5? That is where not the whole stripe
> >>      is read in, modified and written, but just the block to be
> >>      updated and the parity wblocks.
> >
> > No.  (patches welcome).
> 
> As far as I understand the raid6 mathematics, it shouldn't be too hard 
> to do such abbreviated updates, but that it could quickly lead to 
> complex code if you are trying to update more than a couple of blocks at 
> a time.

The RAID5 code already handle some of this complexity.

It would be quite easy to modify the code so that we have
 - list of 'old' data blocks
 - P and Q blocks
 - list of 'new' data blocks.

We then just need to (optimised) maths to deduce the new P and Q given all
of that.
Of course you would only bother with a 7-or-more disk array..

NeilBrown

