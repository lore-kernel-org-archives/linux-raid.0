From: hpa@zytor.com (H. Peter Anvin)
Subject: Re: Adding Reed-Solomon Personality to MD, need help/advice
Date: Sat, 31 Jan 2004 07:20:05 +0000 (UTC)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <bvfkv5$bfm$1@terminus.zytor.com>
References: <6.0.1.1.2.20040130235924.03f39710@mail.athenet.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

=46ollowup to:  <6.0.1.1.2.20040130235924.03f39710@mail.athenet.net>
By author:    Nathan Lewis <nathapl@cs.okstate.edu>
In newsgroup: linux.dev.raid
>
> As part of my Master's thesis, I am working on adding a Reed-Solomon=20
> personality to the existing linux RAID structure and I would like som=
e=20
> assistance.  I'll try to keep this as brief as possible, but I apolog=
ize if=20
> it gets long-winded.
>=20

I'm curious what... what is the intended mode of operation of your R-S
personality?

>
> So far, I've managed to add and register a personality with md, which=
=20
> involved a few minor changes to md.c and related header files, a few=20
> changes to mdadm to allow me to access things from userland.  I've=20
> discovered the 9 functions I need to implement (make_request, run, st=
op,=20
> etc), and managed to "successfully" create an md device using only st=
ub=20
> functions.  So far so good.  Just for reference, I'm using kernel 2.4=
=2E22.
>=20

I would advice you to try a 2.6 kernel instead.  You might find it
useful to compare raid5.c to raid6main.c in those kernels.

	-hpa
--=20
PGP public key available - finger hpa@zytor.com
Key fingerprint: 2047/2A960705 BA 03 D3 2C 14 A8 A8 BD  1E DF FE 69 EE =
35 BD 74
"The earth is but one country, and mankind its citizens."  --  Bah=E1'u=
'll=E1h
Just Say No to Morden * The Shadows were defeated -- Babylon 5 is renew=
ed!!
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
