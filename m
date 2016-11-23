From: NeilBrown <neilb@suse.com>
Subject: Re: [md PATCH 0/5] Stop using bi_phys_segments as a counter
Date: Wed, 23 Nov 2016 13:08:38 +1100
Message-ID: <87zikraqxl.fsf@notabene.neil.brown.name>
References: <147969099621.5434.12384452255155063186.stgit@noble> <20161121234311.6qhwa2g3oa4uhcbi@kernel.org> <87mvgscqe7.fsf@notabene.neil.brown.name> <20161122010220.dcq6brjhsliw4io6@kernel.org> <87k2bwcl44.fsf@notabene.neil.brown.name> <20161122080127.rv4kgmeyluyfyxnd@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161122080127.rv4kgmeyluyfyxnd@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Tue, Nov 22 2016, Shaohua Li wrote:

>
> I still don't like we have no control when to do endio, but don't have better
> idea either. These patches work for raid5, but we need to find similar tricky
> way to workaround raid1/raid10, which reuse bi_phys_segments too. Probably it's
> time MD allocates additional data and attaches to bio. Adding a counter will
> solve the issue in a consistency/clean way for raid1/10/5.

For raid1/raid10 we could do a very similar thing.  There is an
awkwardness in raid1 w.r.t waiting for bi_phys_segments to reach 1, but
that might disappear if Coly's resync changes go through.
Alternately it might make sense to use bio_split so there is one r1_bio
per bio.
I might try the raid10 version and see what it looks like.

Thanks,
NeilBrown


>
> Thanks,
> Shaohua

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYNPomAAoJEDnsnt1WYoG5OhoQAJZnCATdfQrUUkXuHzDyehxi
6VMriRl1BXWqgSrlp0s7FEJWLiM2e/72CTWIGujvb0e42KZ0lnohlowpOxRlCfQ0
39P1TQQtx43XsqfvnnqNOk3X0Yjx9vz+PwylIJnhKdDb2AQZcv+lx3zuAaOTTelt
GbMu7I91oW+bGDUEo9mibqrTtre7TNh+74l49NXr4uzOAPZux+ZmTZG4P+x/cLVn
b8DponkbSYYaMZ+BbAbu7zVCg7dsJVtkcK/4EnMS1Q8VtbO5cR7BoqGtHBGiqQ68
FGXXPiwqS1mUcoizptL5z+IkEJwljjJHlLSMkKGSzmCnx2RA07m3Z7j0MCWc7oa9
ywdkQR+3MAEbZ1GaaObAXIp4Bglsg0lcCUFB/Rd82EDMTH3/mY80sxx0bhWdV69T
tzoL4X6My4wOVoC0vD31swEgooLZPyuHcIOG8ta9Ph2gPB/ZX+ecPzul80+lxive
QEq+Y8cI83r/aSVHV7MlVbNIJlfXF9xGufHygA/furfh6vrpUYg4t6Qhu9Uj5Jtc
q34w4t3L7lTLanMrdPrz9fclNSSLakrYp6Gmz1g6BUARyH1cogDqDFwlXHFuCAkP
o6uTdP70/9atgS4jfQ1WTjvd1GIlMI1EPimVDJciTAQIHQkob/9d7bXeGxxoXpCo
/Lfuve9HH5B+Rtvn2+Pi
=D7ex
-----END PGP SIGNATURE-----
--=-=-=--
