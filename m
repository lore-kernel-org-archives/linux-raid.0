From: NeilBrown <neilb@suse.de>
Subject: Re: RAID50 boot problems
Date: Wed, 24 Apr 2013 16:52:01 +1000
Message-ID: <20130424165201.67cc9d1e@notabene.brown>
References: <20944014.4.1366628571053.JavaMail.root@zimbra>
	<6909786.18.1366738459191.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/06J.67JQpH0jcRZLpjf0UB="; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6909786.18.1366738459191.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: Roman Mamedov <rm@romanrm.ru>, linux-raid <linux-raid@vger.kernel.org>, Alexander Zvyagin <zvyagin.alexander@gmail.com>
List-Id: linux-raid.ids

--Sig_/06J.67JQpH0jcRZLpjf0UB=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 23 Apr 2013 19:34:19 +0200 (CEST) Roy Sigurd Karlsbakk
<roy@karlsbakk.net> wrote:

> > > > Please see http://paste.ubuntu.com/5721934/ for the full list,
> > > > taken
> > > > with network console. This is with rootdelay=3D10
> > >
> > > The "bind" messages are in random order so presumably udev running
> > > 'mdadm -I'
> > > on each device as it appear to add it to an array.
> > > However when the md0 and md1 devices appear, udev isn't being run on
> > > that.
> > > So it looks like your udev rules file is wrong.
> > > Find out which file(s) in /{etc,lib,usr/lib}/udev/rules.d mention
> > > mdadm and
> > > post them.
> >=20
> > /lib/udev/rules.d/64-md-raid.rules is here
> > http://paste.ubuntu.com/5592227/
>=20
> Bug tested positive also on Ubuntu Precise (12.04) and reported to https:=
//bugs.launchpad.net/ubuntu/+source/mdadm/+bug/1171945
>=20
> Vennlige hilsener / Best regards
>=20
>

This will run "mdadm --incremental $tempnode" on any device for which
ID_FS_TYPE is set to "linux_raid_member", which certainly seems reasonable.

What does:
   udevadm info --query=3Dproperty --path=3D/dev/mdXXX | grep ID_FS_TYPE

report for the raid5 arrays?

Looking bug report I see that md0 and md1 have
   ID_FS_TYPE=3Dlinux_raid_member

So that should be working.

The fact that rootdelay=3D10 makes a difference suggests that it is
successfully assembling the raid0, but just taking a bit too long.
Maybe the script in the initrd needs "udevadm settle" just before it attemp=
ts
to mount.

Can you look inside the initrd and see if "udevadm settle" is used anywhere?

NeilBrown

--Sig_/06J.67JQpH0jcRZLpjf0UB=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUXeBETnsnt1WYoG5AQKz2xAAgQK/CiYi+rE5lxYB4wT+M3IvbNuKLkvP
4ccVg0Ron+2h35XZ5ERbbDOlXfbnLNc8moz91jKHjb+ToZbbfGULTqTbhv7fYZ5k
J5rbk2EWemKw7RdzYUyzZQvCgCVXFetXpVDplTzH1cpxm1rNFH8rkQfdgXsk49GY
go8QTu+EchwUgDqLpObTpvQXVfXo61VtUD4UBKIP+L/tx2DN/tUER7sorcuViOuK
Gwm6EyVJ3U9N7VOKRR6r81t5obo3AQr5R4yOkVOeBg1UFTOuNreDAYwSLbAfZXcK
6+jPasAEDJRFmMPl7vKdhh7ZmojhcnyDxbdgz3jqkgBMFVs/JJT2AR9V5zcVLkX4
Wy0NIC2j6VI74hU6YtyfjVmgdMBkQ2weTwrEG/oKbXh96hkndErYTaYgGqmmMeOT
fKJ/egYOzfLDaeCRoeDqr4C/DInX3oCrq7J1/nEIgdHXQ4hLAbJJC9hJrS5k8Izl
tWTwRObTXeLKXdvuvmoMfTvsB5aYuGY0ErydtI2f7OFN/km3JTo1iBZ1F1ctX/bv
b+wNF/WSkhj2M/x8Qat56WcLTmkjjWLz3q4qBvuOdAsP9QAI3Gs7jnpmSGt5raZs
gE+5fGhiEPZaWbUNRhA3FX7kernCIWgLfYRVUrUHRnfWceKFxpXK4clQmP6IbF/r
PNdx8D0qma4=
=Y4vk
-----END PGP SIGNATURE-----

--Sig_/06J.67JQpH0jcRZLpjf0UB=--
