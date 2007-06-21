From: Jon Nelson <jnelson-linux-raid@jamponi.net>
Subject: Re: stripe_cache_size and performance
Date: Thu, 21 Jun 2007 18:09:37 -0500 (CDT)
Message-ID: <Pine.LNX.4.64.0706211808140.5806@gheavc.wnzcbav.cig>
References: <Pine.LNX.4.64.0706211312480.5806@gheavc.wnzcbav.cig>
 <5d96567b0706211242p7f03bd1cw9102ae3e44d67cee@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5d96567b0706211242p7f03bd1cw9102ae3e44d67cee@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 21 Jun 2007, Raz wrote:

> What is your raid configuration ?
> Please note that the stripe_cache_size is acting as a bottle neck in some
> cases.

Well, it's 3x SATA drives in raid5. 320G drives each, and I'm using a 
314G partition from each disk (the rest of the space is quiescent).

> On 6/21/07, Jon Nelson <jnelson-linux-raid@jamponi.net> wrote:
> >
> > I've been futzing with stripe_cache_size on a 3x component raid5,
> > using 2.6.18.8-0.3-default on x86_64 (openSUSE 10.2).
> >
> > With the value set at 4096 I get pretty great write numbers.
> > 2048 and on down the write numbers slowly drop.
> >
> > However, at values above 512 the 'check' performance is terrible. By
> > 'check' performance I mean the value displayed by /proc/mdstat after
> > I issue:
> >
> > echo check > /sys/block/md0/md/sync_action
> >
> > When I say "terrible" I mean < 3MB/s.
> > When I use 384, the performance goes to ~70MB/s
> > 512.. 72-73MB/s
> > 640.. 73-74MB/s
> >
> > 768.. 3300 K/s. Wow!
> >
> > Can somebody 'splain to me what is going on?
> >
> > --
> > Jon Nelson <jnelson-linux-raid@jamponi.net>
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> 
> -- 
> Raz
> 
> 
> 

--
Jon Nelson <jnelson-linux-raid@jamponi.net>
