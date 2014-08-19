From: NeilBrown <neilb@suse.de>
Subject: Re: Full stripe write in RAID6
Date: Tue, 19 Aug 2014 16:54:30 +1000
Message-ID: <20140819165430.1eea7936@notabene.brown>
References: <01b101cfb0c9$e8fcf240$baf6d6c0$@calsoftinc.com>
	<20140806164720.2aac2c5a@notabene.brown>
	<01d701cfbafc$d3545cc0$79fd1640$@calsoftinc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/+yzDIUzfaLf=oPeEYG/HQWT"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <01d701cfbafc$d3545cc0$79fd1640$@calsoftinc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mandar Joshi <mandar.joshi@calsoftinc.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/+yzDIUzfaLf=oPeEYG/HQWT
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 18 Aug 2014 21:25:25 +0530 "Mandar Joshi"
<mandar.joshi@calsoftinc.com> wrote:

> Thanks Neil for the reply...
> Comments inline...
>=20
> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]=20
> Sent: Wednesday, August 06, 2014 12:17 PM
> To: Mandar Joshi
> Cc: linux-raid@vger.kernel.org
> Subject: Re: Full stripe write in RAID6
>=20
> On Tue, 5 Aug 2014 21:55:46 +0530 "Mandar Joshi"
> <mandar.joshi@calsoftinc.com> wrote:
>=20
> > Hi,
> >                 If I am writing entire stripe then whether RAID6 md=20
> > driver need to read any of the blocks from underlying device?
> >                =20
> >                 I have created RAID6 device with default (512K) chunk=20
> > size with total 6 RAID devices. cat=20
> > /sys/block/md127/queue/optimal_io_size =3D
> > 2097152 I believe this is full stripe (512K * 4 data disks).=20
> > If I write 2MB data, I am expected to dirty entire stripe hence what I=
=20
> > believe I need not require to read either any of the data block or=20
> > parity blocks. Thus avoiding RAID6 penalties. Whether md/raid driver=20
> > supports full stripe writes by avoiding RAID 6 penalties?
> >=20
> > I also expected 6 disks will receive 512K writes each. (4 data disk +=20
> > 2 parity disks).
>=20
> Your expectation is correct in theory, but it doesn't always quite work l=
ike that in practice.
> The write request will arrive at the raid6 driver in smaller chunks and i=
t doesn't always decide correctly whether it should wait for more writes to=
 arrive, or if it should start reading now.
>=20
> It would certainly be good to "fix" the scheduling in raid5/raid6, but no=
 one have worked out how yet.
>=20
> NeilBrown
>=20
> [Mandar] Tuning sysfs/.../md/stripe_cache_size=3D32768 significantly lowe=
red pre-reads as discussed above. As it does not force queue for completion=
, stripe handling gets time to dirty next entire full stripes, thus avoidin=
g pre-reads. Still some of the stripe were not lucky to experience the same.
> Further tuning sysfs/.../md/preread_bypass_threshold=3Dstripe_cache_size =
i.e. 32768, almost eliminated pre-reads in my case.
> Neil mentioned that "raid6 driver gets write request in smaller chunks."
> Also correct if my understanding below is wrong.
> Is it because md/raid driver does not have its own io scheduler which can=
 merge requests? Can we not have io scheduler for md?

md/raid5 does have a scheduler and does merge requests.
It is quite unlike the IO scheduler for a SCSI (or similar) device because
its goal is quite different.  The scheduler merges requests into a stripe
rather than into a sequence because that is what benefits raid5.
raid5 sends single-page requests down to the underlying driver and expects =
it
to merge them into multi-page requests if it would benefit from that.

The problem is that the raid5 scheduler isn't very clever and gets it wrong
sometimes.

> When I do any buffered write request on md/raid6, I always get multiple 4=
K requests. I think in absence of io scheduler, its because of Buffered IO =
writes (from the page-cache) will always be in one-page units?

Yes.

> Due to this reason, whether md/raid6 driver was designed in such way that=
 its internal stripe handling considers stripe =3D 4K * noOfDisks?=20

Because that is easier.


> Why design does not consider internal stripe =3D chunk_size * noOfDisks?

That would either be very complex, or would require all IO to be in full
chunks which is no ideal for small random IO.

> I think it will help file systems which can do submit_bio with larger siz=
e(?)
> Is there any config-setting or patch to improve on in this case?

No - apart from the config settings you have already found.


NeilBrown


