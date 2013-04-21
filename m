From: NeilBrown <neilb@suse.de>
Subject: Re: md RAID5: Disk wrongly marked "spare", need to force re-add it
Date: Mon, 22 Apr 2013 07:50:26 +1000
Message-ID: <20130422075026.04b63081@notabene.brown>
References: <516869D2.9030506@bucksch.org>
	<516B3077.9020507@schinagl.nl>
	<516B590C.5060807@bucksch.org>
	<516AE7A0.4070504@schinagl.nl>
	<516BD5E0.4040007@bucksch.org>
	<516FF25B.4000907@bucksch.org>
	<516FFC13.2030803@ultratux.net>
	<5171CB91.1040708@bucksch.org>
	<5171EED3.8030505@bucksch.org>
	<5171F52D.4040701@bucksch.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/aJpbgoi0+WCKp_XwVNtrsMP"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5171F52D.4040701@bucksch.org>
Sender: linux-raid-owner@vger.kernel.org
To: Ben Bucksch <linux.news@bucksch.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/aJpbgoi0+WCKp_XwVNtrsMP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 20 Apr 2013 03:53:49 +0200 Ben Bucksch <linux.news@bucksch.org> wro=
te:

> Ben Bucksch wrote, On 20.04.2013 03:26:
> > I can read my files again, without problem, all is happy.=20
>=20
> Actually, no. XFS filesystem structure is not sane. I must have done=20
> something wrong. (If possible, please let me know what, all data should=20
> be posted.)
>=20
> At first, it looked OK, as if only one recently written directory was=20
> broken. I unmounted one of the FS, did xfs_repair, and after=20
> re-mounting, almost all directories are gone. Almost 100% dataloss. I=20
> can't describe how upset I am against md.

So data was accessible before "xfs_repair", is not accessible after
'xfs_repair', yet you blame md rather than xfs_repair?  Interesting.

You've clearly had a bad experience - I'm sorry about that.
I doubt there is anything you can do to unrepair whatever xfs_repair did, b=
ut
the place to ask would be on the xfs list.

NeilBrown

>=20
> Oh, and in case you're wondering about my backup: That's gone, too, due=20
> to bugs in btrfs that trashed the FS and also stopped the dedicated=20
> backup machine from booting automatically, so I don't have any current=20
> backup either.
>=20
> Ben
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/aJpbgoi0+WCKp_XwVNtrsMP
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUXRfIjnsnt1WYoG5AQIKHQ/9HbFfCgfBrDXAsVsK9zAfw2pDFYU5/KTG
RtsiFnLcJNK86VJN7siYgxir08rW5h2L7hjRmP6E+bnSTDzDdGCiZV6cbuiPwlBL
91YidkTAz2EyGCAjyGSEzznfIttqZJajBRksi07AQoHLUfsEil1tVZa9eFnut+Jb
I430lFV56qiHR5XjPQLKwYmraB0TISh17jqrHxSe1B9VT7Y6h7orOcxLOgz5qD2b
JuHL6ARZ7JYk3NkqWHcycqy6yKMuJFyT7b0cdflMvRQHZXDfSQJsGcovjxcwIoxY
ll1lGWhxGB1muzLNaKM2pKQmLHJi4bDTkrhK/lZuPV0fzd1tM8R5gBw32lmb4Ky6
X3y83CEYxSlShMCIMdYo7n7fM3C3+HmjfIr4joO/E7Dvtwkwue7ZriwnJdErwOLL
ytmInQvw+vfZSnCJR7JCNW/KLw2BPtHKWu/Hr0mjbFb4sBwzgVxDdTYV6zsbyWhp
fDhAH3PB4FUZhEYjS57UMuyI8oWkyszTyE9ipszil0gCcxVV8jV1j+fJPF4lSa8Z
F0SBorsJNbtZ5iO6ypWR3G/cva6vNvWXSEFxkzu4sAH7hD3Uk7tTEGzagCiLViSh
tuk3FVawF/kZQmmwqwp1to5B3c2CiB29ZQHW0hNVVBddC0inP4dAxz8NuQv70JpT
I8Yi/IsCBbU=
=1lPi
-----END PGP SIGNATURE-----

--Sig_/aJpbgoi0+WCKp_XwVNtrsMP--
