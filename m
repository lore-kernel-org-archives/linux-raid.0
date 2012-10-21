From: NeilBrown <neilb@suse.de>
Subject: Re: raid device gone underneath array
Date: Mon, 22 Oct 2012 09:19:21 +1100
Message-ID: <20121022091921.33f78a22@notabene.brown>
References: <CALFpzo4gLGzGWLRdVK7bZnYr3hbR7xOgn402UTP2_7UpRE8j6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ZNR8WAN15bjS=Q3_vE9VeCz"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CALFpzo4gLGzGWLRdVK7bZnYr3hbR7xOgn402UTP2_7UpRE8j6g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Marcus Sorensen <shadowsor@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/ZNR8WAN15bjS=Q3_vE9VeCz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 18 Oct 2012 18:01:34 -0600 Marcus Sorensen <shadowsor@gmail.com>
wrote:

> I've been using software raid to mirror two devices, and recently one
> of the drives went AWOL.
>=20
> md1 : active raid1 sdm[0] sdc[1](F)
>       12884900728 blocks super 1.2 [2/1] [U_]
>       bitmap: 1/96 pages [4KB], 65536KB chunk
>=20
> However, md1 froze, and in looking at the logs I saw this:
>=20
> Oct 18 17:47:48 sys kernel: md: cannot remove active disk sdc from md1 ...
> Oct 18 17:47:48 sys kernel: md: cannot remove active disk sdc from md1 ...
>=20
> [root(marcus)@sanmirror3-01 ~]# mdadm --manage /dev/md1 --remove /dev/sdc
> mdadm: cannot find /dev/sdc: No such file or directory
>=20
> /dev/sdc was already gone! The /sys/block was already removed, no
> reference to it in /proc/scsi/scsi. So md1 was destined to sit there
> forever. So I rebooted and started up the degraded array.

These messages imply that 'sdc' was sent a request and no reply has been
received.  Until the count of pending requests hits zero, md cannot
completely release sdc, and if it was a write - cannot reply to the request
that it received from a files system.

When a device fails or disappears the driver should ensure that all pending
requests fail - and return that failure status.  md depends on this.
So - assuming this status continued for more than a minute - it looks like a
bug with the driver for 'sdc'.

NeilBrown


>=20
> Using kernel 3.6.2 from kernel.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/ZNR8WAN15bjS=Q3_vE9VeCz
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUIR06Tnsnt1WYoG5AQIy0g//UtqqZQf1cINWTQx1rS182VwHipMh6wDo
/8Yr16TsB33tmmze+ckokmWmgVGg+3eaIQh3j8iBD1itPsjMTpcx8zNkkuQG9S90
k9RWPw/iVNz5R2lm7rlEc0Wu3tF6ibWVXbMQEMkh1TD3gz1wqQu5af764SpjN3eT
f5t1wTech3RTJ3wuK0XlVuo1Hi10R6FnvacptCT1gLSvWfoQ/69AG1xTaGf6Fqxq
Z3QEX8ODvt4wWiN9BLvjfrKq02jyaiqvEOJDIhrEm42V9O5UKipJ6ttt4k1vMwA2
BoDGu2OdTuWCMj6p0RXibgiWlSOJmMz02awD8xxkJ8pssFxbnoU5giPnTkScvwJX
3BtWM9dS917YgMvWfKHJoaowAQsJDhgGq9aWi7DKsf+xcBRqAZb07j2AqM2zwmfD
iiqLcYXnIyla17i+g49RIn9JzQe4/H2Zbhgvgzzngcn3b5JXP3Tijyyf98cooo3a
0pNfe6NAiuymQDtSz/B1UJGkJbuCVyewB7UqbCDYZm1xoPv1AuBCTEVaVHGYEfUz
UyDZN6YSGnxxqb9yeOcbfxOmAPts4w3ocwVx7yX76REgwTTXY4ejs92RpE9NAdu+
MTO+OyTGgPXR7UuhbGWgTOQdx/R2qnv8h2V+rJJ4bg13BKoZJXhidxMQ97JGZVW7
9C1sTnA6STc=
=VP6G
-----END PGP SIGNATURE-----

--Sig_/ZNR8WAN15bjS=Q3_vE9VeCz--
