From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [[Patch mdadm] 2/5] Move the files mdmon opens into /dev/ to
 support handoff after pivotroot
Date: Tue, 09 Feb 2010 15:34:18 -0500
Message-ID: <4B71C6CA.3010407@redhat.com>
References: <1263242294-5353-3-git-send-email-dledford@redhat.com> <20100119110930.107ca42e@notabene> <4B55F138.7060008@redhat.com> <20100204174009.6072ec07@notabene.brown> <4B6B15B3.8030205@redhat.com> <e9c3a7c21002041504w17565653m5a8b8cd90543cf1e@mail.gmail.com> <4B6DAC06.6060909@redhat.com> <e9c3a7c21002061307le6f5d56ked4fa3711bdd2367@mail.gmail.com> <4B702EA5.3030103@redhat.com> <20100209083838.6568cac0@notabene.brown> <20100209021949.GB11780@lapse.rw.madduck.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig878B11E8EEBBA2241FC0C644"
Return-path: <initramfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100209021949.GB11780-0owbi4v4jRjYceiJAzDLgeTW4wlIGRCZ@public.gmane.org>
Sender: initramfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, initramfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Marek <mmarek-l3A5Bk7waGM@public.gmane.org>, Hans de Goede <hdegoede@red>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig878B11E8EEBBA2241FC0C644
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 02/08/2010 09:19 PM, martin f krafft wrote:
> also sprach Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org> [2010.02.09.1038 +1300]:
>> I could probably actually live with "/dev/run" as the permanent
>> home for the mdmon files:  /dev/run/mdmon/*.{sock,pid} It
>> addresses most of the issues I had with the original suggestion
>> (hidden files, non-generic approach) so the "cons" are weaker.
>> And I now understand the "pros" better (races with cleaning
>> /var/run, issues with unmounting /var etc).
>=20
> Note that initramfs already carries /dev across the pivot_root, and
> initramfs already uses /dev/.initramfs to carry stuff across.

And the things carried in there should be able to be trivially moved to
a final location.

> I am not sure /dev/run will fly past the Debian Police. On the other
> hand, it would be convenient, since it'll work out-of-the-box, at
> least on Debian systems. I don't really like the idea of a symlink
> in / though. Nor do I really have a better idea.

Persuant to the comments that this should work even if /dev is not
read/write, it really needs to officially be a top level directory (or
else some other mount point that is separate from /dev I think, I guess
it could be in /tmp itself).

>> Anyone second the motion?
>=20
> I am all for finding a solution that works, but I don't think it's
> as easy as "the standards are slow, so let's just forge ahead with
> mdadm only and give them something to standardise".
>=20
> I wouldn't mind avoiding all the bikeshedding, and maybe it'll just
> work, but having to change things later might possibly be a lot of
> trouble =97 after all, we don't want to break people's systems then.

I don't think so.  Once it's all set up, any future change should be no
more than a coordinate package update cycle where initscripts, mkinitrd,
dracut, and a few other select packages that use the locations are all
updated simultaneously.

> On the other hand, this is something that is reinitialised on every
> boot, isn't it? If that's the case and there don't seem to be
> complications with a later move, then I say: yeah, let's go ahead.
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig878B11E8EEBBA2241FC0C644
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktxxsoACgkQg6WylM+/8ZQjvQCgs8CIoIdNTJzMKnRrhq2f/3TU
CDAAn2w/0IkdFBxis9H0CTrZ7OS/tRYJ
=Qx1U
-----END PGP SIGNATURE-----

--------------enig878B11E8EEBBA2241FC0C644--
