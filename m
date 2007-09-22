From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 2.6.23-rc7 0/3] async_tx and md-accel fixes for 2.6.23
Date: Sat, 22 Sep 2007 10:10:06 +1000
Message-ID: <18164.23902.732535.384492@notabene.brown>
References: <20070921012141.17157.65717.stgit@dwillia2-linux.ch.intel.com>
	<20070921114823.49d00263.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andrew Morton on Friday September 21
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, yur@emcraft.com, saeed.bishara@gmail.com, shannon.nelson@intel.com
List-Id: linux-raid.ids

On Friday September 21, akpm@linux-foundation.org wrote:
> On Thu, 20 Sep 2007 18:27:35 -0700
> Dan Williams <dan.j.williams@intel.com> wrote:
> 
> > Fix a couple bugs and provide documentation for the async_tx api.
> > 
> > Neil, please 'ack' patch #3.
> > 
> > git://lost.foo-projects.org/~dwillia2/git/iop async-tx-fixes-for-linus
> 
> Well it looks like Neil is on vacation or is hiding from us or something.

Neil is just not coping well with jet-lag....

Patch #3 looks good and necessary
  Acked-By: NeilBrown <neilb@suse.de>

I know that should probably be a "reviewed-by"....  I was a bit
surprised that the "handle_completed_read_requests" call was so early
in handle_stripe5 - I don't think the code was originally that early.
But it is probably right.   Hopefully my brain will have cleared by
Monday and I'll review it again then.

NeilBrown
