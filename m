From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Any pros or cons of using full disk versus partitons?
Date: Thu, 14 Apr 2011 14:30:07 +0600
Message-ID: <20110414143007.477e6dcd@natsu>
References: <07a801cbfa12$64b8a950$2e29fbf0$@gmail.com>
	<20110413.132112.102552472.davem@davemloft.net>
	<io52j7$cg4$1@dough.gmane.org>
	<BANLkTi=vgVxVRomvpkX5uxSvN9Fe1cgvoQ@mail.gmail.com>
	<20110414181159.48a2086e@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/EI84oxdiU2KzlsKbHaWKBS5"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110414181159.48a2086e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: CoolCold <coolthecold@gmail.com>, David Brown <david.brown@hesbynett.no>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/EI84oxdiU2KzlsKbHaWKBS5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 14 Apr 2011 18:11:59 +1000
NeilBrown <neilb@suse.de> wrote:

> On Thu, 14 Apr 2011 11:57:47 +0400 CoolCold <coolthecold@gmail.com> wrote:
>=20
> > Just my 2 cents: I've faced problems when newer disk was smaller than
> > old disk two or three times, so using partitions now with setting some
> > free space at the end - something near 80 or 100 megabytes.

There are also some Gigabyte motherboards which like to cut off a small
portion of a disk at the end via HPA, and writing a backup of their BIOS th=
ere.
https://encrypted.google.com/search?q=3Dgigabyte+bios+hpa
If you had your user data or mdadm metadata there, bad luck.

On earlier motherboards this was done automatically to every new disk on
SATA0, on newer ones I think it's optional and can be disabled. But anyway,=
 I
now prefer to leave about 8 MB of space at the end of each drive
unpartitioned, just in case.

And another point, again related to buggy BIOSes: some of them seem to read
first sectors of all attached disks and expect to see an MBR-style partition
table there; and if there's something else instead (e.g. basically random
data, in case of the whole disk used for RAID), they may become confused and
lock-up at boot. I had a couple of such cases where a board would lock-up
at HDD detection with a certain drive attached, and would only boot up
properly after it was zeroed and repartitioned.

>=20
> You don't need partitions to do this.  Just use the --size option to mdad=
m.

But then the 1.x+ metadata is still stored at the very end of the device,
which makes it vulnerable to the HPA problem described above.

--=20
With respect,
Roman

--Sig_/EI84oxdiU2KzlsKbHaWKBS5
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk2msI8ACgkQTLKSvz+PZwj63ACgh5lGAQiLbTiNbQeVP19I8cCe
qqwAn3xwbrJAQUWNv6HnQ+nhqxTGCKVb
=hIDH
-----END PGP SIGNATURE-----

--Sig_/EI84oxdiU2KzlsKbHaWKBS5--
