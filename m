From: NeilBrown <neilb@suse.de>
Subject: Re: [RFC] raid5: add a log device to fix raid5/6 write hole issue
Date: Thu, 2 Apr 2015 11:19:41 +1100
Message-ID: <20150402111941.104d0633@notabene.brown>
References: <20150330222459.GA575371@devbig257.prn2.facebook.com>
	<20150402085312.5ea3d518@notabene.brown>
	<20150401234055.GA3375744@devbig257.prn2.facebook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/gZr4cF4bdWeyhIBDCfUBISX"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150401234055.GA3375744@devbig257.prn2.facebook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: dan.j.williams@intel.com, linux-raid@vger.kernel.org, songliubraving@fb.com, Kernel-team@fb.com
List-Id: linux-raid.ids

--Sig_/gZr4cF4bdWeyhIBDCfUBISX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 1 Apr 2015 16:40:57 -0700 Shaohua Li <shli@fb.com> wrote:


> >  Your code does avoid write-hole-protection for fill-stripe-writes, and=
 this
> >  would greatly reduce the  number of block that were written multiple t=
imes.
> >  However I'm not convinced that is correct.
> >  A reasonable  goal is that if the system crashes while writing to a st=
orage
> >  device, then reads should return the old data or not new data, not any=
thing
> >  else.  A crash in the middle of a full-stripe-write to a degraded array
> >  could result in some block in the stripe appearing to contain data tha=
t is
> >  different to both the old and the new.  If you are going to close the =
whole,
> >  I think it should be done properly.
>=20
> I can do it simpley. But don't think this assumption is true. If you
> write to a disk range and there is failure, there is nothing guarantee
> you can either read old data or new data.

If you write a range of blocks to a normal disk and crash during the write,
each block will contain either the old data or the new data.
If you write a range to a degraded RAID5 and crash during the write, you
cannot make that same guarantee.
I don't know how important this is, but then I don't really know how
important any of this is.

>=20
> >=20
> >  A combined log would "simply" involve writing every data block and  ev=
ery
> >  compute parity block (with index information) to the log device.
> >  Replaying the log would collect data blocks and flush out those in a s=
tripe
> >  once the parity block(s) for that stripe became available.
> >=20
> >  I think this would actually turn into a fairly simple logging mechanis=
m.
>=20
> It's not simple at all. It's unlikely we write data and parity
> continuously in disk and in the same time. This will make log checkpoint
> fairly complex.

I don't see any cause for complexity.  Let me be more explicit.

I imagine that all data remains in the stripe cache, in memory, until it is
finally written to the RAID5.  So the stripe cache will need to be quite a
bit bigger.

Every time we get a block that we want to write, either a new data block or=
 a
a computed parity block, we queue it to the log.

The log works like this:
 - take the first (e.g.) 256 blocks in the queue, create a header to descri=
be
   them, write the header with FUA, then write all the data blocks.  If the=
re
   are fewer than 256, just write what we have.
 - when the header write completes, all blocks written *previously* are now
   safe and we can call bio_end_io on data or unlock the stripe for parity.
 - loop back and write some more blocks.  If there are no blocks to write,
   write a header which describes an empty set of blocks, and wait for more
   blocks to appear.


Each stripe_head needs to track (roughly) where the relevant blocks were
written so it can release them when the stripe is written.
I would conceptually divide the log into 32 regions and keep a 32bit number
with each stripe.  When a block is assigned to a region in the log, the
relevant bit is set for the stripe, and a per-region counter is incremented.
When a stripe completes its write, the region counters for all the bits are=
=20
cleared.  The log cannot progress into a region which has a non-zero counte=
r.

We choose the size of transactions so that the first block of each region is
a header block.  These contain a magic number, a sequence number, and a
checksum together with the addresses of the data/parity blocks.  On restart
we read all 32 of these to find out where the log starts and ends.  Then we
replay all the blocks into the stripe cache - discarding any that don't come
with the required parity blocks.

So it is a very simple log which is never read exact on crash recovery.  It
commits everything ASAP so that the writeout to the array can be lazy and c=
an
gather related blocks and sort address etc with not impact on filesystem
latency.

Does that make sense?

NeilBrown

--Sig_/gZr4cF4bdWeyhIBDCfUBISX
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVRyLHjnsnt1WYoG5AQKxCg/+PoyxxKTjTCVmNiXn14v1kUriRdrxHj9R
6Sn4QqxYPdFgV8bb6orPKPQQUULamlylhTQAHu0xmxzK9KJrrDwB5o4TP8Ik82/M
2ZW1prA7goKJ/sEfjtf/g5BsDT6mMBMYGUSCVKuvYFyqg4G4+EQJ66ZTB8UGeoS7
p3QliW4mHvQZF1uQEJWK0PRu5zF3Y6CWAnVnhKuzWejLPdO0ChCPaSWKrTfL/tnn
cruvCSbnAuCpXCKwrBZwFpX2Ibm8A/N6MF/ZPOAnsabN8xwKaJg9mq/Das/OSjB1
V0W0Vlq1LhUdQAjaz51iKXOkpWAvtEbyWTDtlc2wMDm57tPy21GomeM3U7VVglxT
VF7qht/EF9BDzTm6tzwctkrijkiAduwhkRAAiyZ1DVcVad6Qx/d5z4LrC60LlT1E
94BXYPUQQRhlvsWgzGQ9D4aIuVqX1SOxhKQ1uYYW27kJKKUKQT76DG0hXAnLJUVF
CieZaI14I1R5twPT4BKOnRIKdy6yPO0rBuD7R09EhLXGHCnOnxoFojQulpY4CU19
TkGmx4xW8lh8CDDKZoE6UZULMLR9+18vagtIR9SJhLBn6QG7PYv6MJE75nD8poia
xvRpLYcESOlz/csfwiOBKPzm15i6p0zj2ZnOYFtI0ZpJ+XlSXWabSM2oGI3bcc3+
R43UWJ5nGN4=
=1FAk
-----END PGP SIGNATURE-----

--Sig_/gZr4cF4bdWeyhIBDCfUBISX--
