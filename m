From: =?ISO-8859-1?Q?G=FCnther_J=2E?= Niederwimmer <gjn@gjn.priv.at>
Subject: Re: Problem with Dualboot on a LSI 9271-8i Controller
Date: Tue, 08 Oct 2013 08:39:55 +0200
Message-ID: <1692827.Iklf2kLWDY@techz.gjn.prv>
References: <4461728.ofzB8jD5W8@techz.gjn.prv> <52534304.8010606@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52534304.8010606@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am Montag, 7. Oktober 2013, 18:25:56 schrieb Stan Hoeppner:
> On 10/7/2013 6:58 AM, G=FCnther J. Niederwimmer wrote:
> > The System is a Asus W9D WS with a LSI Raid Controller.
>=20
> ...
>=20
> > 2 x Raid1 SSD's with 256GB
> >=20
> > On the first Raid1 is windows installed (UEFI) and on the second Ra=
id1 is
> > Linux (oSUSE) installed (UEFI)
> >=20
> > When I install the system and make the 1. REBOOT all is correct oSU=
SE is
> > booting again, all works correct.
> >=20
> > But after a shutdown only windows is booting again, oSUSE tell me
> >=20
> > Initrd is loading but it is hang.
> >=20
> > Sometime 1-3 Days oSUSE is booting?
>=20
> ...
>=20
> > This is always on different Systems with the same LSI Controller.
>=20
> Does this mean you have multiple computers all identical, all with th=
is
> controller, all dual booting Windows and Linux?  This is a strange
> setup.  Why do you do this?

NO ;)

This is the system from a friend an I change only the Motherboard for T=
ests


> > Have I configure the Raid Controller wrong, or is this Controller b=
roken,
> > or have Grun2-efi Problem with this Controller ....
>=20
> Would you find it surprising that LSI never considered this $600
> Enterprise 8 port RAID controller would be used in a dual boot
> workstation role, with 4 SSDs in two RAID1 sets?
>=20
> My guess is that this is a Grub2 issue and it's having trouble seeing
> both disk devices as enumerated by the UEFI implementation.
>=20
> What happens when you create a 4 SSD RAID10 and partition the resulti=
ng
> single disk device into two equal halves, one partition for SuSE and =
one
> for Windows?  With everything on one disk device this should work muc=
h
> more reliably.

But why it is booting same times (?) and only stop booting on a shutdow=
n ?

--=20
mit freundlichen Gr=FC=DFen / best Regards,

 G=FCnther J. Niederwimmer
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
