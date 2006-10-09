From: Chris Allen <chris@cjx.com>
Subject: Re: raid5 hang on get_active_stripe
Date: Mon, 9 Oct 2006 12:03:45 +0100
Message-ID: <20061009110344.GA7104@cjx.com>
References: <17532.59212.364233.765155@cse.unsw.edu.au> <Pine.LNX.4.64.0605301758380.21977@twinlark.arctic.org> <17532.62343.933852.982391@cse.unsw.edu.au> <Pine.LNX.4.64.0605301844180.21977@twinlark.arctic.org> <17534.22056.981033.686846@cse.unsw.edu.au> <Pine.LNX.4.64.0606020009560.10016@twinlark.arctic.org> <17535.59496.431182.785563@cse.unsw.edu.au> <448F0994.6050704@tmr.com> <17551.18061.160356.35034@cse.unsw.!edu.au> <4528377A.2010001@cjx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4528377A.2010001@cjx.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ok, after more testing, this lockup happens consistently when
bitmaps are switched on and never when they are switched off.

Ideas anybody?




On Sun, Oct 08, 2006 at 12:25:46AM +0100, Chris Allen wrote:
> 
> 
> Neil Brown wrote:
> >On Tuesday June 13, davidsen@tmr.com wrote:
> >  
> >>Will that fix be in 2.6.17?
> >>
> >>    
> >
> >Probably not.  We have had the last 'rc' twice and I so I don't think
> >it is appropriate to submit the patch at this stage.
> >I probably will submit it for an early 2.6.17.x. and for 2.6.16.y.
> >
> >
> >  
> 
> What is the status of this?
> 
> I've been experiencing exactly the same get_active_stripe lockup
> on a FC5 2.6.17-1.2187_FC5smp  stock kernel. Curiously we have ten 
> similar heavily loaded
> servers but only one of them experiences the problem. The problem 
> happens consistently after 24 hours or so
> when I hammer the raid5 array over NFS, but I've never managed to 
> trigger it with local access. I'd also
> say (anecdotally) that it only started happening since I added a bitmap 
> to my array.
> 
> 
> As with the other poster, the lockup is released by increasing 
> stripe_cache_size.
> 
> 
> 
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
