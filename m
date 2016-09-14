From: Roman Mamedov <rm@romanrm.net>
Subject: Re: moving spares into group and checking spares
Date: Wed, 14 Sep 2016 23:22:49 +0500
Message-ID: <20160914232249.6e5fc568@natsu>
References: <nramjg$n07$1@blaine.gmane.org>
        <20160914092959.GA3584@metamorpher.de>
        <nrc2pm$2a9$1@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/NMrfV7JCyeINKcngcqFuu9N"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <nrc2pm$2a9$1@blaine.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: scar <scar@drigon.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/NMrfV7JCyeINKcngcqFuu9N
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 14 Sep 2016 10:52:55 -0700
scar <scar@drigon.com> wrote:

> i'm not sure what you're suggesting, that 4x 11+1 RAID5 arrays should be=
=20
> changed to 1x 46+2 RAID6 array?  that doesn't seem as safe to me

But you think an 11-member RAID5, let alone four of them joined by LVM is
safe? From a resiliency standpoint that setup is like insanity squared.

Considering that your expenses for redundancy are 8 disks at the moment, you
could go with 3x15-disk RAID6 with 2 shared hotspares, making overall
redundancy expense the same 8 disks -- but for a massively safer setup.

Also don't plan on having anything survive any of the joined arrays failure
(expecting to recover data from an FS which suddenly lost a third of itself
should never be part of any plan), and for that reason there is no point in
using LVM concatenation, might just as well join them using mdadm RAID0 and
at least gain the improved linear performance.

--=20
With respect,
Roman

--Sig_/NMrfV7JCyeINKcngcqFuu9N
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlfZlXwACgkQTLKSvz+PZwijqACfa3XihVrTkNUOLbLpWs34LcRh
dG0AnAnhMCjR9dP4I1AhS4cqMDHoRaRa
=ptsq
-----END PGP SIGNATURE-----

--Sig_/NMrfV7JCyeINKcngcqFuu9N--
