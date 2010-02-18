From: Daniel Reurich <daniel@centurion.net.nz>
Subject: Re: (boot time consequences of) Linux mdadm superblock question.
Date: Thu, 18 Feb 2010 18:17:44 +1300
Message-ID: <1266470264.11568.191.camel@localhost.localdomain>
References: <201002140251.59668.volkerarmin@googlemail.com>
	 <alpine.DEB.2.00.1002170932010.4721@asgard.lang.hm>
	 <20100217181016.GA14983@emergent.ellipticsemi.com>
	 <201002171927.07051.volkerarmin@googlemail.com>
	 <20100217183703.GA15446@emergent.ellipticsemi.com>
	 <alpine.DEB.2.00.1002171040350.4721@asgard.lang.hm>
	 <20100218102407.49f73d67@notabene.brown>
	 <20100218025809.GA20358@khazad-dum.debian.net>
	 <20100218032610.GB1991@lapse.rw.madduck.net>
	 <1266465801.11568.183.camel@localhost.localdomain>
	 <20100218044004.GC5136@lapse.rw.madduck.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100218044004.GC5136@lapse.rw.madduck.net>
Sender: linux-raid-owner@vger.kernel.org
To: martin f krafft <madduck@madduck.net>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 2010-02-18 at 17:40 +1300, martin f krafft wrote:
> also sprach Daniel Reurich <daniel@centurion.net.nz> [2010.02.18.1703 +1300]:
> > > Debian experimental. But so far, I was unable to get rid of
> > > mdadm.conf because it only works without the info in that file if
> > > the homehost is correctly encoded in the metadata. So the challenge
> > > I am facing is http://bugs.debian.org/567468.
> > 
> > Why not use an installation generated uuid like that of the root
> > filesystem for the homehost identifier.  It's less likely to change then
> > just about any other system identifier.
> 
> This is a great idea. While I would still have to store that UUID in
> the initrd, as you say, it's 99% likely to remain constant, and when
> it changes, it's 99% likely that the admin is doing something that
> will require more work, so we can resort to 100% hoping that s/he
> knows what she's doing.

It'd already be there if they used it in /etc/fstab.  (I wish they would
as it would solve a whole lot of other media portability problems as
well, but that's another issue.)

-- 
Daniel Reurich.

Centurion Computer Technology (2005) Ltd
Mobile 021 797 722



