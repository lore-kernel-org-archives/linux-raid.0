From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm 3.3: issue with mdmon --takeover
Date: Thu, 12 Sep 2013 15:03:31 +1000
Message-ID: <20130912150331.254aba60@notabene.brown>
References: <CAC9WiBjg4Tbv_UM4o66-8jtFEYGvh3kuP6xSdnz7uL+fq3fZTQ@mail.gmail.com>
	<20130904160832.3627bcb8@notabene.brown>
	<CAC9WiBiHkOjqY4nDwMh4S8td9NMz2mrdqK0R7cZp7nKSMyhBvg@mail.gmail.com>
	<20130905121123.27968f9f@notabene.brown>
	<CAC9WiBiHcS126iFv91250d83sMrBYmRbvoqYAEhjJWjb2p5J3A@mail.gmail.com>
	<CAC9WiBgRiu_YL1TpzD4dtLXv=LiA-RERn+C6Q+i=P_WTNdw3+w@mail.gmail.com>
	<20130911093518.794bbb21@notabene.brown>
	<CAC9WiBiRWN4sZ=nd2R3+XqxMD2X=d9F6JtDGpXaNX1jtOFMB4w@mail.gmail.com>
	<CAC9WiBjsC1E2HV2vmiiKmGFXBBmZ+Rh0gktvxebKqZbKqD2hpw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/19pMhObWE7ilk.5Ab_whXRu"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC9WiBjsC1E2HV2vmiiKmGFXBBmZ+Rh0gktvxebKqZbKqD2hpw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Cc: Martin Wilck <mwilck@arcor.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/19pMhObWE7ilk.5Ab_whXRu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 11 Sep 2013 10:11:29 +0200 Francis Moreau <francis.moro@gmail.com>
wrote:

> On Wed, Sep 11, 2013 at 9:40 AM, Francis Moreau <francis.moro@gmail.com> =
wrote:
> [...]
> >>
> >> I think this patch will help.  The last hunk in particular should make=
 the
> >> difference.
> >>
> >> Please let me know if it fixes the problem.
> >>
> >
> > Yes it fixes the problem.
> >
> > I had to adjust the patch to make it compile by using be64_to_cpu()
> > where needed.
> >
>=20
> Hmm unfortunately the following test case seems broken too, I'm not
> sure it's related however:
>=20
> # create a ddf array containing loop0 and loop1
> $ cat /proc/mdstat
> Personalities : [raid1]
> md124 : active raid1 loop0[1] loop1[0]
>       84416 blocks super external:/md125/0 [2/2] [UU]
>=20
> md125 : inactive loop1[1](S) loop0[0](S)
>       65536 blocks super external:ddf
>=20
> # stop the array
> $ mdadm --stop /dev/md124
> mdadm: stopped /dev/md124
> $ mdadm --stop /dev/md125
> mdadm: stopped /dev/md125
>=20
> # Add only one disk
> $ mdadm -I /dev/loop0
> mdadm: container /dev/md/ddf1 now has 1 device
> mdadm: /dev/md/array1 assembled with 1 device but not started
>=20
> # start the array
> $ mdadm -R /dev/md124

Does
  mdadm -IRs
work at this point?

If so, it is just a problem with my quick reimplementation of "-R".
I've made a note to look at it when I get a chance.

NeilBrown

>=20
> # looks like it failed
> $ cat /proc/mdstat
> Personalities : [raid1]
> md124 : inactive loop0[0]
>       84416 blocks super external:/md125/0
>=20
> md125 : inactive loop0[0](S)
>       32768 blocks super external:ddf
>=20
> # start mdmon manually with debug trace
> $ mdmon /dev/md125
> starting mdmon for md125
> monitor: wake ( )
> no arrays to monitor... exiting
>=20
>=20


--Sig_/19pMhObWE7ilk.5Ab_whXRu
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUjFLIznsnt1WYoG5AQJP8A//fJj2CmFZqQ5qXef/+2jDvW4t65ETITr2
pNaiu1uRlaCihyvYiyRe8SinNYEAaepu4CEHkx7tH+NJ6s/bg7xZ2PyrITx9pEAC
Z/0TSWwwpGJk7ldunGAufhEL2SYcPJUT9yqq+tir/eT7XmLEaN5/7+WizMjjKW9/
98L7Rk5f+EFtvWXLAdUrMG/6Oqh7QHvJ/7gx4Q4VYJtgZYhxlk4SL7arcnmt/jb/
iVFh3x4PTdbE3bpmuU39olWkBXzsJv1UFNjFdx0RYxEPfTOef161yNMRyI5efIfA
/DgsFTi8RevVVxR1TuZGjZIRSDXG+UEnA/pOq9C3QuaLRRMUuFcA3Dfxa/kWq/it
5Q5KmWFup0dxUUP2SJTZvZXHfWzNZ1Uc2ik/3RH/wZMeH8n05I/lNdeQPRlHCsns
nKLnQauof6BECTyjQ6eoanCa1jE0afeWOLrs4k0vsy7HhR5IK8pthOT8Z/RTm3VW
mcycM65KzxVLZXqQLNIQVeHunS3KlkzpUn6534BLOlJknLtrMaFRdv12w9o4Kc6I
DsO4iKTWF/Jk5JvYIn/HjmruScz8cjAomp7Qi/0sKg9B5HXip9wd0dItkAEGFxX8
C2Xg0Qa9vEK07MaK5wlvrZSxuJJcL4xmw9qFnSkMFQTod5fsOTKkCIkj+H24F+vF
mjKAs9vjL4Q=
=xx7B
-----END PGP SIGNATURE-----

--Sig_/19pMhObWE7ilk.5Ab_whXRu--
