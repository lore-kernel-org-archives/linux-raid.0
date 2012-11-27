From: NeilBrown <neilb@suse.de>
Subject: Re: Where can i download mdadm 3.3
Date: Tue, 27 Nov 2012 11:13:06 +1100
Message-ID: <20121127111306.6799c0cb@notabene.brown>
References: <CAGmni9ozPTrqeg+RLBu=J8NEqqK95nwf0ymK7qA7DgpZNRHX=A@mail.gmail.com>
	<20121120122622.34f9bacd@notabene.brown>
	<CAGmni9oWcBYNyfKW4YQUPORRgz+hPM1tQ_jzWrOiNyZV2UmPEA@mail.gmail.com>
	<CAGmni9rkwQO4iHjg+tHSiPQm7Hx_y86cgBUfyio=HrR1Sp9TDg@mail.gmail.com>
	<20121121082500.411ea21b@notabene.brown>
	<CAGmni9pqesseBqR-Udczt2BP8ewUguEawAZ=cLQW=nOPqFx-gQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/CpGBSUgrtPf8pp0JS7DTtn+"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGmni9pqesseBqR-Udczt2BP8ewUguEawAZ=cLQW=nOPqFx-gQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Salatiel Filho <salatiel.filho@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/CpGBSUgrtPf8pp0JS7DTtn+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 25 Nov 2012 10:30:10 -0300 Salatiel Filho <salatiel.filho@gmail.com>
wrote:

> On Tue, Nov 20, 2012 at 6:25 PM, NeilBrown <neilb@suse.de> wrote:
> >
> > On Tue, 20 Nov 2012 14:00:35 -0300 Salatiel Filho <salatiel.filho@gmail=
.com>
> > wrote:
> >
> > > []'s
> > > Salatiel
> > >
> > >
> > > On Tue, Nov 20, 2012 at 8:02 AM, Salatiel Filho
> > > <salatiel.filho@gmail.com> wrote:
> > > > Thanks Neil !
> > > > []'s
> > > > Salatiel
> > > >
> > > >
> > > > On Mon, Nov 19, 2012 at 10:26 PM, NeilBrown <neilb@suse.de> wrote:
> > > >> On Sun, 18 Nov 2012 10:42:22 -0300 Salatiel Filho <salatiel.filho@=
gmail.com>
> > > >> wrote:
> > > >>
> > > >>> Hi guys, i will be building a few arrays very soon and i'd like to
> > > >>> test the badblock feature and the replaceable feature, but i have=
n`t
> > > >>> found where i can download the source of mdadm 1.3. Where can i g=
et it
> > > >>> ?
> > > >>>
> > > >> You can't.  3.3 doesn't exist yet.
> > > >>
> > > >> However
> > > >>   git clone git://neil.brown.name/mdadm
> > > >>   cd mdadm
> > > >>   make
> > > >>
> > > >> will get you code that supports bad blocks and replaceable devices.
> > > >>
> > > >> Alternately you can get a tar file at
> > > >>
> > > >>    http://git.neil.brown.name/git?p=3Dmdadm.git;a=3Dsnapshot;h=3Dm=
aster
> > > >>
> > > >> NeilBrown
> > >
> > > Forgot to send a copy to the list:
> > >
> > >
> > > Now the question, how do i enable badblock list ?
> > > # mdadm -A /dev/md1 /dev/sd[bcd]2 --update=3Dbbl  ?
> >
> > Yes, I think that is right - does it work?
> >
> > >
> > > I actually created also a new array
> > > # mdadm -C -n4 -l5 -e 1.2 /dev/md2 /dev/sd[bcde]3 ,
> > > but how do i verify if badblock support was enabled ?
> >
> > mdadm -E /dev/sdb3
> >
> > should show
> >
> >    Bad Block Log : 512 entries available at offset xxx sectors
> >
> > NeilBrown
> >
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
>=20
>=20
> Well, about the tests:
> I have put some data on a degraded raid 5 with 3 disks where one of
> them has random read errors. After that i added a new disk and the
> raid started to resync.
> After 62.5% i started getting read errors on /dev/sdd2 and the array
> stopped to resync.

Any useful messages from the kernel log?

>=20
> 1) Shouldn`t badblocks be ignored to allow the recover of most data?
> I can see in mdadm -E /dev/sdd2   Bad Block Log : 512 entries
> available at offset 262128 sectors - bad blocks present.

That's the theory.  And bad blocks found should be recorded on both sdd2 and
the new device.

>=20
> 2) After stop the array and try to reassembled with   mdadm -A
> /dev/md1 /dev/sd[bcde]2 --force i got the following message:
> mdadm -A /dev/md1 /dev/sd[bcde]2 --force
> mdadm: forcing event count in /dev/sdb2(0) from 87705 upto 87713
> mdadm: forcing event count in /dev/sdc2(1) from 87705 upto 87713
> mdadm: /dev/md1 has been started with 3 drives (out of 4).

That doesn't look good.  Again, complete kernel messages might help.

