From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: raid0_make_request bug: can't convert ...bigger than 8k
Date: Mon, 17 Jun 2002 14:27:28 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15629.25904.914128.956704@notabene.cse.unsw.edu.au>
References: <3D0A3100.9010506@umich.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Paul Kubicz on Friday June 14
To: Paul Kubicz <pkube@umich.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday June 14, pkube@umich.edu wrote:
> I'm getting a message like this when trying to compile raid into the 
> 2.5.x kernel (up to 2.5.21). I've picked up several semi-relevant 
> messages in a search, but I couldn't find anything that directly 
> addresses the problem.

That would be because the problem hasn't been addressed yet...  I'm
afraid you will have to live without raid0 (and probably linear) in
2.5 kernels for a while longer.

NeilBrown

> 
> I'm trying to mount md0 created under kernel 2.4.x. Thanks for any help.
> 
> 
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
