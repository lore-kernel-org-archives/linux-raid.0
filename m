From: NeilBrown <neilb@suse.de>
Subject: Re: RAID-0/5/6 performances
Date: Fri, 6 Dec 2013 08:57:12 +1100
Message-ID: <20131206085712.0dfe8b6e@notabene.brown>
References: <20131205192454.GA5695@lazy.lzy>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/koZ4ncV7QhwEnl9KRdwVPuH"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131205192454.GA5695@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/koZ4ncV7QhwEnl9KRdwVPuH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 5 Dec 2013 20:24:54 +0100 Piergiorgio Sartor
<piergiorgio.sartor@nexgo.de> wrote:

> Hi all,
>=20
> I've a system, with an LSI 2308 SAS controller
> and 5 2.5" HDD attached.
> Each HDD can do around 100MB/sec read/write.
> This was tested will all HDDs in parallel, to
> make sure the controller can sustain them.
> Single disk has same performance.
>=20
> I was testing RAID 0/5/6 perfomances and I found
> something I could not clearly understand.
>=20
> The test was done with "dd", I wanted to know the
> maximum possible performance.
> Specifically, for reading:
>=20
> dd if=3D/dev/md127 of=3D/dev/null bs=3D4k
>=20
> For writing:
>=20
> dd if=3D/dev/zero of=3D/dev/md127 bs=3D4k conv=3Dfdatasync
>=20
> Note than large block size did not change the
> results. I guess the page size is quite optimal.
>=20
> I tested each RAID with 4 and 5 HDDs, with chunk
> size of 512k, 64k and 16k.
> The "stripe_cache_size" was set to the max 32768.
>=20
> The results were observed with "iostat -k 5",
> taking care to consider variations and ramp up.
>=20
> The table, with MB/sec, the number are the HDDs
> the "r" is read, "w" is write:
>=20
> chunk RAID 4r  4w  5r  5w
> 512k   0   400 400 500 500
> 512k   5   260 300 360 400
> 512k   6    55 180 100 290
>=20
>  64k   0   400 400 440 500
>  64k   5   150 300 160 400
>  64k   6   100 180 140 290
>=20
>  16k   0   380 400 350 500
>  16k   5   100 300 130 390
>  16k   6    80 180 100 290
>=20
> Now, RAID-0/5 seem to perform as expected,
> depending on the number of HDDs. Expecially
> with large chunk size.
> Write performances are not a problem, even
> if those are CPU intensive, with parity RAID.
> RAID-0/5 do not react well with small chunk.
> RAID-6, on the other hand, seems to have an
> idea of its own.
> First of all, it does not seem to respect
> proportionality. I would think a 4 HDDs
> RAID-6 should more or less read as fast as
> 2 HDDs. I can understand some loss, due to
> the parity skip, but not so much. In fact it
> improves with smaller chunk.
> With 5 HDDs, I would expect something better
> than 100MB/sec.
>=20
> Any idea on this? Am I doing something wrong?
> Some suggestion on tuning something in order
> to try to improve RAID-6?
>=20
> Thanks,
>=20
> bye,
>=20

Does look strange.
First thing I would check is the read-ahead size.
md sets it for you but might be messing up some how.
Have a look at=20
   /sys/block/mdX/bdi/read_ahead_kb
for each configuration and see if making it some uniform large number has a=
ny
effect.

NeilBrown

--Sig_/koZ4ncV7QhwEnl9KRdwVPuH
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUqD2uDnsnt1WYoG5AQKBtA/9FZSRX1EBM2WEoBcuwWJ9opph0oTkUH7x
bIw2a195Kdc/cufrBDdsJT6xw+0GS7F1PJWst3SHsjH0kLvMRqaQ/SHmOtNdeyUY
Wntb7B0fQhBpNl0zt9FJaHEkOmyNTC9rC272b7rMxPv75ZTddglQi3bkx/cdr5Eo
SkIW5/CK5/rBibcES9gw3saAlPLFOG5H9AhJIscJCSU7sdrrHE1/1R2WH+nEv/nd
PdNW/WbYcwdznLaDntpUkJ716tGVcXtk31gxi+H5OPctX9hF/mGxe6r1TmOItEDg
c7xMJgzTOd53a2LDQkbn+wY3DzqOa4OcAaxdHIZeL+ScLy7HfaEn3A9SFtxJVsge
sljcszu7b5jfzBdcBs6pKxejBcrvcITbuBd7Y8won+xMg0S5ECqta45tvkah1r+p
vGoO30M/2b2L1RCqTpQCeTCqLVtuzUzbWR/s0NS4M9qws6pSCj0nZsqM8Vu12vNr
/Gn1aNZSf2JhcqokXkP1zQihl9rN/J7NPK7chXPoULg9vQJIps7x9t0+Kj1UKxcX
ZQ4JhrQ6THc2uIFkxcoUdCGOeouetpjOImans5QQRJoaOjt5k/5PBuWJrxp7fztE
dwMJQrlUnRBVQB9rKWfAzaUk91a1o5LpBam1+QpzEh7MdH9g33D3qTYaLr98/tS7
Eg2U08Ya6PU=
=uYZh
-----END PGP SIGNATURE-----

--Sig_/koZ4ncV7QhwEnl9KRdwVPuH--
