From: NeilBrown <neilb@suse.de>
Subject: Re: RAID50 boot problems
Date: Thu, 25 Apr 2013 09:44:17 +1000
Message-ID: <20130425094417.4882607e@notabene.brown>
References: <20944014.4.1366628571053.JavaMail.root@zimbra>
	<6909786.18.1366738459191.JavaMail.root@zimbra>
	<20130424165201.67cc9d1e@notabene.brown>
	<CANBHLUikjsxOvBLkgAk4UDzwa3UPZ=jmTGhDzuMW31HLPCCu8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/.GwLgT4Lbgz6yevckj7hup+"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANBHLUikjsxOvBLkgAk4UDzwa3UPZ=jmTGhDzuMW31HLPCCu8Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dmitrijs Ledkovs <xnox@debian.org>
Cc: Roy Sigurd Karlsbakk <roy@karlsbakk.net>, Roman Mamedov <rm@romanrm.ru>, linux-raid <linux-raid@vger.kernel.org>, Alexander Zvyagin <zvyagin.alexander@gmail.com>
List-Id: linux-raid.ids

--Sig_/.GwLgT4Lbgz6yevckj7hup+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 24 Apr 2013 23:44:20 +0100 Dmitrijs Ledkovs <xnox@debian.org> wrote:

> On 24 April 2013 07:52, NeilBrown <neilb@suse.de> wrote:
> > On Tue, 23 Apr 2013 19:34:19 +0200 (CEST) Roy Sigurd Karlsbakk
> > <roy@karlsbakk.net> wrote:
> >
> >> > > > Please see http://paste.ubuntu.com/5721934/ for the full list,
> >> > > > taken
> >> > > > with network console. This is with rootdelay=3D10
> >> > >
> >> > > The "bind" messages are in random order so presumably udev running
> >> > > 'mdadm -I'
> >> > > on each device as it appear to add it to an array.
> >> > > However when the md0 and md1 devices appear, udev isn't being run =
on
> >> > > that.
> >> > > So it looks like your udev rules file is wrong.
> >> > > Find out which file(s) in /{etc,lib,usr/lib}/udev/rules.d mention
> >> > > mdadm and
> >> > > post them.
> >> >
> >> > /lib/udev/rules.d/64-md-raid.rules is here
> >> > http://paste.ubuntu.com/5592227/
> >>
> >> Bug tested positive also on Ubuntu Precise (12.04) and reported to htt=
ps://bugs.launchpad.net/ubuntu/+source/mdadm/+bug/1171945
> >>
> >> Vennlige hilsener / Best regards
> >>
> >>
> >
> > This will run "mdadm --incremental $tempnode" on any device for which
> > ID_FS_TYPE is set to "linux_raid_member", which certainly seems reasona=
ble.
> >
> > What does:
> >    udevadm info --query=3Dproperty --path=3D/dev/mdXXX | grep ID_FS_TYPE
> >
> > report for the raid5 arrays?
> >
> > Looking bug report I see that md0 and md1 have
> >    ID_FS_TYPE=3Dlinux_raid_member
> >
> > So that should be working.
> >
> > The fact that rootdelay=3D10 makes a difference suggests that it is
> > successfully assembling the raid0, but just taking a bit too long.
> > Maybe the script in the initrd needs "udevadm settle" just before it at=
tempts
> > to mount.
> >
> > Can you look inside the initrd and see if "udevadm settle" is used anyw=
here?
> >
>=20
> Yes, we do call and wait for udevadm to settle a few times, but it is
> still too short and may not be long enough to detect nested raid
> volumes and mount them properly in the correct order and non-degraded.
> I have a few thoughts on using a strategy similar to that in dracut /
> fedora to pass ids of the md arrays to assemble for rootfs device, and
> keep trying to assemble the rest of mdadm "on best effort" basis
> during boot.
> That way I am also hoping to finally get rid of the dreaded "boot
> degraded" boot option / question / prompt.
> This is still just design in progress and hasn't been implemented yet.
> I will be contacting this mailing list once I have something ready to
> improve raid assembly in ubuntu.
>=20

My current thinking is that the initramfs should *only* assemble arrays nee=
ded
to mount the root filesystems.  All other arrays should wait for root to be
mounted so that real /etc/mdadm.conf (or /etc/mdadm/mdadm.conf) can be
consulted.
This can be achieved by putting
  auto -all
in mdadm.conf on the initramfs, then listing the arrays that are needed.

I'm not convinced that your boot-degraded option is a bad thing.  Certainly
it should be optional so unattended boot is possible, and we should do our
best to minimise the number of times that it is consulted.  But there are
times when it is better to know that something is wrong, than to proceed and
do the wrong thing.

A particularly bad case is a RAID1 pair where one device failed a few days
ago.
If after a reboot the good device is missing (cable problem?) and the bad
device is visible, it could be best not to boot rather than to boot with an
old root based on the old  'failed' device.

NeilBrown


--Sig_/.GwLgT4Lbgz6yevckj7hup+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUXhuUTnsnt1WYoG5AQJz+w//fiVghTZgp0k6asNl2fnVWXNd2J+9L/za
cbP9Kq7F+pY4kKa7xGvYk4jfEUjzHzFbA1tIKkrqWXnC1gMvt4QrqmoxfqYuJkd7
+4RdsMz9ucPkPl31MpceD3V1wK/YwtKaVuC7M3zTqbyGKFzyGN22/P7AkV0xyT8v
9XjYUQ/36paOxSFneAoCS38I0LonxGrrDP4JB1RNVFWo/2zJwtiVuV0mLwNW8UIW
i6czYvrT8BOk1/yhCO9I50NT6Yo3U7lJ2hPq1baNtnl6dLTzh9fmngYhWGmbX1uO
vC7CQLZpS6oHWOv+TWywEiEDNZxfsTW4epEDPNsng7xq53/xCFsRBhMuHdWm2r+y
ml4Kn1RtCaRGu+PnfB4BSei07EIk1anoCCj35Tc3OwMsqa99Y1GYS12Z0MGziEt0
F0FsNaRkX6TEi/g1MwLUEMJhvf647SAK5Pt8JmFf5fo+f8QNuqYQ7THxgwzHeCwa
Od6ODLobVka6TrSbGrTYf4dO1ekQTj7Pslx732xyA7pw7H3Dnu7bg2g2fh5qzS91
yP4oR3AjdMFZj5X+3S4K0Qmg8+68lui+f/S6/2iKK2wyeCNN3oT2lUzDe4U64Iwx
qcwwcEKHPFbhhqPqNVM2f1sYb27g6na9QLt7wzgv7fTcEDnOs9Oomsb1/MQCdirs
uZXNsUccals=
=XseJ
-----END PGP SIGNATURE-----

--Sig_/.GwLgT4Lbgz6yevckj7hup+--
