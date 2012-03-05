From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Subject: Re: grub2/grub-pc install not possible on mdadm
Date: Mon, 5 Mar 2012 11:14:02 +0100
Message-ID: <20120305111402.e63fee5b49046ed146cb9dcc@bbaw.de>
References: <4F4C9A11.9060302@profihost.ag>
	<4F4F4B1D.4050000@redhat.com>
	<4F4F4EB3.6030909@profihost.ag>
	<4F4F519E.7040206@redhat.com>
	<4F508864.4050600@profihost.ag>
	<20120302100648.fe4e725f2e98880c839357b0@bbaw.de>
	<4F508EB6.2030101@profihost.ag>
	<4F5091BF.1000102@anonymous.org.uk>
	<4F509402.8070503@profihost.ag>
	<4F50ABA3.1070603@anonymous.org.uk>
	<4F50C7DC.3000700@profihost.ag>
	<20120302163236.3555fec1296cbe30d8d37972@bbaw.de>
	<4F547038.7060009@profihost.ag>
	<4F54899A.4040301@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F54899A.4040301@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: John Robinson <john.robinson@anonymous.org.uk>
List-Id: linux-raid.ids

Hi John,

Am Mon, 05 Mar 2012 09:38:34 +0000
John Robinson <john.robinson@anonymous.org.uk> schrieb:
> On 05/03/2012 07:50, Stefan Priebe - Profihost AG wrote:
> > Am 02.03.2012 16:32, schrieb Lars T=C3=A4uber:
> >> Hi Stefan,
> >>
> >> the metadata versions 1.0 and 1.1 and 1.2 are the same but for the
> >> position of the metadata on disk. Simply use metadata version 1.0 =
and
> >> everything works as with 0.9.
> >>
> >> Grub does to read partition tables inside raid devices.
>=20
> Sure it does, but that's not the point.

that's new to me. This is true for grub2 only?
You mean if Stefan would have used an old fashioned partition table ins=
ide a
Linux SW-RAID with metadata 1.2, grub would have booted like normal?

=20
> >> Because a raid1 with metadata 1.0 or 0.9 looks like a plain disk t=
o grub
> >> it can read a partition table like there was no raid array.
>=20
> For the fourth time, no.
>
> Because a RAID1 with metadata 0.9 or 1.0 looks like a plain disc to t=
he=20
> BIOS, it can read a partition table like there was no RAID array, and=
=20
> therefore the BIOS can load GRUB.

This might be true for UEFI firmware but for the plain old BIOS too?
I thought the BIOS isn't interested in partitions at all.

Lars
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
