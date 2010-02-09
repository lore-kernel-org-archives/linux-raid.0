From: martin f krafft <madduck-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Subject: Re: [[Patch mdadm] 2/5] Move the files mdmon opens into /dev/ to
 support handoff after pivotroot
Date: Tue, 9 Feb 2010 15:19:49 +1300
Message-ID: <20100209021949.GB11780@lapse.rw.madduck.net>
References: <1263242294-5353-3-git-send-email-dledford@redhat.com>
 <20100119110930.107ca42e@notabene>
 <4B55F138.7060008@redhat.com>
 <20100204174009.6072ec07@notabene.brown>
 <4B6B15B3.8030205@redhat.com>
 <e9c3a7c21002041504w17565653m5a8b8cd90543cf1e@mail.gmail.com>
 <4B6DAC06.6060909@redhat.com>
 <e9c3a7c21002061307le6f5d56ked4fa3711bdd2367@mail.gmail.com>
 <4B702EA5.3030103@redhat.com>
 <20100209083838.6568cac0@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-ripemd160;
	protocol="application/pgp-signature"; boundary="3lcZGd9BuhuYXNfi"
Return-path: <initramfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100209083838.6568cac0-wvvUuzkyo1EYVZTmpyfIwg@public.gmane.org>
Sender: initramfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, initramfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Marek <mmarek-l3A5Bk7waGM@public.gmane.org>, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bill Nottingham <notting-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-raid.ids


--3lcZGd9BuhuYXNfi
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org> [2010.02.09.1038 +1300]:
> I could probably actually live with "/dev/run" as the permanent
> home for the mdmon files:  /dev/run/mdmon/*.{sock,pid} It
> addresses most of the issues I had with the original suggestion
> (hidden files, non-generic approach) so the "cons" are weaker.
> And I now understand the "pros" better (races with cleaning
> /var/run, issues with unmounting /var etc).

Note that initramfs already carries /dev across the pivot_root, and
initramfs already uses /dev/.initramfs to carry stuff across.

I am not sure /dev/run will fly past the Debian Police. On the other
hand, it would be convenient, since it'll work out-of-the-box, at
least on Debian systems. I don't really like the idea of a symlink
in / though. Nor do I really have a better idea.

> Anyone second the motion?

I am all for finding a solution that works, but I don't think it's
as easy as "the standards are slow, so let's just forge ahead with
mdadm only and give them something to standardise".

I wouldn't mind avoiding all the bikeshedding, and maybe it'll just
work, but having to change things later might possibly be a lot of
trouble =E2=80=94 after all, we don't want to break people's systems then.

On the other hand, this is something that is reinitialised on every
boot, isn't it? If that's the case and there don't seem to be
complications with a later move, then I say: yeah, let's go ahead.

--=20
 .''`.   martin f. krafft <madduck@d.o>      Related projects:
: :'  :  proud Debian developer               http://debiansystem.info
`. `'`   http://people.debian.org/~madduck    http://vcs-pkg.org
  `-  Debian - when you have better things to do than fixing systems
=20
"when a gentoo admin tells me that the KISS principle is good for
 'busy sysadmins', and that it's not an evolutionary step backwards,
 i wonder whether their tape is already running backwards."

--3lcZGd9BuhuYXNfi
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEAREDAAYFAktwxkUACgkQIgvIgzMMSnXl9QCeN2ku+bY44B3MT/nQZmhx559A
z8UAn20R+f4ShNJn5ygwaX0LMYilHrQe
=Ovk+
-----END PGP SIGNATURE-----

--3lcZGd9BuhuYXNfi--
