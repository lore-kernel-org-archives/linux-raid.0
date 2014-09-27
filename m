From: NeilBrown <neilb@suse.de>
Subject: Re: [GIT PULL REQUEST] late md/raid1 bug fixes for 3.17
Date: Sat, 27 Sep 2014 10:09:23 +1000
Message-ID: <20140927100923.5238a4e9@notabene.brown>
References: <20140924121805.1b8c3bd9@notabene.brown>
	<5425B998.7080304@sbcglobal.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/o2CcMRCnIKPpBS/GbhlbJnR"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5425B998.7080304@sbcglobal.net>
Sender: linux-raid-owner@vger.kernel.org
To: BillStuff <billstuff2001@sbcglobal.net>
Cc: linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/o2CcMRCnIKPpBS/GbhlbJnR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 26 Sep 2014 14:08:08 -0500 BillStuff <billstuff2001@sbcglobal.net>
wrote:

> On 09/23/2014 09:18 PM, NeilBrown wrote:
> [snip]
> >        md/raid1: intialise start_next_window for READ case to avoid hang
> >
>=20
> Neil, I've been testing these patches for the past week or two to see if=
=20
> they help a raid1 "check" hang I had.
>=20
> They seem to help, but I noticed the above patch is different from what=20
> you originally sent on the list.
>=20
> The original patch has an extra chunk:
>=20
> @@ -1444,6 +1445,7 @@ read_again:
> 		r1_bio->state =3D 0;
> 		r1_bio->mddev =3D mddev;
> 		r1_bio->sector =3D bio->bi_iter.bi_sector + sectors_handled;
> +		start_next_window =3D wait_barrier(conf, bio);
> 		goto retry_write;
> 	}
>=20
> Is the correct patch with or without this chunk?
>=20
> Thanks,
> Bill

That hunk was wrong.
This new r1_bio is attached to the previous one and they all complete (and
particularly all "allow_barrier") as a unit.  So only one wait_barrier is
needed.

That chunk only has any affect if you have a bad-blocks list with bad blocks
in it, and try to write a range of the device which includes the bad block.

Thanks,
NeilBrown

--Sig_/o2CcMRCnIKPpBS/GbhlbJnR
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVCYAODnsnt1WYoG5AQLCug//fhKV6/R99QSWAHcBxSD9rF9QZ7I4NL8z
Q5ewhpgnsnjz4MIsoSrt62qa9Pz3yekbyIzFHNnsVl4HksKQFgNwGBUth+14f9Cr
4cscHlpSnKCOlCA9Zgr+izWtkc6WLu1Ow1J11WRvattLbqjtQYMZTPYOh0NzCikY
pFJvpqcJAa3fMZ/NG67vJCVHJqb+SVFn9gT/oLmEfYYQNrbrdTscbsAeiVHMbssT
fHKVMFmRkuel687OpxxBRmqLdJDdqF/mIcQPAIu9423G1l9vVB5xEWup0YWP/jmF
K7cvdhXnpbwrt+YIjxtyKKNir1ibIZUQJc/N+Cz6ymRsbd0En4NU+5/w5FHKzSGw
0kuTdE5hcwRX6NtyeZCd/C/Tv9h55KCcV+mfQxXhRTsUZJjCQnpQ4dS0IOY7/XjI
Kq+orsJl8lkUesGhHTJIZ2Ybmuwuf614ew+8jxptj5+DsarnH3+N8zeItnx7vnRm
nzpoYDatv3hy+fXsveOuQ3QBdjQodg+x/PMdKQbjDQFyIy3oIJ1tPNK7z3ojpc/G
jpw5vurn2BMO8khEzgt6Ge9WP+MsXF5HiFusoQHzmUzun8CrgGMghKoJ8BDie3Cw
A6ZcoZmoma2/hBGf9/z/9ICOCW67UOyT8Z3juOClSTK7nOJ++3iPNFBpzcdCJP0O
dx8uiQVRGN8=
=8kkV
-----END PGP SIGNATURE-----

--Sig_/o2CcMRCnIKPpBS/GbhlbJnR--
