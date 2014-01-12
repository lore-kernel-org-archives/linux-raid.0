From: NeilBrown <neilb@suse.de>
Subject: Re: RAID 10 far and offset on-disk layouts
Date: Mon, 13 Jan 2014 10:20:21 +1100
Message-ID: <20140113102021.1ef3e203@notabene.brown>
References: <52BD8EDD.10809@assyoma.it>
	<20131227151927.GA4003@www5.open-std.org>
	<52BD9B4F.3000509@assyoma.it>
	<20131227154952.GA6539@www5.open-std.org>
	<52CE57D9.1030501@assyoma.it>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/TT9gHQh_heeX7uQVxHAFFRA"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52CE57D9.1030501@assyoma.it>
Sender: linux-raid-owner@vger.kernel.org
To: Gionatan Danti <g.danti@assyoma.it>
Cc: linux-raid@vger.kernel.org, keld@keldix.com
List-Id: linux-raid.ids

--Sig_/TT9gHQh_heeX7uQVxHAFFRA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 09 Jan 2014 09:03:37 +0100 Gionatan Danti <g.danti@assyoma.it> wrot=
e:

> >>
> >> Interesting. Two question:
> >> 1) from which kernel the layout is the one depicted by Wikipedia?

Exactly what depiction in wikipedia are you referring to?  A link to the
image might help.

> >> 2) it is possible, using mdadm, check what "far" layout is in use?

mdadm --detail /dev/mdWHATEVER | grep Layout


> >
> > I cannot answer that. Neil Brown should know.
> >
> > Best regards
> > Keld
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
>=20
> Hi all,
> anyone with an update on these two questions?
>=20
> I was thinking to use the kernel block trace facility to track disk=20
> access and infer the on-disk data structure, but I haven't tried for now.
>=20
> On the other hand, I carefully looked at mdadm output, without finding=20
> anything related to physical block placing.

Look for "Layout".

NeilBrown


>=20
> Any new advices on that regard?
> Thanks.
>=20


--Sig_/TT9gHQh_heeX7uQVxHAFFRA
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUtMjNTnsnt1WYoG5AQJlcA//dmUG+lpb4UqjueS0KyGjj1YOFlUiQ0S3
m0FIb2PZAe66o5/48Uk3m5m0URpgH8xsLn8iXTWn3NHGGkN5Hj9JwlVJdqV8/xxI
BYSx+R0rDGfJXPKyclJrf/YWnzvPhpe1+JDJB4qj9+TUznMoK6qC9osstDp2CQc9
SmqGbADALFyxqvfcyt/O85cDfHvxmeg/9NJfzWNBKrT0Ed//nmmloYyrD9ZhKkvW
4ca5Ky+BIKrKXzgaYnUCkZxcXzDhS+5jBYxgbPei1RcNMQ/WvEhf9JxT+NdZWW6f
ySh5jZ8Qto24oREf5l+N8ZhiM1q+ThQclZO5aM/DjC2LW2E/IfiF+WMtfDU2YjEF
WGiqOGmX5tX7nTtjyr8vYUXnNRQb7rGc9EO/dbBpti7SmWavlhw6odPEM6Fk0Blf
gUEzvpKwdB8tV+vp1KSb64qfRbMo7aGNAD/jyCSBHJXO+s9+UWRl0EJ7a9jmtRd9
ntsDtO3hxa2uLr6viNDPPFbVfzTl0m+Bztn+Ea9c1+P2peiYFfb6tnlholcFibit
sunLV+wSfqjCmwYDfuzd211xXLWnyJcsmolvlVFyyJjnMVsflre2W21HRLVq+QOw
jHJp6ZfVMx5Sr2uhFmal7wtzCxULmxY2ZwJcH39GzajYTo9xZOaZnB+sZum8Og9K
MsmuI76b+9A=
=IxSI
-----END PGP SIGNATURE-----

--Sig_/TT9gHQh_heeX7uQVxHAFFRA--
