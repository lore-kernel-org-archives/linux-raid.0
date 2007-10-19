From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm 2.6.x regression, fails creation of raid1 w/ v1.0 sb and
 internal bitmap
Date: Fri, 19 Oct 2007 12:41:41 +1000
Message-ID: <18200.6501.186871.539817@notabene.brown>
References: <170fa0d20710170837g1b0cd549w3b7fe8e663a01b7e@mail.gmail.com>
	<4716769E.5030508@tmr.com>
	<170fa0d20710171421l4ff62ebdwdef307e71a2ad30d@mail.gmail.com>
	<471754D8.2060909@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bill Davidsen on Thursday October 18
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Mike Snitzer <snitzer@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday October 18, davidsen@tmr.com wrote:
> 
> Unless there's a substantial benefit from using the 1.0 format, you 
> might want to go with something which works. 

I am every grateful to the many people who do not just find work
arounds, but report problems and persist until they get fixed.

Obviously everyone should choose the path that suits them best, but
I'd rather we didn't discourage people who are working to get a bug
fixed. 

>                                               I would suggest using 
> --bitmap-chunk, but the man page claims it doesn't apply to internal 
> bitmaps. It also claims the bitmap size is chosen automatically to best 
> use available space, but "doesn't work" seems an exception to "best 
> use." ;-)

In this case, it does work, and it is best use.  It just appears that
the 'available space' is not truly available - read error.

NeilBrown
