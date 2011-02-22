From: NeilBrown <neilb@suse.de>
Subject: Re: Two questions about stripe_cache_size
Date: Wed, 23 Feb 2011 09:24:22 +1100
Message-ID: <20110223092422.230875fa@notabene.brown>
References: <AANLkTi=bvRBoyUCH+9_9ZTjrWKdqjkfzpnNtdhmvgYCk@mail.gmail.com>
	<20110223090105.4be62a1e@notabene.brown>
	<AANLkTin-Ub0PAvdWDQwzqUyvzVDKia5FGGpyK4ip_=Lo@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTin-Ub0PAvdWDQwzqUyvzVDKia5FGGpyK4ip_=Lo@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Patrick J. LoPresti" <lopresti@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 22 Feb 2011 14:13:14 -0800 "Patrick J. LoPresti" <lopresti@gmail.com>
wrote:

> Thanks, Neil.  Actually, I think I have one more question...  (Well,
> one question with many faces.)
> 
> Is the stripe cache write-back, or write-through?  If the latter, when
> does it get flushed to disk, exactly?
> 

Write-through.

However I am tempted to make it write-back as filesystems now submit 'flush'
requests which can be used to flush the cache.  I wonder if you would be able
to notice any performance difference...

NeilBrown
