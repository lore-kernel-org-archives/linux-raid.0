From: NeilBrown <neilb@suse.de>
Subject: Re: md/raid1:Fix a logic bug in fix_sync_read_error().
Date: Thu, 5 Apr 2012 13:36:45 +1000
Message-ID: <20120405133645.6daf0b8c@notabene.brown>
References: <201203311037586565381@gmail.com>
	<201204051023442812453@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/OqBBr/ueCFe_9pjIQVpD/Ze"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201204051023442812453@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: kedacomkernel <kedacomkernel@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/OqBBr/ueCFe_9pjIQVpD/Ze
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: quoted-printable

On Thu, 5 Apr 2012 10:23:47 +0800 "kedacomkernel" <kedacomkernel@gmail.com>
wrote:

> >>That is correct, and that is how it should be.
>=20
> >>If we get a read error, then try again and get a successful read, then =
there
> >>is nothing more that we need to do.  No need to write or anything.
>=20
> >>So: current code is correct.
>=20
> >>Thanks,
> >>NeilBrown
> Sorry Neil,I don't understand what's your mean?
> I think this function is want to do something like follow when all sync_r=
ead failed.
> 1:want to read partly by PAGE_SIZE from all read devices.

Not exactly.  fix_sync_read_error() only gets called if all reads that were
attempted (often just one, but for 'check' or 'repair' it will have tried a=
ll
devicess) have failed.
So what we need to do in this case is just to get the valid data from
somewhere.  As soon as we have found it we can be happy.

> 2:if read success and write write to other and read back, in order to rep=
air those disks.
=20
yes ... and no.  The code might be a bit confusing.  There may even be room
for improvement.

But after fix_sync_read_error succeeds, the rest of sync_request_write will
write out the data that it recovered to other devices if necessary.

so it doesn't matter that fix_sync_read_error() doesn't write out.

>=20
> for example :
> disk A,B ,read 64k from 0 to 128 sector.
> supposed: disk A read failed because sector 0-7 was bad sector.
> 			   disk B  read failed because sector 8-15 was bad sector.
> by this function,we can fix sector 0-7 of A and sector 8-15 of B.
> Is ok?

Hmm... not sure.
fix_sync_read_error should read all the data from wherever it is.
I guess I'm not certain that sync_request_write() will write it out
everywhere.

So maybe there is a problem there.

However you should make sure that your analysis covered both
fix_sync_read_error and sync_request_write.

NeilBrown



>=20
> If B is read_disk,so read 0-7 is ok and want to write it to A.But becasue=
 the code ,do not write to disk A.
>=20
> ------------------				=20
> kedacomkernel
> 2012-04-05
>=20
> -------------------------------------------------------------
> =B7=A2=BC=FE=C8=CB=A3=BANeilBrown
> =B7=A2=CB=CD=C8=D5=C6=DA=A3=BA2012-04-02 10:05:34
> =CA=D5=BC=FE=C8=CB=A3=BAkedacomkernel
> =B3=AD=CB=CD=A3=BAlinux-raid
> =D6=F7=CC=E2=A3=BARe: md/raid1:Fix a logic bug in fix_sync_read_error().
>=20
> On Sat, 31 Mar 2012 10:38:01 +0800 "kedacomkernel" <kedacomkernel@gmail.c=
om>
> wrote:
>=20
> > >From 0fe15c8e1bd5e46234d37573f3322312d8da325d Mon Sep 17 00:00:00 2001
> > From: majianpeng <majianpeng@gmail.com>
> > Date: Sat, 31 Mar 2012 10:27:33 +0800
> > Subject: [PATCH] md/raid1:Fix a logic bug in fix_sync_read_error().=20
> > If  d=3D=3Dread_disk && success =3D=3D 1 and then break, so d =3D
> >  read_disk. When exec this judgement: >>start =3D d; >>/*
> >  write it back and re-read */ >>while (d !=3D
> >  r1_bio->read_disk) { Because d =3D=3D read_disk,so write and
> >  re-add did not exec.
>=20
> That is correct, and that is how it should be.
>=20
> If we get a read error, then try again and get a successful read, then th=
ere
> is nothing more that we need to do.  No need to write or anything.
>=20
> So: current code is correct.
>=20
> Thanks,
> NeilBrown
>=20
>=20
> >=20
> >=20
> > Signed-off-by: majianpeng <majianpeng@gmail.com>
> > ---
> >  drivers/md/raid1.c |    1 -
> >  1 files changed, 0 insertions(+), 1 deletions(-)
> >=20
> > diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> > index 4a40a20..3a133ff 100644
> > --- a/drivers/md/raid1.c
> > +++ b/drivers/md/raid1.c
> > @@ -1618,7 +1618,6 @@ static int fix_sync_read_error(struct r1bio *r1_b=
io)
> >  						 bio->bi_io_vec[idx].bv_page,
> >  						 READ, false)) {
> >  					success =3D 1;
> > -					break;
> >  				}
> >  			}
> >  			d++;
>=20


--Sig_/OqBBr/ueCFe_9pjIQVpD/Ze
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT30TTTnsnt1WYoG5AQJcVhAAlm91kiWsgocJfP3HjGfFcCql8f5S6AnG
+TgRmBFucV2rErUQoiuHcqRqipwqWjMbs1z8kv2LUBuvh4ynA8K6f0S1djAHZpJr
+Qh+9BkwzzgIYTDRgLwYOmNPz9n45A4uv6weI9lPZRWHV677RrjFUu2Z0/n0jLuk
D+JxDFSEZkexpeSEv0ck8TlpAmMh3gQt7WadSOGCvKm9NNtNaqvxLFhZEToaPOQg
yE6cFlB0c1B9LtBpjFumUAtwcoRFCqMElb+SwijEjrCqdl4kV0DTzIK3oz0ge0lB
N+Si7vKPNDSl8p99LaGjCkb7wwqkPCmcXpBSycM+bVz1c7Hk5RDpoh6+b1wRdTsh
s++nG/vTEaSfDc9t5S09XTwswVvq5SmmvQ6UriT0es4ckzTyzQ6HtgcrtJ6oaO98
A6WUkYUUkAv3fxNPI4Tw8xpQPx2AHdT5fzWGCfw1Bdc+zqLa3sXxZLOfXX8lW3L2
XweWPzyknZ57w8H4mgCj+DsO2KCdL5f6VMDK0kWe/1XskkydDzbfLoFuwhUhmXCw
PPdhRl5MLo+3hxkSG6qkvOlaU0KNPFrk7qgEJ1EzFyGjQscmLORxFVhbUFb77Dss
guwGqNADUWUWmq88tI7U6m1SgAblMiPWSTEt/Mw1H4QS9Fbat0XEUf53Avx6F9r+
7Xz3Ir01waQ=
=/9do
-----END PGP SIGNATURE-----

--Sig_/OqBBr/ueCFe_9pjIQVpD/Ze--
