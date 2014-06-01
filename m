From: NeilBrown <neilb@suse.de>
Subject: Re: [RFC] Process requests instead of bios to use a scheduler
Date: Mon, 2 Jun 2014 09:32:58 +1000
Message-ID: <20140602093258.22aa2c05@notabene.brown>
References: <5385DECE.5060507@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/kkuXPDsd_HotET_frxcqU_v"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5385DECE.5060507@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>, Florian-Ewald =?UTF-8?B?TcO8?= =?UTF-8?B?bGxlcg==?= <florian-ewald.mueller@profitbricks.com>
List-Id: linux-raid.ids

--Sig_/kkuXPDsd_HotET_frxcqU_v
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 28 May 2014 15:04:14 +0200 Sebastian Parschauer
<sebastian.riemer@profitbricks.com> wrote:

> Hi Neil,
>=20
> at ProfitBricks we use the raid0 driver stacked on top of raid1 to form
> a RAID-10. Above there is LVM and SCST/ib_srpt.

Any particular reason you don't use the raid10 driver?


>=20
> We've extended the md driver for our 3.4 based kernels to do full bio
> accounting (by adding ticks and in-flights). Then, we've extended it to
> use the request-by-request mode using blk_init_queue() and an
> md_request_function() selectable by a module parameter and extended
> mdadm. This way the block layer provides the accounting and the
> possibility to select a scheduler.
> With the ticks we maintain a latency statistic. This way we can compare
> both modes.
>=20
> My colleague Florian is in CC as he has been the main developer for this.
>=20
> We did some fio 2.1.7 tests with iodepth 64, posixaio, 10 LVs with 1M
> chunks sequential I/O and 10 LVs with 4K chunks sequential as well as
> random I/O - one fio call per device. After 60s all fio processes are
> killed.
> Test systems have four 1 TB Seagate Constellation HDDs in RAID-10. LVs
> are 20G in size each.
>=20
> The biggest issue in our cloud is unfairness leading to high latency,
> SRP timeouts and reconnects. This way we would need a scheduler for our
> raid0 device.

Having a scheduler for RAID0 doesn't make any sense to me.
RAID0 simply passes each request down to the appropriate underlying device.
That device then does its own scheduling.

Adding a scheduler may well make sense for RAID1 (the current "scheduler"
only does some read balancing and is rather simplistic) and for RAID4/5/6/1=
0.

But not for RAID0 .... was that a typo?


> The difference is tremendous when comparing the results of 4K random
> writes fighting against 1M sequential writes. With a scheduler the
> maximum write latency dropped from 10s to 1.6s. The other statistic
> values are number of bios for scheduler none and number of requests for
> other schedulers. First read, then write.
>=20
> Scheduler: none
> <      8 ms: 0 2139
> <     16 ms: 0 9451
> <     32 ms: 0 10277
> <     64 ms: 0 3586
> <    128 ms: 0 5169
> <    256 ms: 2 31688
> <    512 ms: 3 115360
> <   1024 ms: 2 283681
> <   2048 ms: 0 420918
> <   4096 ms: 0 10625
> <   8192 ms: 0 220
> <  16384 ms: 0 4
> <  32768 ms: 0 0
> <  65536 ms: 0 0
> >=3D 65536 ms: 0 0
>  maximum ms: 660 9920
>=20
> Scheduler: deadline
> <      8 ms: 2 435
> <     16 ms: 1 997
> <     32 ms: 0 1560
> <     64 ms: 0 4345
> <    128 ms: 1 11933
> <    256 ms: 2 46366
> <    512 ms: 0 182166
> <   1024 ms: 1 75903
> <   2048 ms: 0 146
> <   4096 ms: 0 0
> <   8192 ms: 0 0
> <  16384 ms: 0 0
> <  32768 ms: 0 0
> <  65536 ms: 0 0
> >=3D 65536 ms: 0 0
>  maximum ms: 640 1640

Could you do a graph?  I like graphs :-)
I can certainly seem something has changed here...

>=20
> We clone the bios from the request and put them into a bio list. The
> request is marked as in-flight and afterwards the bios are processed
> one-by-one the same way as with the other mode.
>=20
> Is it safe to do it like this with a scheduler?

I see nothing inherently wrong with the theory.  The details of the code are
much more important.

>=20
> Any concerns regarding the write-intent bitmap?

Only that it has to keep working.

>=20
> Do you have any other concerns?
>=20
> We can provide you with the full test results, the test scripts and also
> some code parts if you wish.

I'm not against improving the scheduling in various md raid levels, though
not RAID0 as I mentioned above.

Show me the code and I might be able to provide a more detailed opinion.

NeilBrown

--Sig_/kkuXPDsd_HotET_frxcqU_v
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU4u4Kjnsnt1WYoG5AQJseg//fEtsxqQwejsOx1W8HLWpYDZzKo7qkbgz
0DnX9JmcNl9IklbfMDOxaeIMbsbv8OtEoTibF5FbUkeeEZd3u+rgLPEhZct7wlXG
v/nFpgX30xLnylS4rHVTE/AFI+9xhBrX5iTH+fg+zJjIvjtoL+amA/jvSPcGYiQh
dLcAZC8NaD/B/G5vjgYDOeudSNXkkWcU5kMz/Q5KlKiy8ZpbTBsaQI1UL+URwjSe
Hw0CiQRBymAEVzTic1o1un87JgY91MlJJfk3I18AoIUAfJcd0Vsv9pw9W5YPxK/k
Gwrx1oMi4gvxzfSdv+49zqU7U/HYYecp+ey8Rdz6mibq4dYGuAvT8H9zCI0ENyPE
fnyGSHPEw8zdbd5KRrXCl4O+a5jV5NzOrzZ1H++QT908pxUFfo1gMPFBbw1Spc5m
AZWFbXOQqkICH6wR+myoMwfY5bUCh5wlEzJkmHvD5YZuwVQ690EN8Espa4ZeEtDb
UOit3VFfRIqDfTbRJmqHHgS32mlJUKwXqnvwuUG90W+JHGUAqmOoSVWqkHIdojkv
gCD6Nb/vTd1oSuCXBeWjYdGOS7yIjrdIgofYitYVjgP3BjvoXwz8pGzjDQnI15T/
bc58URQB2O0sBwJpPBgVkyf7vfjbGjZgcWWw4nJtq4Ees6oF44HUGHh/fhoMwgaG
y1HcJI9w5Fk=
=T9o4
-----END PGP SIGNATURE-----

--Sig_/kkuXPDsd_HotET_frxcqU_v--
