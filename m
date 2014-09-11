From: NeilBrown <neilb@suse.de>
Subject: Re: Raid 1 vs Raid 10 single thread performance
Date: Thu, 11 Sep 2014 14:59:11 +1000
Message-ID: <20140911145911.47c0d857@notabene.brown>
References: <CAEp_DRAVPBvA34kgdjWqO6f6489SbmHQf-dFXC_SwSQd8e0C2w@mail.gmail.com>
	<20140911103110.42449c9e@notabene.brown>
	<CAEp_DRANDtdBCmRCqfiMeyfDg2+-q_EGsrs97QcE744Otqg0Og@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/aZL==FWMtrtcgz6BL2gnU1R"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAEp_DRANDtdBCmRCqfiMeyfDg2+-q_EGsrs97QcE744Otqg0Og@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bostjan Skufca <bostjan@a2o.si>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/aZL==FWMtrtcgz6BL2gnU1R
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 11 Sep 2014 06:48:31 +0200 Bostjan Skufca <bostjan@a2o.si> wrote:

> On 11 September 2014 02:31, NeilBrown <neilb@suse.de> wrote:
> > On Wed, 10 Sep 2014 23:24:11 +0200 Bostjan Skufca <bostjan@a2o.si> wrot=
e:
> >> What does "properly" actually mean?
> >> I was doing some benchmarks with various raid configurations and
> >> figured out that the order of devices submitted to creation command is
> >> significant. It also makes raid10 created in such mode reliable or
> >> unreliable to a device failure (not partition failure, device failure,
> >> which means that two raid underlying devices fail at once).
> >
> > I don't think you've really explained what "properly" means.  How exact=
ly do
> > you get better throughput?
> >
> > If you want double-speed single-thread throughput on 2 devices, then cr=
eate a
> > 2-device RAID10 with "--layout=3Df2".
>=20
> I went and retested a few things and I see I must have done something
> wrong before:
> - regardless whether I use --layout flag or not, and
> - regardless of device cli arg order at array creation time,
> =3D I always get double-speed single-thread throughput. Yaay!
>=20
> Anyway, the thing is that regardless of -using -layout=3Df2 or not,
> redundancy STILL depends on the order of command line arguments passed
> to mdadm --create.
> If I do:
> - "sda1 sdb1 sda2 sdb2" - redundandcy is ok
> - "sda1 sda2 sdb1 sdb2" - redundancy fails
>=20
> Is there a flag that ensures redundancy in this particular case?
> If not, don't you think the naive user (me, for example) would assume
> that code is smart enough to ensure basic redundancy, if there are at
> least two devices available?

I cannot guess what other people will assume.  I certainly cannot guard
against all possible incorrect assumptions.

If you create an array which doesn't have true redundancy you will get a
message from the kernel saying:

  %s: WARNING: %s appears to be on the same physical disk as %s.
  True protection against single-disk failure might be compromised.

Maybe mdadm could produce a similar message...


>=20
> Because, if someone wants only performance and no redundancy, they
> will look no further than raid 0. But raid10 strongly hints at
> redundancy being incorporated in it. (I admit this is anecdotal, based
> on my own experience and thought flow.)

I really don't think there is any value is splitting a device into multiple
partitions and putting more than one partition per device into an array.
Have you tried using just one partition per device, making a RAID10 with
--layout=3Df2 ??

NeilBrown


>=20
>=20
> b.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/aZL==FWMtrtcgz6BL2gnU1R
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVBEsHznsnt1WYoG5AQLl2Q//XYxFCt8oem4HzA/uANR9os9lGA1XBx6H
l7yqh8CRvg32QHaxhh2an35PC40hhtutfrbeLbMQZsaZlWKzA/gMSFIm6MG/3ePw
Z8J9vdCh/mCtWwo2Rpzwrj+iXRcXXmfp6cMMa/Ey+MWZbN7UpaICyUZzEYtPZ17w
uLWWg64D7yNgF+W6lOqTOh3fbl2jPt4PjQZ6cc/AXWW2tByzUDM77KyOkvHNhviG
wtzVfXr+oTbeCzeRbSg9Xk7iVhBzuw8nPKei18HvQ4VCP3pLNVTKqYISxlpQEPc4
U0qHWAHY8qHHDtE+gtY/tmxJlag72+LTO9S0KQpLX3YIaUFfYpQOMMg79VMXxkWR
U14HjBGASk+BXsSVD8Xoosspv32yUOiql0hcHc7p8wKScqlA8ehCR9mlY437Iyhy
Cc3eSxOCxY0ApfLuciVZcPhVOICoO0dQCkAz0OvwMITnHkJlMPVJMg9LlqvcqfD9
5jmvhBSFDBZTOlXziAcwiiiRIlyafd0VEK1f5g3CLZ60d/cL2DaL7jxOM6GEcVZD
FLBggzDT94xavI5hyntRGkTKIFnybIjBTPIwaosez5E8zrdq1v2VFplDHki4PAHu
0d1ATXZsBLIQVONs22DAQE7tC90sCztRG6nRTd23LHiUt7a04nnyGKjxYj3E65yA
CxmmAJpQsa8=
=Aa7J
-----END PGP SIGNATURE-----

--Sig_/aZL==FWMtrtcgz6BL2gnU1R--
