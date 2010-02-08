From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [[Patch mdadm] 2/5] Move the files mdmon opens into /dev/ to
 	support handoff after pivotroot
Date: Mon, 08 Feb 2010 10:32:53 -0500
Message-ID: <4B702EA5.3030103@redhat.com>
References: <1263242294-5353-1-git-send-email-dledford@redhat.com>	 <1263242294-5353-3-git-send-email-dledford@redhat.com>	 <20100119110930.107ca42e@notabene> <4B55F138.7060008@redhat.com>	 <20100204174009.6072ec07@notabene.brown> <4B6B15B3.8030205@redhat.com>	 <e9c3a7c21002041504w17565653m5a8b8cd90543cf1e@mail.gmail.com>	 <4B6DAC06.6060909@redhat.com> <e9c3a7c21002061307le6f5d56ked4fa3711bdd2367@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8C2EC1085F7E56718E20F071"
Return-path: <initramfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e9c3a7c21002061307le6f5d56ked4fa3711bdd2367-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: initramfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, initramfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, martin f krafft <madduck-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>, Michal Marek <mmarek-l3A5Bk7waGM@public.gmane.org>, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bill Nottingham <notting-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8C2EC1085F7E56718E20F071
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 02/06/2010 04:07 PM, Dan Williams wrote:

> This comment makes me see Neil's argument in a different light,
> (hopefully I am not mischaracterizing it), but essentially we are
> waiting for the standards to catch up with this new class of program.
> FUSE, CUSE, and mdmon belong to a class of programs that move
> traditionally exclusive kernel space functionality to userspace.
> Debian's /lib/init/rw looks to be a response to this grey area of the
> standards (not that I have any familiarity with the LSB).

So if we want to argue that the standards are simply behind the times,
and we need to do something that makes sense regardless of the
standards, then I don't think anything in /dev or /lib makes sense.  The
files that need to be created pre-rw-root are varied in their type and
purpose between different things.  What we really need is simply an
early boot /tmp area.  So, why not make a top level directory that
clearly delineates this nature?  Something like /pre-init or /early-tmp
or whatever?  Or possibly /tmp/pre-boot or /tmp/pre-init or
/tmp/pre-pivot-root (the pre-pivot-root naming is awfully linux
specific, so maybe /tmp/pre-init or /tmp/pre-boot would be better for
possible standards acceptance later)?  I was thinking that mdmon's files
would be stuck there, but then I remembered that we are doing option #3
for mdmon, restarting after the system is up and running, so only the
mdmon instances from the initramfs would put their files there, the
final ones would be on the real /var/run area.  So, since as far as I
know the mdmon .sock files were the only pre-boot files that couldn't be
moved later (but effectively get moved by restarting mdmon after r/w
/var/run), any and all files in /tmp/pre-pivot-root should be removed
once the system is up and running, and quite possibly the filesystem
could be entirely done away with.  At least then the naming would be to
Neil's satisfaction I think, and mine.  And personally, when the
standards are simply behind the times, I have no problem blazing ahead
and letting them catch up when they get off their asses.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig8C2EC1085F7E56718E20F071
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktwLqUACgkQg6WylM+/8ZSVmQCeIJKALtegyzSsEVkKCN0YLSdW
AiIAnieaeua4ah9dD0D0P4Jtg6MJ0bIf
=zQpi
-----END PGP SIGNATURE-----

--------------enig8C2EC1085F7E56718E20F071--
