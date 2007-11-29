From: Neil Brown <neilb@suse.de>
Subject: Re: raid6 check/repair
Date: Thu, 29 Nov 2007 17:04:20 +1100
Message-ID: <18254.22116.223033.435761@notabene.brown>
References: <474431BF.30103@ph.tum.de>
	<18244.64972.172685.796502@notabene.brown>
	<4745B375.4030500@ph.tum.de>
	<474BA644.60101@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bill Davidsen on Tuesday November 27
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: thiemo.nagel@ph.tum.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday November 27, davidsen@tmr.com wrote:
> Thiemo Nagel wrote:
> > Dear Neil,
> >
> > thank you very much for your detailed answer.
> >
> > Neil Brown wrote:
> >> While it is possible to use the RAID6 P+Q information to deduce which
> >> data block is wrong if it is known that either 0 or 1 datablocks is 
> >> wrong, it is *not* possible to deduce which block or blocks are wrong
> >> if it is possible that more than 1 data block is wrong.
> >
> > If I'm not mistaken, this is only partly correct.  Using P+Q redundancy,
> > it *is* possible, to distinguish three cases:
> > a) exactly zero bad blocks
> > b) exactly one bad block
> > c) more than one bad block
> >
> > Of course, it is only possible to recover from b), but one *can* tell,
> > whether the situation is a) or b) or c) and act accordingly.
> I was waiting for a response before saying "me too," but that's exactly 
> the case, there is a class of failures other than power failure or total 
> device failure which result in just the "one identifiable bad sector" 
> result. Given that the data needs to be read to realize that it is bad, 
> why not go the extra inch and fix it properly instead of redoing the p+q 
> which just makes the problem invisible rather than fixing it.
> 
> Obviously this is a subset of all the things which can go wrong, but I 
> suspect it's a sizable subset.

Why do think that it is a sizable subset.  Disk drives have internal
checksum which are designed to prevent corrupted data being returned.

If the data is getting corrupt on some buss between the CPU and the
media, then I suspect that your problem is big enough that RAID cannot
meaningfully solve it, and "New hardware plus possibly restore from
backup" would be the only credible option.

NeilBrown
