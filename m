From: NeilBrown <neilb@suse.de>
Subject: Re: Advice recovering from interrupted grow on RAID5 array
Date: Thu, 17 Oct 2013 11:07:25 +1100
Message-ID: <20131017110725.54de5b06@notabene.brown>
References: <CA+90J__=u_m9RW7c9KHGMRr+6ZOSVQUN6yXm61YM_yir-7LE7A@mail.gmail.com>
	<20131016162625.628c5558@notabene.brown>
	<CA+90J_9vLnEVPhAkQmZ5VS=gTw0fjf107wf=2riLn+=RstJMSQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/CYzRHRUExwUtddGTE9Lxxbz"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+90J_9vLnEVPhAkQmZ5VS=gTw0fjf107wf=2riLn+=RstJMSQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: John Yates <jyates65@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/CYzRHRUExwUtddGTE9Lxxbz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 16 Oct 2013 09:02:52 -0400 John Yates <jyates65@gmail.com> wrote:

> On Wed, Oct 16, 2013 at 1:26 AM, NeilBrown <neilb@suse.de> wrote:
> > On Mon, 14 Oct 2013 21:59:45 -0400 John Yates <jyates65@gmail.com> wrot=
e:
> >
> >> Midway through a RAID5 grow operation from 5 to 6 USB connected
> >> drives, system logs show that the kernel lost communication with some
> >> of the drive ports which has left my array in a state that I have not
> >> been able to reassemble. After reseating the cable connections and
> >> rebooting, all of the drives appear to be functioning normally, so
> >> hopefully the data is still intact. I need advice on recovery steps
> >> for the array.
> >>
> >> It appears that each drive failed in quick succession with /dev/sdc1
> >> being the last standing and having the others marked as missing in its
> >> superblock. The superblocks of the other drives show all drives as
> >> available. (--examine output below)
> >>
> >> >mdadm --assemble /dev/md127 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /=
dev/sdf1 /dev/sdg1
> >> mdadm: too-old timestamp on backup-metadata on device-5
> >> mdadm: If you think it is should be safe, try 'export MDADM_GROW_ALLOW=
_OLD=3D1'
> >> mdadm: /dev/md127 assembled from 1 drives - not enough to start the ar=
ray.
> >
> > Did you try following the suggestion and run
> >
> >  export MDADM_GROW_ALLOW_OLD=3D1
> >
> > and the try the --asssemble again?
> >
> > NeilBrown
>=20
> Yes I did, thanks. Not much change though. It accepts the timestamp,
> but then appears not to use it.
>=20
> mdadm --assemble /dev/md127 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1
> /dev/sdf1 /dev/sdg1 --verbose
> mdadm: looking for devices for /dev/md127
> mdadm: /dev/sdb1 is identified as a member of /dev/md127, slot 4.
> mdadm: /dev/sdc1 is identified as a member of /dev/md127, slot 3.
> mdadm: /dev/sdd1 is identified as a member of /dev/md127, slot 2.
> mdadm: /dev/sde1 is identified as a member of /dev/md127, slot 0.
> mdadm: /dev/sdf1 is identified as a member of /dev/md127, slot 1.
> mdadm: /dev/sdg1 is identified as a member of /dev/md127, slot 5.
> mdadm: :/dev/md127 has an active reshape - checking if critical
> section needs to be restored
> mdadm: accepting backup with timestamp 1381360844 for array with
> timestamp 1381729948
> mdadm: backup-metadata found on device-5 but is not needed
> mdadm: added /dev/sdf1 to /dev/md127 as 1
> mdadm: added /dev/sdd1 to /dev/md127 as 2
> mdadm: added /dev/sdc1 to /dev/md127 as 3
> mdadm: added /dev/sdb1 to /dev/md127 as 4 (possibly out of date)
> mdadm: added /dev/sdg1 to /dev/md127 as 5 (possibly out of date)
> mdadm: added /dev/sde1 to /dev/md127 as 0
> mdadm: /dev/md127 assembled from 4 drives - not enough to start the array.


What about with MDADM_GROW_ALLOW_OLD=3D1 *and* --force ??

If that doesn't work, please add --verbose as well, and report the output.

NeilBrown

--Sig_/CYzRHRUExwUtddGTE9Lxxbz
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUl8qPTnsnt1WYoG5AQLQHxAAgOl8Q5tQJJMHAMkkjeZXhkogucVPamF7
KqfqH8dMNhlWKrwkK/tf1TWrMJM+KdCWRQ7cAemlWmwB5GeLcQKrUTY28vkn1COe
oM79L4he8yO4debOlWV4cxHXZYOypRXN4I2UhoKSRVmHIKDkxx1MipnuN/qHtuFW
tBoy0QJPYvbdZZ5/1SsCwGOSAWOc+03Mel7HAcmtW28FNORtIv4sLFnZlqgXYltX
vfZcwT5TgztEz/bC8fhZryHLcxD5Hanerpp6jZibO5rQAMbsa8xeD41Ai4NNBlYf
y2laKAWCF/mTX5Yxp2nwiLBVgw+PMYmAS2jBOVQehGytTDPHD1ENsjIxgOcZ+LZj
t/R3tmGiGyr/Nt7WqvK5BvAvxINFArvwkSwO1tf+vNHmij1xjRQQM9jOAiSC1IEn
3vSyUzyqsj1zOdxHK9iwkoEdKbl2Fy67cijpNumW+rp37SaeMyIPJss52lQQeggD
tZQypOPGHsIGMTWs82GXIuoK6qvwNYFOd7je7HqW2ylCQIhOQPm3n14+3XLh8Ur3
c0t/kfSujTfX2kwzxU7N4VHLCixXTapqM3MdSJNCeU1n1C/pmLdavpyBlG5JLCSS
BNMzan+ILQJNapRhDrs0mwbleJKyUpAlUO7O2o5/Xf17reChKKhxVoEPLEHko9Y8
we0AJgzsUSE=
=cWXi
-----END PGP SIGNATURE-----

--Sig_/CYzRHRUExwUtddGTE9Lxxbz--
