From: Neil Brown <neilb@suse.de>
Subject: Re: spurious dots in dmesg when reconstructing arrays
Date: Thu, 17 Aug 2006 21:44:39 +1000
Message-ID: <17636.22183.827402.227427@cse.unsw.edu.au>
References: <44E447E0.9020006@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Michael Tokarev on Thursday August 17
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday August 17, mjt@tls.msk.ru wrote:
> A long time ago I noticied pretty bad formatting of
> dmesg text in md array reconstruction output, but
> never bothered to ask.  So here it goes.

What kernel version?
My patch logs suggest that I fixed that about 1 year ago...
which means it is still in SLES9 at least :-)

> 
> But the thing is: I've no idea where this dot is coming from... ;)
> 

drivers/md/md.c.  md_do_sync.  Immediately after
	ITERAE_MDDEV(mddev2,tmp) {


> Can we fix this umm.. misformatting please? ;)

Done that.

NeilBrown
