From: "David Rees" <drees76@gmail.com>
Subject: Re: Linux Software RAID a bit of a weakness?
Date: Tue, 27 Feb 2007 12:12:29 -0800
Message-ID: <72dbd3150702271212r42125b73ya8f9fa2016932793@mail.gmail.com>
References: <1172258378.21648.51.camel@cowie> <45DF46B7.3040707@maine.edu>
	 <1172406243.3765.29.camel@cowie> <45E1E051.1020908@sauce.co.nz>
	 <72dbd3150702260856p5053d028je85cacffb15a5536@mail.gmail.com>
	 <1172510818.11898.33.camel@cowie>
	 <72dbd3150702261313o88c1dd6tf910049e69708868@mail.gmail.com>
	 <17891.20361.634717.178466@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17891.20361.634717.178466@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Colin Simpson <csimpson@csl.co.uk>, Richard Scobie <richard@sauce.co.nz>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 2/26/07, Neil Brown <neilb@suse.de> wrote:
> On Monday February 26, drees76@gmail.com wrote:
> > I'm pretty sure that rear errors will be noticed by the MD system,
> > either.
>
> :-)  Your typing is nearly as bad as mine often is, but your intent is
> correct.  If you independently read from a device in an MD array and get an
> error, MD won't notice.  MD only notices errors for requests that it
> makes of the devices itself.

Doh, 2 errors in one line! Should have read:

I'm pretty sure that read errors will _not_ be noticed by the MD system, either.

Good thing at least Neil understood me. :-)

-Dave
