From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: RAID 5 array recovery - two drives errors in external enclosure
Date: Thu, 17 Sep 2009 22:22:52 +0100
Message-ID: <20090917212252.GC19611@cthulhu.home.robinhill.me.uk>
References: <2267211f0909171342g6ebf68a2y393daa587e59c714@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qjNfmADvan18RZcF"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2267211f0909171342g6ebf68a2y393daa587e59c714@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--qjNfmADvan18RZcF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Sep 17, 2009 at 01:42:30PM -0700, Tim Bostrom wrote:

> OK,
>=20
> Let me start off by saying - I panicked.  Rule #1 - don't panic.  I
> did.  Sorry.
>=20
> I have a RAID 5 array running on Fedora 10.
> (Linux tera.teambostrom.com 2.6.27.30-170.2.82.fc10.i686 #1 SMP Mon
> Aug 17 08:38:59 EDT 2009 i686 athlon i386 GNU/Linux)
>=20
> 5 drives in an external enclosure (AMS eSATA Venus T5).  It's a
> Sil4726 inside the enclosure running to a Sil3132 controller via eSATA
> in the desktop.  I had been running this setup for just over a year.
> Was working fine.   I just moved into a new home and had my server
> down for a while  - before I brought it back online, I got a "great
> idea" to blow out the dust from the enclosure using compressed air.
> When I finally brought up the array again, I noticed that drives were
> missing.  Tried re-adding the drives to the array and had some issues
> - they seemed to get added but after a short time of rebuilding the
> array, I would get a bunch of HW resets in dmesg and then the array
> would kick out drives and stop.
>=20
<- much snippage ->

> I popped the drives out of the enclosure and into the actual tower
> case and connected each of them to its own SATA port.  The HW resets
> seemed to go away, but I couldn't get the array to come back online.
>  Then I did the stupid panic (following someone's advice I shouldn't
> have).
>=20
> thinking I should just re-create the array, I did:
>=20
> mdadm --create /dev/md0 --level=3D5 --raid-devices=3D5 /dev/sd[b-f]1
>=20
> Stupid me again - ignores the warning that it belongs to an array
> already.  I let it build for a minute or so and then tried to mount it
> while rebuilding... and got error messages:
>=20
> EXT3-fs: unable to read superblock
> EXT3-fs: md0: couldn't mount because of unsupported optional features
> (3fd18e00).
>=20
> Now - I'm at a loss.  I'm afraid to do anything else.   I've been
> viewing the FAQ and I have a few ideas, but I'm just more freaked.  Is
> there any hope?  What should I do next without causing more trouble?
>
Looking at the mdadm output, there's a couple of possible errors.
Firstly, your newly created array has a different chunksize than your
original one.  Secondly, the drives may be in the wrong order.  In
either case, providing you don't _actually_ have any faulty drives, then
it should be (mostly) recoverable.=20

Given the order you specified the drives in the create, sdf1 will be the
partition that's been trashed by the rebuild, so you'll want to leave
that out altogether for now.

You need to try to recreate the array with the correct chunk size and
with the remaining drives in different orders, running a read-only
filesystem check each time until you find the correct order.

So start with:
    mdadm -C /dev/md0 -l 5 -n 5 -c 256 /dev/sd[bcde]1 missing

Then repeat for every possible order of the four disks and "missing",
stopping the array each time if the mount fails.

When you've finally found the correct order, you can re-add sdf1 to get
the array back to normal.

HTH,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--qjNfmADvan18RZcF
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkqyqKsACgkQShxCyD40xBI8sACfSX6OaJwRoIhRopHtbAowOlxL
2UcAoLZWOqDaFthCZB4AssJhDnGLn3VT
=pVX/
-----END PGP SIGNATURE-----

--qjNfmADvan18RZcF--
