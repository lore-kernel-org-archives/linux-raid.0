From: Doug Ledford <dledford@redhat.com>
Subject: Re: Software RAID5 write issues
Date: Wed, 10 Jun 2009 21:46:32 -0400
Message-ID: <1244684792.21347.231.camel@firewall.xsintricity.com>
References: <AB9F712C-7A3F-4832-B60B-AB56DE448F14@crc.id.au>
	 <1244667422.21347.210.camel@firewall.xsintricity.com>
	 <916523ED-3D03-4AB1-A64A-1797852ABE9B@crc.id.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-o/EGebM5TV8Lie+pEe8+"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <916523ED-3D03-4AB1-A64A-1797852ABE9B@crc.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Steven Haigh <netwiz@crc.id.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-o/EGebM5TV8Lie+pEe8+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-06-11 at 10:05 +1000, Steven Haigh wrote:
> Isn't the PCI Bus limited to around 133MB/sec? If so, even with 3 =20
> drives on the same controller, you would expect divided equally that =20
> each drive would get ~44MB/sec before overheads - not around 7MB/sec =20
> per drive. I know I'm not going to get phenomenal performance with my =20
> setup, but as most the data is archiving (and then copied to tape), I =20
> would like to get things at least up to a reasonable level instead of =20
> having a write speed of ~12% of the read speed.

It is, but it's shared amongst all the cards on that particular bus, and
in particular older motherboards would daisy chain busses such that a
later bus only gets part of that bandwidth because earlier busses are
using it too.  Plus the PCI bus limitation is 133MB/s theoretical
maximum, in practice you get less due to things like arbitration and
such.

> Hmmm - a very interesting read - but I am a little confused when it =20
> comes to PCI bandwidth. I would assume (maybe wrongly) that if I can =20
> READ from the array at 95MB/sec (as measured by bonnie++), then I =20
> should be able to write to the same array at a little faster than 11MB/=20
> sec - as a read would usually read from 4 of 5 drives, however a write =20
> would go to all drives. This being said, I wouldn't expect one extra =20
> write to equal 12% of a read speed!

There are two factors involved in this (I'm speculating of course, but
here goes).

One, a read doesn't involve every drive in the array.  For any given
stripe, you will actually only read from 4 of the 5 drives.  Since 3 of
the drives are on the card, that means that 3 out of 5 stripes, one of
those drives will be the parity drive and therefore not used in the read
process.  So, for 3 out of 5 stripes, you actually read from two of the
drives behind the card and two on the motherboard.  The other two you
read from three of the drives behind the card and one on the
motherboard.  That accounts for a reasonable amount of difference all by
itself.  As an example, I have an external SATA drive case here that
holds 4 drives on a repeater and uses a single eSATA cable to run the 4
drives.  When accessing a single drive, I get 132MB/s throughput.  When
I access two drives, it drops to 60MB/s throughput per drive.  When
accessing three drives, it drops to 39MB/s throughput per drive.  So,
you can see where, on read, the lack of need to access all three drives
can really help on specific stripes.  In other words, reading from only
4 drives at a time *helps* your performance because whatever two drives
are in use behind the PCI card run faster and can keep up better with
the two drives on the motherboard.  Since writes always go to all 5
drives, you always get the slower speed (and you are writing 25% more
data to disk relative to the amount of actual data transfered than when
you are reading to boot).

Two, you use a 1MB chunk size.  Given a 5 drive raid5, that gives a 4MB
stripe width.  My guess is that your stripe size is large enough,
relative to your average write size, that your array is more often than
not performing a read/modify/write cycle for writing instead of a full
stripe write.  In a full stripe write, the md stack will write out all
four data chunks and a calculated parity chunk without regard to what
parity was before and what data was there before.  If, on the other
hand, it doesn't have enough data to write an entire stripe by the time
it is flushing things out, then it has to do a read/modify/write cycle.
The particulars of what's most efficient in this case depend on how many
chunks are being overwritten in the stripe, but regardless it means
reading in parts of the stripe and parity first, then doing xor
operations, then writing new data and new parity back out.  This will
mean that at least some of the 5 drives are doing both reads and writes
in a single stripe operation.  So, I think the combination of
read/modify/write cycles combined with the poor performance of drives
behind the PCI card actually can result in the drastic difference you
are seeing between read and write speeds.

> The other thing I wonder is if it has something to do with the =20
> sil_sata driver - as ALL the drives in the RAID5 are handled by that =20
> kernel module. The boot RAID1 is on the ICH5 SATA controller - and =20
> suffers no performance issues at all. It shows a good 40MB/sec+ read =20
> AND write speeds per drive.

It's entirely possible that the driver plays a role in this, yes.  I
don't have any hardware that uses that driver so I couldn't say.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband


--=-o/EGebM5TV8Lie+pEe8+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkowYfgACgkQQ9aEs6Ims9jdgwCgoVxo0GWAU0mkpRojqkmYBBxC
LUQAnR1GGsZSsyE9kdE3yKMBFkIH3cJY
=Lby4
-----END PGP SIGNATURE-----

--=-o/EGebM5TV8Lie+pEe8+--

