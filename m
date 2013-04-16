From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: RAID5 recovering
Date: Tue, 16 Apr 2013 14:30:35 +0600
Message-ID: <20130416143035.43533168@natsu>
References: <516C04FB.3030604@inserm.fr>
	<20130415151939.GA8383@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Xf+N4ARmUeSnT5lv/uDIMdg"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130415151939.GA8383@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Hill <robin@robinhill.me.uk>
Cc: Pierre Martineau <pierre.martineau@inserm.fr>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Xf+N4ARmUeSnT5lv/uDIMdg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 15 Apr 2013 16:19:39 +0100
Robin Hill <robin@robinhill.me.uk> wrote:

> Given the rebuild time for a 1To disk, I'd be wary of running RAID5 - if
> you have the space, adding another disk and going to RAID6 will be much
> safer.

As I see it, 3 disks is about the only configuration where RAID5 still does
make sense.

4 disks is a tricky spot, RAID5 already feels a bit too dangerous, but RAID6
is still not space-efficient enough.

5-disk (and more) RAID6 is the way to go, but changing from 3 disks to 5 or
more is not always justified requirements/cost/space-wise.

--=20
With respect,
Roman

--Sig_/Xf+N4ARmUeSnT5lv/uDIMdg
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlFtDCsACgkQTLKSvz+PZwhXrACdG5T6LLE9uBtkDjI0cNeiLRHy
ItIAn3V7JqANS8ZDlyxvbm882AD512yO
=aOa1
-----END PGP SIGNATURE-----

--Sig_/Xf+N4ARmUeSnT5lv/uDIMdg--
