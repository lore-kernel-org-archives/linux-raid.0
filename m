From: NeilBrown <neilb@suse.com>
Subject: Re: [md PATCH 0/5] Stop using bi_phys_segments as a counter
Date: Thu, 24 Nov 2016 11:31:59 +1100
Message-ID: <87d1hlbtvk.fsf@notabene.neil.brown.name>
References: <147969099621.5434.12384452255155063186.stgit@noble> <20161121234311.6qhwa2g3oa4uhcbi@kernel.org> <87mvgscqe7.fsf@notabene.neil.brown.name> <20161122010220.dcq6brjhsliw4io6@kernel.org> <87k2bwcl44.fsf@notabene.neil.brown.name> <20161122080127.rv4kgmeyluyfyxnd@kernel.org> <87zikraqxl.fsf@notabene.neil.brown.name> <20161123084540.GE16966@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161123084540.GE16966@lst.de>
Sender: linux-raid-owner@vger.kernel.org
Cc: Shaohua Li <shli@kernel.org>, Christoph Hellwig <hch@lst.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 23 2016, Christoph Hellwig wrote:

> On Wed, Nov 23, 2016 at 01:08:38PM +1100, NeilBrown wrote:
>> For raid1/raid10 we could do a very similar thing.  There is an
>> awkwardness in raid1 w.r.t waiting for bi_phys_segments to reach 1, but
>> that might disappear if Coly's resync changes go through.
>> Alternately it might make sense to use bio_split so there is one r1_bio
>> per bio.
>> I might try the raid10 version and see what it looks like.
>
> For RAID1 reads there already is one r1_bio per bio

unless the bad-block-log records some bad/missing blocks in the middle
of the range being read.

> - in fact I have
> a hack that doesn't allocate a r1_bio at all, but that one currently
> does not handle reads from degraded arrays at all.  Due you remember
> why we only mark a leg fail for a given bio instead of on a per-device
> or at least per sector-range?

When we detect a read error, we try to "correct" it by reading the data
From=20elsewhere and over-writing the "bad" block.  If that works, there
was no need to mark the whole device as faulty.  If it does fail, that
is when the device is failed.

We could have a "soft-write-mostly" flag to discourage reads from a
questionable device, until it has been properly tested.

>
> For writes it would make sense to allocate the new bio for each mirror
> using a bio_set with front_pad for raid1-specific data, but I haven't
> really looked into the details yet.

Yes, you could.  I don't know if it would be an improvement, or just a
change.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYNjT/AAoJEDnsnt1WYoG5hy0P/i1HO/I4aQyxpuuUAKhwvyIi
p/ctDNCXp9u2tw4Rmx1Ex0EmIvlvc+25WsA8r21c72NpMDk5wrsCkv1oiR7T/FmG
zwTEQVkqZ48e31bsVC4Kv1CLT6gM6HWHCEnybW7ilvc3SmKEjC/9xsqX+fUXl1a3
5vryjlnHeXkRSmK6jhonobOkB/T+AoL0kIIkTd7aD1LjkG+wgkhp7FkHhvzEaojY
7FMuauzgu+GJYFGz5wdyLcdnBCXQn4x2NX8b/f357/ISQc5clY4LArpXTOFGuSmo
r/G+OiBuwN0iuy5zG+A/AlGPEZ2nObX8ZQCxdrXr8a1w+gH8wvDovZeNQui6oR+U
BbeQzvps1mOH8dawE/DNiagfGXtckn7pKBaKZdvUEyTIxrIrEuolpJzGyPVsmsRU
X9OorKJxpf83qyE+5hX7G1lZLl6QBoJRHDsyp4MlfxcSddpnA+JlAaNwCEr7QSON
IKUyHt/TvYefPbbcHjGIGrOFMka1xQz0eryKLKS62CrQblWSorRtyeE6s6povPme
EHXAjpha0K4EuOv77YUQtRql78NSaA7KDS46ubD3OIYjOyc5XnmUNGiEe7b1bdrO
cIvHPBM50yzWa4oMY1I3vuiYyXpf43yLUPllkFeay4Ssu3NC6+O85KD6vqGC74y4
RkLWkgwpuOJzdX1LhO9A
=tFlD
-----END PGP SIGNATURE-----
--=-=-=--
