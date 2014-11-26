From: NeilBrown <neilb@suse.de>
Subject: Re:
Date: Thu, 27 Nov 2014 07:49:49 +1100
Message-ID: <20141127074949.7d437769@notabene.brown>
References: <CABGuBc=AJZzxR9W7frK_bdhaq24p1evsOBAdB1Otb4M2hbfqWg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/bqvKv3M+BQi4tAY37SiAFWo"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABGuBc=AJZzxR9W7frK_bdhaq24p1evsOBAdB1Otb4M2hbfqWg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Travis Williams <travis@euppc.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/bqvKv3M+BQi4tAY37SiAFWo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 26 Nov 2014 12:38:44 -0600 Travis Williams <travis@euppc.com> wrote:

> Hello all,
>=20
> I feel as though I must be missing something that I have had no luck
> finding all morning.
>=20
> When setting up arrays with spares in a spare-group, I'm having no
> luck finding a way to get that information from mdadm or mdstat. This
> becomes an issue when trying to write out configs and the like, or
> simply trying to get a feel for how arrays are setup on a system.
>=20
> Many tutorials/documentation/etc etc list using `mdadm --scan --detail
> >> /etc/mdadm/mdadm.conf` as a way to write out the running config for
> initialization at reboot.  There is never any of the spare-group
> information listed in that output. Is there another way to see what
> spare-group is included in a currently running array?
>=20
> It also isn't listed in `mdadm --scan`, or by `cat /proc/mdstat`
>=20
> I've primarily noticed this with Debian 7, with mdadm v3.2.5 - 18th
> May 2012. kernel 3.2.0-4.
>=20
> When I modify the mdadm.conf myself and add the 'spare-group' setting
> myself, the arrays work as expected, but I haven't been able to find a
> way to KNOW that they are currently running that way without failing
> drives out to see. This nearly burned me after a restart in one
> instance that I caught out of dumb luck before anything of value was
> lost.
>=20

mdadm.conf is the primary  location for spare-group information.
When "mdadm --monitor" is run, it reads that file and uses that information.
If you change the spare-group information in mdadm.conf, it would make sense
to restart "mdadm --monitor" so that it uses the updated information.

mdadm --scan --detail >> /etc/mdadm.conf

was only even meant to be a starting point - a guide.  You are still
responsible for your mdadm.conf file.

NeilBrown

--Sig_/bqvKv3M+BQi4tAY37SiAFWo
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVHY87Tnsnt1WYoG5AQLq/g//W4DumjMQZTpJXhMS2RXsniR/W+hhHX7k
DB2M3O+UtgBmYcauy4ohMuwn9OZmb1pgrv9aa0kpVHVSu7tLN1c1fAzQuJiYOYjg
QmVfDKcJHQUllra58t2VlmAA+9ZeruxXjeVE6yJTfn0JiApYJ3mWHPZ+H1jU5Cen
6o8xfgO/dhnhZitcmFLHUMXcVx3d9pLbzvF2phV4arwRvVhu+PYI0BKI1SNTWMB5
dUGYWYvGXzKzV4II5HJaU5o5DrS4kwJRDwMWgIAOGKb6IlwNuW6RIyXfhFc8N9fb
h67kWnT/i6jkZoQTqKqiW8fCsvRfT6A/KtMiwvW4b1GX71TsiPG3ri4DpwHEewv+
nYpq2+upxlWTPmpHw5Nr2nLnOvcwuGhKvzsy18O8TPOuBJNlTICC7wRZYOi7V/40
L2HG1wWs15lsoCBvsKS1ZJAjBAkzVk0zpjctvUri0rChluxeUa9GEAv2FHl5SeHa
C4GTb0trA8dbV1qf0/72gDYomh54kbq0WHcooy9c49gNwLdfInT9xTiB6/jx2Dgq
Hbo7kJQQoD1dBIvM7FK6DhoDLb2YgZlgvUJ4wpZpWE4fDyNeUJy4bVJcRbmSbdXy
5URMln/0+KNg3UfF295upQH7K+Y6ZVbZHEbQNW2MCH3E1Dy9KJClwb/DmkZJM14+
nUVrw7bujQk=
=wxQf
-----END PGP SIGNATURE-----

--Sig_/bqvKv3M+BQi4tAY37SiAFWo--
