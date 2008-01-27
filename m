From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: striping of a 4 drive raid10
Date: Sun, 27 Jan 2008 22:43:08 +0100
Message-ID: <20080127214308.GA14643@rap.rap.dk>
References: <20080127193345.GA5426@rap.rap.dk> <18332.58743.852744.907807@tree.ty.sabi.co.UK>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18332.58743.852744.907807@tree.ty.sabi.co.UK>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg_lxra@lxra.for.sabi.co.UK>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Jan 27, 2008 at 08:11:35PM +0000, Peter Grandi wrote:
> >>> On Sun, 27 Jan 2008 20:33:45 +0100, Keld J=F8rn Simonsen
> >>> <keld@dkuug.dk> said:
>=20
> keld> Hi I have tried to make a striping raid out of my new 4 x
> keld> 1 TB SATA-2 disks. I tried raid10,f2 in several ways:
>=20
> keld> 1: md0 =3D raid10,f2 of sda1+sdb1, md1=3D raid10,f2 of sdc1+sdd=
1, md2 =3D raid0
> keld>    of md0+md1
> keld> 2: md0 =3D raid0 of sda1+sdb1, md1=3D raid0 of sdc1+sdd1, md2 =3D=
 raid01,f2
> keld>    of md0+md1
> keld> 3: md0 =3D raid10,f2 of sda1+sdb1, md1=3D raid10,f2 of sdc1+sdd=
1, chunksize of=20
> keld>    md0 =3Dmd1 =3D128 KB,  md2 =3D raid0 of md0+md1 chunksize =3D=
 256 KB
> keld> 4: md0 =3D raid0 of sda1+sdb1, md1=3D raid0 of sdc1+sdd1, chunk=
size
> keld>    of md0 =3D md1 =3D 128 KB, md2 =3D raid01,f2 of md0+md1 chun=
ksize =3D 256 KB
>=20
> These stacked RAID levels don't make a lot of sense.
>=20
> keld> 5: md0=3D raid10,f4 of sda1+sdb1+sdc1+sdd1
>=20
> This also does not make a lot of sense. Why have four mirrors
> instead of two?

My error, I did mean f2.

Anyway 4 mirrors would make the disk 2 times faster than 2 disks, and g=
iven disk
prices these days this could make a lot of sense.

> Instead, try 'md0 =3D raid10,f2' for example. The first mirror of
> will be striped across the outer half of all four drives, and
> the second mirrors will be rotated in the inner half of each
> drive.
>=20
> Which of course means that reads will be quite quick, but writes
> and degraded operation will be slower.
>=20
> Consider this post for more details:
>=20
>   http://www.spinics.net/lists/raid/msg18130.html

Thanks for the reference.

There is also more in the original article on possible layouts of what
is now known as raid10,f2

http://marc.info/?l=3Dlinux-raid&m=3D107427614604701&w=3D2

including performance enhancements due to use of the faster outer
sectors, and smaller average seek times because you can seek on only
half the disk.

best regards
keld
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
