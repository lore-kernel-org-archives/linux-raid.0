From: Doug Ledford <dledford@redhat.com>
Subject: Re: RFC - device names and mdadm with some reference to udev.
Date: Mon, 27 Oct 2008 13:24:30 -0400
Message-ID: <1225128270.4845.144.camel@firewall.xsintricity.com>
References: <18692.62860.863118.727187@notabene.brown>
	 <20081027082257.GB1801@piper.oerlikon.madduck.net>
	 <1225120416.4845.128.camel@firewall.xsintricity.com>
	 <20081027161000.GG17300@skl-net.de>
	 <ac3eb2510810270937i3acd7c94r2817b8f4c79babec@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Dc2QBivZVvUcflBly3cX"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ac3eb2510810270937i3acd7c94r2817b8f4c79babec@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Andre Noll <maan@systemlinux.org>, martin f krafft <madduck@debian.org>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, Michal Marek <mmarek@novell.com>
List-Id: linux-raid.ids


--=-Dc2QBivZVvUcflBly3cX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-27 at 17:37 +0100, Kay Sievers wrote:
> On Mon, Oct 27, 2008 at 17:10, Andre Noll <maan@systemlinux.org> wrote:
> > On 11:13, Doug Ledford wrote:
> >
> >> > I would really like to have a clear separation of competencies.
> >> > Ideally, mdadm never creates any devices but leaves it all to udev,
> >> > and all configuration about alternate names ("symlinks") is done in
> >> > the udev rules file.
> >>
> >> This would then require that we have a working udev in our initrd
> >> images.  It would greatly increase the complexity of early booting as =
a
> >> result.
> >
> > Given that the initramfs usually contains busybox, one can also using
> > mdev. It's much simpler than udev and it's good enough if the only
> > thing you want to do is mounting the root partition that resides on
> > a software raid array.
>=20
> Depends on your definition of "usual". Debian, Fedora, openSUSE,
> Ubuntu, Gentoo (as far as Gentoo counts as a distro with a default
> setup) none of them uses any busybox/mdev setup, and all use udev in
> initramfs.

Not a complete udev implementation IIRC.  It doesn't have all the rules
that a running system has.  And at least Fedora still starts md devices
via a specific call to mdadm in the initrd script, not via udev rules.

> It's very simple to setup and follows the same logic as udev running
> in the rootfs, There is absolutely no "increase of complexity"
> involved if you use udev in the real root anyway, you just copy the
> binaries and the rules, and on bootup you wait for /dev/root to show
> up, mount it and start /sbin/init. Custom busybox stuff does not
> support any non-trivial feature a "general purpose" distro needs to
> support today.

I've found the udev rules method of starting md devices to be
problematic (at best).

Here's the issue (in Fedora at least).  Starting devices via udev means
starting them as soon as they are capable and not waiting until all
devices are up and running.  You have to do this in case the device is
in a degraded state and you aren't going to get all the devices.
However, we don't create a bitmap on devices by default in the installer
(a user can add one themselves, but it isn't there by default).  Without
the bitmap, if the device is written to before all devices are added, it
triggers a full resync of the device.  As it turns out, for certain
installations, this happens on *every* single reboot.  It's painful, to
say the least.   So, I wanted to change the udev rule to work slightly
differently.  I wanted the invocation of mdadm --incremental that
happened to be the one that took the array from an unrunable state to a
runable but degraded state to sleep for say 2 to 5 seconds, and then if
the array is still not up and running due to subsequent udev rule
invocations, it would start the array in a degraded state.  This,
however, breaks udevsettle.  So, the current setup (for the upcoming
fedora 10) is done such that the udev rule won't start any degraded
arrays, and instead we have both a specific mdadm invocation in the
initrd and another in rc.sysinit that will start any degraded arrays
that are also listed in the mdadm.conf file.  This makes sure that known
arrays are assembled and started if at all possible, but we only start
unknown arrays if they are complete.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband


--=-Dc2QBivZVvUcflBly3cX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkF+U4ACgkQTzP9PM7pjw9lxwCfYjuFkXMKD/4loQHxbcDmFJ3E
m2kAnA5K0VvcI/MYEMkceoL1T57UP+WQ
=R93w
-----END PGP SIGNATURE-----

--=-Dc2QBivZVvUcflBly3cX--

