From: Neil Brown <neilb@suse.de>
Subject: Re: raid6 check/repair
Date: Fri, 16 Nov 2007 15:26:18 +1100
Message-ID: <18237.7146.783687.826984@notabene.brown>
References: <m3wssjr0j9.fsf@unna.nsc.liu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Leif Nixon on Thursday November 15
Sender: linux-raid-owner@vger.kernel.org
To: Leif Nixon <nixon@nsc.liu.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday November 15, nixon@nsc.liu.se wrote:
> Hi,
> 
> I have been looking a bit at the check/repair functionality in the
> raid6 personality.
> 
> It seems that if an inconsistent stripe is found during repair, md
> does not try to determine which block is corrupt (using e.g. the
> method in section 4 of HPA's raid6 paper), but just recomputes the
> parity blocks - i.e. the same way as inconsistent raid5 stripes are
> handled.
> 
> Correct?

Correct!

The mostly likely cause of parity being incorrect is if a write to
data + P + Q was interrupted when one or two of those had been
written, but the other had not.

No matter which was or was not written, correctly P and Q will produce
a 'correct' result, and it is simple.  I really don't see any
justification for being more clever.


NeilBrown
