From: Neil Brown <neilb@suse.de>
Subject: Re: ANNOUNCE: mdadm 2.3 - A tool for managing Soft RAID under Linux
Date: Mon, 6 Feb 2006 08:50:46 +1100
Message-ID: <17382.29494.565610.555435@cse.unsw.edu.au>
References: <17377.38441.974634.267086@cse.unsw.edu.au>
	<20060204173744.GB31715@percy.comedia.it>
	<20060204195418.GC32334@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Luca Berra on Saturday February 4
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday February 4, bluca@comedia.it wrote:
> On Sat, Feb 04, 2006 at 06:37:45PM +0100, Luca Berra wrote:
> >On Thu, Feb 02, 2006 at 04:18:33PM +1100, Neil Brown wrote:
> >>
> >>
> >>I am pleased to announce the availability of
> >>   mdadm version 2.3
> >>
> >and i am pleased to reply with the first patch for mdadm 2.3,
> >which will allow building on 64bit machines.
> >
> A more knowledgeable C programmer than me suggested using PRIu64
> instead of casting to format correctly theese printfs, what do you
> think about it?
> 

Which way to work around a shortcoming in the C language?
I don't think either is clearly better, though I suspect using PRIu64
might make internationalisation of the strings somewhat harder.

Being largely a kernel programmer these days, and as the kernel tends
to cast the number rather than massage the format string, I would
prefer to do that (i.e. put in the cast like your patch did).

Thanks,
NeilBrown
