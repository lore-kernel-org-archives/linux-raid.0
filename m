From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [[Patch mdadm] 2/5] Move the files mdmon opens into /dev/ to
  support handoff after pivotroot
Date: Tue, 09 Feb 2010 15:30:13 -0500
Message-ID: <4B71C5D5.8040404@redhat.com>
References: <1263242294-5353-1-git-send-email-dledford@redhat.com>	<1263242294-5353-3-git-send-email-dledford@redhat.com>	<20100119110930.107ca42e@notabene>	<4B55F138.7060008@redhat.com>	<20100204174009.6072ec07@notabene.brown>	<4B6B15B3.8030205@redhat.com>	<e9c3a7c21002041504w17565653m5a8b8cd90543cf1e@mail.gmail.com>	<4B6DAC06.6060909@redhat.com>	<e9c3a7c21002061307le6f5d56ked4fa3711bdd2367@mail.gmail.com>	<4B702EA5.3030103@redhat.com> <20100209083838.6568cac0@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8F3907E14B409290B15E8EF4"
Return-path: <initramfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100209083838.6568cac0-wvvUuzkyo1EYVZTmpyfIwg@public.gmane.org>
Sender: initramfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>
Cc: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, initramfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, martin f krafft <madduck-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>, Michal Marek <mmarek-l3A5Bk7waGM@public.gmane.org>, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bill Nottingham <notting-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8F3907E14B409290B15E8EF4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 02/08/2010 04:38 PM, Neil Brown wrote:
> On Mon, 08 Feb 2010 10:32:53 -0500
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>=20
>> On 02/06/2010 04:07 PM, Dan Williams wrote:
>>
>>> This comment makes me see Neil's argument in a different light,
>>> (hopefully I am not mischaracterizing it), but essentially we are
>>> waiting for the standards to catch up with this new class of program.=

>>> FUSE, CUSE, and mdmon belong to a class of programs that move
>>> traditionally exclusive kernel space functionality to userspace.
>>> Debian's /lib/init/rw looks to be a response to this grey area of the=

>>> standards (not that I have any familiarity with the LSB).
>>
>> So if we want to argue that the standards are simply behind the times,=

>> and we need to do something that makes sense regardless of the
>> standards, then I don't think anything in /dev or /lib makes sense.  T=
he
>> files that need to be created pre-rw-root are varied in their type and=

>> purpose between different things.  What we really need is simply an
>> early boot /tmp area.  So, why not make a top level directory that
>> clearly delineates this nature?  Something like /pre-init or /early-tm=
p
>> or whatever?  Or possibly /tmp/pre-boot or /tmp/pre-init or
>> /tmp/pre-pivot-root (the pre-pivot-root naming is awfully linux
>> specific, so maybe /tmp/pre-init or /tmp/pre-boot would be better for
>> possible standards acceptance later)?  I was thinking that mdmon's fil=
es
>> would be stuck there, but then I remembered that we are doing option #=
3
>> for mdmon, restarting after the system is up and running, so only the
>> mdmon instances from the initramfs would put their files there, the
>> final ones would be on the real /var/run area.  So, since as far as I
>> know the mdmon .sock files were the only pre-boot files that couldn't =
be
>> moved later (but effectively get moved by restarting mdmon after r/w
>> /var/run), any and all files in /tmp/pre-pivot-root should be removed
>> once the system is up and running, and quite possibly the filesystem
>> could be entirely done away with.  At least then the naming would be t=
o
>> Neil's satisfaction I think, and mine.  And personally, when the
>> standards are simply behind the times, I have no problem blazing ahead=

>> and letting them catch up when they get off their asses.
>>
>>
>=20
> That's the spirit!!!
> Let's figure out what we really want/need, and just do it.
>=20
> Following my recent discovery that mdmon prevents /var from being unmou=
nted
> at shutdown, I wonder if we really want something generic that persists=
 from
> very early boot to very late shutdown, rather than just the early-boot =
part.
> So something like /var/run, but not dependent on /var and guaranteed to=
 be
> in-memory (or swap) and created very early by initramfs.
>=20
>    /run
> ???
> Trivial implementation for most distros would be to make it a symlink
> to /dev/run.
>=20
> I would prefer a name a little more descriptive than "/run" - something=
 that
> reflects the idea that it is particularly for early-boot or late-shutdo=
wn -
> but nothing comes to mind.
>=20
> I could probably actually live with "/dev/run" as the permanent home fo=
r the
> mdmon files:  /dev/run/mdmon/*.{sock,pid}
> It addresses most of the issues I had with the original suggestion (hid=
den
> files, non-generic approach) so the "cons" are weaker.  And I now under=
stand
> the "pros" better (races with cleaning /var/run, issues with unmounting=
 /var
> etc).
>=20
> Anyone second the motion?

I second the idea, but I hate the name run.  Mainly because it's not
really descriptive to the issue at hand.  I mean, everything needs to
run, the part that's different about all of this is that it needs to run
*pre-root-filesystem-available*.

If we were to stick with unix tradition of being short and cryptic (but
make sense when explained), then /ptmp -> /dev/ptmp might work with the
explanation being that it's a pre-init temporary file area (or
pre-root-filesystem temporary file area).

Of course, the /ptmp -> /dev/ptmp would only be if we are using the dev
filesystem for simplicity's sake.  However, as someone else mentioned,
realistically if we want this to be accepted, it should not be dependent
on udev and a tmpfs based dev directory, it should stand on its own.
Meaning that it *should* be its own minor tmpfs filesystem mounted at
/ptmp.  But maybe that's something to work toward versus a first step.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig8F3907E14B409290B15E8EF4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktxxdUACgkQg6WylM+/8ZQ58gCeLgOGMXGijQSBGMwHxsktsPJt
lScAoKfOM4VTZlz0+6hOrsqIruL915y5
=tCCb
-----END PGP SIGNATURE-----

--------------enig8F3907E14B409290B15E8EF4--
