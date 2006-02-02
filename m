From: Neil Brown <neilb@suse.de>
Subject: Re: Crash and rebuild...
Date: Thu, 2 Feb 2006 13:40:20 +1100
Message-ID: <17377.28948.406585.25621@cse.unsw.edu.au>
References: <1138809957.2217.98.camel@fun-palace.bortnak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Neil Bortnak on Thursday February 2
Sender: linux-raid-owner@vger.kernel.org
To: Neil Bortnak <linux-raid@moro.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday February 2, linux-raid@moro.us wrote:
> 
> In any case, I have included the relevant dmesgs and a --examine and
> --detail for all drives as soon as the second (2.6.15.1) weird rebuild
> started. If you need any more info I'll do my best to provide it, but I
> thought I should at least report this.


Thanks for all the details.  I can see what is happening.

sdj1 (the failed drive) is claiming the same slot in the array as sdo1
(the spare drive that has been rebuilt), so sdo1 gets rejected.
sdj1 should be rejected before that because of the old 'event' count,
but the 'autorun' code isn't doing that check.

I'll see what I can do about fixing this.

Thanks again,
NeilBrown
