From: Volker Armin Hemmann <volkerarmin@googlemail.com>
Subject: Re: Linux mdadm superblock question.
Date: Tue, 16 Feb 2010 15:37:08 +0100
Message-ID: <201002161537.08487.volkerarmin@googlemail.com>
References: <201002140251.59668.volkerarmin@googlemail.com> <201002142013.24922.volkerarmin@googlemail.com> <4B7AAB8D.9030009@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4B7AAB8D.9030009@anonymous.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>, linux-kernel@vger.kernel.org
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Dienstag 16 Februar 2010, John Robinson wrote:
> On 14/02/2010 19:13, Volker Armin Hemmann wrote:
> > On Sonntag 14 Februar 2010, you wrote:
> >> On 14/02/2010 18:40, Volker Armin Hemmann wrote:
> >>> On Sonntag 14 Februar 2010, you wrote:
> >>>> In other words, 'auto-detection' for 1.x format devices is using=
 an
> >>>> initrd/initramfs.
> >>>=20
> >>> which makes 1.x format useless for everybody who does not want to=
 deal
> >>> with initrd/initramfs.
> >>=20
> >> True, but afaik every distro uses an initrd/initramfs and bundles =
tools
> >> making it easy to manage and customise them, so what's the problem=
?
> >=20
> > and distros do it because of all the drivers they have to ship. But=
 for
> > example I am not bound by such limitations. Why should I deal with =
that?
> > It is hard enough not to forget 'make modules_install'. And now add
> > initrd. Autodetecting just works - but if you use an initrd an it
> > doesn't. Where do you start?
> >=20
> > Initrd's maybe great for distro packagers, but are they really usef=
ull
> > for anybody else?
>=20
> Not just for distro packagers, they're useful for distro users, which
> are presumably 99% of Linux users these days, including the vast
> majority of enterprise users who like tested, supported systems.
>=20
> But even for people building their own kernels, initrd/initramfs are
> useful if you're using LVM, or indeed trying to boot off anything tha=
t's
> not a simple device.

so assume you have an initrd and metadata 1.x without auto assembling.

You do some changes to the raid and screw up something else. Next boot =
nothing=20
works. Mostly because the mdadm.conf in your initrd is not correct.

You whip out your trusty usb stick with a resuce system - and you are s=
tuck.=20
If autoassembling would work, you would have working md devices you cou=
ld=20
mount and edit the files you have to. But you don't and the mdadm.conf =
in the=20
initrd is outdated.

Sounds like 'you are screwed'.

Or you have that famous grub boot line to have root autoassembled but t=
he=20
device names changed.=20

Yeah, sounds really great.

And that because ...? Is there any good reason not to have autoassmblin=
g in=20
the kernel?

Gl=FCck Auf
Volker
