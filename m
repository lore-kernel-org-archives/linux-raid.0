From: NeilBrown <neilb@suse.de>
Subject: Re: [RFC] raid5: add a log device to fix raid5/6 write hole issue
Date: Thu, 9 Apr 2015 15:04:59 +1000
Message-ID: <20150409150459.320c668a@notabene.brown>
References: <20150330222459.GA575371@devbig257.prn2.facebook.com>
	<20150402085312.5ea3d518@notabene.brown>
	<20150401234055.GA3375744@devbig257.prn2.facebook.com>
	<20150402111941.104d0633@notabene.brown>
	<20150402040749.GA4025688@devbig257.prn2.facebook.com>
	<20150409004238.GA186860@devbig257.prn2.facebook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/n+BOK+Vi17l=RMHHQ=mYXNQ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150409004238.GA186860@devbig257.prn2.facebook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: dan.j.williams@intel.com, linux-raid@vger.kernel.org, songliubraving@fb.com, Kernel-team@fb.com
List-Id: linux-raid.ids

--Sig_/n+BOK+Vi17l=RMHHQ=mYXNQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 8 Apr 2015 17:43:11 -0700 Shaohua Li <shli@fb.com> wrote:

> Hi,
> This is what I'm working on now, and hopefully had the basic code
> running next week. The new design will do cache and fix the write hole
> issue too. Before I post the code out, I'd like to check if the design
> has obvious issues.

I can't say I'm excited about it....

You still haven't explained why you would ever want to read data from the
"cache"?  Why not just keep everything in the stripe-cache until it is safe
in the RAID.   I asked before and you said:

>> I'm not enthusiastic to use stripe cache though, we can't keep all data
>> in stripe cache. What we really need is an index.

which is hardly an answer.  Why cannot you keep all the data in the stripe
cache?  How much data is there? How much memory can you afford to dedicate?

You must have some very long sustained bursts of writes which are much fast=
er
than the RAID can accept in order to not be able to keep everything in memo=
ry.


Your cache layout seems very rigid.  I would much rather a layout that was
very general and flexible.  If you want to always allocate a chunk at a time
then fine, but don't force that on the cache layout.

The log really should be very simple.  A block describing what comes next,
then lots of data/parity.  Then another block and more data etc etc.
Each metadata  block points to the next one.
If you need an index of the cache, you keep that in memory.  On restart, you
read all of the metadata blocks and  built up the index.

I think that space in the log should be reclaimed in exactly the order that
it is written, so the active part of the log is contiguous.   Obviously
individual blocks become inactive in arbitrary order as they are written to
the RAID, but each extent of the log becomes free in order.
If you want that to happen out of order, you would need to present a very
good reason.

Best to start as simple as possible....


NeilBrown




>=20
> Thanks,
> Shaohua
>=20
> Main goal is to aggregate write IO to hopefully make full stripe IO and f=
ix the
> write hole issue. This might speed up read too, but it's not optimized for
> read, eg, we don't proactivly cache data for read. The aggregation makes =
a lot
> of sense for workloads which sequentially write to several files. Such
> workloads are popular in today's datacenter.
>=20
> Here cache =3D cache disk, generally SSD. raid =3D raid array or raid dis=
ks
> (excluding cache disk)
> -------------------------
> cache layout will like this:
>=20
> |super|chunk descriptor|chunk data|
>=20
> We divide cache to equal sized chunks. each chunk will have a descriptor.
> Its size will be raid_chunk_size * raid_disks. That is the cache chunk can
> store a whole raid chunk data and parity.
>=20
> Write IO will store to cache chunks first and then flush to raid chunks. =
We use
> fixed size chunk:
> -manage cache space easily. We don't need a complex tree-like index
>=20
> -flush data from cache to raid easily. data and parity are in the same ch=
unk
>=20
> -reclaim space is easy. when there is no free chunk in cache, we must try=
 to
> free some chunks, eg, reclaim. We do reclaim in chunk unit. reclaim a chu=
nk
> just means flush the chunk from cache to raid. If we use complex data
> structure, we will need garbage collection and so on.
>=20
> -The downside is we waste space. Eg, a single 4k data will use a whole ch=
unk in
> cache. But we can reclaim chunks with low utilization quickly to mitgate =
this
> issue partially.
>=20
> --------------------
> chunk descriptor looks like this:
> chunk_desc {
> 	u64 seq;
> 	u64 raid_chunk_index;
> 	u32 state;
> 	u8 bitmaps[];
> }
>=20
> seq: seq can be used to implement LRU-like algorithm for chunk reclaim. E=
very
> time data is written to the chunk, we update the chunk's seq. When we flu=
sh a
> chunk from cache to raid, we freeze the chunk (eg, the chunk can't accept=
 new
> IO). If there is new IO, we write the new IO to another chunk. The new ch=
unk
> will have a bigger seq than original chunk. crash and reboot can use the =
seq to
> detinguish which chunk is newer.
>=20
> raid_chunk_index: where the chunk should be flushed to raid
>=20
> state: chunk state. Currently I defined 3 states
> -FREE, the chunk is free
> -RUNNING, the chunk maps to raid chunk and accepts new IO
> -PARITY_INCORE, the chunk has both data and parity stored in cache
>=20
> bitmaps: each page of data and parity has one bit. 1 means present. Store=
 data
