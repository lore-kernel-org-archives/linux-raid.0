From: Sebastian Kuzminsky <seb@highlab.com>
Subject: Re: [linux-lvm] Re: more info on the hang with 2.6.15-rc5
Date: Mon, 09 Jan 2006 11:05:20 -0700
Message-ID: <E1Ew1OS-00034G-Ss@highlab.com>
References: <E1EpIfb-0001e2-GR@highlab.com> <43C1580B.9020609@tmr.com> <E1Evmqw-0001pO-Ng@highlab.com> <43C28E52.8080104@mattgillen.net> <43C290D4.5030209@projecthugo.co.uk> <17346.40174.865171.160466@dobie.ylee.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <17346.40174.865171.160466@dobie.ylee.org> 
Sender: linux-raid-owner@vger.kernel.org
To: Yeechang Lee <ylee@pobox.com>
Cc: kernel-lists@projecthugo.co.uk, LVM general discussion and development <linux-lvm@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Yeechang Lee <ylee@pobox.com> wrote:
> Matt Darcy <kernel-lists@projecthugo.co.uk> says:
> > Judging from the ammount of problems with this driver it is %90 the
> > driver and %10 raid interaction with the dirver
> >
> > I don't believe this is an LVM issue, more a case of the driver's
> > just not ready for use, so if you use it with raid and lvm you speed
> > up the crash.
> 
> I'm coming into this late, but could your issue be related to
> <URL:https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=167173>?

That problem was fixed or worked around by using 8K kernel stacks instead
of 4K.  Both my kernels (debug & production) use 8K stacks, so I dont
think that's it.

What I get isn't crashes with stack traces & kernel messages like that
bug, I get hard lockups with no output.


-- 
Sebastian Kuzminsky
