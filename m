From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Possible to change chunk size on RAID-1 without re-init or
 destructive result?
Date: Wed, 27 Mar 2013 12:02:52 +0600
Message-ID: <20130327120252.57c78c34@natsu>
References: <CAFCYAsfriik8VAPV9MVhsDtgqHTaKs3kzYoSLVQHaiYKfzjXZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Lvg2saC=0Jyh4WRsY3AUe2j"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFCYAsfriik8VAPV9MVhsDtgqHTaKs3kzYoSLVQHaiYKfzjXZw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Johnson <jeff.johnson@aeoncomputing.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Lvg2saC=0Jyh4WRsY3AUe2j
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 26 Mar 2013 22:30:01 -0700
Jeff Johnson <jeff.johnson@aeoncomputing.com> wrote:

> I have a RAID-1, two disk volume that was created with a strange chunk
> size. For reasons I won't go into here removing the data and
> redefining a new RAID-1 volume with a different chunk size is
> presently not a viable option.

You can always fail and remove one member, make a new degraded RAID1 on it,
'dd' data from one RAID1 to the other, kill the old RAID1, add the remaining
drive to the new RAID1.

Do a full backup beforehand, of course.


--=20
With respect,
Roman

--Sig_/Lvg2saC=0Jyh4WRsY3AUe2j
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlFSi4wACgkQTLKSvz+PZwhgqgCfSv9S9X80wEKhqtrwQ1ZTfbQP
D/wAnR5lUyA8dXdFaPuGSmA2zUf4cqGD
=0Huh
-----END PGP SIGNATURE-----

--Sig_/Lvg2saC=0Jyh4WRsY3AUe2j--
