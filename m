From: Doug Ledford <dledford@redhat.com>
Subject: Re: Time to  deprecate old RAID formats?
Date: Sat, 27 Oct 2007 20:18:33 -0400
Message-ID: <1193530713.10336.389.camel@firewall.xsintricity.com>
References: <18200.49267.763509.924873@stoffel.org>
	 <Pine.LNX.4.64.0710191109000.27246@p34.internal.lan>
	 <18200.53593.687483.120827@stoffel.org>
	 <1192810534.1666.68.camel@firewall.xsintricity.com>
	 <18200.56684.14194.630264@stoffel.org>
	 <1192813877.1666.79.camel@firewall.xsintricity.com>
	 <18200.63987.514073.184865@stoffel.org>	<471E7DC6.7050206@tmr.com>
	 <1193184555.10336.3.camel@firewall.xsintricity.com>
	 <18207.56169.769976.512617@notabene.brown>	<471FDEB1.8040401@garzik.org>
	 <47204F45.4010205@dgreaves.com> <18209.34365.375059.602828@notabene.brown>
	 <4721F742.1090301@tmr.com>
	 <1193424116.10336.281.camel@firewall.xsintricity.com>
	 <4723574A.3010308@tmr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-pA/j/ZeJHGpu4jOTgVU/"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4723574A.3010308@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Neil Brown <neilb@suse.de>, David Greaves <david@dgreaves.com>, Jeff Garzik <jeff@garzik.org>, John Stoffel <john@stoffel.org>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-pA/j/ZeJHGpu4jOTgVU/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-10-27 at 11:20 -0400, Bill Davidsen wrote:
> > * When using lilo to boot from a raid device, it automatically installs
> > itself to the mbr, not to the partition.  This can not be changed.  Onl=
y
> > 0.90 and 1.0 superblock types are supported because lilo doesn't
> > understand the offset to the beginning of the fs otherwise.
> >  =20
>=20
> I'm reasonably sure that's wrong, I used to set up dual boot machines by=20
> putting LILO in the partition and making that the boot partition, by=20
> changing the active partition flag I could just have the machine boot=20
> Windows, to keep people from getting confused.

Yeah, someone else pointed this out too.  The original patch to lilo
*did* do as I suggest, so they must have improved on the patch later.

> > * When using grub to boot from a raid device, only 0.90 and 1.0
> > superblocks are supported[1] (because grub is ignorant of the raid and
> > it requires the fs to start at the start of the partition).  You can us=
e
> > either MBR or partition based installs of grub.  However, partition
> > based installs require that all bootable partitions be in exactly the
> > same logical block address across all devices.  This limitation can be
> > an extremely hazardous limitation in the event a drive dies and you hav=
e
> > to replace it with a new drive as newer drives may not share the older
> > drive's geometry and will require starting your boot partition in an od=
d
> > location to make the logical block addresses match.
> >
> > * When using grub2, there is supposedly already support for raid/lvm
> > devices.  However, I do not know if this includes version 1.0, 1.1, or
> > 1.2 superblocks.  I intend to find that out today.  If you tell grub2 t=
o
> > install to an md device, it searches out all constituent devices and
> > installs to the MBR on each device[2].  This can't be changed (at least
> > right now, probably not ever though).
> >  =20
>=20
> That sounds like a good reason to avoid grub2, frankly. Software which=20
> decides that it knows what to do better than the user isn't my=20
> preference. If I wanted software which fores me to do things "their way"=20
> I'd be running Windows.

It's not really all that unreasonable of a restriction.  Most people
aren't aware than when you put a boot sector at the beginning of a
partition, you only have 512 bytes of space, so the boot loader that you
put there is basically nothing more than code to read the remainder of
the boot loader from the file system space.  Now, traditionally, most
boot loaders have had to hard code the block addresses of certain key
components into these second stage boot loaders.  If a user isn't aware
of the fact that the boot loader does this at install time (or at kernel
selection update time in the case of lilo), then they aren't aware that
the files must reside at exactly the same logical block address on all
devices.  Without that knowledge, they can easily create an unbootable
setup by having the various boot partitions in slightly different
locations on the disks.  And intelligent partition editors like parted
can compound the problem because as they insulate the user from having
to pick which partition number is used for what partition, etc., they
can end up placing the various boot partitions in different areas of
different drives.  The requirement above is a means of making sure that
users aren't surprise by a non-working setup.  The whole element of
least surprise thing.  Of course, if they keep that requirement, then I
would expect it to be well documented so that people know this going
into putting the boot loader in place, but I would argue that this is at
least better than finding out when a drive dies that your system isn't
bootable.

