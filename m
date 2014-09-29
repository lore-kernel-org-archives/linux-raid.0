From: NeilBrown <neilb@suse.de>
Subject: Re: Raid5 hang in 3.14.19
Date: Mon, 29 Sep 2014 14:08:18 +1000
Message-ID: <20140929140818.1086972e@notabene.brown>
References: <5425E9D6.1050102@sbcglobal.net>
	<20140929122533.3b91a543@notabene.brown>
	<5428D863.7090409@sbcglobal.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/=JHfv65sunYqpFNmCl32Dyr"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5428D863.7090409@sbcglobal.net>
Sender: linux-raid-owner@vger.kernel.org
To: BillStuff <billstuff2001@sbcglobal.net>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/=JHfv65sunYqpFNmCl32Dyr
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 28 Sep 2014 22:56:19 -0500 BillStuff <billstuff2001@sbcglobal.net>
wrote:

> On 09/28/2014 09:25 PM, NeilBrown wrote:
> > On Fri, 26 Sep 2014 17:33:58 -0500 BillStuff <billstuff2001@sbcglobal.n=
et>
> > wrote:
> >
> >> Hi Neil,
> >>
> >> I found something that looks similar to the problem described in
> >> "Re: seems like a deadlock in workqueue when md do a flush" from Sept =
14th.
> >>
> >> It's on 3.14.19 with 7 recent patches for fixing raid1 recovery hangs.
> >>
> >> on this array:
> >> md3 : active raid5 sdf1[5] sde1[4] sdd1[3] sdc1[2] sdb1[1] sda1[0]
> >>         104171200 blocks level 5, 64k chunk, algorithm 2 [6/6] [UUUUUU]
> >>         bitmap: 1/5 pages [4KB], 2048KB chunk
> >>
> >> I was running a test doing parallel kernel builds, read/write loops, a=
nd
> >> disk add / remove / check loops,
> >> on both this array and a raid1 array.
> >>
> >> I was trying to stress test your recent raid1 fixes, which went well,
> >> but then after 5 days,
> >> the raid5 array hung up with this in dmesg:
> > I think this is different to the workqueue problem you mentioned, thoug=
h as I
> > don't know exactly what caused either I cannot be certain.
> >
> >   From the data you provided it looks like everything is waiting on
> > get_active_stripe(), or on a process that is waiting on that.
> > That seems pretty common whenever anything goes wrong in raid5 :-(
> >
> > The md3_raid5 task is listed as blocked, but not stack trace is given.
> > If the machine is still in the state, then
> >
> >   cat /proc/1698/stack
> >
> > might be useful.
> > (echo t > /proc/sysrq-trigger is always a good idea)
>=20
> Might this help? I believe the array was doing a "check" when things=20
> hung up.

It looks like it was trying to start doing a 'check'.
The 'resync' thread hadn't been started yet.
What is 'kthreadd' doing?
My guess is that it is in try_to_free_pages() waiting for writeout
for some xfs file page onto the md array ... which won't progress until
the thread gets started.

That would suggest that we need an async way to start threads...

Thanks,
NeilBrown


--Sig_/=JHfv65sunYqpFNmCl32Dyr
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVCjbMznsnt1WYoG5AQJ8kBAAoxanj3zt6V6N44gmzKFtR1PU1RgZKTFV
WEUrNbl1edjTrXAWxgSfbAcdYy51M47gSbf5OmzTyjtwyEziRmZUjjwcDHqP6Hax
UFopNI78JvhluBl/bhomwJKDFvzbIyrGAbbV3J4m4DNKkW74sZnJKbMuJhGRX7Wk
Yps6AuWyzXUWEaDtoa2r0p6qjv8IHa9vmyIsOKz86wvWkwOjoQVb1FhJzIUPGv33
zjIuMWyXxL1YxyTMjo6V48avkKV7o9rmmM8DJGVlQFKdpqJ7f/zl2lQCDEisC+XI
hUco363encSCrQfV8KRZfxis00oHlDnerd6M6mtjbokFhoBzC2KBa30WHbA0QRad
yHxOzzJ857IPmgI7u9yzhcG49dfhCS3IOKDWvhTPCGUnKK5nOgs6s1g17mxy/LT9
sZVJp2kKaOZLuyMUJkbo0zOPgOXCpq7bCX5jBvxSevyt3xYg6VYBWn/5/PPYZMbf
5J8ucSMDPpkInBrGgLJ2N9CppCAx9jWd53pUBq71NA6X8dwLZtdGFU6V6s+6LaKn
FDt1Tapo8CJ2ONu1DGuhuOGjXs/QtWGNHpYDUTJUULsy8HZY48dg3XbIudeMtCL7
C5e+Jr0qYsOTekokzrTadSNzTr1dGpVG5QHZCfFoFfvEy1Po7Sfa7seH0DIoo0Vr
ulSSvvY5wRE=
=byhs
-----END PGP SIGNATURE-----

--Sig_/=JHfv65sunYqpFNmCl32Dyr--
