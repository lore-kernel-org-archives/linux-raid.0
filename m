From: =?UTF-8?B?Q2zDoXVkaW8=?= Martins <ctpm@ist.utl.pt>
Subject: Re: status of sas1068 ata-passthrough bug?
Date: Wed, 3 Nov 2010 03:20:49 +0000
Message-ID: <20101103032049.3a731d19.ctpm@ist.utl.pt>
References: <AANLkTimXicMBtagN0a98eK1DD9rGj4QOqsxiZN32o59Y@mail.gmail.com>
	<20101102220517.41416adb.ctpm@ist.utl.pt>
	<AANLkTi=m0QSBq=W0KoZiSo_5hdbi31z9ipV2z6s5C2=T@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=m0QSBq=W0KoZiSo_5hdbi31z9ipV2z6s5C2=T@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Tue, 2 Nov 2010 22:00:43 -0500 Matt Garman <matthew.garman@gmail.com=
> wrote:
> >
> > =C2=A0This is indeed fixed in v2.6.36, by commit 2a1b7e5
> >
> > http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;=
a=3Dcommit;h=3D2a1b7e5
> >
> > =C2=A0I've been running a 16-disk RAID6 MD array since 2.6.36 and I=
 can use
> > smartmontools with no issues.
>=20
> Thank you, that is very helpful!
>=20
> Do you, or the list in general, happen to know if this fix has made i=
t
> into any distribution-specific kernels?  E.g., ubuntu server, centos,
> etc?
>=20

 Hi,

 Sadly I don't know if it has made any distro kernels. I tend to stick
to vanilla so I can get the latest features and fixes, especially the
ones related to storage hardware and filesystems (though, you might
sometimes also get the latest bugs ;-) ).

 I would guess that Ubuntu might have some 2.6.35 kernel with this fix
backported, but I'm just speculating.

 Also, as a last resort, you could try to apply the patch and rebuild
using the sources of your favorite distro kernel. The patch is quite
simple, but be warned that the MPTSAS module also got some other
potentially interesting fixes on the 2.6.36 cycle.

 Best regards

Cl=C3=A1udio

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
