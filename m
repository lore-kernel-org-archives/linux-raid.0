From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm/Monitor.c - never removes MD devices from statelist
Date: Mon, 12 Sep 2011 05:36:46 +0200
Message-ID: <20110912053646.5eb0b55d@notabene.brown>
References: <CAGRgLy4=mq_py=Qr+Mk8MOvXY1fbwgeEmEr1kAcmiwHQfCZweg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy4=mq_py=Qr+Mk8MOvXY1fbwgeEmEr1kAcmiwHQfCZweg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 11 Sep 2011 21:32:12 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hi everybody,
> looking at the code of Monitor.c and doing some tests with it, I see
> that it is capable of detecting new arrays, when they appear in
> /proc/mdstat (if --scan is given). However, once array is added to
> 'statelist', it is never removed from there. Is this intentional?
> Perhaps only if --scan is given, and device disappears from
> /proc/mdstat, then it should be removed from monitoring, otherwise it
> could stick there forever, even though the array has been gone long
> time ago. And if it appears again, it will be picked up anyways.
> 

You are right - arrays are never removed.

Is that a problem?  Probably not, though I guess you could probably create
a scenario where there were lots of inactive devices cluttering memory.

Is it worth fixing?  I don't know - it depends on how intrusive the patch is.
We would only want to remove arrays with ->err set if 'scan' was set, but
when it is, it possible makes sense.

Want to try creating a patch?

NeilBrown
