From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 000 of 5] md: Assorted minor fixes for mainline
Date: Sat, 9 Dec 2006 19:51:09 +1100
Message-ID: <17786.30973.594360.165898@cse.unsw.edu.au>
References: <20061208120132.21203.patches@notabene>
	<20061208160455.05a81359.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andrew Morton on Friday December 8
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Friday December 8, akpm@osdl.org wrote:
> 
> md-change-lifetime-rules-for-md-devices.patch still has a cloud over its
> head (Jiri Kosina <jikos@jikos.cz>'s repeatable failure), so I staged these
> new patches as below:
> 
> 
>  md-fix-innocuous-bug-in-raid6-stripe_to_pdidx.patch
>  #
>  md-conditionalize-some-code.patch
> +md-remove-some-old-ifdefed-out-code-from-raid5c.patch
> +md-return-a-non-zero-error-to-bi_end_io-as-appropriate-in-raid5.patch
> +md-assorted-md-and-raid1-one-liners.patch
>  md-change-lifetime-rules-for-md-devices.patch
> +md-close-a-race-between-destroying-and-recreating-an-md-device.patch
> +md-allow-mddevs-to-live-a-bit-longer-to-avoid-a-loop-with-udev.patch
> 
> So the last three are maybe-not-for-2.6.20.
> 
> Does that sounds sane?

Yes, perfectly sane ... though I still hope to nail that bug :-)

Thanks,
NeilBrown
