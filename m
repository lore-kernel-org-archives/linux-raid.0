From: Nick Bowler <nbowler@elliptictech.com>
Subject: Re: Linux mdadm superblock question.
Date: Wed, 17 Feb 2010 13:51:05 -0500
Message-ID: <20100217185105.GA15614@emergent.ellipticsemi.com>
References: <201002140251.59668.volkerarmin@googlemail.com>
 <alpine.DEB.2.00.1002170932010.4721@asgard.lang.hm>
 <20100217181016.GA14983@emergent.ellipticsemi.com>
 <201002171927.07051.volkerarmin@googlemail.com>
 <20100217183703.GA15446@emergent.ellipticsemi.com>
 <alpine.DEB.2.00.1002171040350.4721@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1002171040350.4721@asgard.lang.hm>
Sender: linux-kernel-owner@vger.kernel.org
To: david@lang.hm
Cc: Volker Armin Hemmann <volkerarmin@googlemail.com>, Kyle Moffett <kyle@moffetthome.net>, Rudy Zijlstra <rudy@grumpydevil.homelinux.org>, Neil Brown <neilb@suse.de>, "Mr. James W. Laferriere" <babydr@baby-dragons.com>, Bill Davidsen <davidsen@tmr.com>, Michael Evans <mjevans1983@gmail.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10:41 Wed 17 Feb     , david@lang.hm wrote:
> On Wed, 17 Feb 2010, Nick Bowler wrote:
> > It takes about half a second for mdadm to assemble my root array, is
> > that what you're referring to?
> >
> > I assume that kernel auto-assembly is no faster, although I've never
> > used it.  Regardless, half a second isn't very long to wait.
> 
> If you are aiming for a 5-second boot time it's 10% of your total boot 
> time. That's a lot for a feature that's not needed.

Only if the kernel auto-assembly takes zero time, which it obviously
does not.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
