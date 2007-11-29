From: Neil Brown <neilb@suse.de>
Subject: Re: raid6 check/repair
Date: Thu, 29 Nov 2007 17:01:33 +1100
Message-ID: <18254.21949.441607.134763@notabene.brown>
References: <474431BF.30103@ph.tum.de>
	<18244.64972.172685.796502@notabene.brown>
	<4745B375.4030500@ph.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Thiemo Nagel on Thursday November 22
Sender: linux-raid-owner@vger.kernel.org
To: thiemo.nagel@ph.tum.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday November 22, thiemo.nagel@ph.tum.de wrote:
> Dear Neil,
> 
> thank you very much for your detailed answer.
> 
> Neil Brown wrote:
> > While it is possible to use the RAID6 P+Q information to deduce which
> > data block is wrong if it is known that either 0 or 1 datablocks is 
> > wrong, it is *not* possible to deduce which block or blocks are wrong
> > if it is possible that more than 1 data block is wrong.
> 
> If I'm not mistaken, this is only partly correct.  Using P+Q redundancy,
> it *is* possible, to distinguish three cases:
> a) exactly zero bad blocks
> b) exactly one bad block
> c) more than one bad block
> 
> Of course, it is only possible to recover from b), but one *can* tell,
> whether the situation is a) or b) or c) and act accordingly.

It would seem that either you or Peter Anvin is mistaken.

On page 9 of 
  http://www.kernel.org/pub/linux/kernel/people/hpa/raid6.pdf
at the end of section 4 it says:

      Finally, as a word of caution it should be noted that RAID-6 by
      itself cannot even detect, never mind recover from, dual-disk
      corruption. If two disks are corrupt in the same byte positions,
      the above algorithm will in general introduce additional data
      corruption by corrupting a third drive.

> 
> The point that I'm trying to make is, that there does exist a specific
> case, in which recovery is possible, and that implementing recovery for
> that case will not hurt in any way.

Assuming that it true (maybe hpa got it wrong) what specific
conditions would lead to one drive having corrupt data, and would
correcting it on an occasional 'repair' pass be an appropriate
response?

Does the value justify the cost of extra code complexity?

> 
> > RAID is not designed to protect again bad RAM, bad cables, chipset 
> > bugs drivers bugs etc.  It is only designed to protect against drive 
> > failure, where the drive failure is apparent.  i.e. a read must 
> > return either the same data that was last written, or a failure 
> > indication. Anything else is beyond the design parameters for RAID.
> 
> I'm taking a more pragmatic approach here.  In my opinion, RAID should
> "just protect my data", against drive failure, yes, of course, but if it
> can help me in case of occasional data corruption, I'd happily take
> that, too, especially if it doesn't cost extra... ;-)

Everything costs extra.  Code uses bytes of memory, requires
maintenance, and possibly introduced new bugs.  I'm not convinced the
failure mode that you are considering actually happens with a
meaningful frequency.

NeilBrown

