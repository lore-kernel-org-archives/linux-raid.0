From: Volker Armin Hemmann <volkerarmin@googlemail.com>
Subject: Re: Linux mdadm superblock question.
Date: Wed, 17 Feb 2010 19:46:08 +0100
Message-ID: <201002171946.09884.volkerarmin@googlemail.com>
References: <201002140251.59668.volkerarmin@googlemail.com> <201002171927.07051.volkerarmin@googlemail.com> <20100217183703.GA15446@emergent.ellipticsemi.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100217183703.GA15446@emergent.ellipticsemi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nick Bowler <nbowler@elliptictech.com>
Cc: david@lang.hm, Kyle Moffett <kyle@moffetthome.net>, Rudy Zijlstra <rudy@grumpydevil.homelinux.org>, Neil Brown <neilb@suse.de>, "Mr. James W. Laferriere" <babydr@baby-dragons.com>, Bill Davidsen <davidsen@tmr.com>, Michael Evans <mjevans1983@gmail.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mittwoch 17 Februar 2010, Nick Bowler wrote:
> On 19:27 Wed 17 Feb     , Volker Armin Hemmann wrote:
> > On Mittwoch 17 Februar 2010, Nick Bowler wrote:
> > > On 09:41 Wed 17 Feb     , david@lang.hm wrote:
> > > > for a distro that is trying to make one kernel image run on eve=
ry
> > > > possible type of hardware features like initramfs (and udev,
> > > > modeules, etc) are wonderful.
> > > >=20
> > > > however for people who run systems that are known ahead of time=
 and
> > > > static (and who build their own kernels instead of just relying=
 on
> > > > the distro default kernel), all of this is unnessesary complica=
tion,
> > > > which leaves more room for problems to creep in.
> > >=20
> > > Such people can easily construct an initramfs containing busybox =
and
> > > mdadm with a shell script hardcoded to mount their root fs and ru=
n
> > > switch_root.  It's a ~10 minute jobbie that only needs to be done=
 once.
> >=20
> > and even better when you don't have to do that one time job at all.
>=20
> But people who are building their own kernels are already doing a
> (much harder, imo) one time job of configuring their kernels.
>=20
> > btw, what about additional delay?
>=20
> It takes about half a second for mdadm to assemble my root array, is
> that what you're referring to?
>=20
> I assume that kernel auto-assembly is no faster, although I've never
> used it.  Regardless, half a second isn't very long to wait.

well at the moment it takes less than two seconds until init takes over=
=2E

Adding .5 seconds is a lot. And loading the initrd and changing root is=
n't=20
free either, true?

I remember well all the noise in the past about making linux booting fa=
ster.=20
So why slow it down with an initrd - especially if you can do without?

Gl=FCck Auf,
Volker
