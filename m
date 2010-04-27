From: Christian Gatzemeier <c.gatzemeier@tu-bs.de>
Subject: Re: "failed" vs "released" and "locked-out" state and --incremental auto-re-adding
Date: Tue, 27 Apr 2010 19:39:24 +0000 (UTC)
Message-ID: <loom.20100427T210643-938@post.gmane.org>
References: <loom.20100423T140059-877@post.gmane.org> <loom.20100427T002749-963@post.gmane.org> <4BD61EA7.5060609@redhat.com> <loom.20100427T113838-836@post.gmane.org> <4BD706AA.9090404@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Doug Ledford <dledford <at> redhat.com> writes:

> 
> On 04/27/2010 06:13 AM, Christian Gatzemeier wrote:
>
> > There we have a very good word to name --remove so that mdadm is easier to
> > understand (IMHO). "release"
> 
> You're probably right, but it's also too late to change it now 
> Remove has been in use for quite some time and there are untold numbers
> of programs and scripts that use it as it is so that it would be very
> difficult to change it.

I agree. The only thing one could probably do is adding a --release option that
just does the same as --remove, and maybe depreciating --remove when refering to
that action (but of course never actually removing it).

In any case thank you for your enhancements and fine explanations.


Christian





