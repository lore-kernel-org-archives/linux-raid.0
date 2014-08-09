From: NeilBrown <neilb@suse.de>
Subject: Re: RAID10-reshape crashed due to memory allocation problem
Date: Sat, 9 Aug 2014 10:37:24 +1000
Message-ID: <20140809103724.0355b9d3@notabene.brown>
References: <201408081646.s78GkqtA017996@portal.naev.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/5lFO.FanIS+Te61=uD=5MGi"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201408081646.s78GkqtA017996@portal.naev.de>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Koch <mdraid.pkoch@dfgh.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/5lFO.FanIS+Te61=uD=5MGi
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 8 Aug 2014 18:46:52 +0200 mdraid.pkoch@dfgh.net (Peter Koch) wrote:

> Dear Neil,
>=20
> thanks for the info about set meaning of set-A, the difference
> between Device-ID and RaidDevice.
>=20
> > > Number   Major   Minor   RaidDevice State
> > >    0       8       16        0      active sync set-A   /dev/sdb
> > >    1       8      160        1      active sync set-B   /dev/sdk
> > >    2       8       32        2      active sync set-A   /dev/sdc
> > >    3       8      176        3      active sync set-B   /dev/sdl
> > >    4       8       48        4      active sync set-A   /dev/sdd
> > >    5       8      192        5      active sync set-B   /dev/sdm
> > >    6       8       64        6      active sync set-A   /dev/sde
> > >    7       8      208        7      active sync set-B   /dev/sdn
> > >    8       8       80        8      active sync set-A   /dev/sdf
> > >    9       8      224        9      active sync set-B   /dev/sdo
> > >   10       8       96       10      active sync set-A   /dev/sdg
> > >   11       8      240       11      active sync set-B   /dev/sdp
> > >   12       8      112       12      active sync set-A   /dev/sdh
> > >   14       8      128       13      active sync set-B   /dev/sdi
> > >   13      65        0       14      active sync set-A   /dev/sdq
> > >   15      65       16       15      active sync set-B   /dev/sdr
> >=20
> > It's not "sync set-A", it is "active" and "sync" and  "set-A".
> > When you have a RAID10 that can be seen as two sets of devices where on=
e set
> > is mirrored to the other, they are labels as "set-A" and  "set-B", just=
 like
> > you assumed.
>=20
> The first time I noticed "set-A" and "set-B" in mdadm -D output
> was after the reshape operation started. If I understand you
> correct the real reason for these information to appear was not
> the reshape operation but growing the array from an odd number
> of drives (13) to an even number (16)

Correct.  A 13 drive array would not have well defined sets.

>=20
> > > What's the difference between column 1 and column 4 in
> > > mdadm -D output?
> >
> > column 1 identified the device.  column 4 give the role that the device=
 plays
> > in the array.
> > This seemed to make sense once, but it could be more confusing than hel=
pful.
>=20
> What irritates me most is the fact that /proc/mdstat output
> lists the device id. For a raid10-array with near-2 layout and
> an even number of drives I was under the impression that the data
> is mirrored between all drives with even and all drives with odd
> numbers. In my case this is wrong: drives 0,2,4,6,8,10,12,13
> are mirrored with drives 1,3,5,7,9,11,14,15.

Yes, that irritates me too.  I haven't quite managed to work up the courage
to "fix" it as technically it is an API change and someone might depend on
the current behaviour.

>=20
> Spare-Drives are not shown with their number but with their role
> within the array (namely (S) ). So why not printing the role
> for all drives instead of their device-id. I would also suggest
> adding the set to mdstat-output, i.e:
>=20
> md5 : active raid10 sdb[A0] sdr[B7] sdq[A7] sdi[B6] sdh[A6] sdp[B5] sdg[A=
5] sdo[B4] sdf[A4] sdn[B3] sde[A3] sdm[B2] sdd[A2] sdl[B1] sdc[A1] sdk[B0]
>=20

That would be an even bigger API change.

I have seriously considered writing an mdadm comment which prints out a
summary similar to /proc/mdstat, but with a better thought out structure and
content.  Then I could just tell people to ignore mdstat.  I haven't yet.


> Is there any way to change the device-id?

If you --zero the superblock, then add the device again, it might  get a
different device id.

NeilBrown

--Sig_/5lFO.FanIS+Te61=uD=5MGi
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU+VtRDnsnt1WYoG5AQJIwg/+L1XkrBbJhre+5qoMF1qXPs1+6CTAd9R9
j4tRE46bInxi+VbahR8/kUSqKBRAoMYZbYj4ccPJXnZ0P4SRcu4C0f/Wo+TpG73I
QQTclg659p/VxCB2yhL5Ga3981p8+xj0y0cbngno3wRyzDApu7fNdmuuTAjN8PMK
I33JOLdcWSsJhCVK+mqEmavEtw5SCP5RREQBF8Cq/iamKegTjcFX5BvUenLJrgml
IsX3TW23VLj9lLsj8xahLnmThPaOLccyfZOHzURc2XnQMP+aefeTHU9discfZZu5
dUdvPM6iE0gdXr1HLVTGRxpavF8+cp5qgHPu1ouO9Tdfw0AiBZeuIAOmrpyAD95S
wHrS80ehT/Le59WOXYBfgDVOIvcW5PtPextxNS3FckXmfUQzmbBrJFU5LjC7Clgd
dPcawnp1dNQC7zQt4KnGxqafixvNTl0MYnmlOJsVbHv1kzaQlWHFB1+MeasRzRas
mmYXN4Y69qVKdIbb+1uEho6IXU7gZHrA0tgA1F3NZGsT73OI5c7msKk6GpD/+ef/
awnAdKKjaIm7no5vcnI3Uqso9bvWxLQF04SIpYptL/HYdYgehPbDqQafxM9SKt1T
kFbFynIqrsxhB0Spg2pu6T1XlD2KDu5QcDpTeFo0bttxm+gqlGYegz/7gAuJLuoT
5PJbP63lsFg=
=Ze1k
-----END PGP SIGNATURE-----

--Sig_/5lFO.FanIS+Te61=uD=5MGi--
