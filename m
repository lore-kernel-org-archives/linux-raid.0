From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: How to un-degrade an array after a totally spurious failure?
Date: Mon, 8 Jun 2009 20:55:51 -0500
Message-ID: <20090609015548401.RETS26412@cdptpa-omta03.mail.rr.com>
References: <18989.3642.996238.323569@fisica.ufpr.br>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18989.3642.996238.323569@fisica.ufpr.br>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>  >> > Leslie Rhorer (lrhorer@satx.rr.com) wrote on 7 June 2009 20:43:
>  >> >  >OK, what about a RAID 6 array with one failed disk?  Is the remove
> & add
>  >> >  >the best option there, or should one apply a different method?
>  >> >
>  >> > It is, since that's what the raid is for. It's still operational.
>  >> > We've done it here and it works.
>  >>
>  >> Well, yes, I know it should work.  The question is, "Is it the best
> method?"
> 
> I don't understand what you mean. It is the only method.

We've discussed others, here, including stopping the array and doing an
assemble --force.  I think re-add will also work, won't it?

> Everything
> should be perfectly fine because of the redundancy. You only have to
> do tricks when you have more failed disks than the array supports,
> which always involves a certain risk.

If there are other "tricks", then by definition a remove followed by an add
is not the only possible method.  I can certainly accept it is the best one,
but I was not certain of it, which is why I asked.  OF course, one can
define "best" in a number of ways, but I would say the fastest recovery
method that still maintains data integrity is the best.  The add + resync is
not exactly fast.

