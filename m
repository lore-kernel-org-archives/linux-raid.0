From: Bernd Schubert <bernd-schubert@gmx.de>
Subject: Re: [patch] limit error rate
Date: Mon, 28 Apr 2008 23:33:17 +0200
Message-ID: <200804282333.18172.bernd-schubert@gmx.de>
References: <ftquac$82m$1@ger.gmane.org> <200804240055.17675.bernd-schubert@gmx.de> <18453.11291.797493.538474@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18453.11291.797493.538474@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday 28 April 2008, Neil Brown wrote:
> This is not good, you are subtly changing semantics.
> You have changed:
>
>   if (A)
>       X;
>   else if (B)
>       Y;
>   else if (C)
>       Z;
>   else
>       W;
>
> to
>   if (A && foo())
>       X;
>   else if (B && foo())
>       Y;
>   else if (C && foo())
>       Z;
>   else
>       W;
>
> If 'A' and not 'foo()', you want nothing to happen, but you will
> actually get one of Y, Z, or W happening, all of which are wrong.


Ouch, right. I shouldn't write patches in the middle of the night...

>
> > Btw, from my point of view the
> >
> > if (printk_ratelimit())
> > 	printk("print output");
> >
> > looks odd. I just don't see why the API isn't
> >
> > printk_ratelimit("print output");
>
> Very sensible.  I've put
>
>   #define printk_rl  printk_ratelimit() ?: printk
>
> at the start of raid5.c, and used it to fix the problematic printks.

Great!

Thanks a lot,
Bernd

