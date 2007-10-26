From: Doug Ledford <dledford@redhat.com>
Subject: Re: Time to  deprecate old RAID formats?
Date: Fri, 26 Oct 2007 14:41:56 -0400
Message-ID: <1193424116.10336.281.camel@firewall.xsintricity.com>
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
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-r6KHdtiIhIg/iuy/U4Bb"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4721F742.1090301@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Neil Brown <neilb@suse.de>, David Greaves <david@dgreaves.com>, Jeff Garzik <jeff@garzik.org>, John Stoffel <john@stoffel.org>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-r6KHdtiIhIg/iuy/U4Bb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-10-26 at 10:18 -0400, Bill Davidsen wrote:
> Neil Brown wrote:
> > On Thursday October 25, david@dgreaves.com wrote:
> >  =20
> >> I didn't get a reply to my suggestion of separating the data and locat=
ion...
> >>    =20
> >
> > No. Sorry.
> >
> >  =20
> >> ie not talking about superblock versions 0.9, 1.0, 1.1, 1.2 etc but a =
data
> >> format (0.9 vs 1.0) and a location (end,start,offset4k)?
> >>
> >> This would certainly make things a lot clearer to new (and old!) users=
:
> >>
> >> mdadm --create /dev/md0 --metadata 1.0 --meta-location offset4k
> >> or
> >> mdadm --create /dev/md0 --metadata 1.0 --meta-location start
> >> or
> >> mdadm --create /dev/md0 --metadata 1.0 --meta-location end
> >>    =20
> >
> > I'm happy to support synonyms.  How about
> >
> >    --metadata 1-end
> >    --metadata 1-start
> >
> > ??
> >  =20
> Offset? Do you like "1-offset4k" or maybe "1-start4k" or even=20
> "1-start+4k" for that? The last is most intuitive but I don't know how=20
> you feel about the + in there.

Actually, after doing some research, here's what I've found:

* When using lilo to boot from a raid device, it automatically installs
itself to the mbr, not to the partition.  This can not be changed.  Only
0.90 and 1.0 superblock types are supported because lilo doesn't
understand the offset to the beginning of the fs otherwise.

* When using grub to boot from a raid device, only 0.90 and 1.0
superblocks are supported[1] (because grub is ignorant of the raid and
it requires the fs to start at the start of the partition).  You can use
either MBR or partition based installs of grub.  However, partition
based installs require that all bootable partitions be in exactly the
same logical block address across all devices.  This limitation can be
an extremely hazardous limitation in the event a drive dies and you have
to replace it with a new drive as newer drives may not share the older
drive's geometry and will require starting your boot partition in an odd
location to make the logical block addresses match.

* When using grub2, there is supposedly already support for raid/lvm
devices.  However, I do not know if this includes version 1.0, 1.1, or
1.2 superblocks.  I intend to find that out today.  If you tell grub2 to
install to an md device, it searches out all constituent devices and
installs to the MBR on each device[2].  This can't be changed (at least
right now, probably not ever though).

So, given the above situations, really, superblock format 1.2 is likely
to never be needed.  None of the shipping boot loaders work with 1.2
regardless, and the boot loader under development won't install to the
partition in the event of an md device and therefore doesn't need that
4k buffer that 1.2 provides.

[1] Grub won't work with either 1.1 or 1.2 superblocks at the moment.  A
person could probably hack it to work, but since grub development has
stopped in preference to the still under development grub2, they won't
take the patches upstream unless they are bug fixes, not new features.

[2] There are two ways to install to a master boot record.  The first is
to use the first 512 bytes *only* and hardcode the location of the
remainder of the boot loader into those 512 bytes.  The second way is to
use the free space between the MBR and the start of the first partition
to embed the remainder of the boot loader.  When you point grub2 at an
md device, they automatically only use the second method of boot loader
installation.  This gives them the freedom to be able to modify the
second stage boot loader on a boot disk by boot disk basis.  The
downside to this is that they need lots of room after the MBR and before
the first partition in order to put their core.img file in place.  I
*think*, and I'll know for sure later today, that the core.img file is
generated during grub install from the list of optional modules you
specify during setup.  Eg., the pc module gives partition table support,
the lvm module lvm support, etc.  You list the modules you need, and
grub then builds a core.img out of all those modules.  The normal amount
of space between the MBR and the first partition is (sectors_per_track -
1).  For standard disk geometries, that basically leaves 254 sectors, or
127k of space.  This might not be enough for your particular needs if
you have a complex boot environment.  In that case, you would need to
bump at least the starting track of your first partition to make room
for your boot loader.  Unfortunately, how is a person to know how much
room their setup needs until after they've installed and it's too late
to bump the partition table start?  They can't.  So, that's another
thing I think I will check out today, what the maximum size of grub2
might be with all modules included, and what a common size might be.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-r6KHdtiIhIg/iuy/U4Bb
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHIjT0TzP9PM7pjw8RAsK/AJ4npqkk+FA8Xo/KrU9Hq4jKRFTuFgCfe1fA
QwlPitgTg5B8F9synbcJ+Tc=
=YSj1
-----END PGP SIGNATURE-----

--=-r6KHdtiIhIg/iuy/U4Bb--

