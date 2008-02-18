From: Neil Brown <neilb@suse.de>
Subject: Re: suns raid-z / zfs
Date: Mon, 18 Feb 2008 15:07:44 +1100
Message-ID: <18361.1168.473685.214133@notabene.brown>
References: <20080217160403.GA15710@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Keld Jorn Simonsen on Sunday February 17
Sender: linux-raid-owner@vger.kernel.org
To: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday February 17, keld@dkuug.dk wrote:
> Hi
> 
> any opinions on suns zfs/raid-z?

It's vaguely interesting.  I'm not sold on the idea though.

> It seems like a good way to avoid the performance problems of raid-5
> /raid-6

I think there are better ways.

> 
> But does it stripe? One could think that rewriting stripes
> other places would damage the striping effects.

I'm not sure what you mean exactly.  But I suspect your concerns here
are unjustified.

> 
> Or is the performance only meant to be good for random read/write?

I suspect it is mean to be good for everything.  But you would have to
ask SUN that.

> 
> Can the code be lifted to Linux? I understand that it is already in
> freebsd. Does Suns licence prevent this?

My understanding is that the sun license prevents it.

However raid-z only makes sense in the context of a specific
filesystem such as ZFS.  It isn't something that you could just layer
any filesystem on top of.

> 
> And could something like this be built into existing file systems like
> ext3 and xfs? They could have a multipartition layer in their code, and
> then the heuristics to optimize block access could also apply to stripe
> access.

I doubt it, but I haven't thought deeply enough about it to see if
there might be some relatively non-intrusive way.

NeilBrown

> 
> best regards
> keld
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