> In case of direct IO, pages will be accumulated and then given to md/raid=
6, hence md/raid6 can receive more than 4K requests.
> But again here, with direct io I could not get a write request more than =
chunk size of it. Any specific reason?
>=20
>=20
>=20
> >=20
> > If I do IO directly on block device /dev/md127, I do observe reads=20
> > happening on md device and underlying raid devices as well.
> >=20
> > #mdstat o/p:
> > md127 : active raid6 sdah1[5] sdai1[4] sdaj1[3] sdcg1[2] sdch1[1]=20
> > sdci1[0]
> >       41926656 blocks super 1.2 level 6, 512k chunk, algorithm 2 [6/6]=
=20
> > [UUUUUU]
> >=20
> >=20
> >=20
> > # time (dd if=3D/dev/zero of=3D/dev/md127 bs=3D2M count=3D1 && sync)
> >=20
> > # iostat::
> > Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> > sdaj1            19.80         1.60       205.20          8       1026
> > sdai1            18.20         0.00       205.20          0       1026
> > sdah1            33.60        11.20       344.40         56       1722
> > sdcg1            20.20         0.00       205.20          0       1026
> > sdci1            31.00         3.20       344.40         16       1722
> > sdch1            34.00       120.00       205.20        600       1026
> > md127           119.20       134.40       819.20        672       4096
> >=20
> >=20
> > So to avoid cache effect, if any (?) I am using raw device to perform I=
O.
> > Then for one stripe write I do observe no reads happening.=20
> > At the same time I also see few disks getting more writes than=20
> > expected. Did not get why?
> >=20
> > # raw -qa
> > /dev/raw/raw1:  bound to major 9, minor 127
> >=20
> > #time (dd if=3D/dev/zero of=3D/dev/raw/raw1 bs=3D2M count=3D1 && sync)
> >=20
> > # iostat shows:
> > Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> > sdaj1             7.00         0.00       205.20          0       1026
> > sdai1             6.20         0.00       205.20          0       1026
> > sdah1             9.80         0.00       246.80          0       1234
> > sdcg1             6.80         0.00       205.20          0       1026
> > sdci1             9.60         0.00       246.80          0       1234
> > sdch1             6.80         0.00       205.20          0       1026
> > md127             0.80         0.00       819.20          0       4096
> >=20
> > I assume if I perform writes in multiples of =E2=80=9Coptimal_io_size=
=E2=80=9D I would=20
> > be doing full stripe writes thus avoiding reads. But unfortunately=20
> > with two 2M writes, I do see reads happening for some these drives.=20
> > Same case for
> > count=3D4 or 6 (equal to data disks or total disks).
> > # time (dd if=3D/dev/zero of=3D/dev/raw/raw1 bs=3D2M count=3D2 && sync)
> >=20
> >=20
> > Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> > sdaj1            13.40       204.80       410.00       1024       2050
> > sdai1            11.20         0.00       410.00          0       2050
> > sdah1            15.80         0.00       464.40          0       2322
> > sdcg1            13.20       204.80       410.00       1024       2050
> > sdci1            16.60         0.00       464.40          0       2322
> > sdch1            12.40       192.00       410.00        960       2050
> > md127             1.60         0.00      1638.40          0       8192
> >=20
> >=20
> > I read about =E2=80=9C/sys/block/md127/md/md/preread_bypass_threshold=
=E2=80=9D.=20
> > I tried setting this to 0 as well as suggested somewhere. But no help.
> >=20
> > I believe RAID6 penalties will exist if it=E2=80=99s a random write, bu=
t in=20
> > case of seq. write, whether they will still exist in some other form=20
> > in Linux md/raid driver?
> > My aim is to maximize RAID6 Write IO rate with sequential Writes=20
> > without
> > RAID6 penalties.
> >=20
> > Rectify me wherever my assumptions are wrong. Let me know if any other=
=20
> > configuration param (for block device or md device) is required to=20
> > achieve the same.
> >=20
> > --
> > Mandar Joshi
>=20


--Sig_/+yzDIUzfaLf=oPeEYG/HQWT
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU/L0pjnsnt1WYoG5AQJ1KRAAs4qzXg1YvcmK4J/odTVaGCHfUF5CY9Ho
Vdfjf//dztoO0lwvQgkZ/TuH16Tbp/wXXj3Nhaqlb3NIb4j1Z3mpxkxyeqhzoUT+
rKSsQARb2CKx66gyi7x5Rm8faKYNNq2Wt6HC9XTeNghtfk8ehev/cztxWD1uDQGZ
jf4d743CTYRSypHrYFhA5KBhlCegNcPBbymFCIqcN4SHykLdBs+kbVOC0i0E0hj4
iLCw7PEAMFL9jbijfnVStv5k1RUOGpXgd3f86xFfqgFWgJ4oHIHx9mEvD+NhgjHj
QtXSZpYj3aBNzGZUTgU4PgMNDar0f4K3mJm2p8rA6I/pDAmIWbEtZil1BVY8LWMc
jb31vVteksJt9IMBaRHhjUDUV4eYs9oxoaPUbQOxjRuPiB1Kv8hqW8YfrZnY5sHM
Dzv0b5kolT/EJuKoSTGEgz2YoJqkFPh5SQQxn8IP/TPdgXS3irWvFCrzA2+8/1dw
6P0IKFJaUVAka/X7XNSMwYtZn2Y4DnKqVaJULpvQ5IVxk9KqrOnfsctwrkTkWiCB
U+m3MiL83vHumaQod442V2Ik/fpjq8Ey+1xTB58xF23PZU8LfOlKBwgdQO8jIRBr
OwioIl9TPoFxT92nEBgbagrYW42zzh4aegR4ISwL5cP292vtC8n/bjY8qmkBAy28
nNw+eeNTLYM=
=EnvM
-----END PGP SIGNATURE-----

--Sig_/+yzDIUzfaLf=oPeEYG/HQWT--
