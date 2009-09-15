From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH v2 7/9] md/raid6: asynchronous handle_stripe6
Date: Tue, 15 Sep 2009 15:26:16 +1000
Message-ID: <19119.9592.91030.892183@notabene.brown>
References: <20090831163914.1696.55782.stgit@dwillia2-linux.ch.intel.com>
	<20090831164139.1696.24706.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Monday August 31
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, Ilya Yanok <yanok@emcraft.com>, Yuri Tikhonov <yur@emcraft.com>
List-Id: linux-raid.ids


Sorry for the long delay in getting to these.  I week's leave recently
and that always causes tasks to pile up....

I am happy for this to  all go in this merge window.  I just have a
few nits I would like to see changed then I'll pull and push to Linus.

in this patch:
>  		/* now count some things */
>  		if (test_bit(R5_LOCKED, &dev->flags)) s.locked++;
>  		if (test_bit(R5_UPTODATE, &dev->flags)) s.uptodate++;
> +		if (test_bit(R5_Wantcompute, &dev->flags))
> +			BUG_ON(++s.compute > 2);

I think having a side-effect in a BUG_ON is very poor form.  I should
be able to recompile the code with BUG_ON() becoming a no-op and
everything should still work.
So something like:
> +		if (test_bit(R5_Wantcompute, &dev->flags)) {
> +			++s.compute;
> +			BUG_ON(s.compute > 2);
> +		}

please.

NeilBrown

