From: John DeFranco <defranco@cup.hp.com>
Subject: Re: Veritas Volume Manager
Date: Wed, 14 May 2003 13:27:29 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200305141327.29713.defranco@cup.hp.com>
References: <B0E6075E55C7D6119DDE0002A53F8BCEFFDD2D@blpfroclab01.bausch.com> <20030514194644.GB6949@localhost> <3EC2A232.8070308@moeraki.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3EC2A232.8070308@moeraki.com>
To: John Finlay <finlay@moeraki.com>, Jose Luis Domingo Lopez <linux-raid@24x7linux.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I actually think its also really (relatively) expensive for Linux as 
well. Veritas is not in the habit doing things for the good of the 
community. Whether it worth it or not really depends on what your 
requirements are. Certainly the Veritas product provides a much 
cleaner solution in terms of including the mirroring portion within 
the vm itself (although depending on what features you want it will 
be an extra cost as well). This is better than using lvm on top of md 
(which I do at my site). 

These other products (lvm and md) are free but that also means if you 
have a problem who knows when it will be addressed. Same is true to a 
certain point with Veritas as well.

I have done quite a bit of work with VxVM on both Solaris and HP-UX as 
well as work with md/lvm. Both have their pros and cons. If you don't 
mind the cost and feel the current tools are primitive then VxVM 
might be worth it. However it you just want a reasonable 
mirroring/raid solution md/lvm might just be ok.

My $.02
On Wednesday 14 May 2003 13:08, John Finlay wrote:
> Hi Jose,
>
> I am assuming that this list is about linux raid and that the
> Veritas products are raid products on linux. I assume that this
> list is not restricted to discussions about free raid
> implementations. If I want marketing fluff I can get that from the
> Veritas site but I'm interested in why real people would use
> Veritas on linux or why not. So far it seems that the cons are lack
> of broad support for various linux kernels and cost (which is not
> on the web site) and the pro is a professional mature stable
> product. The current crop of free linux raid tools (MD and LVM)
> seem really primitive and inflexible and having experience with
> Veritas in a previous life on Solaris (where it's really expensive)
> I was wondering if the linux version was as good and whether people
> felt it was worth spending the money to get the Veritas features.
> Of course it's possible that Veritas is overkill for the seemingly
> limited capabilities and application of the current linux PC type
> systems and of course the Veritas stuff might not cover all the
> possible hardware configurations that are available for linux.
>
> Thanks
>
> John
>
> Jose Luis Domingo Lopez wrote:
> >On Wednesday, 14 May 2003, at 10:19:25 -0700,
> >
> >John Finlay wrote:
> >>Thanks for the info. My impression is that the Veritas VM has a
> >> lot more features than MD/LVM including management tools,
> >> on-line reconfiguration, etc. These seem like valuable features.
> >> What's the cost of VVM?
> >
> >You can (and should) always go to the vendor's website and look
> > there, because this list is not about Veritas products and/or
> > marketing/sales.
>
> -
> To unsubscribe from this list: send the line "unsubscribe
> linux-raid" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
==========
Cheers
   -jdf

