From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH-stable16] Fix a potential NULL dereference in md/raid1
Date: Mon, 21 Aug 2006 10:07:12 +1000
Message-ID: <17640.63792.278940.578508@cse.unsw.edu.au>
References: <20060821094833.21982.patches@notabene>
	<1060820235013.22016@suse.de>
	<20060821000109.GA11651@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Adrian Bunk on Monday August 21
Sender: linux-raid-owner@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday August 21, bunk@stusta.de wrote:
> On Mon, Aug 21, 2006 at 09:50:13AM +1000, NeilBrown wrote:
> 
> > patch for 2.6.16 stable series
> >...
> 
> Thanks for this patch.
> 
> It does also apply against both 2.6.17.9 and Linus' tree.
> 
> Is it not required in these trees, or are you also submitting it there?

I've just sent a patch to stable@kernel.org for 2.6.17.9. (it is the
same patch with slightly different line numbers).

The patch for -linus is quite different and will follow shortly (with
a few other patches).

Thanks,
NeilBrown
