From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: RAID 5 - One drive dropped while replacing another
Date: Wed, 2 Feb 2011 04:36:05 +0500
Message-ID: <20110202043605.593f0c5c@natsu>
References: <AANLkTinXTYds442gPrs9a9vKtWTo4OcDHDEzvO0njvyv@mail.gmail.com>
	<AANLkTikSjLhoUM5f2ibqCUmo8XF-tsrhxZ7oieg08dtD@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/3mUb1wChNLpRRGVLFU8c+bB"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikSjLhoUM5f2ibqCUmo8XF-tsrhxZ7oieg08dtD@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bryan Wintermute <bryanwintermute@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/3mUb1wChNLpRRGVLFU8c+bB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 1 Feb 2011 15:27:50 -0800
Bryan Wintermute <bryanwintermute@gmail.com> wrote:

> I have a RAID5 setup with 15 drives.

Looks like you got the problem you were so desperately asking for, with this
crazy setup. :(

> Is there anything I can do to get around these bad sectors or force mdadm
> to ignore them to at least complete the recovery?

I suppose the second failed drive is still mostly alive, just has some
unreadable areas? If so, I suggest that you get another new clean drive, and
while your mdadm array is stopped, copy whatever you can with e.g. dd_rescue
from the semi-dead drive to this new one. Then remove the bad drive from the
system, and start the array with the new drive instead of the bad one.

--=20
With respect,
Roman

--Sig_/3mUb1wChNLpRRGVLFU8c+bB
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk1ImOUACgkQTLKSvz+PZwh3JQCfRq+B4KfQTLwdPZ3vBEmsmHb/
TbEAnRikteZh2ecFecYiV2cN+VNZCq6V
=tGJg
-----END PGP SIGNATURE-----

--Sig_/3mUb1wChNLpRRGVLFU8c+bB--
