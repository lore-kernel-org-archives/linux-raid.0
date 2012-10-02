From: Brian Candler <B.Candler@pobox.com>
Subject: Re: RAID6 rebuild stuck
Date: Tue, 2 Oct 2012 16:56:33 +0100
Message-ID: <20121002155633.GC30589@nsrc.org>
References: <20121001112946.GB27455@nsrc.org>
 <20121002155642.606b2108@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121002155642.606b2108@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Oct 02, 2012 at 03:56:42PM +1000, NeilBrown wrote:
> Lesson: always do a read test as well as a write test!

And there was me thinking that drives read back data after writing it -
clearly they do not :-)

> Looks like a bug. md_do_sync() is still waiting for all the submitted sync
> requests to complete.  This suggests some sort of accounting problem, but I
> cannot easily see it.
> 
> A reboot is likely to be the only fix.

Thank you. We'll take it out of service and upgrade to 12.04 at the same
time.

Cheers,

Brian.
