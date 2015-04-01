From: NeilBrown <neilb@suse.de>
Subject: Re: [RFC] raid5: add a log device to fix raid5/6 write hole issue
Date: Thu, 2 Apr 2015 08:53:12 +1100
Message-ID: <20150402085312.5ea3d518@notabene.brown>
References: <20150330222459.GA575371@devbig257.prn2.facebook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/E0erCGyOAOa0._6WH2FYYVw"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150330222459.GA575371@devbig257.prn2.facebook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: dan.j.williams@intel.com, linux-raid@vger.kernel.org, songliubraving@fb.com, Kernel-team@fb.com
List-Id: linux-raid.ids

--Sig_/E0erCGyOAOa0._6WH2FYYVw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 30 Mar 2015 15:25:17 -0700 Shaohua Li <shli@fb.com> wrote:

> This is my attempt to fix raid5/6 write hole issue, it's not for merge
> yet, I post it out for comments. Any comments and suggestions are
> welcome!
>=20
> Thanks,
> Shaohua
>=20
> We expect a completed raid5/6 stack with reliability and high
> performance. Currently raid5/6 has 2 issues:
>=20
> 1. read-modify-write for small size IO. To fix this issue, a cache layer
> above raid5/6 can be used to aggregate write to full stripe write.
> 2. write hole issue. A write log below raid5/6 can fix the issue.
>=20
> We plan to use a SSD to fix the two issues. Here we just fix the write
> hole issue.
>=20
> 1. We don't try to fix the issues together. A cache layer will do write
> acceleration. A log layer will fix write hole. The seperation will
> simplify things a lot.
>=20
> 2. Current assumption is flashcache/bcache will be used as the cache
> layer. If they don't work well, we can fix them or add a simple cache
> layer for raid write aggregation later. We also assume cache layer will
> absorb write, so log doesn't worry about write latency.
>=20
> 3. For log, write will hit to log disk first, then raid disks, and
> finally IO completion is reported. An optimal way is to report IO
> completion just after IO hits to log disk to cut write latency. But in
> that way, read path need query log disk and increase complexity. And
> since we don't worry about write latency, we choose a simple soltuion.
> This will be revisited if there is performance issue.
>=20
> This design isn't intrusive for raid5/6. Actully only very few changes
> of existing code is required.
>=20
> Log looks like jbd. Stripe IO to raid disks will be written to log disk
> first in atomic way. Several stripe IO will consist a transaction. If
> all stripes of a transaction are finished, the tranaction can be
> checkpoint.
>=20
> Basic logic of raid 5/6 write will be:
> 1. normal raid5/6 steps for a stripe (fetch data, calculate checksum,
> and etc). log hooks to ops_run_io.
> 2. stripe is added to a transaction. Write stripe data to log disk (metad=
ata
> block, stripe data)
> 3. write commit block to log disk
> 4. flush log disk cache.
> 5. stripe is logged now and normal stripe handling continues
>=20
> Transaction checkpoint process:
> 1. all stripes of a transaction are finished
> 2. flush disk cache of all raid disks
> 3. change log super to reflect new log checkpoint position
> 4. WRITE_FUA log super
>=20
> metadata, data and commit block IO can run in the meaning time, as
> checksum will be used to make sure their data is correct (like jbd2).
> Log IO doesn't wait 5s to start like jbd, instead the IO will start
> every time a metadata block is full. This can cut some latency.
>=20
> Disk layout:
>=20
> |super|metadata|data|metadata| data ... |commitdata|metadata|data| ... |c=
ommitdata|
> super, metadata, commit will use one block
>=20
> This is an initial version, which works but a lot of stuffes are
> missing:
> 1. error handling
> 2. log recovery and impact to raid resync (don't need resync anymore)
> 3. utility changes
>=20
> The big question is how we report log disk. In this patch, I simply use
> a spare disk for testing. We need a new raid disk role for log disk.
>=20
> Signed-off-by: Shaohua Li <shli@fb.com>


Hi,
 thanks for the proposal and the patch which makes it nice and concrete...

 I should start out by saying that I'm not really sold on the importance of
 the issues you are addressing here.
 The "write hole" is certainly of theoretical significance, but I do wonder
 how much practical significance it has.  It can only be a problem if you
 have a system failure and a degraded array at the same time, and both of
 those should be very rare event individually... =20
 I wonder if anyone has *ever* lost data to the "write hole".

 As for write-ahead caching to reduce latency, most writes from Linux are
 async and so would not benefit from that.  If you do have a heavily
 synchronous write load, then that can be fixed in the filesystem.
 e.g. with ext3 and an external log to a low-latency device you can get
 low-latency writes which largely mask the latency issues introduced by
 RAID5.

 The fact that I'm "not really sold" doesn't mean I am against them ... may=
be
 it is just an encouragement for someone to sell them more :-)

 While I understand that keeping the two separate might simplify the
 problem, I'm not at all sure it is a good idea.  It would mean that every
 data block were written three times - once to the write-ahead log, once to
 the write-hole-protection log, and once to the RAID5.

 Your code does avoid write-hole-protection for fill-stripe-writes, and this
 would greatly reduce the  number of block that were written multiple times.
 However I'm not convinced that is correct.
 A reasonable  goal is that if the system crashes while writing to a storage
 device, then reads should return the old data or not new data, not anything
 else.  A crash in the middle of a full-stripe-write to a degraded array
 could result in some block in the stripe appearing to contain data that is
 different to both the old and the new.  If you are going to close the whol=