> bits first.
>=20
> -----IO READ PATH------
> IO READ will check each chunk desc. If data is present in cache, dispatch=
 to
> cache. otherwise to raid.
>=20
> -----IO WRITE PATH------
> 1. find or create a chunk in cache
> 2. write to cache
> 3. write descriptor
>=20
> We write descriptor immediately in asynchronous way to reduce data loss, =
the
> chunk will be RUNNING state.
>=20
> -For normal write, IO return after 2. This will cut latency too. If there=
 is a
> crash, the chunk state might be FREE or bitmap isn't set. In either case,=
 this
> is the first write to the chunk, IO READ will read raid and get old data.=
 We
> meet the symantics. If data isn't in cache, we will read old data in cach=
e, we
> meet the symantics too.
>=20
> -For FUA write, 2 will be a FUA write. When 2 finishes, run 3 with FUA. IO
> return after 3. Crash after IO return deosn't impact symantics. We will r=
ead
> old or new data if crash happens before IO return, which is the similar l=
ike
> the normal write case.
>=20
> -For FLUSH, wait all previous descriptor write finish and then flush cach=
e disk
> cache. In this way, we guarantee all previous write hit cache.
>=20
> -----chunk reclaim--------
> 1. select a chunk
> 2. freeze the chunk
> 3. copy chunk data from cache to raid, so stripe state machine runs, eg,
> calculate parity and so on
> 4. Hook to raid5 run_io. We write parity to cache
> 5. flush cache disk cache
> 6. mark descriptor PARITY_INCORE, and WRITE_FUA to cache
> 7. raid5 run_io continue run. data and parity write to raid disks
> 8. flush all raid disk cache
> 9. mark descriptor FREE, WRITE_FUA to cache
>=20
> We will batch several chunks for reclaim for better performance. FUA writ=
e can
> be replaced with FLUSH too.
>=20
> If there is a crash before 6, descriptor state will be RUNNING. Recovery =
just
> need discard the parity bitmap. If there is a crash before 9, descriptor =
state
> will be PARITY_INCORE, recovery must copy both data and parity to raid.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/n+BOK+Vi17l=RMHHQ=mYXNQ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVSYIeznsnt1WYoG5AQJUZhAAsKnHzscHxEVVTPpc0z5dKlOubHvESAbP
o2MHQYDGzqgu8N6EZ/BpdxeCz8J1ljei0Bj2tv/1Hhx43nCqF48ZJSquA28pdxn4
wtBlcuMFLU5/FweMe1hDhTSyfAFSnNIRok5u+nW5/+15Oceeyw6hNx3yudgLXPwa
lDB58MCVYK2Xn/KiigJ12MYI+5OjP6L2KmJ9TALtNRM2r7Z29LudZYypTIsq7aWv
5Eg7LsY6Ki7dE1rfvQwgnxNNDv46/YG/ucbyzGDHEB8UUZCj3rHj33taN3vgLHdR
cjxRvJtaG7y3IgOpgUIFFxjEipVQpyNf5S9C6L9q8kio+iq30V5XFUTMSmx0dYrG
+kbrRczMVgBKYoMoDNavUGRS3z945J1o4K/GcbE8XkRnX0ONnOrrS7rQ7tK3RyG3
dLOAXmeAk/SUWGEXRmtfOHedrkz7lySH9pFdwUAqRMeXIUFbVOTC29rLClixj4gb
fu9vyxm5pCGwMJu7MfPDQqKHANf3AtRJMgY/3u+FluON1Vrp3Cjc/IUDnU53f9gh
FusoOgauqmIiHwkH5OnoiNajtQKPJir+AVpRYWejnCKhcFHPoWEirbbQip0iVgTW
A2EoXFcxViZr2mtiz79eTUw0tfiKdAOEjTy2pD3CFWALOBUpJjFN2xkb3OIr1Dv5
l3H3ezYsZgc=
=Wr00
-----END PGP SIGNATURE-----

--Sig_/n+BOK+Vi17l=RMHHQ=mYXNQ--
