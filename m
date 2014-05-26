From: NeilBrown <neilb@suse.de>
Subject: Re: Rebuilding a RAID5 array after drive (hardware) failure
Date: Tue, 27 May 2014 09:03:23 +1000
Message-ID: <20140527090323.2f68b473@notabene.brown>
References: <CAG__1a52uiLi8PAm6deHyx14yQ8JfOmaiOicEn86kYBqJG_1HQ@mail.gmail.com>
	<20140522144905.50511c1a@notabene.brown>
	<CAG__1a4-MxTjiFMt4n3YsK0DxLvcT2raadcPLvKDuOam9JgPXw@mail.gmail.com>
	<CAG__1a7QFWguQ_YDzDCLO1xM9DMe8bZs-p97-Jc0CYCjpdusXg@mail.gmail.com>
	<20140526104640.0895483c@notabene.brown>
	<CAG__1a6yGqmU3CD4HV5uSFL8h3Eu5=mK03kjOp1sw2xhsdhSyg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/HCC_WISRYnf09nhNV3Xu8=W"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAG__1a6yGqmU3CD4HV5uSFL8h3Eu5=mK03kjOp1sw2xhsdhSyg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: George Duffield <forumscollective@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/HCC_WISRYnf09nhNV3Xu8=W
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 26 May 2014 21:57:15 +0200 George Duffield
<forumscollective@gmail.com> wrote:

> >> - Can it be renamed to md0?
> >
> > Sure.
> > If this is being assembled by the initrd, then either the initrd must s=
et the
> > hostname to "fileserver" before mdadm gets to assemble the array, or the
> > initrd must contain an /etc/mdadm.conf which lists "/dev/md0" has havin=
g the
> > UUID of this array.
> >
> > NeilBrown
> >
>=20
> I'm learning a few things the hard way here e.g. I had saved my
> mdadm.conf to a file in the home folder of the default user so I could
> reference it later if needs be - no flash, no file.  Next time email
> it to myself.
>=20
> If I were to run sudo update-initramfs -u would that restore things or
> pretty much make md127 permanent.

I can't see.  Each distro has their own 'initramfs' building code.
What I would probably do is:
  - run update-initramfs
    mkdir /tmp/i; cd /tmp/i; zcat /boot/initramfs | cpio -idv
      # note, filename might be wrong
  - inspect /tmp/i/etc/mdadm.conf and  fstab etc etc and make sure
    "/dev/md0" is used and "/dev/md127" isn't.=20
  - make changes as necessary
  - find | cpio -oc | gzip --best > /boot/initramfs.test

then figure a way to boot from /boot/initramfs.test

>=20
> In the event update-initramfs -u is not the way to go, it there an
> example of a good mdadm.conf floating about that I can reference to
> make the necessary changes?

It is really worth making the effort to read the man page and understand how
to make your own /etc/mdadm.conf

   mdadm -Ds

is a good start, but should be examined and edited to make sure it matches
your requirements.

All you really need is:

    ARRAY /dev/md0 UUID=3Dwhatever:xxxxxxx......

That is it.

NeilBrown



--Sig_/HCC_WISRYnf09nhNV3Xu8=W
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU4PIPDnsnt1WYoG5AQLBvw/8D8pO91MrYKMv442eNgY6xkGsilEFzfAW
oiO4aVWqxuhp+1JXBJthGleLlObYtZTRuMXPsksTtWXxIyuL2Is+meo+3CMzjcH/
h33iXfN0yqFbwkSjW+wCxPxsCtJfBKh1F4vGBu3j35z+71OQieMokwcjAcd3FB8+
VEuG04SOMfW2Ke53Wn+AE9GHfDcqFFjTM8rII9+mHZHlzf5iCQalvQ+RC57QyEjA
qDrSqcsUglGux6LaIP/lJpp4HerNPsEaGRzTgs916Gy1HMNLvNt6jMGctYpQ+vgx
WlxINHwILKYMLTZW0cZjZnrkkB0GIWbLO+UUqgs4aAZY647oOqqBFK1ku0y/fEHc
EQzLWMJv0aXimBgACktHB4nJ1Lqv49nu28Wt9ZFBOCnBEesjwJLEr3MVI6+II5pg
Q+ZUqrl/wY6bHzlUOUY+ruSD1vXYanUcCSctSC2Q0lCfYJ5q5DmTryj97zwHh7vx
OsvgdWnh7DuYE6Yp2liw/2IwASi9+Gz/anMNDPZ8TFKTic96GfU4u9sVKGsnSQCJ
jPzfEocaIYKoWxsM1HqC6TA7uBq7aDRceIgo/8VU1srd5J1yH7b2jQAC+7awRCnN
7KagWESGRXYdSEr3PMNPAhprUlvr76Nk9VM9NHXO+3PQQX35ehTlYjTWPNmJOzUr
ujOCI/vKCww=
=TfOq
-----END PGP SIGNATURE-----

--Sig_/HCC_WISRYnf09nhNV3Xu8=W--
