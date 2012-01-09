From: NeilBrown <neilb@suse.de>
Subject: Re: recovery from multiple failures
Date: Mon, 9 Jan 2012 16:13:11 +1100
Message-ID: <20120109161311.77897c30@notabene.brown>
References: <eu9pt8xa4l.ln2@goaway.wombat.san-francisco.ca.us>
	<4F0A30CD.60904@turmel.org>
	<fatpt8x1so.ln2@goaway.wombat.san-francisco.ca.us>
	<qa8qt8xi1r.ln2@goaway.wombat.san-francisco.ca.us>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/0wLAh_okDk33bdJx2_+7PS6"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <qa8qt8xi1r.ln2@goaway.wombat.san-francisco.ca.us>
Sender: linux-raid-owner@vger.kernel.org
To: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/0wLAh_okDk33bdJx2_+7PS6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 08 Jan 2012 20:51:06 -0800 Keith Keller
<kkeller@wombat.san-francisco.ca.us> wrote:

> On 2012-01-09, Keith Keller <kkeller@wombat.san-francisco.ca.us> wrote:
> > md/raid:md0: cannot start dirty degraded array.
>=20
> Upon further reading (specifically man md), it looks like this is the
> tail reason for the array not starting--the kernel will refuse to start
> arrays in this condition.  If I'm reading the docs and other posts
> accurately, it seems like I can use a kernel parameter (since this isn't
> my /, I should also be able to unload and re-load the md module) to
> force the kernel to start the array, at which point in theory I should
> be able to work with it (including, ultimately, an xfs_repair if
> needed).  But OTOH, it seems like this parameter applies only to / on
> mdraid, and --force should have started the array, so I'm not really
> sure what to make of it.
>=20
> I've posted this before, but the kernel I'm using is fairly recent,
> 2.6.39-4.el5 from ELrepo.
>=20
> --keith
>=20

--assemble --force certainly should start dirty/degraded array.
There was a bug a while back where it didn't.  Maybe you should try a newer
mdadm.

Alternately:
=20
   echo 1 > /sys/module/md_mod/parameters/start_dirty_degraded=20


and try again.  That is an easy way to set the module parameter after the
module is loaded.

NeilBrown

--Sig_/0wLAh_okDk33bdJx2_+7PS6
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTwp3Zznsnt1WYoG5AQIa3hAAvXb/rjXnhqtz5NE8gUQYaYlHl78UtC5+
fOI8HI5USyuOSGkOByQ1KI81Tfxujbdz9JnwiJ6USdOZQ2JIRCZBm3enJOgXbUof
jPmunNeRBAcxdW4GrBbvZ1IWk4n5+2ZOsw8JfPiCGUp9kxQUxvwKrf4tvTJ5xNCh
rXdQdA0McWJlN36UU13dJMLjkEwHqMZrbChKYc/3/7XpkELVPcyXN8zl4M/eaw1j
2iRNnzGvIAOCBApYyFuFGFmOB7wtHav/rUwyn6y9Gf+oQtofBnatMDemhR7ad65C
rOwc8x23b1bxAQ4amDrrMrCAh/d4nuFOtvuEg+hM2IqjFgGcudYfpzvrX1KapmKA
7hNBm0XkuYKmkbp/oF50BLobdUDWKmjYMKYOcvYqOq/oOw8rsex2Trbk77fMebT9
Z3wGD/K+daRmHkvL+A6O5af8PYWy+WoQD0bUPSb5QnXOfuAojC3UN8wCZaIP0oRG
inIZeOux+eGdnEUz2pwbglbspF05y8TZGZ3yTJme4R2pat2grzoHZqczRyzjROdG
UyXzWRfksgu72BUGMNuC6WVmzEesC758O3Ta861rwzbiXtm8bzxGNOawisdry1ni
lH2Tsr6pJkY/iap8YEGnS7dNbgnIxaDWsCFpbSeGv/wAdLcaNt/X49j43Uo12dIP
HogEs3wNuJs=
=A10l
-----END PGP SIGNATURE-----

--Sig_/0wLAh_okDk33bdJx2_+7PS6--