e,
 I think it should be done properly.

 A combined log would "simply" involve writing every data block and  every
 compute parity block (with index information) to the log device.
 Replaying the log would collect data blocks and flush out those in a stripe
 once the parity block(s) for that stripe became available.

 I think this would actually turn into a fairly simple logging mechanism.

NeilBrown

--Sig_/E0erCGyOAOa0._6WH2FYYVw
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVRxoyDnsnt1WYoG5AQJCLxAAnKOdtAyTMtOPCux0xBbd9EgPtjHm/vEz
dlbD6KGjajEx2PniiYv5r+ywO+rNqvUxs7rwCIn2zLznaDD4eppudg6shdDdRHoc
mXuJBDgTZztg1I8NwKZ1wj8R4tx2v5f9F1Rta038FmIx4PSHtChb5Q6yM4vON8Zv
iTsEQsWC7CilgPlV4GFZw8zQ4gdtoNGMBhpzSYMkfSE+tL9/ZZDowzloHJ1UNLJi
ZiyLB7ydXu+SXzubpAqBq4rLSbqzxVzjojYFMCGIGgCpqCsgUZuAvEHUgh6dzqVb
6/UbQ3N9he1sW9V5LP70XYcdwKkSXEGneNaAQkJtloqPUDS0d05+H8XthY8uVTkB
aND8/yqfeRskCiAzYQLr6gWKZkerOQ5arJvvHI+wNLN50gVA+f4u/YsEgeuaIAnz
2gPQXJ+43FFCNoYhhVY+O4omIcWbkqB5hcNkjTJzFvByDw1cx5GSGJnU0FMwnDhF
tWgdLMLgJ2btDIhzFxowUiT20gqU4VvCVjaVGxXIaODTzltctSOOngJjZ+ANZF9w
oFYclGu2pqJeX7LDf6I+AXDI7OWRRXGF4V1x27/MPtDO4oNhUWVlbSQnVScsndqV
FhYdHIwRjSd/AnAz0ScYK4243oWT/adQ+TFXJF0YIvbxfQCpX4ACgvK36gyX/JiK
B7cRXpopwQY=
=mUht
-----END PGP SIGNATURE-----

--Sig_/E0erCGyOAOa0._6WH2FYYVw--
