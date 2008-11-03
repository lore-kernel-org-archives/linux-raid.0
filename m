From: Doug Ledford <dledford@redhat.com>
Subject: Re: RFC - device names and mdadm with some reference to udev.
Date: Mon, 03 Nov 2008 09:34:31 -0500
Message-ID: <1225722871.26510.326.camel@firewall.xsintricity.com>
References: <18692.62860.863118.727187@notabene.brown>
	 <1225387127.26510.155.camel@firewall.xsintricity.com>
	 <18698.54207.663716.200113@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-bzfKFMefyDKi6kAn5MI2"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18698.54207.663716.200113@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, "martin f. krafft" <madduck@debian.org>, Michal Marek <mmarek@novell.com>, Kay Sievers <kay.sievers@vrfy.org>
List-Id: linux-raid.ids


--=-bzfKFMefyDKi6kAn5MI2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-10-31 at 20:45 +1100, Neil Brown wrote:
> > >  1/ The only device nodes created will be /dev/mdX and /dev/md_dX
> > >     along with partitions /dev/mdXpY and /dev/md_dXpY as appropriate.
> > >     These will be created by mdadm in accordance with the "--auto"
> > >     flag unless something in mdadm.conf says to leave it to udev.
> > >     In that case, mdadm will create a temporary node
> > >     (/dev/.mdadm.whatever) and remove it once udev has created the
> > >     real thing.
> >=20
> > One thing I noticed in my work on the incremental stuff, is that the
> > user friendly device naming method still wants to create
> > these /dev/md_dX{pY} array names.  I'm actually in favor of doing away
> > with the notion that an array needs to be numbered and exist in a
> > numbered format in the /dev/ namespace.  If you have a user friendly
> > name, such as /dev/md/root and /dev/md/boot, or /dev/md/root_p1
> > and /dev/md/root_p2, I see no need to add additional numbered devices.
> > Instead, just allow the device number of the named devices to be random=
.
>=20
> I have considered dropping the "/dev/mdXX" names altogether, and I
> think mdadm.2 sometimes does that.  But I've decided against it.
> My reasons are:
>=20
>  1/ udev is going to create them anyway, so there is no point trying
>     to hide them.

I don't think this is accurate.

>  2/ those names appear in /proc/mdstat and despite all the rhetoric
>     about naming policy not belonging in the kernel, the kernel does
>     set some naming policy, "mdX" etc are part of that, and we cannot
>     avoid it.
>     Joe Sysadmin will see a name in /proc/mdstat and might want to
>     access that device.  Having it easily available in /dev is good.
>=20
> My current thought is that /dev/md/ provides human friendly names.
> /dev/disk/by-id/md-whatever provides script-friendly names.  And /dev
> directly contains kernel-friendly names.

The in-kernel names are set by the kernel md code.  Right now, it has a
simplistic test that checks if the device is partitionable, then sets
the kobject name to either md%d or md_d%d.  The key point being that the
md code gets to set the kobject name, and it's the kobject name that is
used my udev.  Don't get me wrong, I know changing this setup now would
break udev horribly, this being because udev current does
subsystem=3D=3Dblock,kernel=3D=3D"md*" to match all md devices.  In order t=
o
break from this, we would need to do something like
subsystem=3D=3Dblock,subtype=3D=3Dmd and skip any name check tests.  Then w=
e
could in fact use arbitrary names and udev and the rest of the system
would be fine.  So, I'm not saying it would work today, but that doesn't
mean it couldn't be designed for and then implemented with a coordinated
change to the kernel and udev.

> >=20
> > >  2/ There will be various symlinks to these devices.
> > >     a/ if "symlinks=3Dyes" is given in mdadm.conf, symlinks from
> > >          /dev/md/X or /dev/md/dX will be created.
> > >     b/ if udev is configured like on Debian,
> > >               /dev/disk/by-id/md-name-XXXX
> > > 	and   /dev/disk/by-id/md-uuid-UUUU
> > >        will be created (by udev).
> > >     c/ If there is a 'name' associated with the array then
> > >         /dev/md/name will be created as a link.
> > >     d/ if an explicit device name of /dev/name was given,
> > >         either on a -A, -B, -C, command or in mdadm.conf,
> > > 	then the 'name' must match the name of the array,
> > > 	and /dev/name will be used as well as /dev/md/name.
> >=20
> > I think all these symlinks are problematic.  We have a naming
> > consistency problem, and creating all these links just perpetuates that
> > problem.  I would be in favor of standardizing the namespace location
> > and semantics and doing away with all the symlinks.  Do that, and withi=
n
> > one release cycle all the confusion will be gone.
>=20
> Your last sentence is very pragmatic and sensible.  If confusion
> exists, we really want to move firmly away from it, and people will
> cope, particularly if things become cleared (even if they are
> different to what they are used to).
>=20
> I am dropping support for the "--symlinks" option and matching
> mdadm.conf entry.=20
> /dev/mdXXX will always be the device node.  There will always be (at
> most) one entry in /dev/md/ which points to it.  It might be e.g.
> /dev/md/0, but only if no better name is available.

Excellent.  I found the symlinks to create all sorts of cruft that
didn't need to be there.

> > The scariest suggestion, but probably the most complete and automated,
> > would be to have mdadm do a search on any constituent devices to find
> > out what the eventual low level driver is.  If it's a fiber channel
> > driver, or iSCSI, then don't auto assemble.  If it's sata/e-sata, or
> > local SAS, then it's more likely auto assemble is fine.  But, that leve=
l
> > of mucking around in /sys for each device would probably be quite ugly.
>=20
>=20
> Quite.  And I'd almost certainly get it wrong.  One day someone might
> come up with a solution that can be automated.  For now I think I
> stick with configuration in mdadm.conf

I'll keep this in mind as a spare time project...

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband


--=-bzfKFMefyDKi6kAn5MI2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkPC/cACgkQTzP9PM7pjw88aQCfaNCGzKeiUyhWUGQSn+zL3IFd
9ygAn2HwZgRX8aUr9zISiXy2yAYQh/a9
=W1G1
-----END PGP SIGNATURE-----

--=-bzfKFMefyDKi6kAn5MI2--

