From: martin f krafft <madduck-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Subject: Re: [[Patch mdadm] 2/5] Move the files mdmon opens into /dev/ to
 support handoff after pivotroot
Date: Sun, 7 Feb 2010 10:46:40 +1300
Message-ID: <20100206214640.GB20587@lapse.rw.madduck.net>
References: <1263242294-5353-1-git-send-email-dledford@redhat.com>
 <1263242294-5353-3-git-send-email-dledford@redhat.com>
 <20100119110930.107ca42e@notabene>
 <4B55F138.7060008@redhat.com>
 <20100204174009.6072ec07@notabene.brown>
 <4B6B15B3.8030205@redhat.com>
 <e9c3a7c21002041504w17565653m5a8b8cd90543cf1e@mail.gmail.com>
 <4B6DAC06.6060909@redhat.com>
 <e9c3a7c21002061307le6f5d56ked4fa3711bdd2367@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-ripemd160;
	protocol="application/pgp-signature"; boundary="uZ3hkaAS1mZxFaxD"
Return-path: <initramfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <e9c3a7c21002061307le6f5d56ked4fa3711bdd2367-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: initramfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, initramfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Marek <mmarek-l3A5Bk7waGM@public.gmane.org>, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bill Nottingham <notting-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-raid.ids


--uZ3hkaAS1mZxFaxD
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> [2010.02.07.1007 +1300]:
> This comment makes me see Neil's argument in a different light,
> (hopefully I am not mischaracterizing it), but essentially we are
> waiting for the standards to catch up with this new class of
> program. FUSE, CUSE, and mdmon belong to a class of programs that
> move traditionally exclusive kernel space functionality to
> userspace. Debian's /lib/init/rw looks to be a response to this
> grey area of the standards (not that I have any familiarity with
> the LSB).

I have not read the full thread for lack of time, but I would like
to chime in that I favour user-space over kernel-space any day: it
makes for stabler systems, better interfaces, and easier upgrades
=E2=80=94 even though it's definitely more work for the distro maintainers.

So mdmon seems like a good idea, even though some details might need
to be worked out to everyone's satisfaction yet.

I agree with Dan that this trend is new and that slow-moving
standards like the FHS have yet to catch up. But they cannot catch
up if distros don't explore the field. Debian's latest move in this
exploration was indeed /lib/init/rw, but it's questionable, not only
because it's a tmpfs, which makes it unusable for e.g. md bitmaps
=E2=80=94 unless we invented a place that moved to persistent storage as
early as possible, in a way that would make it accessible early
during the next boot. But now I am diverting the topic=E2=80=A6

--=20
 .''`.   martin f. krafft <madduck@d.o>      Related projects:
: :'  :  proud Debian developer               http://debiansystem.info
`. `'`   http://people.debian.org/~madduck    http://vcs-pkg.org
  `-  Debian - when you have better things to do than fixing systems
=20
"there are two major products that come out of berkeley: lsd and unix.
 we don't believe this to be a coincidence."
                                                 -- jeremy s. anderson

--uZ3hkaAS1mZxFaxD
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEAREDAAYFAktt40AACgkQIgvIgzMMSnX4fQCgsyGhAdpfuObqWlkmBLNFI/jO
YxQAniFBRkITdqXjkkx1VgkHHNCJDbO2
=tLKB
-----END PGP SIGNATURE-----

--uZ3hkaAS1mZxFaxD--
