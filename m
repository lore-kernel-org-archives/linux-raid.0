From: hansbkk@gmail.com
Subject: Re: What's the typical RAID10 setup?
Date: Tue, 1 Feb 2011 15:46:46 +0700
Message-ID: <AANLkTi=uAQ0dfZwmrCZLKNL4ssPx0LQAru0j+bJcjrEL@mail.gmail.com>
References: <AANLkTimc35i0W8vmsEGWrjCH7pYLBo=Ju1inA6xQ8bj6@mail.gmail.com>
	<AANLkTimoSvWj3mnowZbVKKHEMzwjiQ=WqRUUsj91n_Zr@mail.gmail.com>
	<20110131152151.GD7861@cthulhu.home.robinhill.me.uk>
	<AANLkTimfnRxm=chKx4MFSxX1c0hypnVW-jaYwq757DaH@mail.gmail.com>
	<AANLkTi=mLFwdLzcjcpzC0JJ=v8Aa817g+CzrR88pmy9y@mail.gmail.com>
	<AANLkTikvXk0gyXz6MBvhyzxXatk0FVeASPr8R8+74c_i@mail.gmail.com>
	<AANLkTinGSNmp6yUNfb9thnr3zKFTzw=fUFm+Gef3DAHw@mail.gmail.com>
	<AANLkTim_uQ7AQs_ZSyeYPJPYSLCJd6ChzzTBwBNk2qA9@mail.gmail.com>
	<20110131192858.GD27952@www2.open-std.org>
	<4D4718E1.9040607@hardwarefreak.com>
	<20110131203725.GB2283@www2.open-std.org>
	<AANLkTimxCkxkg6xuz8FgFf0=u4KY=0M=6+afnxLzT+Tu@mail.gmail.com>
	<AANLkTi=+rPzaNTKAjB=QUEGsbUcwfN8uijm96DoY_4FA@mail.gmail.com>
	<AANLkTinM6FkJtxL8dNpoy-haGqNsZVfLDwmvZcshTEYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinM6FkJtxL8dNpoy-haGqNsZVfLDwmvZcshTEYQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>, Roberto Spadim <roberto@spadim.com.br>, =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@keldix.com>, Stan Hoeppner <stan@hardwarefreak.com>, Denis <denismpa@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

For regulars here on the list we understand "raid10" to mean (what
outsiders call non-standard) "md raid10".

To be very clear for everyone coming here, how about we agree to use
that - "md raid10" and "raid1+0" to mean the (to outsiders "standard")
version, and to just not use plain "raid10" at all as it is ambiguous.

My understanding of "standard" = accepted in all the subdomain
discussion areas of the overall concept (md raid being a subset of
raid).

Within the overall topic domain, mdadm-implemented raid is just one
flavor, one which in fact many consider substandard and
inconsequential - although I and of course most here disagree, that's
the way it is.

A major advantage is the fact that mdraid is not proprietary but open,
and although the meaning of standard may often imply open as opposed
to to proprietary, that's not so in this case.


On Tue, Feb 1, 2011 at 4:27 AM, Jon Nelson
<jnelson-linux-raid@jamponi.net> wrote:
> Before this goes any further, why not just reference the excellent
> Wikipedia article (actually, excellent applies to both Wikipedia *and*
> the article):
>
> http://en.wikipedia.org/wiki/Non-standard_RAID_levels#Linux_MD_RAID_10
>
> The only problem I have with the wikipedia article is the assertion
> that Linux MD RAID 10 is non-standard. It's as standard as anything
> else is in this world.
