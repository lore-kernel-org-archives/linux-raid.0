From: NeilBrown <neilb@suse.de>
Subject: Re: Backup file size when migrating from raid5 to raid6?
Date: Mon, 7 May 2012 10:54:58 +1000
Message-ID: <20120507105458.6411b0cf@notabene.brown>
References: <CAH-e9vLTY2eo0p3ud5FaWNe_2f8hej0aitFuu8K0M1RZdObiXQ@mail.gmail.com>
	<CAH-e9vLiK6=HmDjM=Ub7p_Lxrp_L0x1bkAa2oP=ykajqvtkfDQ@mail.gmail.com>
	<20120506210028.6212b2f8@notabene.brown>
	<CAH-e9vJkrv2R-HTR7JfHwZK1sbYQ3fduGbtxEwtor4gtyd6PKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/EFdrhxyBewlKfsmigAM3WPb"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH-e9vJkrv2R-HTR7JfHwZK1sbYQ3fduGbtxEwtor4gtyd6PKQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Gar=F0ar?= Arnarsson <gardar@giraffi.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/EFdrhxyBewlKfsmigAM3WPb
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 7 May 2012 00:32:35 +0000 Gar=C3=B0ar Arnarsson <gardar@giraffi.net=
> wrote:

> That's an excellent idea, I was going to add another disk for extra space
> right after migrating to raid6.
>=20
> Just to be clear, I'll be running the normalize attribute just once to
> straighten the array out right? Or will I have to do it for every extra
> drive I add in the future?

Just once.

>=20
> And what are the N+1 you mention in --raid-devices=3DN+1

By "N+1" I just meant "1 more than the number of devices currently in the
array".

If you have both new devices ready to go, you just do a single reshape
operation that converts to RAID6 and adds more space.  This does not need a
backup file and is probably the best approach.

If you currently have a 10-drive RAID5 and want a 12-drive RAID6, then

 mdadm --grow /dev/md0 --raid-devices=3D12 --level=3D6

is what you want.

NeilBrown


>=20
> Thanks.
>=20
>=20
> 2012/5/6 NeilBrown <neilb@suse.de>
>=20
> > On Sun, 6 May 2012 10:17:52 +0000 Gar=C3=B0ar Arnarsson <gardar@giraffi=
.net>
> > wrote:
> >
> > > My raid5 array has gotten a bit big, it's containing total 10 drives
> > > right now (I started out with 3 drives). So I am going to convert it
> > > to raid6 before it gets any bigger.
> > >
> > > I am doing a test-run on a virtual machine with virtual drives to see
> > > that everything works flawlessly.
> > >
> > > When I tried to convert the array to raid6 I got a error message about
> > > a missing backup-file
> > >
> > > mdadm --grow /dev/md0 --raid-devices=3D5 --level=3D6
> > >
> > > mdadm level of /dev/md0 changed to raid6
> > > mdadm: /dev/md0: Cannot grow - need backup-file
> > > mdadm: aborting level change
> > >
> > > I added the backup file and was able to convert the array successfully
> > > after that.
> > >
> > > My question is, how big is this backup file going to be? My real raid
> > > array consists of 2tb drives, will the backup file be as big as one
> > > drive in the array, or will it just be few megabytes or gigabytes?
> > > I'm asking because I'm wondering if I need to buy an extra hdd for the
> > > backup file or if the backup file can just be on my OS hdd that has
> > > around 100gb free.
> >
> > The backup file is a few megabytes. Around 16MB I think.
> >
> > However if you are likely to add another device in the not too distant
> > future
> > you can save yourself a bit of time.
> >
> > If you
> >
> >  mdadm --grow /dev/md0 --level=3D6 --layout=3Dpreserve
> >
> > It will just make the new few a 'Q-block' device, containing the extra
> > RAID6
> > 'parity' block for each stripe.  This doesn't require any reshape or or=
 any
> > backup file and is a lot faster.  All it requires is a normal recovery
> > operation.
> >
> > Then when you later add another device you can
> >
> >  mdadm --grow /dev/md0 --raid-devices=3DN+1 --layout=3Dnormalise
> >
> > This will convert from the Q-on-the-last-device layout to a more normal
> > rotated-P-and-Q layout at the same time as adding extra space.
> >
> > NeilBrown
> >
>=20
>=20
>=20


--Sig_/EFdrhxyBewlKfsmigAM3WPb
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT6cdYjnsnt1WYoG5AQKY+w//ewYylbik7iAf4j66yR2kRNwLawbAZK/J
JACWPWj2ph0tlYg0P+pJGdmfP4P3t+TzP+i/VWc58fQG74rScQBujKlezzexac5G
SiaoocJwF8kOIyhhrBsDsnQEZkfVnD++6kgiNpJNyJAq5k5/qaujImFmLdCATPML
Nrda/AIO1fcT2EBCVZ5+R6TLBy9f6wSNXEf4DQbK/VZtiSp0FtmUil5lcW1v2X+D
USSH//1bMyF3EzE5H8DR8rsGYmnqYnKr7+J1BMuv9kzQRh2Pngsubf8rlrKmHXy1
6bRsAa0sXZFKgE9PjP58R1wXTt92MmmIRNYIEKy7N/1GwL3n/592xJ28I71aGDxT
CE1vYh5L1tPPLHQvW5g6auhLtyuGy5Hb7B1TBv/NAP073AmVuRRSlvUUCBddA56u
VyUD+ZecmoE7tfqs/uEGItihr7h/CncvmARfqiSbI7edPUltem+3NIigb8jMrj8t
1fG6zskzXA417Be/yoQ/BwPrDLLuCU6MNBTlXNgYvVwaI82hGdYJeojJtNkepiBd
QJc7gqXYFZyu4kL6Tx1egkU0YDEOrVPe+wvSI7GXNpoxpFttNqIsx2HWFuaHwgoP
y+pA9GdQGenuG1pBXsA9MVH0MtexGBpF0ALRNeG90JSwC9fTMM7m5V2jBi+THbzY
PYuBYlwoDt4=
=fzlV
-----END PGP SIGNATURE-----

--Sig_/EFdrhxyBewlKfsmigAM3WPb--
