From: Volker Armin Hemmann <volkerarmin@googlemail.com>
Subject: Re: Linux mdadm superblock question.
Date: Tue, 16 Feb 2010 22:06:32 +0100
Message-ID: <201002162206.32797.volkerarmin@googlemail.com>
References: <201002140251.59668.volkerarmin@googlemail.com> <201002141940.35716.volkerarmin@googlemail.com> <4B7AD35E.7000405@tmr.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4B7AD35E.7000405@tmr.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Michael Evans <mjevans1983@gmail.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Dienstag 16 Februar 2010, Bill Davidsen wrote:
> Volker Armin Hemmann wrote:
> > On Sonntag 14 Februar 2010, you wrote:
> >> In other words, 'auto-detection' for 1.x format devices is using a=
n
> >> initrd/initramfs.
> >=20
> > which makes 1.x format useless for everybody who does not want to d=
eal
> > with initrd/initramfs.
>=20
> You make this sound like some major big deal. are you running your ow=
n
> distribution? In most cases mkinitrd does the right thing when you "m=
ake
> install" the kernel, and if you are doing something in the build so
> complex that it needs options, you really should understand the optio=
ns
> and be sure you're doing what you want.
>=20
> Generally this involves preloading a module or two, and if you need i=
t
> every time you probably should have built it in, anyway.
>=20
> My opinion...

I am running my own kernels - and of course everything that is needed t=
o boot=20
and get the basic system up is built in. Why should I make the disk dri=
vers=20
modules?=20
That does not make sense.

And the reason is simple: even when the system is completely fucked up,=
 I want=20
a kernel that is able to boot until init=3D/bin/bb takes over.

Gl=FCck Auf
Volker
