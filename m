From: NeilBrown <neilb@suse.com>
Subject: Re: raid10.c read_balance question
Date: Tue, 22 Nov 2016 15:49:05 +1100
Message-ID: <87h970ce66.fsf@notabene.neil.brown.name>
References: <CAANLjFodaUUZrROncC+uQjWX5pXVxgJ0HWkNunwugQQrp4Kojw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAANLjFodaUUZrROncC+uQjWX5pXVxgJ0HWkNunwugQQrp4Kojw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robert LeBlanc <robert@leblancnet.us>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Tue, Nov 22 2016, Robert LeBlanc wrote:

> I'm looking to improve 'near' layout performance in raid10 and looking
> at the code for read_balance, the comments mention that there is a
> 'next expected sequential IO' sector number stored for the RAID array,
> but I don't see such a variable in the struct, nor do I see in
> read_balance where that variable is being updated. With such a value,
> I could use it (with another variable) to guess if the current
> requests are random or sequential enough to take the latency hit to
> move drive heads to help parallel the read. This would be a much
> simpler route than what I was thinking about previously.
>
> Am I just missing this variable? I would expect it to be in the
> r10conf struct, would that be the right place to implement it if
> doesn't exist?

I think it is "head_position".

NeilBrown

>
> Thanks,
> ----------------
> Robert LeBlanc
> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYM85BAAoJEDnsnt1WYoG5YckP/0H/Wo74yTV0VXUG1X7gZI4i
JJBXP1GBlTjoc6TsCEZgOB5AaDTMZZDZJFfBAt4W+osDXkTPYjHpWE4LkuO4IceW
vIh0YAvysHKKoGhI6nrwgxvbgUfGj9bFPG7CIi2VzQ1Wqp3lVQOvJlb7o6jbwpWG
rJbbex4cBiJlNN4d/04OVFaUvmIVUm33ZPeejbP5sANEXfU2d5mUCT7DKZKVcPsz
aWAM+TgZi4um72StTMnmbMO3+yjjeQiiL4xNnMwahiOeW5ZoFb4ofaNXRwp6armN
MpbkH36rbrVtc1bFpNhoWMIl0pDvjzEOy0oPVjy6uHl+WABQFVipaSZDjim+9A9n
QRygMytS7mR4LAdaxWVwmOjXA/sK85rAGbZMTv+27CTMNqxg4mMUsHlOXWehHQAn
6gYiZ3GME0m+UcropRmLrT5h443MbfPfn1l3/L82i2wlM1PB+sDjNvF/8Ic6uNMo
qCLehjel8aURNgzVYOCQr4n5/XRgjwmF1TH6lvbf6gKhTmnCttbYrSgEOMd4Mm9g
mMrQDPgumQKbxKYGuMuJJx2RcR2xkrZ7lf/Uj4tuetr25HrKQuZAh85cph1Zly+n
7wEWXcBWG96hLSLwOUg+cIR6mEvzBWtFJKGlFPq5yUtnVzqSNxIoJgMBxzSNKXxQ
90nwXtX4TDOXWxd9ZJi/
=m7Fc
-----END PGP SIGNATURE-----
--=-=-=--
