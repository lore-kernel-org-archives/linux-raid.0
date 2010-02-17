From: Volker Armin Hemmann <volkerarmin@googlemail.com>
Subject: Re: Linux mdadm superblock question.
Date: Wed, 17 Feb 2010 19:27:06 +0100
Message-ID: <201002171927.07051.volkerarmin@googlemail.com>
References: <201002140251.59668.volkerarmin@googlemail.com> <alpine.DEB.2.00.1002170932010.4721@asgard.lang.hm> <20100217181016.GA14983@emergent.ellipticsemi.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100217181016.GA14983@emergent.ellipticsemi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nick Bowler <nbowler@elliptictech.com>
Cc: david@lang.hm, Kyle Moffett <kyle@moffetthome.net>, Rudy Zijlstra <rudy@grumpydevil.homelinux.org>, Neil Brown <neilb@suse.de>, "Mr. James W. Laferriere" <babydr@baby-dragons.com>, Bill Davidsen <davidsen@tmr.com>, Michael Evans <mjevans1983@gmail.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mittwoch 17 Februar 2010, Nick Bowler wrote:
> On 09:41 Wed 17 Feb     , david@lang.hm wrote:
> > for a distro that is trying to make one kernel image run on every
> > possible type of hardware features like initramfs (and udev, modeul=
es,
> > etc) are wonderful.
> >=20
> > however for people who run systems that are known ahead of time and
> > static (and who build their own kernels instead of just relying on =
the
> > distro default kernel), all of this is unnessesary complication, wh=
ich
> > leaves more room for problems to creep in.
>=20
> Such people can easily construct an initramfs containing busybox and
> mdadm with a shell script hardcoded to mount their root fs and run
> switch_root.  It's a ~10 minute jobbie that only needs to be done onc=
e.


and even better when you don't have to do that one time job at all.

btw, what about additional delay?=20


Gl=FCck Auf,
Volker
