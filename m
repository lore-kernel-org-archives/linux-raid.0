From: NeilBrown <neilb@suse.de>
Subject: Re: Need to remove failed disk from RAID5 array
Date: Fri, 20 Jul 2012 11:37:17 +1000
Message-ID: <20120720113717.7888da79@notabene.brown>
References: <CAB1R3shxBWebm13ie5gR0h++-GBTyfZrranHr8tjGkbPipV32w@mail.gmail.com>
	<50071C0A.8080307@tmr.com>
	<CAB1R3sjhES1+0XB43oXLomgH7Q6LPiTm11tPSoDJ91RRrfNy=A@mail.gmail.com>
	<20120719091611.22e16100@natsu>
	<500818D5.4080208@tmr.com>
	<20120720070801.498902ba@notabene.brown>
	<CAB1R3sgV9e9Ngvh+H6VtDB=mSfvPC8S3hafOncasz+EmTWRA-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Lqvv88ywWZ7XEAZC_2Y/9cg"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAB1R3sgV9e9Ngvh+H6VtDB=mSfvPC8S3hafOncasz+EmTWRA-A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alex <mysqlstudent@gmail.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Roman Mamedov <rm@romanrm.ru>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/Lqvv88ywWZ7XEAZC_2Y/9cg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 19 Jul 2012 21:04:17 -0400 Alex <mysqlstudent@gmail.com> wrote:

> Hi,
>=20
> >> That's a good argument for not using "whole disk" array members, a par=
tition can
> >> be started at a good offset and may perform better. As for the speed, =
since it
> >> is reconstructing the array data (hope the other drives are okay), eve=
ry block
> >> written requires three blocks read and a reconstruct in cpu and memory=
. You can
> >> use "blockdev" to increase readahead, and set the devices to use the d=
eadline
> >> scheduler, that _may_ improve things somewhat, but you have to read th=
ree block
> >> to write one, so it's not going to be fast.
> >>
> >
> > Read-ahead has absolutely no effect in this context.
> >
> > Read-ahead is a function of the page cache.  When filling the page cach=
e,
> > read-ahead suggests how much more to be read than has been asked for.
> >
> > resync/recovery does not use the page cache, consequently the readahead
> > setting is irrelevant.
> >
> > IO scheduler choice may make a difference.
>=20
> It's already set for cfq. I assume that would be the preferred over deadl=
ine?

The one that is preferred is the one that works best.  I suggest trying them
all and seeing what effect they have on your workload.

>=20
> I set it on the actual disk devices. Should I also set it on md0/1
> devices as well? It is currently 'none'.
>=20
> /sys/devices/virtual/block/md0/queue/scheduler

The queue/scheduler is meaningless for md devices.  They do not use the
block-layer queuing code.
The queue/scheduler setting on the actual devices is meaningful.

NeilBrown


--Sig_/Lqvv88ywWZ7XEAZC_2Y/9cg
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUAi2TTnsnt1WYoG5AQJb6RAAj7QNJ+Alm2GtuJNc1aSjbLvQGgriKHp8
d0QGV28nnCRrNoMV9uap3buyW8ibdYTzHHYAFbWaO6hcmHVcPbak/RUgLJtO1GWa
n4AMq7nib/HrSXPLhbhEtS0+nvedIo+PTMos8fJRpT0IM64xPP/8i05k9OFYE0TW
Amg6YtOXSnsWCn0d/2CzVYzFBNG4RrSzJgXmcpKBVkkvr+s55UmyD3vneRziOgho
19pm+540fVY99h8Wi1NZ2OXbk6A+2MvYKLH7jKNuGApk92Zj+VExIMVyXXbZKKYa
4LeFPYGl1uJGlz21fzdfpxwZ6bP7QGFankDMxSfswNVFQ8u4uDbV3JTdEbjOOxLZ
A8UOWKpeXhWwffOZeXSoakXdTjVQAhdSivOapYlpaUicVQNrokPVUu5E+sb+ebxd
d/+GX7xBAvIKm9L3LTYMvZ0FSEIYdK2n88S4y6V300xh8gfr6pIR98VFk6MzM6Bk
veiFOPH9jHsqRXfgfwGgsPmHL00mWp9BFZj16e3d5tUNLfsPjn7amCdpCQmPgkyE
pMdMe/McgdY3UsCvsPG/RTf1/gFatYiLrifz0tlQNXq0hQ9TVza/zlQ4Q53VUjil
GJhHotcuSPqcRGzbK3ZsowBQKvIuHIS2Ht/Ky2weZpl9wC6QILXTBhSdGeWeCywg
pklqnrpL0Pg=
=9o5Z
-----END PGP SIGNATURE-----

--Sig_/Lqvv88ywWZ7XEAZC_2Y/9cg--