>=20
> and i noticed that sde2 was not added to the array.
>=20
> # mdadm -D /dev/md1
> /dev/md1:
>         Version : 1.2
>   Creation Time : Tue Nov 20 08:43:35 2012
>      Raid Level : raid5
>      Array Size : 3918320640 (3736.80 GiB 4012.36 GB)
>   Used Dev Size : 1306106880 (1245.60 GiB 1337.45 GB)
>    Raid Devices : 4
>   Total Devices : 3
>     Persistence : Superblock is persistent
>=20
>   Intent Bitmap : Internal
>=20
>     Update Time : Sun Nov 25 10:04:06 2012
>           State : active, degraded
>  Active Devices : 3
> Working Devices : 3
>  Failed Devices : 0
>   Spare Devices : 0
>=20
>          Layout : left-symmetric
>      Chunk Size : 512K
>=20
>            Name : zotac:1  (local to host zotac)
>            UUID : 93e55a39:94681b9d:4c0a1a15:cad51a71
>          Events : 87713
>=20
>     Number   Major   Minor   RaidDevice State
>        0       8       18        0      active sync   /dev/sdb2
>        1       8       34        1      active sync   /dev/sdc2
>        2       8       50        2      active sync   /dev/sdd2
>        6       0        0        6      removed
>=20
>=20
> After add it manually , mdadm -a /dev/md1 /dev/sde2
> the rebuild started from the beginning, ignoring the recovery offset:

That would be because the 'Events' number is too old so the 'recovery offse=
t'
is suspect.


>=20
> # mdadm -E /dev/sde2
> /dev/sde2:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0xb
>      Array UUID : 93e55a39:94681b9d:4c0a1a15:cad51a71
>            Name : zotac:1  (local to host zotac)
>   Creation Time : Tue Nov 20 08:43:35 2012
>      Raid Level : raid5
>    Raid Devices : 4
>=20
>  Avail Dev Size : 3592190757 (1712.89 GiB 1839.20 GB)
>      Array Size : 3918320640 (3736.80 GiB 4012.36 GB)
>   Used Dev Size : 2612213760 (1245.60 GiB 1337.45 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
> Recovery Offset : 1634547480 sectors
>           State : clean
>     Device UUID : 08019409:984c2217:21706201:039b6bbf
>=20
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Sun Nov 25 10:04:06 2012
>   Bad Block Log : 512 entries available at offset 262128 sectors
>        Checksum : bd6c4947 - correct
>          Events : 87705
>=20
>          Layout : left-symmetric
>      Chunk Size : 512K
>=20
>    Device Role : Active device 3
>    Array State : AAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D =
replacing)
>=20
>=20
>=20
> 3) What's the correct procedure that allows me recover most of the
> data, ignoring the readerrors ?
>=20
> 4) I know that sdd2 has read errors at  sectors 1634863440 -
> 1634863800, if i write zero directly to those sectors using 'dd' , how
> will raid behave during rebuild? After a write it will probably be
> able to read it again (i dont care about the data on those sectors) .

If it can read, it will, and will write to the new device.

>=20
> 5) Right now i am not using replaceable option , but where replaceable
> option could help me here ?

I don't think 'replaceable' is particularly relevant here.

NeilBrown


>=20
>=20
> Thanks !


--Sig_/CpGBSUgrtPf8pp0JS7DTtn+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBULQFkznsnt1WYoG5AQIZ2A//SqtCReLJ8baPBVvuEOipiXc0x9SwTATv
RW1v9yJgL9gTLKt/tGADr4OqAo1AJtgzyXBg19ZQbFTHsoQI1KSt1v5N05kePfQ3
3lfFWbTKkYoxVqV2/oc+9A6FsUJPbZu7WpcFXFWRfghfPiOV0z9B90k4YdHZVt7r
4BPPES6YvQZ0F+60LunL2+tchxpB1b7PRV3XuWpMYkg32ZXvt+7xSXzpex5sFrxj
fRtO0BmsPV5KCy4QHEkvvSr9OpkVuMwBFE2knc2WvB0cck/nikHSLsAuhh95aRZN
63x8PRjE0utMUMXVwiBZgNuwkmGobnassyOyegiZsEtEkmRQnrg9X4jtyX4o2PP4
yFKFRBUIfdxLyMf2N1F6HS5Vr7Y1w+ZqEiUGxUhpEsuofUZ0nyZSfwE9UxdFr9Hd
IquwWMWZWSlU8iZ7/na422bz5wCHvsmtWe4fVYwEducBiGjNx1gsiMYDoCNlghDb
0YJeeH3psjWxxzmuu/qmN4QldloG/kJyaEJLlDtmQL0wGl4q62jaNsns9uUd+Ol1
0aTL+gj2g/BA6tdUv9ChlNU5FjR5IENYWH8tJrwe3ur8kk+OD6MPkpBu6ldmp5aA
ojVch6y21wclrME+dh6GVGPLvg//bFHErIWzrwQ7vQizyvGP5er2LE5iOxn4hI46
+KhZ+mKy0OQ=
=1oRj
-----END PGP SIGNATURE-----

--Sig_/CpGBSUgrtPf8pp0JS7DTtn+--
