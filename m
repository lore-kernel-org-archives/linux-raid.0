From: NeilBrown <neilb@suse.de>
Subject: Re: possibly silly question (raid failover)
Date: Wed, 2 Nov 2011 09:25:26 +1100
Message-ID: <20111102092526.50b410b1@notabene.brown>
References: <4EAF3F78.5060900@meetinghouse.net>
	<j8odkj$46h$1@dough.gmane.org>
	<4EAFEE95.6070608@meetinghouse.net>
	<4EAFF636.6060904@anonymous.org.uk>
	<j8p0g3$9r4$1@dough.gmane.org>
	<4EB052E6.4050400@meetinghouse.net>
	<20111101221539.GA1319@www5.open-std.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ik60z2cWbie0QRDJddUgueO"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111101221539.GA1319@www5.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: keld@keldix.com
Cc: Miles Fidelman <mfidelman@meetinghouse.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/ik60z2cWbie0QRDJddUgueO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 1 Nov 2011 23:15:39 +0100 keld@keldix.com wrote:

> On Tue, Nov 01, 2011 at 04:13:26PM -0400, Miles Fidelman wrote:
> > David Brown wrote:
> > >
> > >No, md RAID10 does /not/ offer more redundancy than RAID1.  You are=20
> > >right that md RAID10 offers more than RAID1 (or traditional RAID0 over=
=20
> > >RAID1 sets) - but it is a convenience and performance benefit, not a=20
> > >redundancy benefit.  In particular, it lets you build RAID10 from any=
=20
> > >number of disks, not just two.  And it lets you stripe over all disks,=
=20
> > >improving performance for some loads (though not /all/ loads - if you=
=20
> > >have lots of concurrent small reads, you may be faster using plain=20
> > >RAID1).
>=20
> In fact raid10 mas a bit less redundancy than raid1+0.
> It is as far as I know built as raid0+1 with a disk layout
> where you can only loose eg 1 out of 4 disks, while raid1+0
> in some cases can lose 2 disks out of 4.

With md/raid10 you can in some case lose 2 out of 4 disks and survive, just
like raid1+0.

NeilBrown


>=20
> Also for lots of concurrent small reads raid10 can in some cases be somew=
hat
> faster than raid1, and AFAIK never slower than raid1.=20
>=20
> Best regards
> keld
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/ik60z2cWbie0QRDJddUgueO
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTrBx4Dnsnt1WYoG5AQLwbA/+PLtTnyRZ/KErjZSVRWf5Ub1fUeB35fio
yOGmgrBFj2ZO2YuDmFW2xyQl2yyPxlui3WEAQN2saSqIhG4Cg7f66qON3FT8eqGS
XCJ/zkC/7cY40+fqyJY+b1ut0IoaB3kj2gzAJZOrRBoqURx7JCkcYaYuTRPFMQOh
fFvX6eBG59eXH251+lTeQEvb/Wuvbc5XB3hmyeNQjvJmxAeDYN27gRARwBrrsKN3
jbEiGkyjuHz4LFIrr3rvoFcwsu9ik+iW1BCXaSJs9hbCreS7MS/q0U/0JMuNU84N
t6G4T5fvOgViwgwFjoq0ajrcYFj1CgupoQ3ARKkPpwc5i8vQGZeEZlgIuJBXlhb5
UOC8F5smjYjFpbwTGVfSd367tMbggGWaFkLlqOsJFp5DMdhyq9Yie/dEdE4g9V/l
tSXEVhaF3cTOxPa/mb+8EsBPaA90WZAcwAlnstKcMLOXE9bcpGJ9M+DaCyCqqrBX
lFnMxjbfsq8Mh41x/EhcBj0+tXJlK06Rdpg7f+TWEJSmSPwVQZ/kEGRU/xxVoxH3
LWQPyBPVfYnakcbNy4YuulqaNbO/gKErE+/myAohAxtlyxLdLKCtxR2QM1aDwNp7
8BgTcAOW+XA3TJB4LrSYEQJohLDck5z9fJ4rcRHwle+nm9lO/Zrg75zVnl2GtO55
dsJ5tlVyC2g=
=Rv38
-----END PGP SIGNATURE-----

--Sig_/ik60z2cWbie0QRDJddUgueO--
