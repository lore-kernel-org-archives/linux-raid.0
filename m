From: Andre Noll <maan@systemlinux.org>
Subject: Re: RFC - device names and mdadm with some reference to udev.
Date: Mon, 27 Oct 2008 14:24:53 +0100
Message-ID: <20081027132453.GF17300@skl-net.de>
References: <18692.62860.863118.727187@notabene.brown> <ac3eb2510810270541g2ac57bd1p5576f15959e849e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sDKAb4OeUBrWWL6P"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ac3eb2510810270541g2ac57bd1p5576f15959e849e@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, Doug Ledford <dledford@redhat.com>, "martin f. krafft" <madduck@debian.org>, Michal Marek <mmarek@novell.com>
List-Id: linux-raid.ids


--sDKAb4OeUBrWWL6P
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 13:41, Kay Sievers wrote:
> >  1/ The only device nodes created will be /dev/mdX and /dev/md_dX
> >    along with partitions /dev/mdXpY and /dev/md_dXpY as appropriate.
> >    These will be created by mdadm in accordance with the "--auto"
> >    flag unless something in mdadm.conf says to leave it to udev.
> >    In that case, mdadm will create a temporary node
> >    (/dev/.mdadm.whatever) and remove it once udev has created the
> >    real thing.
>=20
> Sounds fine, if mdadm needs a device node. It could also wait for udev
> to have the node created, but having a temporary node sounds fine, as
> long as it will not clash with anything udev is creating.

IMHO we should try to avoid creating device nodes from mdadm whenever
possible. OTOH it should be possible to assemble a raid array manually
i.e. without udev, for example when used from a rescue system.

> >    In particular, it will remove the device node as described in 1,
> >    any partitions, and any symlinks in /dev or /dev/md which point to
> >    any of those.  I need to be certain that this won't confuse udev.
>=20
> You must never touch anything that udev has created. It must be driven
> by kernel "add/remove/change" events.

I think it's no problem to let mdadm generate such events rather than
messing with device nodes itself. BTW: What's the preferred way to
wait for the generation of the device node after an appropriate event
has been generated? Polling?

> Some systems do automount all devices. Most systems do only hotplug
> devices which are not listed in /etc/fstab. Expect in the future that
> there will always be auto-assembly and also auto-mounting to some
> degree. All the newer storage buses, like iSCSI and such will always
> need  auto-mounting on device discovery, and not work with any
> bootup-script logic.

The nice thing is that this kind of auto-mounting can be handled from
user space. So we _might_ get rid of the in-kernel raid autodetect
code eventually.

> > I'm also wondering if I should include a udev 'rules' file for md in
> > the mdadm distribution.  Obviously it would be no more than a
> > recommendation, but it might give me a voice in guiding how udev
> > interacted with mdadm.
>=20
> Definitely, it should carry a udev rules file which instructs udev to
> create all intended symlinks and also supports the raid auto-assembly
> setup. It should not mount anything by default though.

How about distributing such a rules file together with udev? As far as
I understand it, you (Kay) are currently trying to unify the different
udev configurations that exist in the wild. If the udev source code
contained a rules file for md, this would already help.

Moreover, changes to udev that require modifications of the md rules
file might happen more frequently than changes to md that require
such modifications ;)

> Do you think mdadm will stay a program only, called by udev/the user,
> or will a port of its functionality live in a daemon?

mdadm already has a daemon mode. It's currently used only as a
monitoring tool (to send alert mails on disk failures) but this could
be extended if necessary.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--sDKAb4OeUBrWWL6P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFJBcEkWto1QDEAkw8RAgUuAKCNZCg6LmguOGV8fpZZKNEncxovNACdGHw/
HWtnfOJGu2Ik+wIQRO+2znk=
=v9mU
-----END PGP SIGNATURE-----

--sDKAb4OeUBrWWL6P--
