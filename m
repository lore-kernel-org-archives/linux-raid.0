From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Problem with Dualboot on a LSI 9271-8i Controller
Date: Mon, 07 Oct 2013 18:25:56 -0500
Message-ID: <52534304.8010606@hardwarefreak.com>
References: <4461728.ofzB8jD5W8@techz.gjn.prv>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4461728.ofzB8jD5W8@techz.gjn.prv>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?=22G=FCnther_J=2E_Niederwimmer=22?= <gjn@gjn.priv.at>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/7/2013 6:58 AM, G=FCnther J. Niederwimmer wrote:

> The System is a Asus W9D WS with a LSI Raid Controller.
=2E..
> 2 x Raid1 SSD's with 256GB
>=20
> On the first Raid1 is windows installed (UEFI) and on the second Raid=
1 is Linux=20
> (oSUSE) installed (UEFI)
>=20
> When I install the system and make the 1. REBOOT all is correct oSUSE=
 is=20
> booting again, all works correct.
>=20
> But after a shutdown only windows is booting again, oSUSE tell me=20
>=20
> Initrd is loading but it is hang.
>=20
> Sometime 1-3 Days oSUSE is booting?
=2E..
> This is always on different Systems with the same LSI Controller.

Does this mean you have multiple computers all identical, all with this
controller, all dual booting Windows and Linux?  This is a strange
setup.  Why do you do this?

> Have I configure the Raid Controller wrong, or is this Controller bro=
ken, or=20
> have Grun2-efi Problem with this Controller ....

Would you find it surprising that LSI never considered this $600
Enterprise 8 port RAID controller would be used in a dual boot
workstation role, with 4 SSDs in two RAID1 sets?

My guess is that this is a Grub2 issue and it's having trouble seeing
both disk devices as enumerated by the UEFI implementation.

What happens when you create a 4 SSD RAID10 and partition the resulting
single disk device into two equal halves, one partition for SuSE and on=
e
for Windows?  With everything on one disk device this should work much
more reliably.

--=20
Stan

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
