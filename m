From: NeilBrown <neilb@suse.de>
Subject: Re: Please advise, strange "not enough to start the array while not
 clean"
Date: Mon, 22 Sep 2014 16:56:02 +1000
Message-ID: <20140922165602.43330805@notabene.brown>
References: <CAAOsTSkaFdum4LD8aOkOsG-f45fTjRSUPb=EqguJi4yaNjcSdQ@mail.gmail.com>
	<20140922131940.58f97093@notabene.brown>
	<CAAOsTSncnYC=hTMtQ8O-dOAdkqueqP3=kJJi6jfoAb1CwQtvHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/Jkz54CbR+XTPDJrXmMEiBjw"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAOsTSncnYC=hTMtQ8O-dOAdkqueqP3=kJJi6jfoAb1CwQtvHA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Patrik =?UTF-8?B?SG9ybsOtaw==?= <patrik@dsl.sk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Jkz54CbR+XTPDJrXmMEiBjw
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 22 Sep 2014 08:34:21 +0200 Patrik Horn=C3=ADk <patrik@dsl.sk> wrote:

> - Well what is exact meaning of --no-degraded then? Because I am using
> it also on RAID6 arrays that are missing one drive and mdadm starts
> them. I thought until today that it is against assembling for example
> RAID6 array with missing more than two drives or to be more precise
> array with number of drives it used last time. (I did not look at the
> code what does it exactly. It is mdadm 3.3 on Debian.)

Sorry, I confused myself.
"--no-degraded" means "Only start the array if all expected devices are
present".
So if the array "knows" that one device is missing, it will start if all
other devices are present.  But if it "thinks" that all devices are working,
then it will only start if all the devices ar there.

>=20
> - Well array was shutdown cleanly manually by mdadm -S. Cant the not
> clean classification be result of md101 device between find devices or
> result of first two assemble tries?

If the state still says "Clean" (which it does, thanks), the mdadm should
treat it as 'clean'.

I think you are probably hitting the bug fixed by

 http://git.neil.brown.name/?p=3Dmdadm.git;a=3Dcommitdiff;h=3D56bbc588f7f0f=
3bdd3ec23f02109b427c1d3b8f1

which is in 3.3.1.

So a new version of mdadm should fix it.

NeilBrown