> > So, given the above situations, really, superblock format 1.2 is likely
> > to never be needed.  None of the shipping boot loaders work with 1.2
> > regardless, and the boot loader under development won't install to the
> > partition in the event of an md device and therefore doesn't need that
> > 4k buffer that 1.2 provides.
> >  =20
>=20
> Sounds right, although it may have other uses for clever people.
> > [1] Grub won't work with either 1.1 or 1.2 superblocks at the moment.  =
A
> > person could probably hack it to work, but since grub development has
> > stopped in preference to the still under development grub2, they won't
> > take the patches upstream unless they are bug fixes, not new features.
> >  =20
>=20
> If the patches were available, "doesn't work with existing raid formats"=20
> would probably qualify as a bug.

Possibly.  I'm a bit overbooked on other work at the moment, but I may
try to squeeze in some work on grub/grub2 to support version 1.1 or 1.2
superblocks.

> > [2] There are two ways to install to a master boot record.  The first i=
s
> > to use the first 512 bytes *only* and hardcode the location of the
> > remainder of the boot loader into those 512 bytes.  The second way is t=
o
> > use the free space between the MBR and the start of the first partition
> > to embed the remainder of the boot loader.  When you point grub2 at an
> > md device, they automatically only use the second method of boot loader
> > installation.  This gives them the freedom to be able to modify the
> > second stage boot loader on a boot disk by boot disk basis.  The
> > downside to this is that they need lots of room after the MBR and befor=
e
> > the first partition in order to put their core.img file in place.  I
> > *think*, and I'll know for sure later today, that the core.img file is
> > generated during grub install from the list of optional modules you
> > specify during setup.  Eg., the pc module gives partition table support=
,
> > the lvm module lvm support, etc.  You list the modules you need, and
> > grub then builds a core.img out of all those modules.  The normal amoun=
t
> > of space between the MBR and the first partition is (sectors_per_track =
-
> > 1).  For standard disk geometries, that basically leaves 254 sectors, o=
r
> > 127k of space.  This might not be enough for your particular needs if
> > you have a complex boot environment.  In that case, you would need to
> > bump at least the starting track of your first partition to make room
> > for your boot loader.  Unfortunately, how is a person to know how much
> > room their setup needs until after they've installed and it's too late
> > to bump the partition table start?  They can't.  So, that's another
> > thing I think I will check out today, what the maximum size of grub2
> > might be with all modules included, and what a common size might be.
> >
> >  =20
> Based on your description, it sounds as if grub2 may not have given=20
> adequate thought to what users other than the authors might need (that=20
> may be a premature conclusion). I have multiple installs on several of=20
> my machines, and I assume that the grub2 for 32 and 64 bit will be=20
> different. Thanks for the research.

No, not really.  The grub command on the two is different, but they
actually build the boot sector out of 16 bit non-protected mode code,
just like DOS.  So either one would build the same boot sector given the
same config.  And you can always use the same trick I've used in the
past of creating a large /boot partition (say 250MB) and using that same
partition as /boot in all of your installs.  Then they share a single
grub config (while the grub binaries are in the individual / partitions)
and from the single grub instance you can boot to any of the installs,
as well as a kernel update in any install updates that global grub
config.  The other option is to use separate /boot partitions and chain
load the grub instances, but I find that clunky in comparison.  Of
course, in my case I also made /lib/modules its own partition and also
shared it between all the installs so that I could manually edit the
various kernel boot params to specify different root partitions and in
so doing I could boot a RHEL5 kernel using a RHEL4 install and vice
versa.  But if you do that, you have to manually
patch /etc/rc.d/rc.sysinit to mount the /lib/modules partition before
ever trying to do anything with modules (and you have to mount it rw so
they can do a depmod if needed), then remount it ro for the fsck, then
it gets remounted rw again after the fs check.  It was a pain in the ass
to maintain because every update to initscripts would wipe out the patch
and if you forgot to repatch the file, the system wouldn't boot and
you'd have to boot into another install, mount the / partition of the
broken install, patch the file, then it would work again in that
install.


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-pA/j/ZeJHGpu4jOTgVU/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHI9VZTzP9PM7pjw8RAjO0AJkBCqLuj/+CTueW/gyfW/OXRjrPlQCffQWQ
7agt2u/BgiSK3lUIO4iCqkY=
=sw1S
-----END PGP SIGNATURE-----

--=-pA/j/ZeJHGpu4jOTgVU/--

