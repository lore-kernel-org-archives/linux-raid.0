From: Volker Armin Hemmann <volkerarmin@googlemail.com>
Subject: Re: Linux mdadm superblock question.
Date: Tue, 16 Feb 2010 23:18:33 +0100
Message-ID: <201002162318.33950.volkerarmin@googlemail.com>
References: <201002140251.59668.volkerarmin@googlemail.com> <201002162206.32797.volkerarmin@googlemail.com> <20100216220020.GA1036@emergent.ellipticsemi.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100216220020.GA1036@emergent.ellipticsemi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>, Michael Evans <mjevans1983@gmail.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Nick Bowler <nbowler@elliptictech.com>
List-Id: linux-raid.ids

On Dienstag 16 Februar 2010, Nick Bowler wrote:
> On 22:06 Tue 16 Feb     , Volker Armin Hemmann wrote:
> > On Dienstag 16 Februar 2010, Bill Davidsen wrote:
> > > Volker Armin Hemmann wrote:
> > > > On Sonntag 14 Februar 2010, you wrote:
> > > >> In other words, 'auto-detection' for 1.x format devices is usi=
ng an
> > > >> initrd/initramfs.
> > > >=20
> > > > which makes 1.x format useless for everybody who does not want =
to
> > > > deal with initrd/initramfs.
> > >=20
> > > You make this sound like some major big deal. are you running you=
r own
> > > distribution? In most cases mkinitrd does the right thing when yo=
u
> > > "make install" the kernel, and if you are doing something in the =
build
> > > so complex that it needs options, you really should understand th=
e
> > > options and be sure you're doing what you want.
> > >=20
> > > Generally this involves preloading a module or two, and if you ne=
ed it
> > > every time you probably should have built it in, anyway.
> > >=20
> > > My opinion...
> >=20
> > I am running my own kernels - and of course everything that is need=
ed to
> > boot and get the basic system up is built in. Why should I make the=
 disk
> > drivers modules?
> > That does not make sense.
>=20
> I agree that it makes little sense to make something a module when yo=
u
> can't unload it anyway, but...
>=20
> > And the reason is simple: even when the system is completely fucked=
 up, I
> > want a kernel that is able to boot until init=3D/bin/bb takes over.
>=20
> I put a complete set of recovery tools into my initramfses so that wh=
en
> the system is completely fucked up, I have a kernel that is able to b=
oot
> until rdinit=3D/bin/zsh (or /bin/bb, if you prefer) takes over.
>=20
> This has the added advantage of working when the root filesystem cann=
ot
> be mounted at all: a scenario which does not seem too far-fetched whe=
n
> the filesystem is located on a raid array.

and what do you do if you have to boot from a cd/usb stick and need to =
access=20
the raid?

Simple with auto assembling. Not so much without.

Gl=FCck Auf,
Volker
