From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: OT: silent data corruption reading from hard drives
Date: Thu, 2 Aug 2012 14:06:34 +0600
Message-ID: <20120802140634.6f729d07@natsu>
References: <50191ADE.10809@fastmail.fm>
	<5019D052.4000409@hardwarefreak.com>
	<20120802091917.32fb0ca5@natsu>
	<501A316C.3020305@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/tRwjjN2oqbODyzcbRrA6dkw"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <501A316C.3020305@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: matt <listy@fastmail.fm>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/tRwjjN2oqbODyzcbRrA6dkw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 02 Aug 2012 02:51:08 -0500
Stan Hoeppner <stan@hardwarefreak.com> wrote:

> I didn't say, nor imply such a thing.  You missed my point entirely
> about dollar amount.  It had two aspects:
>=20
> 1.  Some people are willing to spend hundreds or thousands on drives,
> then hook them to $15 controllers without giving that ratio a thought,
> no reflection upon the sanity of it.

Why should there be any reflection? There is no no automatic "Hmm, this thi=
ng
costs $XXX, so the other thing should also cost $XXX" rule.

$15 is simply the right price for a perfectly working 2 port SATA controller
(based on some of those chip models I named) on the market.

The rule is not "buy expensive", it's "avoid buying (known-)broken". Maybe
it's more difficult to come across a broken card in the expensive segment.
Maybe it's not. In any case my suggestion is to just do some research before
you buy, identify broken chips and cards, avoid those, and save yourself th=
ose
$185 or whatever.

> First, there are not "enterprise" controllers that use the Marvell SAS
> chip, period.  It's a low/mid cost, entry level 8 port SAS ASIC.  The
> cards based on it a not crappy, but actually pretty decent.  They run
> very well with Windows, *BSD, SCO, NetWare, and other OSes.  It just
> happens that the Linux driver, yes mv_sas, totally sucks

The end result for the user is the same, they accidentally buy that card, t=
hey
use GNU/Linux, they have to use that sucky driver. The best choice is to av=
oid
buying the card in the first place, but how do you know you should, if you
didn't do the research (see above) and just looked at the price tag.

> > Also, if you only use the mdadm software RAID, getting an enterprise ha=
rdware
> > RAID controller is truly a waste of money, unless you really need the e=
xtra
> > port density.
>=20
> That logic is flawed.  If you have an enterprise hardware RAID
> controller you're not going to use md/RAID, unless you're stitching LUNs
> together with linear or RAID0, as I often do.  In fact that's my most
> frequent use of md/RAID--concatenation of hardware RAID or SAN LUNs.

I do not recommend using hardware RAID. It locks you into one card/vendor,
usually is much less flexible than mdadm, and often even provides lower
performance. See http://linux.yyz.us/why-software-raid.html

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/tRwjjN2oqbODyzcbRrA6dkw
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlAaNQoACgkQTLKSvz+PZwgzUACeJG7CeNn3Kag26led0zA1bwvU
sOoAnA1Meo0EXQupS3T75LB4kdQbxxz6
=YOhv
-----END PGP SIGNATURE-----

--Sig_/tRwjjN2oqbODyzcbRrA6dkw--
