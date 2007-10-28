From: Doug Ledford <dledford@redhat.com>
Subject: Re: Time to  deprecate old RAID formats?
Date: Sat, 27 Oct 2007 20:26:00 -0400
Message-ID: <1193531160.10336.397.camel@firewall.xsintricity.com>
References: <1192810534.1666.68.camel@firewall.xsintricity.com>
	 <18200.56684.14194.630264@stoffel.org>
	 <1192813877.1666.79.camel@firewall.xsintricity.com>
	 <18200.63987.514073.184865@stoffel.org>
	 <20071019212303.GB2013@teal.hq.k1024.org>
	 <1192830129.1666.103.camel@firewall.xsintricity.com>
	 <20071020075349.GA17431@teal.hq.k1024.org>
	 <1192885917.1666.112.camel@firewall.xsintricity.com>
	 <20071026095417.GC32550@percy.comedia.it>
	 <1193424779.10336.287.camel@firewall.xsintricity.com>
	 <20071026223046.GB8210@boogie.lpds.sztaki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BWzhQwlUjKPK14QOjUYQ"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071026223046.GB8210@boogie.lpds.sztaki.hu>
Sender: linux-raid-owner@vger.kernel.org
To: Gabor Gombas <gombasg@sztaki.hu>
Cc: Luca Berra <bluca@comedia.it>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-BWzhQwlUjKPK14QOjUYQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-10-27 at 00:30 +0200, Gabor Gombas wrote:
> On Fri, Oct 26, 2007 at 02:52:59PM -0400, Doug Ledford wrote:
>=20
> > In fact, no you can't.  I know, because I've created a device that had
> > both but wasn't a raid device.  And it's matching partner still existed
> > too.  What you are talking about would have misrecognized this
> > situation, guaranteed.
>=20
> Maybe we need a 2.0 superblock that contains the physical size of every
> component, not just the logical size that is used for RAID. That way if
> the size read from the superblock does not match the size of the device,
> you know that this device should be ignored.

In my case that wouldn't have helped.  What actually happened was I
create a two disk raid1 device using whole devices and a version 1.0
superblock.  I know a version 1.1 wouldn't work because it would be
where the boot sector needed to be, and wasn't sure if a 1.2 would work
either.  Then I tried to make the whole disk raid device a partitioned
device.  This obviously put a partition table right where the BIOS and
the kernel would look for it whether the raid was up or not.  I also
tried doing an lvm setup to split the raid up into chunks and that
didn't work either.  So, then I redid the partition table and created
individual raid devices from the partitions.  But, I didn't think to
zero the old whole disk superblock.  When I made the individual raid
devices, I used all 1.1 superblocks.  So, when it was all said and done,
I had a bunch of partitions that looked like a valid set of partitions
for the whole disk raid device and a whole disk raid superblock, but I
also had superblocks in each partition with their own bitmaps and so on.
It was only because I wasn't using mdadm in the initrd and specifying
uuids that it found the right devices to start and ignored the whole
disk devices.  But, when I later made some more devices and went to
update the mdadm.conf file using mdadm -Eb, it found the devices and
added it to the mdadm.conf.  If I hadn't checked it before remaking my
initrd, it would have hosed the system.  And it would have passed all
the tests you can throw at it.  Quite simply, there is no way to tell
the difference between those two situations with 100% certainty.  Mdadm
tries to be smart and start the newest devices, but Luca's original
suggestion of skip the partition scanning in the kernel and figure it
out from user space would not have shown mdadm the new devices and would
have gotten it wrong every time.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-BWzhQwlUjKPK14QOjUYQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHI9cXTzP9PM7pjw8RAk8hAJ9oMcBnVU4Qydn8AslMz6ifuiWuggCeOZzx
gHIdxYgIS+ktg0K6gV8K6Hs=
=dlme
-----END PGP SIGNATURE-----

--=-BWzhQwlUjKPK14QOjUYQ--