>=20
> - Anyway as I mentioned superblock on all five devices has clean state. E=
xample:
> /dev/sdk1:
>           Magic : XXXXXXX
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : XXXXXXXXXXXXXXXXXXXXX
>            Name :
>   Creation Time : Thu Aug XXXXXXXX
>      Raid Level : raid6
>    Raid Devices : 6
>=20
>  Avail Dev Size : 5860268943 (2794.39 GiB 3000.46 GB)
>      Array Size : 11720536064 (11177.57 GiB 12001.83 GB)
>   Used Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=3D262056 sectors, after=3D911 sectors
>           State : clean
>     Device UUID : YYYYYYYYYYYYYYYYYYYY
>=20
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Mon Sep 22 02:23:45 2014
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : ZZZZZZZZ - correct
>          Events : EEEEEE
>=20
>          Layout : left-symmetric
>      Chunk Size : 512K
>=20
>    Device Role : Active device 4
>    Array State : AAAAA. ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=
=3D replacing)
>=20
> - md101 has Events count lower by 16 than others devices.
>=20
> - Please I need little more assurance what is exact state of array and
> explain why it is behaving as it is behaving, so I can be sure what
> steps are needed and what happens. The data on array is important.
> Patrik Horn=C3=ADk
> =C5=A1=C3=A9fredaktor www.DSL.sk
> Tel.: +421 905 385 666
> Email: patrik@dsl.sk
>=20
>=20
> 2014-09-22 5:19 GMT+02:00 NeilBrown <neilb@suse.de>:
> > On Mon, 22 Sep 2014 04:11:20 +0200 Patrik Horn=C3=ADk <patrik@dsl.sk> w=
rote:
> >
> >> Hello Neil,
> >>
> >> I've got this situation unfamiliar to me on RAID6 array md1 with impor=
tant data.
> >>
> >> - It is RAID6 with 6 devices, 5 are partitions and 1 is another RAID0
> >> array md101 from two smaller drives. One of the smaller drives froze,
> >> so md101 got kicked out from md1 and marked as faulty in md1. After
> >> while I've stopped md1 without removing md101 from it first. Then I
> >> rebooted and assembled md101.
> >>
> >> - First I tried mdadm -A --no-degraded -u UUID /dev/md1 but got
> >> "mdadm: /dev/md1 assembled from 5 drives (out of 6), but not started."
> >> so I stopped the md1.
> >>
> >> - Second time I started it with -v and got:
> >>
> >> mdadm: /dev/md101 is identified as a member of /dev/md1, slot 5.
> >> mdadm: /dev/sdk1 is identified as a member of /dev/md1, slot 4.
> >> mdadm: /dev/sdi1 is identified as a member of /dev/md1, slot 1.
> >> mdadm: /dev/sdh1 is identified as a member of /dev/md1, slot 2.
> >> mdadm: /dev/sdg1 is identified as a member of /dev/md1, slot 0.
> >> mdadm: /dev/sde1 is identified as a member of /dev/md1, slot 3.
> >> mdadm: added /dev/sdi1 to /dev/md1 as 1
> >> mdadm: added /dev/sdh1 to /dev/md1 as 2
> >> mdadm: added /dev/sde1 to /dev/md1 as 3
> >> mdadm: added /dev/sdk1 to /dev/md1 as 4
> >> mdadm: added /dev/md101 to /dev/md1 as 5 (possibly out of date)
> >> mdadm: added /dev/sdg1 to /dev/md1 as 0
> >> mdadm: /dev/md1 assembled from 5 drives (out of 6), but not started.
> >>
> >> - On third time I tried without --nodegraded with mdadm -A -v -u UUID
> >> /dev/md1. This is what I've got:
> >>
> >> mdadm: /dev/md101 is identified as a member of /dev/md1, slot 5.
> >> mdadm: /dev/sdk1 is identified as a member of /dev/md1, slot 4.
> >> mdadm: /dev/sdi1 is identified as a member of /dev/md1, slot 1.
> >> mdadm: /dev/sdh1 is identified as a member of /dev/md1, slot 2.
> >> mdadm: /dev/sdg1 is identified as a member of /dev/md1, slot 0.
> >> mdadm: /dev/sde1 is identified as a member of /dev/md1, slot 3.
> >> mdadm: added /dev/sdi1 to /dev/md1 as 1
> >> mdadm: added /dev/sdh1 to /dev/md1 as 2
> >> mdadm: added /dev/sde1 to /dev/md1 as 3
> >> mdadm: added /dev/sdk1 to /dev/md1 as 4
> >> mdadm: added /dev/md101 to /dev/md1 as 5 (possibly out of date)
> >> mdadm: added /dev/sdg1 to /dev/md1 as 0
> >> mdadm: /dev/md1 assembled from 5 drives - not enough to start the
> >> array while not clean - consider --force.
> >>
> >> Array md1 has bitmap. All drive devices have all same Events, their
> >> state is clean and Device Role is Active device. md101 has active
> >> state and lower Events.
> >>
> >> Is this expected behavior? My theory is that it is caused by md101 and
> >> I should start array md1 without it (by for example stopping md101)
> >> and then re-add it. Is that a case or is it something else?
> >>
> >> Thanks.
> >>
> >> Best regards,
> >>
> >> Patrik
> >
> >
> > The array is clearly degraded as one of the devices failed and hasn't b=
een
> > recovered yet, so using --nodegraded is counter productive, as you
> > discovered.
> >
> > It appears that the array is also marked as 'dirty'.  That suggests tha=
t it
> > wasn't shut down cleanly.
> > What does "mdadm --examine" of some device show?
> >
> > You probably need to re-assemble the array with --force like it suggest=
s,
> > then add the failed device and let it recover.
> >
> > NeilBrown
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/Jkz54CbR+XTPDJrXmMEiBjw
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVB/IAjnsnt1WYoG5AQIzQg//eaqMwS4ywAWA/q4Jm20cv/WkQ1sRGYMC
X7TqIPnKXy1ImIXCeEYnwtZWjrBV/MBj7pUEUFJPxMhJffoydUcmaincls6W3+G7
Vh1aSn90Eb42iYHHlnG0P5Q0Wp5DDigA845vMcfYJFsCs4Q++eFy2yLEtCzaDkwD
WfaBIaeSAK2ljOjdB0TdewNA4yDJI5MuJY4GtCElUzVpuqDKi2lat529AixZ6Zld
Y/9DImGaI6HHqeGSRiW7LOhx6ygA+YgpfCiq43l/fVOiedyvmUcgkZEesWt0lUdQ
iqb6EIG4TOMGdxaSLOLbM2zO0uNs0GdkKyQLLQcTX4NMvOy0OCxud77k9kzqWOoy
0YoQnKzKtP+70qMWMG8SLzBPxOrL+oRJzv5DUjoDjI6dbM2ch5oEFbEvCJWXw8fS
UNs4dFRwww3hIdfzTCCCwyOi+1qH+oL3iyGcAB2sIhMqWhmfQgHgKBFVWj4d2ghG
4O6fvPxU/8hNhueGiy7lb/wbTgwXfBpwvGTUAvVBwd1OSgG0xVYCRaG81rZXAFUB
biACQmBw0Y0qES0fHRBv6++FTXYGrj9D2rCbDaQYkyr27DXdBwyRcfy4UdZuD4Lo
HcuYf8SZHiCE6uIt9sAyN2IQp6DskEysixqsFcixZjSL0Y0vZnDyYeTM3RjWHr5G
ZSQ96uWEUBw=
=+QGk
-----END PGP SIGNATURE-----

--Sig_/Jkz54CbR+XTPDJrXmMEiBjw--
