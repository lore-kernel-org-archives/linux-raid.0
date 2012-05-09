From: NeilBrown <neilb@suse.de>
Subject: Re: Another RAID-5 problem
Date: Thu, 10 May 2012 08:58:32 +1000
Message-ID: <20120510085832.1bb1acfa@notabene.brown>
References: <1931403540.986928.1336565853409.JavaMail.ngmail@webmail08.arcor-online.net>
	<20120509193119.GA10724@lazy.lzy>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/zuOxLYuN+8O6YQC21zv/Otx"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120509193119.GA10724@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/zuOxLYuN+8O6YQC21zv/Otx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 9 May 2012 21:31:19 +0200 Piergiorgio Sartor
<piergiorgio.sartor@nexgo.de> wrote:


> Actually, we solved this issue in a "creative" way.
>=20
> Looking at:
>=20
> https://raid.wiki.kernel.org/index.php/RAID_superblock_formats
>=20
> we identify the proper address and look-up way for the
> component order and, using "od -Ax -tx4 /dev/sdXi | less"
> we were able to understand the device order.
> For the fresh men, please note that address 0xA0 has
> the device number and this is a pointer added to 0x100,
> where the device role is stored.
> While at 0xA0 are stored 4 bytes int, at 0x100 are
> stored 2 bytes int (short int), so the "-tx4" of "od"
> swaps (due to CPU endianess) each pair of short int,
> so the order will be 1 0 3 2 5 4 ...
> If "-tx2" is used, than the 0x100 will be correct,
> but 0xA0 will have bytes swapped pair wise.

Well done!!

>=20
> Fortunately, the superblock seemed OK for the data.
> Other information, like raid level, was completely
> wiped out...
>=20
> The only itch left is the data offset.
> We plan to try to use mdadm 2.6.7.1 (which originally
> created the array) using Ubuntu 10.10 desktop (live).
>=20
> Still, I would like to know about backing up the
> first few MB of each component with "dd" and about
> switching to read only, in order to avoid damage
> by LVM/mount.

Takes a backup of the first few MB certainly wouldn't hurt, and might help =
if
something goes terribly wrong. (Just as long as you don't restore a backup =
to
the wrong device :-)

Yes, starting in --readonly mode, or switching to --readonly mode after you
have started the array, is probably a good idea.
Some filesystems sometimes try to write even if the device is marked as
read-only (e.g. they try to replay the journal).  If that happen md will BUG
and machine will crash, which might be better than corrupting data.

NeilBrown


--Sig_/zuOxLYuN+8O6YQC21zv/Otx
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT6r2mDnsnt1WYoG5AQJ1YxAApO4CPV5DckKGmDAdzmZxdtDTkj/Oxn/k
tszFqhMnvK0yYmMsHwmX/TxKhCFj6cVeghTUZfQS3MJUpnMIkvZspPwi7JzbcXM1
rr3+D03kF+3lCv2JSYWXPSuK8unc4NrwZCmkjKMl/SgCoJSqQCHtOeh8drphG285
wSD/n4QI9hesQu7FYKqgsWy9Vgk4QhAeIezmu0mTCZrsOg9EDYcossg6zOXhbc2P
OPruWolo0ghCasQnBgyoZpYC56RaAix3/VJyOA6AMzs9mq2tLfvt6vLa17yFMke9
E3HthK8t4A7LcD/4NGDTEBEZJJ76ZaEbTcROKqaq26MxD57ItcLpb9+dOHhgXPEh
0fhSlV/OD40VKhc1QTMYJ5pgJbK6p2xnohS/klxU15nguqcWxFSI/tQcIEaxXy7b
/m5GzVzfehRiifiZsnhFzQUNI2/WQne59Ueyp7ha1veHwuIA8d8wmyIQLQLarg8C
qLq7eP4nwg2hBkjNi7fksng0V3pCJbFFi1wVVzYQshQqKHmPmacYDG6W0f10O5bW
AUDXuKE6BpW1Ne3WF1ee8ZTGs8VZoZAsgnCEQnwCiW7ju09hPKDqG7IVXpCAAieu
NviGej+C4R6euCMZuyy5h2vZ3zo4xQSsITdrD+5L8aI4nSOOkhvuXl91hY2jO5/1
dQ41dT7g/lc=
=kY5s
-----END PGP SIGNATURE-----

--Sig_/zuOxLYuN+8O6YQC21zv/Otx--
