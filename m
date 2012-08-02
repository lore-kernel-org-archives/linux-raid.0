From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: OT: silent data corruption reading from hard drives
Date: Thu, 2 Aug 2012 09:19:17 +0600
Message-ID: <20120802091917.32fb0ca5@natsu>
References: <50191ADE.10809@fastmail.fm>
	<5019D052.4000409@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/njLROfOneLl=K8nnbl81dep"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5019D052.4000409@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: matt <listy@fastmail.fm>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/njLROfOneLl=K8nnbl81dep
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 01 Aug 2012 19:56:50 -0500
Stan Hoeppner <stan@hardwarefreak.com> wrote:

> On 8/1/2012 7:02 AM, matt wrote:
> > Is silent data corruption like this simply to be expected when using ch=
eap
> > commodity hardware?
>=20
> When you pay less than 1/4th the price of one drive for the controller
> card directing all your drives, is it really necessary to ask this questi=
on?
>=20
> Two large pizzas cost more than a Syba/Rosewill/Koutech/etc SATA card.
> The pizza is consumed in one night, maybe some for breakfast.  Would you
> trust a day worth of pizza with your RAID?  With your data?
>=20
> One tank of gas for the average car today costs $50, the same as two of
> these SATA cards.  The gas is gone in a week or two.  You want the cards
> to run for 2-4 years.
>=20
> Your drives cost anywhere from $400-$1000, yet your controller maybe
> $50.  Do I really need to say any more?  Spend $150-250 on a decent
> SAS/SATA controller such as an LSI or Adaptec and you won't have to
> worry about this kind of thing.

While you're at it also don't forget to get yourself some quality
Ethernet cabling, you don't want any data corruption on your LAN, do you
http://www.amazon.com/Denon-AKDL1-Dedicated-Link-Cable/dp/tech-data/B000I1X=
6PM/ref=3Dde_a_smtd

It's not a matter of "just pay more and all your problems will be solved".

There are some really crappy controllers even in the "enterprise" range
(e.g. those using the mv_sas driver). And there's a lot of $15 models giving
zero problems whatsoever (e.g. the ahci-compliant Marvell 88SE912x, JMicron
JMB36x).=20

Also, if you only use the mdadm software RAID, getting an enterprise hardwa=
re
RAID controller is truly a waste of money, unless you really need the extra
port density.

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/njLROfOneLl=K8nnbl81dep
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlAZ8bUACgkQTLKSvz+PZwiDSACeP7hzZIVlJ/yku78Y0XgkksZ/
tXoAn2SrtRqunpSIgX51z108i2MqlMDP
=1cZ7
-----END PGP SIGNATURE-----

--Sig_/njLROfOneLl=K8nnbl81dep--
