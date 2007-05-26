From: David Miller <davem@davemloft.net>
Subject: Re: raid10 kernel panic on sparc64
Date: Sat, 26 May 2007 15:50:01 -0700 (PDT)
Message-ID: <20070526.155001.112603157.davem@davemloft.net>
References: <Pine.LNX.4.61.0704020211380.1245@yvahk01.tjqt.qr>
	<20070412.142628.27805319.davem@davemloft.net>
	<Pine.LNX.4.61.0705261710130.7344@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0705261710130.7344@yvahk01.tjqt.qr>
Sender: linux-raid-owner@vger.kernel.org
To: jengelh@linux01.gwdg.de
Cc: linux-raid@vger.kernel.org, sparclinux@vger.kernel.org
List-Id: linux-raid.ids

From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Date: Sat, 26 May 2007 17:10:30 +0200 (MEST)

> 
> On Apr 12 2007 14:26, David Miller wrote:
> >
> >> Kernel is kernel-smp-2.6.16-1.2128sp4.sparc64.rpm from Aurora Corona.
> >> Perhaps it helps, otherwise hold your breath until I reproduce it.
> >
> >Jan, if you can reproduce this with the current 2.6.20 vanilla
> >kernel I'd be very interested in a full trace so that I can
> >try to fix this.
> >
> >With the combination of an old kernel and only part of the
> >crash trace, there isn't much I can do with this report.
> 
> Does not seem to happen under 2.6.21-1.3149.al3.2smp anymore.

Thanks for following up on this Jan.

I'd personally really appreciate reports against upstream
instead of dist kernels in the future, and I'm sure the
linux-raid maintainers feel similarly :-)
