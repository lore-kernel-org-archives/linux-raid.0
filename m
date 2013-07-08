From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm ignoring X as it reports Y as failed
Date: Mon, 8 Jul 2013 13:58:58 +1000
Message-ID: <20130708135858.347c941e@notabene.brown>
References: <20130706210614.180228gmgmc172qu@mail.netbox.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/9z=7I.4cj3yGRR_R9eDZ_P5"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130706210614.180228gmgmc172qu@mail.netbox.cz>
Sender: linux-raid-owner@vger.kernel.org
To: Marek Jaros <mjaros1@nbox.cz>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/9z=7I.4cj3yGRR_R9eDZ_P5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 06 Jul 2013 21:06:14 +0200 "Marek Jaros" <mjaros1@nbox.cz> wrote:

> Hey everybody.
>=20
> To keep it short, I have a RAID-5 mdraid, just today 2 out of the 5 =20
> drives dropped out. It was a cable issue and has since been fixed. The =20
> array was not being written to or utilized in other way so no data has =20
> been lost.
>=20
> However when I attempted to reassemble the array with
>=20
> mdadm --assemble --force --verbose /dev/md0 /dev/sdc /dev/sdd /dev/sde =20
> /dev/sdf /dev/sdg
>=20
>=20
> I got the folowing errors
>=20
> mdadm: looking for devices for /dev/md0
> mdadm: /dev/sdc is identified as a member of /dev/md0, slot 0.
> mdadm: /dev/sdd is identified as a member of /dev/md0, slot 1.
> mdadm: /dev/sde is identified as a member of /dev/md0, slot 2.
> mdadm: /dev/sdf is identified as a member of /dev/md0, slot 3.
> mdadm: /dev/sdg is identified as a member of /dev/md0, slot 4.
> mdadm: ignoring /dev/sde as it reports /dev/sdc as failed
> mdadm: ignoring /dev/sdf as it reports /dev/sdc as failed
> mdadm: ignoring /dev/sdg as it reports /dev/sdc as failed
> mdadm: added /dev/sdd to /dev/md0 as 1
> mdadm: no uptodate device for slot 2 of /dev/md0
> mdadm: no uptodate device for slot 3 of /dev/md0
> mdadm: no uptodate device for slot 4 of /dev/md0
> mdadm: added /dev/sdc to /dev/md0 as 0
> mdadm: /dev/md0 assembled from 2 drives - not enough to start the array.
>=20
>=20
> After doing --examine* I indeed found out that the StateArray info =20
> inside the superblock has marked the first two drives as missing. That =20
> is however not true anymore but I can't force it to assemble the array =20
> or update the superblock info.
>=20
> So is there anyway to force mdadm to assemble the array? Or perhaps =20
> edit the superblock info manually? I'd rather avoid having to recreate =20
> the array from scratch.
>=20
> Any help or pointers with more info are highly appreciated. Thank you.
>=20

Hi again,
 could you tell me what kernel you are running?  Because as far as I can te=
ll
 the state of the devices that you reported is impossible!

The interesting bit of the --examine output is:

/dev/sdc:
     Update Time : Sat Jul  6 14:43:14 2013
          Events : 2742
    Array State : AAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdd:
     Update Time : Sat Jul  6 14:29:42 2013
          Events : 2742
    Array State : AAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sde:
     Update Time : Sat Jul  6 14:46:15 2013
          Events : 2742
    Array State : ..AAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdg:
     Update Time : Sat Jul  6 14:46:15 2013
          Events : 2742
    Array State : ..AAA ('A' =3D=3D active, '.' =3D=3D missing)

 From this I can see that:
   at 14:29:42 everything was fine and all the superblocks were updated.
   at 14:43:13 everything still seemed to be fine and md tried to update the
               superblock again (it does that from time to time) but failed
               to write to /dev/sdd.  This would have triggered an error so
               it would have marked sdd as faulty and updated the superbloc=
ks
               again.
Probably when it tried it found that the write to sdc failed to, so it mark=
ed
that as faulty and tried again.
   at 14:46:15 it wrote out metadata to sde and sdg reporting that sdc and =
sdd
                were faulty.

Every time that it updates the superblock when the array is degraded it must
update the 'Events' count.  However the Events count at 14:46:15 (after 2
devices have failed) is the same as it was at 14:43:14 before anything had
failed.  That is really wrong.

Hence the question.  I need to know if this is a bug that has already been
fixed (I cannot find a fix, but you never know), or if the bug is still
present and I need to hunt some more.

Thanks,
NeilBrown

--Sig_/9z=7I.4cj3yGRR_R9eDZ_P5
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUdo5Ajnsnt1WYoG5AQJ67Q/+MyiNFrPv/vWxLVE8MeVtCto1HbRGgGCj
kXW5jEc2qVoHFDY2SGXH2Bf29f1mrW4bMBettrCS7FFvPc5wxZONjcZfIOQTfsWQ
Lg8MBo4fZ95nmdkoFoE8xx44QIO6OVaC5JAyTgzTTdvh7vj39ljq3NhgzkzP5yAR
deM2qMPdDXubCTyeKAP9GnVnWsqBJiAfBk6WLCATEPGIe+bnRb0XmrWJryLKysDF
E9lyWD41QmmH/3KUg/7RA5lvPPkoersoaLzg6mOv43JGlDssEzk3Du+8+e9TfFNO
6Uky4+qSEjHIObGZb1gkdimxHn5PiuYI14XlyeDEv1/Qj3gbHcUiYjoXunIsh8cq
5FWErBvNL6S1rqHIDBCXveG1/dBUh1bUG2os8caJCXx/gW3+yQPttNEvUZW0lxzp
GmL5K9IHKo0j0CyHAx8WDUC8Au0vDhQeevmqB9WcD2naLVQURkkBuP/tel5v6Prn
TFgvcrK7wBzrVE5PLpqVTNwqmfq+IxRrtaE6unzCt0eUDtvklwxKTkCTv4vhSyT9
aaD3rx8+N/kXV2ebUhRzhbeKWRWgUTatK5zDr9IwMMghWTyXNDi0QKZWzrdXFsKu
cKJ3InKr9hG+KP2nNmgTXTw1T9k7AEgjX+F0HsoKgHm3L1BS2ko72a5/HEMKf/fN
HW2Ol5D6/ZY=
=3uq/
-----END PGP SIGNATURE-----

--Sig_/9z=7I.4cj3yGRR_R9eDZ_P5--
