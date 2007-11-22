From: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Subject: Re: raid6 check/repair
Date: Thu, 22 Nov 2007 17:51:01 +0100
Message-ID: <4745B375.4030500@ph.tum.de>
References: <474431BF.30103@ph.tum.de> <18244.64972.172685.796502@notabene.brown>
Reply-To: thiemo.nagel@ph.tum.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18244.64972.172685.796502@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Neil,

thank you very much for your detailed answer.

Neil Brown wrote:
> While it is possible to use the RAID6 P+Q information to deduce which
> data block is wrong if it is known that either 0 or 1 datablocks is 
> wrong, it is *not* possible to deduce which block or blocks are wrong
> if it is possible that more than 1 data block is wrong.

If I'm not mistaken, this is only partly correct.  Using P+Q redundancy,
it *is* possible, to distinguish three cases:
a) exactly zero bad blocks
b) exactly one bad block
c) more than one bad block

Of course, it is only possible to recover from b), but one *can* tell,
whether the situation is a) or b) or c) and act accordingly.

> As it is quite possible for a write to be aborted in the middle 
> (during unexpected power down) with an unknown number of blocks in a 
> given stripe updated but others not, we do not know how many blocks 
> might be "wrong" so we cannot try to recover some wrong block.

As already mentioned, in my opinion, one can distinguish between 0, 1
and >1 bad blocks, and that is sufficient.

> Doing so would quite possibly corrupt a block that is not wrong.

I don't think additional corruption could be introduced, since recovery
would only be done for the case of exactly one bad block.

> 
> [...]
> 
> As I said above - there is no solution that works in all cases.

I fully agree.  When more than one block is corrupted, and you don't 
know which are the corrupted blocks, you're lost.

> If more that one block is corrupt, and you don't know which ones, 
> then you lose and there is now way around that.

Sure.

The point that I'm trying to make is, that there does exist a specific
case, in which recovery is possible, and that implementing recovery for
that case will not hurt in any way.

> RAID is not designed to protect again bad RAM, bad cables, chipset 
> bugs drivers bugs etc.  It is only designed to protect against drive 
> failure, where the drive failure is apparent.  i.e. a read must 
> return either the same data that was last written, or a failure 
> indication. Anything else is beyond the design parameters for RAID.

I'm taking a more pragmatic approach here.  In my opinion, RAID should
"just protect my data", against drive failure, yes, of course, but if it
can help me in case of occasional data corruption, I'd happily take
that, too, especially if it doesn't cost extra... ;-)

Kind regards,

Thiemo

