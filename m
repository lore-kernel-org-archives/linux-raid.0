From: NeilBrown <neilb@suse.de>
Subject: Re: MD Raid1 hangs system on read error (3.10)
Date: Mon, 6 Oct 2014 11:08:33 +1100
Message-ID: <20141006110833.5028706c@notabene.brown>
References: <20141005092700.GA1452@login.tika.stderr.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/SMyvPQOhnvUGK7w0L3vCeQ/"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141005092700.GA1452@login.tika.stderr.nl>
Sender: linux-raid-owner@vger.kernel.org
To: Matthijs Kooijman <matthijs@stdin.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/SMyvPQOhnvUGK7w0L3vCeQ/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 5 Oct 2014 11:27:01 +0200 Matthijs Kooijman <matthijs@stdin.nl> wro=
te:

> Hey folks,
>=20
> a few times now I've found my system being locked up after a read error
> from a hard disk. It looks like the MD code that handles the read error
> messes up and causes a GPF.
>=20
> After this happens, the system becomes completely unresponsive - it
> responds to ping and opens TCP connections, but no data comes out. The
> serial console also gives no response.
>=20
> After rebooting, the disk in question showed a pending sector. In the
> most recent occurence, I found that the array was also resyncing. I'm
> not sure if this also happened in the earlier occurences (but since the
> pending sector didn't disappear in the next day, I'd expect no resync
> happened before). The read errors always happened during a routine check
> of the array.

That last sentence is the clue I needed - thanks.

You are running 3.10.3.  It contains a bug that was fixed in 3.10.32.

http://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/=
?id=3D9f2d289933e60ec726a7a9522e2dcdfdc82c58de

So if you upgrade your kernel, the problem should be gone.

NeilBrown

--Sig_/SMyvPQOhnvUGK7w0L3vCeQ/
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVDHdgTnsnt1WYoG5AQL+sQ/9EAtW/1xTVvJ5gcCi1M1urvtinZHAQ1OB
N2EhK2mClEBOjjYZ9Zjcah9dxOfWWBZUm9FfMFZrTwSIepuo66+9edYZPpVxLeyk
2yXoxm2j3NmWuxV8Gny/gFsAGjyjmtATqrEYYxOInq3XyLtVBr+nUXyOBAn+hXad
6YrI3fqXW1k4jaAVIoCgM/J4UZRpJODJnK1tkKK9+CR4Ch92S5zQgoxh9fuJ9TUj
GtXyOkeVr1wD0oSuOvhlXPtbrvgZdAQDvffCdoRwxLIi67QNWmxYbB6gVY2e1CcP
l6AfiSylnizgJUbR6UlZW805mUto3dUrRiwZ87jSwzr3Wgve3Wh9rOgENL01VlW5
0qQlWXEhmmw+TxckMx3vhaRgnnKamEw+Ly0eGusSSfwMMIBOiqKzhWcfanvHM6La
847HjBRIPXmJG28ZWZz6OEraoME2XKZkZcKZy3i+JCQy/ZmDHZ3oy3OqKbsJoisq
TPVE04aKDEIrLAa7RqyidD3MCbLy2uHfcSEWD9NTksgTY4mrySg9ajEoK6bOfu68
bk/yJpMCycnDIMOjLcTwaXKuftB3aWCqiG3aORqMPLa7j+kTdM0KITLSf/5l8rPS
JZlp1Omt89GrFnws5uEZuraotd0SpZtEMDyVwUmeCvpkd7GGu32X99q0OWccZ4BR
8ThYSk8vT6Q=
=k7t7
-----END PGP SIGNATURE-----

--Sig_/SMyvPQOhnvUGK7w0L3vCeQ/--
