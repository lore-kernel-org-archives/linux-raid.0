From: Doug Ledford <dledford@redhat.com>
Subject: Re: Time to  deprecate old RAID formats?
Date: Sun, 28 Oct 2007 13:47:55 -0400
Message-ID: <1193593675.10336.404.camel@firewall.xsintricity.com>
References: <1192813877.1666.79.camel@firewall.xsintricity.com>
	 <18200.63987.514073.184865@stoffel.org>
	 <20071019212303.GB2013@teal.hq.k1024.org>
	 <1192830129.1666.103.camel@firewall.xsintricity.com>
	 <20071020075349.GA17431@teal.hq.k1024.org>
	 <1192885917.1666.112.camel@firewall.xsintricity.com>
	 <20071026095417.GC32550@percy.comedia.it>
	 <1193424779.10336.287.camel@firewall.xsintricity.com>
	 <20071026223046.GB8210@boogie.lpds.sztaki.hu>
	 <1193531160.10336.397.camel@firewall.xsintricity.com>
	 <20071028141336.GC22861@percy.comedia.it>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3TFQDBCAQtOSb24F94e1"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071028141336.GC22861@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-3TFQDBCAQtOSb24F94e1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-10-28 at 15:13 +0100, Luca Berra wrote:
> On Sat, Oct 27, 2007 at 08:26:00PM -0400, Doug Ledford wrote:
> >On Sat, 2007-10-27 at 00:30 +0200, Gabor Gombas wrote:
> >> On Fri, Oct 26, 2007 at 02:52:59PM -0400, Doug Ledford wrote:
> >>=20
> >> > In fact, no you can't.  I know, because I've created a device that h=
ad
> >> > both but wasn't a raid device.  And it's matching partner still exis=
ted
> >> > too.  What you are talking about would have misrecognized this
> >> > situation, guaranteed.
> >>=20
> >> Maybe we need a 2.0 superblock that contains the physical size of ever=
y
> >> component, not just the logical size that is used for RAID. That way i=
f
> >> the size read from the superblock does not match the size of the devic=
e,
> >> you know that this device should be ignored.
> >
> >In my case that wouldn't have helped.  What actually happened was I
> >create a two disk raid1 device using whole devices and a version 1.0
> >superblock.  I know a version 1.1 wouldn't work because it would be
> >where the boot sector needed to be, and wasn't sure if a 1.2 would work
> >either.  Then I tried to make the whole disk raid device a partitioned
> >device.  This obviously put a partition table right where the BIOS and
> >the kernel would look for it whether the raid was up or not.  I also
> the only reason i can think for the above setup not working is udev
> mucking with your device too early.

It was a combination of boot loader issues and an inability to get this
device partitioned up the way I needed.  I went with a totally different
setup in the end because I essentially started out with a two drive
raid1 for the OS and another 2 drive raid1 for data, but I wanted to
span them and I was attempting to do so with a mixture of md raid and
lvm physical volume striping.  Didn't work.

> >tried doing an lvm setup to split the raid up into chunks and that
> >didn't work either.  So, then I redid the partition table and created
> >individual raid devices from the partitions.  But, I didn't think to
> >zero the old whole disk superblock.  When I made the individual raid
> >devices, I used all 1.1 superblocks.  So, when it was all said and done,
> >I had a bunch of partitions that looked like a valid set of partitions
> >for the whole disk raid device and a whole disk raid superblock, but I
> >also had superblocks in each partition with their own bitmaps and so on.
> OK
>=20
> >It was only because I wasn't using mdadm in the initrd and specifying
> >uuids that it found the right devices to start and ignored the whole
> >disk devices.  But, when I later made some more devices and went to
> >update the mdadm.conf file using mdadm -Eb, it found the devices and
> >added it to the mdadm.conf.  If I hadn't checked it before remaking my
> >initrd, it would have hosed the system.  And it would have passed all
> the above is not clear to me, afair redhat initrd still uses
> raidautorun,

RHEL does, but this is on a personal machine I installed Fedora an and
latest Fedora has a mkinitrd that installs mdadm and mdadm.conf and
starts the needed devices using the UUID.  My first sentence above
should have read that I *was* using mdadm.

>  which iirc does not works with recent superblocks,
> so you used uuids on kernel command line?
> or you use something else for initrd?
> why would remaking the initrd break it?

Remaking the initrd installs the new mdadm.conf file, which would have
then contained the whole disk devices and it's UUID.  There in would
have been the problem.

> >the tests you can throw at it.  Quite simply, there is no way to tell
> >the difference between those two situations with 100% certainty.  Mdadm
> >tries to be smart and start the newest devices, but Luca's original
> >suggestion of skip the partition scanning in the kernel and figure it
> >out from user space would not have shown mdadm the new devices and would
> >have gotten it wrong every time.
> yes, in this particular case it would have, congratulation you found a ne=
w
> creative way of shooting yourself in the feet.

Creative, not so much.  I just backed out of what I started and tried
something else.  Lots of people do that.

> maybe mdadm should do checks when creating a device to prevent this kind
> of mistakes.
> i.e.
> if creating an array on a partition, check the whole device for a
> superblock and refuse in case it finds one
>=20
> if creating an array on a whole device that has a partition table,
> either require --force, or check for superblocks in every possible
> partition.

What happens if you add the partition table *after* you make the whole
disk device and there are stale superblocks in the partitions?  This
still isn't infallible.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-3TFQDBCAQtOSb24F94e1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHJMtLTzP9PM7pjw8RAvZwAJsGXrtQuUArZGV4+M/qgGYpucLrlwCdG94X
dOqKJZCn+GTzaos7BccZ4eE=
=rtEQ
-----END PGP SIGNATURE-----

--=-3TFQDBCAQtOSb24F94e1--

