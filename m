From: Doug Ledford <dledford@redhat.com>
Subject: Re: RFC - device names and mdadm with some reference to udev.
Date: Wed, 29 Oct 2008 14:49:15 -0400
Message-ID: <1225306155.26510.76.camel@firewall.xsintricity.com>
References: <18692.62860.863118.727187@notabene.brown>
	 <20081027082257.GB1801@piper.oerlikon.madduck.net>
	 <1225120416.4845.128.camel@firewall.xsintricity.com>
	 <20081027161000.GG17300@skl-net.de>
	 <ac3eb2510810270937i3acd7c94r2817b8f4c79babec@mail.gmail.com>
	 <1225128270.4845.144.camel@firewall.xsintricity.com>
	 <18694.20608.954160.346473@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-SrB6MoJZhAJ1miAm2ZJ/"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18694.20608.954160.346473@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-SrB6MoJZhAJ1miAm2ZJ/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-28 at 10:36 +1100, Neil Brown wrote:
> On Monday October 27, dledford@redhat.com wrote:
> >=20
> > I've found the udev rules method of starting md devices to be
> > problematic (at best).
> >=20
> > Here's the issue (in Fedora at least).  Starting devices via udev means
> > starting them as soon as they are capable and not waiting until all
> > devices are up and running.  You have to do this in case the device is
> > in a degraded state and you aren't going to get all the devices.
> > However, we don't create a bitmap on devices by default in the installe=
r
> > (a user can add one themselves, but it isn't there by default).  Withou=
t
> > the bitmap, if the device is written to before all devices are added, i=
t
> > triggers a full resync of the device.  As it turns out, for certain
> > installations, this happens on *every* single reboot.  It's painful, to
> > say the least.   So, I wanted to change the udev rule to work slightly
> > differently.  I wanted the invocation of mdadm --incremental that
> > happened to be the one that took the array from an unrunable state to a
> > runable but degraded state to sleep for say 2 to 5 seconds, and then if
> > the array is still not up and running due to subsequent udev rule
> > invocations, it would start the array in a degraded state.  This,
> > however, breaks udevsettle.  So, the current setup (for the upcoming
> > fedora 10) is done such that the udev rule won't start any degraded
> > arrays, and instead we have both a specific mdadm invocation in the
> > initrd and another in rc.sysinit that will start any degraded arrays
> > that are also listed in the mdadm.conf file.  This makes sure that know=
n
> > arrays are assembled and started if at all possible, but we only start
> > unknown arrays if they are complete.
> >=20
>=20
> This is using udev to start md devices, which is not quite the focus
> of the previous discussion.  That was more about using udev to create
> the entries in /dev when someone else started the arrays.

True enough, although I think they are a bit related simply because it's
udev rules on block devices that trigger the mdadm -I invocations that
trigger the new mdadm devices, so the issue of creating devices from
udev rules is at least mildly related to how mdadm gets called in the
first place, especially for the issue of hot plugging as you brought up
in your mail as hot plugging is specifically a case of udev kicking
mdadm off.

> However this is still a real issue that I would like to handle as best
> we can.
>=20
> I would like to get the md code to always have at least an in-memory
> bitmap to allow quite resync after a "re-add".
>=20
> However even this isn't a perfect solution as there is a window when a
> single device failure can kill an array.
>=20
> Your solution sounds good, but I'd be happy to hear other thoughts on
> the issue.

I ended up coding this up.  It took quite a bit more touchup in the
incremental code than I expected.  In general, mdadm-2.6.7.1 doesn't do
a very good job of honoring information in /etc/mdadm.conf when doing
incremental assembly.  So, momentarily I'll send you a patch series/pull
request with the changes.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband


--=-SrB6MoJZhAJ1miAm2ZJ/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkIsCsACgkQTzP9PM7pjw9+gACeMYC2sFcdmWksR1X8v8ro+3Vx
dDAAni5/TDiYa+VBsdK5HOrLdoS1dn4p
=vpcJ
-----END PGP SIGNATURE-----

--=-SrB6MoJZhAJ1miAm2ZJ/--

