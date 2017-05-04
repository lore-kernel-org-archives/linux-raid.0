From: NeilBrown <neilb@suse.com>
Subject: Re: RAID creation resync behaviors
Date: Fri, 05 May 2017 07:57:32 +1000
Message-ID: <877f1wp9o3.fsf@notabene.neil.brown.name>
References: <20170503202748.7r243wj5h4polt6y@kernel.org> <fe3c30e4-b0dd-639e-7db7-344aa93ce198@hesbynett.no> <20170504015454.d4obiuume6e3yrdv@kernel.org> <590ADA3F.8070909@hesbynett.no>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <590ADA3F.8070909@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>, Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, jes.sorensen@gmail.com, neilb@suse.de
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Thu, May 04 2017, David Brown wrote:

>
> I have another couple of questions that might be relevant, but I am
> really not sure about the correct answers.
>
> First, if you have a stripe that you know is unused - it has not been
> written to since the array was created - could the raid layer safely
> return all zeros if an attempt was made to read the stripe?

"know is unused" and "it has not been written to since the array was
created" are not necessarily the same thing.

If I have some devices which used to have a RAID5 array but for which
the metadata got destroyed, I might carefully "create" a RAID5 over the
devices and then have access to my data.  This has been done more than
once - it is not just theoretical.

But if you really "know" it is unused, then returning zeros should be fine.

>
> Second, when syncing an unused stripe (such as during creation), rather
> than reading the old data and copying it or generating parities, could
> we simply write all zeros to all the blocks in the stripes?  For many
> SSDs, this is very efficient.

If you were happy to destroy whatever was there before (see above
recovery example for when you wouldn't), then it might be possible to
make this work.
You would need to be careful not to write zeros over a region that the
filesystem has already used.
That means you either disable all writes until the initialization
completes (waste of time), or you add complexity to track which strips
have been written and which haven't, and only initialise strips that have
not been written.  This complexity would only be used once in the entire
life of the RAID.  That might not be best use of resources.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlkLo88ACgkQOeye3VZi
gbnbow/+IT0XNJu/Ke52xfTz6Zs3EozbhRtir6o3mVVs1JVxWV24kN7VAJOdSsD9
VYRbS+ChiA/w6U/ZkvxylMsJucZRzC3/bgXhOG9VmFMvwwFlcpNnzfio8af+e9zV
TS2h5d9IqtrYLNOHDoGrmXXkFY4tB0OuxMGTzxTI4lDMsAS9o5mggvEgghBRgL1b
ewBcPJZuBiXhJx6mgtiEI/hEw4aP3fKjUX2VcDgWI97tauAN2jKNCD5go67VFqa6
AkOtiVub/FF1lTzy21TQBMxvCnCPFMmwqhIOJf2sdaA/gGYar1pXcYukjnOjI6mz
dAfNAm4wrdBOS4xV5r+wsn6t88Katiac53Eqrx8Oxk72k2WpDlA0bq3ngactgeFs
TLsu0M3Gzdu8NH6om9Ubgq6gE4KYm9ZWNJ2tYzZzr4mWkreZyjBEehJfh41Jl612
d1p47JJ/2/u2iA02jPFYkioKzN+bOoArOlL/3i1gpEOxeYta9vI4ZS4OQ9UEEYZ6
o8VM3jdecyjNMwbCkZQuERfdOL3Y7JJwZxctPichrdfxQsb+hhgyvMm+Ths/pJPn
ghsjcWyUhSJ6wbXmh8q0yvxsX461gN+DJdCyWShNBEX5iJ12dcfsqGvM53eM/cQz
hyTI9+X2wpHGEunX4Rgd+bEkqpVEubwKVr2AdF+u4BVF5lxhkBQ=
=eCFh
-----END PGP SIGNATURE-----
--=-=-=--
