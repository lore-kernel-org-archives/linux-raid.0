From: Andy Smith <andy@lug.org.uk>
Subject: Re: block level vs. file level
Date: Sun, 12 Feb 2006 21:31:57 +0000
Message-ID: <20060212213157.GX32687@strugglers.net>
References: <43EF8CFB.5080403@kfa.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cnZewGtz8xdCmwBG"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <43EF8CFB.5080403@kfa.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--cnZewGtz8xdCmwBG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 12, 2006 at 11:31:07AM -0800, it wrote:
> The hardware raid does the mirroring on the block level, so it's=20
> actually /dev/sda mirroring /dev/sdb - the whole drive, and not=20
> partitions. There is a way to set this up on software raid. It takes=20
> more configuration tweaking, but the mirroring then includes the=20
> partition table as well. This way, if a drive fails, one can replace it=
=20
> without pre-partitioning it.

That can be less flexible though.  If I have say 4 drives then I
quite often want small /boot, / and swap under RAID-1 then the rest
as a single large partition in RAID-5, -6 or -10 as an LVM PV.

> This also raises another point, which is relevant for both cases - same=
=20
> exact models of hard disks have different number of cylinders, so if a=20
> RAID partition is created on a larger drive it cannot be mirrored to a=20
> smaller drive.

Same exact models don't usually have different block counts, but
certainly if you replace a dead drive with a different one of the
same advertised capacity you can end up getting one slightly
smaller.

> Does anyone have any experience with this?

Yes, and it's a pain, but if you have to deal with it I think the
wealth of options in md leaves you better able to handle it than
with hardware RAID.  Here's something that happened to me:

http://strugglers.net/wiki/becks.strugglers.net

--=20
http://strugglers.net/wiki/Xen_hosting -- A Xen VPS hosting hobby
Encrypted mail welcome - keyid 0x604DE5DB

--cnZewGtz8xdCmwBG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFD76lNIJm2TL8VSQsRAhxaAKCOCQQ588jWnIfbL/Ex0Z0D0ipt0gCePRJd
KIuZV16qqOJltgV69yID87E=
=1QRC
-----END PGP SIGNATURE-----

--cnZewGtz8xdCmwBG--
