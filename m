From: NeilBrown <neilb@suse.de>
Subject: Re: [systemd-devel] systemd kills mdmon if it was started manually
 by user
Date: Wed, 2 Nov 2011 11:44:16 +1100
Message-ID: <20111102114416.7879b77f@notabene.brown>
References: <20110125034434.GC7046@tango.0pointer.de>
	<AANLkTik189VTXYpzLFqP=MNBg=Nx-Yq6BOKURtiby++B@mail.gmail.com>
	<20110125042814.GA9727@tango.0pointer.de>
	<AANLkTik7dd5SHkuBVrS6LLDR9v57GsFjjxDKQKPp-YVL@mail.gmail.com>
	<20110208094843.GD11446@tango.0pointer.de>
	<AANLkTi=rFoqBwKdd0B3Xx6JrGdJdut0a2r=wFh0oSx73@mail.gmail.com>
	<20110208110730.GF23157@tango.0pointer.de>
	<AANLkTinmO9gsJcwr+0bGGuVJfF2dyM5rDJqqSkmh_hqs@mail.gmail.com>
	<20110208172822.GC21847@tango.0pointer.de>
	<CAA9_cmfhUyenz2B1=wDsUtKcrj-5uOURproUemje37bPpM4-Qw@mail.gmail.com>
	<20111031110613.GA1402@tango.0pointer.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/qbC1zt=AFweHA4Gg+4E49Yp"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111031110613.GA1402@tango.0pointer.de>
Sender: linux-raid-owner@vger.kernel.org
To: Lennart Poettering <lennart@poettering.net>
Cc: Dan Williams <dan.j.williams@intel.com>, Andrey Borzenkov <arvidjaar@mail.ru>, Tomasz Torcz <tomek@pipebreaker.pl>, systemd-devel@lists.freedesktop.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/qbC1zt=AFweHA4Gg+4E49Yp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 31 Oct 2011 12:06:13 +0100 Lennart Poettering
<lennart@poettering.net> wrote:

> On Sun, 23.10.11 01:00, Dan Williams (dan.j.williams@intel.com) wrote:
>=20
> > > Well, it would be nice if the md utils would offer something doing th=
is
> > > without spawning multiple processes and killing them again.
> > >
> >=20
> > /me wonders why his raid5 resyncs every boot on Fedora 15 and has
> > found this old thread.
> >=20
> > I'm tempted to:
> >=20
> > 1/ teach ignore_proc() to scan for pid files in /dev/md/ (MDMON_DIR on
> > Fedora)
>=20
> This will not help you.
>=20
> We nowadays jump back into the initrd when we shut down, so that the
> initrd disassembles everything it assembled at boot time. This for the
> first time enables us to ensure that all layers of our stack are in a
> sane state (i.e. fully offline) when we shut down, regardless in which
> way you stack it.

This sounds particularly elegant.
Is there some part of the filesystem, that survives through the whole proce=
ss
- from before / is mounted until after it is unmounted?
Presumably this would be /run if anything.

mdmon must be running from the time that / becomes writable until after it
becomes readonly.
If we can have it from before it is mounted until after it is unmounted, th=
at
might be even better.
(It is possible to start a new one which replaces the old one but if that w=
as
only used for version upgrades, that would be best).

So if mdmon has a 'cwd' and all open files in /run (and the executable
elsewhere in the same filesystem), could it easily survive the 'kill all
processes before unmounting /' thing?

>=20
> However, just excluding mdmom from being killed will not make this work,
> simply because jumping into initrd only works sensibly if we can drop
> all references to all previous mounts which requires us to have only one
> process running at that time, and one process only.
>=20
> It always boils down to the same thing: mdmon must be something we can
> shutdown cleanly like every other process. Excluding it from that will
> just move the problem around, but not fix it.

My ideal would be that you just ignore mdmon.
After unmounting '/', you shutdown md arrays with "mdadm -Ss" and then mdmon
will spontaneously disappear.


>=20
> > 2/ arrange for mdadm --wait-clean --scan to be called after all
> > filesytems have been mounted read only
>=20
> Won't help you really either, since we have to kill all processes before
> we jump into the initrd to fully disassemble mounts and storage.
>=20
> There'll always be this chicken and egg problem: we cannot disassmble
> all storage until all processes are gone and we are back in the
> initrd. But mdmon wants to stay running after we=20
>=20
> > ...but a few things strike me.  This does not seem to be what was
> > being proposed above.  Systemd does not treat dm devices like a
> > service and takes care to shut them down explicitly (but in that case
> > there is an api that it can call).  Is it time for a libmd.so,  so
> > systemd can invoke the "--wait-clean --scan" process itself?  Probably
> > simpler to just SIGTERM mdmon and wait for it.
>=20
> We actually try to disassemble md already, i.e. we call the
> DM_DEV_REMOVE ioctl for all left-over devices. I am not really
> interested to link against libdm itself.

:-)
I get used to this .. people confusing md and dm, people confusing nfs-clie=
nt
with nfs-server, people confusing me with some other Mr Brown :-)

NeilBrown


--Sig_/qbC1zt=AFweHA4Gg+4E49Yp
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTrCSZTnsnt1WYoG5AQKQYw//byMvU8e+Z5MrEe18Y5y2idCclouA70+G
wVmqzST5+fk25u5AJLRRbksWbDvLuZR4B4WSPhy+Bcox9qDQqRjAK+zBzsBUceOZ
ckWBklIuuMJ9dd5HJ7v3rrsYdhRNrJZQOLTWPg7vrVDIwnyvatRuzXOTpTV8lie3
QfQsIumLzg/C1IfddCWsjW0Ub13JtEmre/Nq6UOfcPrpayvL+64EiA4kLJ8zi21S
MiG+C2cYLggowKPZ37lrCo8IdRv0hRmGkOxcaVWZl+dqE6gGTJPA3JtA1yDyJgdg
wbu3mztUNdxAPOMqB75WhZm1z2yZ3to2EclbP8GJY6LSTPtbKeZR/z51TCWvRLwU
TimguwHUq1JlARoOhZpLluPTj1zXUxCFBNzcHTiUxHRXbZEEYHhKtymNw2h387gz
Ls8vrkWvhcmrBI4H0AG3SIO0f7njEEEvhapPqs0EUNc1wAFS0BdsZHYRe0q9OTyj
M28n/QbRtpoYXV2xTuoBy193xJGwBDoIKmf2jSyjBL2gIh5ygtiqnLq4+lEpYy4B
rMRA6mieaUmnbX9IUjt0kEYD2eyMyeT5yvXEeELxDixVTnkvHhdWKUYteIT50r07
2L0Jdkj7YRi/zkIuvALDZfvq8lbmofk6NI6HJBuYcw0MLq0vwfIY6rzXjtL3zkmP
10Ka43hTKCg=
=MTAR
-----END PGP SIGNATURE-----

--Sig_/qbC1zt=AFweHA4Gg+4E49Yp--
