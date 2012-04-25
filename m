From: Brian Candler <B.Candler@pobox.com>
Subject: Re: RAID6 fails to assemble after unclean shutdown
Date: Wed, 25 Apr 2012 12:16:06 +0100
Message-ID: <20120425111606.GA10101@nsrc.org>
References: <20120425103536.GA9978@nsrc.org>
 <20120425210145.73b1e51b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120425210145.73b1e51b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Apr 25, 2012 at 09:01:45PM +1000, NeilBrown wrote:
> Presumably something when wrong during shutdown.  However without more
> details (--examine) I cannot guess.

OK, thank you.

I've also found
https://raid.wiki.kernel.org/articles/r/a/i/RAID_Recovery_d376.html
which shows the --examine option too.

When building the array, would you suggest I also specify --bitmap=internal,
so that there is less data to resync after an error?

Regards,

Brian.
