From: NeilBrown <neilb@suse.de>
Subject: Re: Data corruption after resizing partition, when using bitmaps
Date: Thu, 21 May 2015 10:24:44 +1000
Message-ID: <20150521102444.6346dc5d@notabene.brown>
References: <20150519141239.GA5309@psychosis.jim.sh>
	<20150520153104.7ac99de1@notabene.brown>
	<20150520063149.GA8346@psychosis.jim.sh>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/fDQ7tRh2XwA94Wg/qdJVHaD"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150520063149.GA8346@psychosis.jim.sh>
Sender: linux-raid-owner@vger.kernel.org
To: Jim Paris <jim@jtan.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/fDQ7tRh2XwA94Wg/qdJVHaD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 20 May 2015 02:31:50 -0400 Jim Paris <jim@jtan.com> wrote:

> NeilBrown wrote:
> > On Tue, 19 May 2015 10:12:40 -0400 Jim Paris <jim@jtan.com> wrote:
> >=20
> > > I had a raid1 mirror consisting of big partitions on two disks.
> > > The first disk was 2TB, partitioned like this:
> > >=20
> > >   [--sda1(128M)--][-------sda2(~2T)--------------]
> > >=20
> > > The second disk was 3TB, partitioned like this:
> > >=20
> > >   [--sdb1(128M)--][-------sdb2(~3T)----------------------------------=
--]
> > >=20
> > > sda2 and sdb2 were part of the array, which was only ~2TB in size due
> > > to the smaller disk.
> > >=20
> > > I realized that I needed to add a BIOS boot partition to the 3TB disk,
> > > so I removed sdb2 from the array, and repartitioned sdb like this:
> > >=20
> > >   [--sdb1(128M)--][--sdb2(1M)--][-------sdb3(~3T)--------------------=
--]
> > >=20
> > > Then I added sdb3 to the array.  And lost all my data. :(
> > >=20
> > > What happened was that the last sector of the big partition did not
> > > change location.  So the metadata (0.90) at the end was still present.
> >=20
> > This is one of the big reasons why 1.x was invented.
> >=20
> > > Adding sdb3 to the array was considered a "re-add" because the UUID
> > > and array sizes still matched the array, even though the partition
> > > itself shrank.  And the resync was thus guided by an out-of-date
> > > bitmap, which caused very little data to actually be written to sdb3,
> > > so half the reads from the array started returning junk.  Once the
> > > filesystem got involved, the result was rapid corruption.
> > >=20
> > > If I had not been using write-intent bitmaps, everything would have
> > > worked fine.  I only recently started using bitmaps, and never had any
> > > problems with adjusting partitions like this before that.
> > >=20
> > > Perhaps mdadm can be more careful here -- for example, maybe checking
> > > the actual device size and not just the "used dev size" when
> > > determining whether to trust the bitmap.
> >=20
> > It is perfectly acceptable to have the various devices in an array of
> > different sizes.  Unfortunately I don't think there is anything that md=
adm
> > can usefully do here.
> >=20
> > Thanks for the report anyway,
> > NeilBrown
>=20
> Hi Neil,
>=20
> Can we add u64 device_size to bitmap_super_t, and ensure that it
> matches the actual current device size before trusting the bitmap?

Well .... we could, but the bitmap_super is currently the same on all
devices.  This would  make it different.
And if we a going to change the metadata, why not just convert from 0.90 to
1.0?

 mdadm --stop /dev/mdXX
 mdadm --assemble /dev/mdXX --update=3Dmetadata /dev/...list-of-devices....

You might need to remove the bitmap first, and add it back afterwards.

NeilBrown

--Sig_/fDQ7tRh2XwA94Wg/qdJVHaD
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVV0lzDnsnt1WYoG5AQI4Mg/+NXbytAm1/7S5geUxAj7rJFl8ALFDNw25
nFf0xDN9Mpp93e7JjAgmzK6UbsNYjn3VZo1McafU+VkNuD3Z8zvalA7ByfAoSRpF
Du1J9mmT9TqWb1eRGmnfc/cg9OHVgMDQ6iDSBBoy/ZWz+FjZSw31oByG56IFAqUN
qZ1GtfCfp2Y6RxjJG/FS05U6IwQGcDP1vAtVIYGD0+YTvysBQDp7RHHy4QIuqRuE
+hLTvUL4QYOwLUtOXotcTkd9ZUxGb1aMxd93nkVPWbaLySnbEvYfUcXkReqxvNy5
EOLNfyaSGQbTwf+sYo1WN5i4lAXkW6UIrMYgMParfO+XxwxasTQOQ9r32f4eAs/d
It8kkTeKj4DHrEC9WVuik2UpGQDxP2ccMXzFpUYD2LdKZaMKcI2hh/ujBRkA/d7Y
0ygR+cZKgXA0JBe6qRweXCGXkpgS6rF3PV6v9zlvDX2eMOBPnqf2TWZZbskbgBem
leCta4QqSnRxmIZj2P6BKgc/vlCOGDJwFAcrxYqI0b73kDouwEw8V3se7eFX54vF
CFGSmOsgO0a1nRwRi6A/Z3Y/dT1OEp2CzvgaiRVBZhhlJ+7Xko1L7hiMUXzvwIQK
UZcPUhjjsulmMefDegYHxmeI93rDDpJVfMsTBGS305z1E0hh75SbrKbF2YnvNjWB
oHP3PNhW5f8=
=WfZ3
-----END PGP SIGNATURE-----

--Sig_/fDQ7tRh2XwA94Wg/qdJVHaD--
