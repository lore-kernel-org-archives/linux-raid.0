From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] raid5-cache: use crc32c checksum
Date: Fri, 30 Oct 2015 17:37:49 +1100
Message-ID: <87io5ox3nm.fsf@notabene.neil.brown.name>
References: <05c660271fe0d5f42bc053ef89c5e20ff57cf955.1445989535.git.shli@fb.com> <5630E942.90501@sandisk.com> <20151028154124.GA439358@devbig084.prn1.facebook.com> <56315032.7070904@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56315032.7070904@sandisk.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, Shaohua Li <shli@fb.com>
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Thu, Oct 29 2015, Bart Van Assche wrote:

> On 10/28/2015 08:41 AM, Shaohua Li wrote:
>> crc32c has lower overhead with cpu acceleration. It's a shame I didn't
>> use it in first post, sorry. This changes disk format, but we are still
>> ok in current stage.
>>
>> V2: delete unnecessary type conversion as pointed out by Bart
>
> Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>

Thanks.  I've applied the second version and added your reviewed-by.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWMxA9AAoJEDnsnt1WYoG5Dh4P/AgQKFrJOZIV7f4HiSVMOmBX
hgnbgY4fDS8boyxfF2He0J2SNZDXxuUyGwIZC1YHs00E/qRlp/DHzeFLeXQOXFq/
wZmpQgdcay07XlcciqHXnzuGl/0rVganIpycNTgiQ9OxgHTzwdNvuPK4wNxdJhuh
BjIMiNUezk2TPVyDGcuzH7UAqQ2rcFt+bRRcoKKVHMncyAtGCReOqb4Bfi5w48tK
3GTugIkHDWFDkIvnZHeJAauLyJkZ5fX7/2GJcU6aCOm+4vZ88OCNvcKVgRPxn0NL
I/RA8HZDTmzACA0QSkFBCj/Eqj71vZLLLnQiYTz72IzoonGTJN314dfG7MBa2BQF
FlgSkjacVneH2mVf13o8xlMaxFrsLjQA1BTArSsZz2Lx+/c7wmW06f5i6YgnFrUM
B/W5Mk+tuZhMNv3an37Hw+MuuTt3adaim8aW101CUW/BPFAmylKHC3+vEdTk+fjl
0DKyXCrt6unZeF6qdUcVMXLdqf+wO5GDg29wjw4LMJe61BKapBRS01zk3+gfLpfs
hBW9yxkWGPh0wSGrDStgeve2qY3FZGdIPgJVT534Mm5Co7ARBKlzmxzcf1643kxc
z7ihDKn9J1b6Tqn/UzejKMGN7qY69pq1S1ZbJoajLJPz2oZZSG9IqoH51MOg2lOa
LKqTB9Sh13A91s/sq/4I
=fhUG
-----END PGP SIGNATURE-----
--=-=-=--
