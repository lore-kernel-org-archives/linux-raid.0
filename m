From: NeilBrown <neilb@suse.de>
Subject: Re: Two questions about stripe_cache_size
Date: Wed, 23 Feb 2011 09:01:05 +1100
Message-ID: <20110223090105.4be62a1e@notabene.brown>
References: <AANLkTi=bvRBoyUCH+9_9ZTjrWKdqjkfzpnNtdhmvgYCk@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=bvRBoyUCH+9_9ZTjrWKdqjkfzpnNtdhmvgYCk@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Patrick J. LoPresti" <lopresti@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 22 Feb 2011 13:46:57 -0800 "Patrick J. LoPresti" <lopresti@gmail.com>
wrote:

> (Thanks to Piergiorgio Sartor for pointing out this setting to me.)
> 
> I am looking for documentation on /sys/block/mdX/md/stripe_cache_size.
>  Specifically:
> 
> 1) What are the units of this attribute?

Pages per device (1 page is 4K normally)

> 
> 2) I see it is supported for RAID 5.  Is it supported for RAID 6?

Yes.

NeilBrown

