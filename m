From: NeilBrown <neilb@suse.com>
Subject: Re: raid0 vs. mkfs
Date: Mon, 28 Nov 2016 19:40:25 +1100
Message-ID: <87inr880au.fsf@notabene.neil.brown.name>
References: <56c83c4e-d451-07e5-88e2-40b085d8681c@scylladb.com> <87oa108a1x.fsf@notabene.neil.brown.name> <286a5fc1-eda3-0421-a88e-b03c09403259@scylladb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <286a5fc1-eda3-0421-a88e-b03c09403259@scylladb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Avi Kivity <avi@scylladb.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 28 2016, Avi Kivity wrote:

> On 11/28/2016 07:09 AM, NeilBrown wrote:
>> On Mon, Nov 28 2016, Avi Kivity wrote:
>>
>>> mkfs /dev/md0 can take a very long time, if /dev/md0 is a very large
>>> disk that supports TRIM/DISCARD (erase whichever is inappropriate).
>>> That is because mkfs issues a TRIM/DISCARD (erase whichever is
>>> inappropriate) for the entire partition. As far as I can tell, md
>>> converts the large TRIM/DISCARD (erase whichever is inappropriate) into
>>> a large number of TRIM/DISCARD (erase whichever is inappropriate)
>>> requests, one per chunk-size worth of disk, and issues them to the RAID
>>> components individually.
>>>
>>>
>>> It seems to me that md can convert the large TRIM/DISCARD (erase
>>> whichever is inappropriate) request it gets into one TRIM/DISCARD (erase
>>> whichever is inappropriate) per RAID component, converting an O(disk
>>> size / chunk size) operation into an O(number of RAID components)
>>> operation, which is much faster.
>>>
>>>
>>> I observed this with mkfs.xfs on a RAID0 of four 3TB NVMe devices, with
>>> the operation taking about a quarter of an hour, continuously pushing
>>> half-megabyte TRIM/DISCARD (erase whichever is inappropriate) requests
>>> to the disk. Linux 4.1.12.
>> Surely it is the task of the underlying driver, or the queuing
>> infrastructure, to merge small requests into large requests.
>
> Here's a blkparse of that run.  As can be seen, there is no concurrency,=
=20
> so nobody down the stack has any chance of merging anything.

That isn't a valid conclusion to draw.
raid0 effectively calls the make_request_fn function that is registered
by the underlying driver.
If that function handles DISCARD synchronously, then you won't see any
concurrency, and that is because the driver chose not to queue but to
handle directly.
I don't know if it actually does this though.  I don't know the insides
of the nmve driver .... there seems to be a lightnvm thing and a scsi
thing and a pci thing and it all confuses me.

>
>
> No merging was happening.  This is an NVMe drive, so running with the=20
> noop scheduler (which should still merge).   Does the queuing layer=20
> merge trims?

I wish I knew.  I once thought I understood about half of the block
queuing code, but now with multi-queue, I'll need to learn it all
again. :-(

>
> I don't think it's the queuing layer's job, though.  At the I/O=20
> scheduler you can merge to clean up sloppy patterns from the upper=20
> layer, but each layer should try to generate the best pattern it can.=20=
=20

Why?  How does it know what is best for the layer below?

> Large merges mean increased latency for the first request in the chain,=20
> forcing the I/O scheduler to make a decision which can harm the=20
> workload.  By generating merged requests in the first place, the upper=20
> layer removes the need to make that tradeoff (splitting the requests=20
> removes information: "we are interested only in when all of the range is=
=20
> trimmed, not any particular request").

If it is easy for the upper layer to break a very large request into a
few very large requests, then I wouldn't necessarily object.
But unless it is very hard for the lower layer to merge requests, it
should be doing that too.
When drivers/lightnvm/rrpc.c is providing rrpc_make_rq as the
make_request_fn, it performs REQ_OP_DISCARD synchronously.  I would
suggest that is a very poor design.  I don't know if that is affecting
you (though a printk would find out).

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlg77XsACgkQOeye3VZi
gblEgBAAgIp+m+AR+9GRTOhjFPOqGY+CuD76PT02l631D78Gy6fAw2EsZFtVjyV/
97vlQqgidnZAXLvNcrZeM94wzsrlg6+OmZbOjdrFLChZWtcA6G8ZLHTef+wMIoCe
FOHtcPi+2vlky7Xh+b+QMmKjaCHn5vMRfxe24bnnxcxmifzKatHBsT7n3Mr2m0mO
fJ2gnDiKV+6IYwK2TqpJdpBaOV5Ps5kdcI2pbokI3pzxkvjlPn93WsgwxyxE9CDy
8+XpypA7yNSB6GArcoTwlO4mQpl4EIP32d1s69DpNpdfcpJhQdi2nk7cqXv/f3ys
+RHRYICvgf5VTYKTpJ1L0Q5naDz+KEDB1ZR1+aKd2O8+1mU0FuKWC913Eb5bZQMz
suceZ2iYZ0/ds/9qpUlCm25ajq+tFcAovMvOZvdfSzphM++KrEXGt4hsm7lzql+o
O2/CvA3FTGDTjHLOivtXY1GqYM/I/ECcvShaEwaIQ5XY2Lxko5F52IMLCRZxRBml
sSxuNh3HSYAuMD/Sj1lPBqjPwQG6NFRBZdex/kYon6dnohYcAoF3LnTwzbDxXLMC
ZEx2i8LXgesiEh4WDCfXxK0s/QepfObSrPum90blq7GLvR2GRij2VLmVQdYbq2r9
ghJkbeXtW9QFmncipagfTgMGuP616d3lYzpBST7TrqjbDPJJDVA=
=T4KN
-----END PGP SIGNATURE-----
--=-=-=--
