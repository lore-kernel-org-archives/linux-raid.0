From: Scott McDermott <vaxerdec@frontiernet.net>
Subject: Re: Mirroring swap
Date: Thu, 26 Jun 2003 22:24:47 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030626222447.C29149@newbox.localdomain>
References: <Pine.LNX.4.43.0306260916190.5551-100000@unicorn.drogon.net> <1056662597.10690.6.camel@gregdell.example.com> <200306261444280640.52F72FDF@shargaas.coreyfro.com> <20030626215606.A29149@newbox.localdomain> <200306261914500491.05546D13@ilneval.coreyfro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200306261914500491.05546D13@ilneval.coreyfro.com>; from coreyfro@coreyfro.com on Thu, Jun 26, 2003 at 07:14:50PM -0700
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Corey McGuire on Thu 26/06 19:14 -0700:
> I'd like to know if Linux can address more than 4GB's of
> RAM (on a 32 bit processor without using dirty tricks like
> Intel's 36bit hack) including the swap system.

Without PAE (36-bit), then of course the limit is 32-bit
addressing.

You're right that 4G is not that expensive, but only certain
workloads can actually use this much memory.  If your
working set is only 256M, but you often do other work with
different working sets, this is a good candidate for disk
swap.  Since you only use the one working set at a time, you
really don't need to fit all of your working sets in core at
once and you are just wasting money.  Disk is still MUCH
cheaper than fast memory.
