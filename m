From: "Mandar Joshi" <mandar.joshi@calsoftinc.com>
Subject: RE: Full stripe write in RAID6
Date: Mon, 18 Aug 2014 21:25:25 +0530
Message-ID: <01d701cfbafc$d3545cc0$79fd1640$@calsoftinc.com>
References: <01b101cfb0c9$e8fcf240$baf6d6c0$@calsoftinc.com> <20140806164720.2aac2c5a@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140806164720.2aac2c5a@notabene.brown>
Content-Language: en-us
Sender: linux-raid-owner@vger.kernel.org
To: 'NeilBrown' <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks Neil for the reply...
Comments inline...

-----Original Message-----
=46rom: NeilBrown [mailto:neilb@suse.de]=20
Sent: Wednesday, August 06, 2014 12:17 PM
To: Mandar Joshi
Cc: linux-raid@vger.kernel.org
Subject: Re: Full stripe write in RAID6

On Tue, 5 Aug 2014 21:55:46 +0530 "Mandar Joshi"
<mandar.joshi@calsoftinc.com> wrote:

> Hi,
>                 If I am writing entire stripe then whether RAID6 md=20
> driver need to read any of the blocks from underlying device?
>                =20
>                 I have created RAID6 device with default (512K) chunk=
=20
> size with total 6 RAID devices. cat=20
> /sys/block/md127/queue/optimal_io_size =3D
> 2097152 I believe this is full stripe (512K * 4 data disks).=20
> If I write 2MB data, I am expected to dirty entire stripe hence what =
I=20
> believe I need not require to read either any of the data block or=20
> parity blocks. Thus avoiding RAID6 penalties. Whether md/raid driver=20
> supports full stripe writes by avoiding RAID 6 penalties?
>=20
> I also expected 6 disks will receive 512K writes each. (4 data disk +=
=20
> 2 parity disks).

Your expectation is correct in theory, but it doesn't always quite work=
 like that in practice.
The write request will arrive at the raid6 driver in smaller chunks and=
 it doesn't always decide correctly whether it should wait for more wri=
tes to arrive, or if it should start reading now.

It would certainly be good to "fix" the scheduling in raid5/raid6, but =
no one have worked out how yet.

NeilBrown

[Mandar] Tuning sysfs/.../md/stripe_cache_size=3D32768 significantly lo=
wered pre-reads as discussed above. As it does not force queue for comp=
letion, stripe handling gets time to dirty next entire full stripes, th=
us avoiding pre-reads. Still some of the stripe were not lucky to exper=
ience the same.
=46urther tuning sysfs/.../md/preread_bypass_threshold=3Dstripe_cache_s=
ize i.e. 32768, almost eliminated pre-reads in my case.
Neil mentioned that "raid6 driver gets write request in smaller chunks.=
"
Also correct if my understanding below is wrong.
Is it because md/raid driver does not have its own io scheduler which c=
an merge requests? Can we not have io scheduler for md?
When I do any buffered write request on md/raid6, I always get multiple=
 4K requests. I think in absence of io scheduler, its because of Buffer=
ed IO writes (from the page-cache) will always be in one-page units?
Due to this reason, whether md/raid6 driver was designed in such way th=
at its internal stripe handling considers stripe =3D 4K * noOfDisks?=20
Why design does not consider internal stripe =3D chunk_size * noOfDisks=
?
I think it will help file systems which can do submit_bio with larger s=
ize(?)
Is there any config-setting or patch to improve on in this case?
In case of direct IO, pages will be accumulated and then given to md/ra=
id6, hence md/raid6 can receive more than 4K requests.
But again here, with direct io I could not get a write request more tha=
n chunk size of it. Any specific reason?



>=20
> If I do IO directly on block device /dev/md127, I do observe reads=20
> happening on md device and underlying raid devices as well.
>=20
> #mdstat o/p:
> md127 : active raid6 sdah1[5] sdai1[4] sdaj1[3] sdcg1[2] sdch1[1]=20
> sdci1[0]
>       41926656 blocks super 1.2 level 6, 512k chunk, algorithm 2 [6/6=
]=20
> [UUUUUU]
>=20
>=20
>=20
> # time (dd if=3D/dev/zero of=3D/dev/md127 bs=3D2M count=3D1 && sync)
>=20
> # iostat::
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrt=
n
> sdaj1            19.80         1.60       205.20          8       102=
6
> sdai1            18.20         0.00       205.20          0       102=
6
> sdah1            33.60        11.20       344.40         56       172=
2
> sdcg1            20.20         0.00       205.20          0       102=
6
> sdci1            31.00         3.20       344.40         16       172=
2
> sdch1            34.00       120.00       205.20        600       102=
6
> md127           119.20       134.40       819.20        672       409=
6
>=20
>=20
> So to avoid cache effect, if any (?) I am using raw device to perform=
 IO.
> Then for one stripe write I do observe no reads happening.=20
> At the same time I also see few disks getting more writes than=20
> expected. Did not get why?
>=20
> # raw -qa
> /dev/raw/raw1:  bound to major 9, minor 127
>=20
> #time (dd if=3D/dev/zero of=3D/dev/raw/raw1 bs=3D2M count=3D1 && sync=
)
>=20
> # iostat shows:
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrt=
n
> sdaj1             7.00         0.00       205.20          0       102=
6
> sdai1             6.20         0.00       205.20          0       102=
6
> sdah1             9.80         0.00       246.80          0       123=
4
> sdcg1             6.80         0.00       205.20          0       102=
6
> sdci1             9.60         0.00       246.80          0       123=
4
> sdch1             6.80         0.00       205.20          0       102=
6
> md127             0.80         0.00       819.20          0       409=
6
>=20
> I assume if I perform writes in multiples of =E2=80=9Coptimal_io_size=
=E2=80=9D I would=20
> be doing full stripe writes thus avoiding reads. But unfortunately=20
> with two 2M writes, I do see reads happening for some these drives.=20
> Same case for
> count=3D4 or 6 (equal to data disks or total disks).
> # time (dd if=3D/dev/zero of=3D/dev/raw/raw1 bs=3D2M count=3D2 && syn=
c)
>=20
>=20
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrt=
n
> sdaj1            13.40       204.80       410.00       1024       205=
0
> sdai1            11.20         0.00       410.00          0       205=
0
> sdah1            15.80         0.00       464.40          0       232=
2
> sdcg1            13.20       204.80       410.00       1024       205=
0
> sdci1            16.60         0.00       464.40          0       232=
2
> sdch1            12.40       192.00       410.00        960       205=
0
> md127             1.60         0.00      1638.40          0       819=
2
>=20
>=20
> I read about =E2=80=9C/sys/block/md127/md/md/preread_bypass_threshold=
=E2=80=9D.=20
> I tried setting this to 0 as well as suggested somewhere. But no help=
=2E
>=20
> I believe RAID6 penalties will exist if it=E2=80=99s a random write, =
but in=20
> case of seq. write, whether they will still exist in some other form=20
> in Linux md/raid driver?
> My aim is to maximize RAID6 Write IO rate with sequential Writes=20
> without
> RAID6 penalties.
>=20
> Rectify me wherever my assumptions are wrong. Let me know if any othe=
r=20
> configuration param (for block device or md device) is required to=20
> achieve the same.
>=20
> --
> Mandar Joshi


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
