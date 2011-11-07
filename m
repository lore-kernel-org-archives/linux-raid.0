From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] kill-subarray: fix, IMSM cannot kill-subarray with
 unsupported metadata
Date: Mon, 7 Nov 2011 12:34:11 +1100
Message-ID: <20111107123411.3751cd50@notabene.brown>
References: <F9123E44003394499FDD2B17C60621D4043755@IRSMSX101.ger.corp.intel.com>
	<20111031113151.64f566b1@notabene.brown>
	<F9123E44003394499FDD2B17C60621D4043D80@IRSMSX101.ger.corp.intel.com>
	<20111101154807.0cf42aa5@notabene.brown>
	<F9123E44003394499FDD2B17C60621D4044D82@IRSMSX101.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/wrIVnvdc5sesFSUr4l7eFqt"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F9123E44003394499FDD2B17C60621D4044D82@IRSMSX101.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Labun, Marcin" <Marcin.Labun@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Kwolek, Adam" <adam.kwolek@intel.com>
List-Id: linux-raid.ids

--Sig_/wrIVnvdc5sesFSUr4l7eFqt
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 3 Nov 2011 15:23:03 +0000 "Labun, Marcin" <Marcin.Labun@intel.com>
wrote:

> Hi Neil,
> This is OK.=20
> However, reshape_container (called from Grow_continue_command) ignores in=
fo that is chosen by subarray string given by user.
> Therefore, all container's arrays are possibly grown (including those we =
want to block)
> So we need to patch Grow_continue, so it performs grow on the array that =
user requested, not all arrays that are in the reshape process.
> Thanks,
> Marcin
>=20

I don't think I understand...

When continuing a grow the user shouldn't need to specify which subarray
needs to be continued.  That information is in the metadata.
So use just says "--grow --continue" and mdadm looks at the container to see
which arrays are in the middle of a reshape and continues those.
If one of them is such that the next array must be reshaped when this one
completes, that should just happen automatically too.

??

NeilBrown


--Sig_/wrIVnvdc5sesFSUr4l7eFqt
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTrc1kznsnt1WYoG5AQKKJQ/+LFVEvbln5Gt+iv9pvqA5K+LpPbUdEUNn
5Mm76AUoK3KidTXnoFzLLAU0wKhBO2medz6vt1e2PjSq9qA2Vngz0uqP+jpSGnbu
uUvZ3QNht7McH7gzJPPyR0pstMHB6uUU3UUL6iQNeyCiPE4jEwUjffK/tTc3Q60u
2gObyjOVA+wEcKvv6sd75DHW0wXYZu6O1gF37tRl01LS4XnwWzRlaaMn9tEAe5I5
oF4pmmtHoEtTCo1HgbrFqIRDUsUhVVdZdd0Kdy4jBcbuqd9RZZ4QzxQJi1+ffRm+
Nt5Gh0h9C5kVL/m4NNXGVWMzgzcBed9wSHP9xz2Nnf+e/JtaSeUjqL8ZOB3IMFAT
x8jO9pfgvo/j82RgsN9s0UPxCMZogmgdEgOyQNh15X9fjeDHD+VB/xTAyOjgjf0V
P/6ApvDA/7Nw4ZkGUjwE6UGGoXfKnrtcF9DTLqX+2mRvc7v8I149JXvVp3SKJWxp
ar9pOt9XEnK57jZKY58OA4eWcLA4Xg4SnHb7dHh/5KMQmc85M9oMLOtbN5h2Sutv
u5xC1022f+bpZbBhgV05gcFwMmNeBCbPLteKc6zQeIZ5hu3oTTc3tZH1PkO9/Zzo
jns4/jTH5mrjfO1EJv58vTBIrNCqFVcWjhGEJ7uhzpZdemViPqi9Qjtp1D+rJrDd
rF2eELQJ5c4=
=zRMA
-----END PGP SIGNATURE-----

--Sig_/wrIVnvdc5sesFSUr4l7eFqt--
