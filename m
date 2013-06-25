From: NeilBrown <neilb@suse.de>
Subject: Re: Scrubbing "check" not working for RAID10 in 3.10-rc1+
Date: Tue, 25 Jun 2013 16:32:21 +1000
Message-ID: <20130625163221.6f25f83d@notabene.brown>
References: <1372141160.2016.0.camel@f16>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/nOktL70_1ppXbvmMwhBt2d1"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1372141160.2016.0.camel@f16>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/nOktL70_1ppXbvmMwhBt2d1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 25 Jun 2013 01:19:20 -0500 Jonathan Brassow <jbrassow@redhat.com>
wrote:

> Neil,
>=20
> I've noticed that the "check" operation no longer works for RAID10.  It
> works just fine for the other RAIDs.  The ("data-check") sync_thread
> kicks off just fine, sync_request_write() is called, but it never gets
> past:
>         if (i =3D=3D conf->copies)
>                 goto done;
> The test I am performing creates a RAID array, waits for it to sync,
> shuts it down, writes random data to one of the devices, assembles the
> array, and then runs a "check" - there should be descrepancies.  The
> descrepancies are found and recorded in resync_mismatches for all RAIDs
> <=3D 3.9 and only for non-RAID10 3.10-rc1+.

I just tried on 3.10-rc5+ and it works as expected.
If you can provide a test script that fails, I'll look into it.

>=20
> I'm sorry I haven't tracked it down yet and I'm going to be on vacation
> starting tomorrow with only intermittent access to e-mail.  Sorry to
> leave you hanging.

Go enjoy your vacation and don't worry about me hanging :-)

>=20
> Thanks,
>  brassow
>=20
> P.S.  This also reminded me of a patch I have concerning tracking the
> last sync action for the purpose of making mismatch_count more useful.
> I'll post that before leaving.
>=20

Thanks.

NeilBrown

--Sig_/nOktL70_1ppXbvmMwhBt2d1
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUck5dTnsnt1WYoG5AQI7ThAAtBWmWtvszEM49K0ZEr1ByDspcevlCLUS
EFd5DJZUO+j7L8v7STiT69eQwdekNiKORj/G+DdgTW7yIoBakgAuhpnzHHXW4Prl
I0JmiTnWDKFYkmJxbaKjeRxqFfjonSY4zDlgurB0K6k5ht5AqjboeUGooHbLoDp3
P00MXiqzz7JobuRTPt7ZPOxxivxvisPN5JlbQKEoPJj1jVZLpz9yIdzYczWmigec
JadBj17X+9ROvdyVNhRX5YlXtxQwZX3Zg2C2pWoFGVmce0ncgC1G/r+gpLmShbEC
LhKUD8CZZsy/4dtdS7daplojGjQHRt/8y5jnxZxsx5YXx5+otHg8Fo599BIVb3+W
J7+tKbXCjRJGFThcAayDAFHShDJCH+pRF/+0VX4vnNB+btzTHyQBUnbFvmWmFTes
8YH2u9PPK5CQ1KauUERn+OV3GTHyiIeMOvzRnWvwTW0304gumLpX/5MmoXaHLXkX
M2624XKmK/EreT2O/9Srik4CdcxS2EB/hB9u+3OIr+ScUqwfbqFtsa9P04dA0WgK
pU+i2C/I3h1ObesoSf+3FDOltSjtTP0RMfuGTcsHZEqJbBf0rB3AC87pcYNDxMh4
+iGRYXAkAoQ0CxHFPpyqJZCIav5+JA6IkEpfb9S80xcZvWlAmPeCzNEw7CK3y5/9
p4qaURi4wGk=
=QK6S
-----END PGP SIGNATURE-----

--Sig_/nOktL70_1ppXbvmMwhBt2d1--
