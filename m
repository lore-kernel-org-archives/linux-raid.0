From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH md 1 of 2] Add interface to md driver for userspace
 monitoring of events.
Date: Mon, 6 Sep 2004 16:07:38 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040906160738.368c20f3.akpm@osdl.org>
References: <20040903122034.15346.patches@notabene>
	<E1C33nX-00040i-9v@notabene.cse.unsw.edu.au>
	<20040903031920.11e31d3f.akpm@osdl.org>
	<16699.47090.307180.958993@cse.unsw.edu.au>
	<20040906140233.GB20941@lst.de>
	<16700.60002.246730.450275@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16700.60002.246730.450275@cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: hch@lst.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown <neilb@cse.unsw.edu.au> wrote:
>
> > poll on procfs is defintily abuse, even in categories of the use procfs
>  > every times.
>  > 
> 
>  Oh well..  If you gain more from the patch not going in than I gain
>  from it going in, so be it.

That's not the point.  Sure, the code works and is useful.  But it takes a
crappy interface and makes it crappier.

You know where we'd end up if we took that attitude all the time, yes?

Could we explore a medium-term plan to tidy all this up?
