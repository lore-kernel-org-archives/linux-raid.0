From: NeilBrown <neilb@suse.de>
Subject: Re: md RAID with enterprise-class SATA or SAS drives
Date: Tue, 22 May 2012 09:34:04 +1000
Message-ID: <20120522093404.3ffaae42@notabene.brown>
References: <4FAAE8F1.8000600@pocock.com.au>
	<CALFpzo5ObdwFATdT4e20znnxzU5hX9SVSfqJcdqOXM1FEYJQuw@mail.gmail.com>
	<4FABC7C6.4030107@turmel.org>
	<4FAC2FF2.5060305@hardwarefreak.com>
	<4FAC40BC.1060300@hesbynett.no>
	<CABYL=ToORULrdhBVQk0K8zQqFYkOomY-wgG7PpnJnzP9u7iBnA@mail.gmail.com>
	<4FACBB68.2080304@hesbynett.no>
	<4FACCAC8.4020206@pocock.com.au>
	<4FAD9283.7020809@hardwarefreak.com>
	<CAGqmV7oJg8vwKPJEYJhPANzaN-xxVW6Lw2gLTEKmMfG=pqCHuA@mail.gmail.com>
	<4FBA8EA9.40203@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/hEX9BWtx8meC8vMnt_sG43V"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FBA8EA9.40203@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: CoolCold <coolthecold@gmail.com>, Daniel Pocock <daniel@pocock.com.au>, David Brown <david.brown@hesbynett.no>, Roberto Spadim <roberto@spadim.com.br>, Phil Turmel <philip@turmel.org>, Marcus Sorensen <shadowsor@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/hEX9BWtx8meC8vMnt_sG43V
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 21 May 2012 13:51:21 -0500 Stan Hoeppner <stan@hardwarefreak.com>
wrote:

> On 5/21/2012 10:20 AM, CoolCold wrote:
> > On Sat, May 12, 2012 at 2:28 AM, Stan Hoeppner <stan@hardwarefreak.com>=
 wrote:
> >> On 5/11/2012 3:16 AM, Daniel Pocock wrote:
> >>
> > [snip]
> >> That's the one scenario where I abhor using md raid, as I mentioned.  =
At
> >> least, a boot raid 1 pair.  Using layered md raid 1 + 0, or 1 + linear
> >> is a great solution for many workloads.  Ask me why I say raid 1 + 0
> >> instead of raid 10.
> > So, I'm asking - why?
>=20
> Neil pointed out quite some time ago that the md RAID 1/5/6/10 code runs
> as a single kernel thread.  Thus when running heavy IO workloads across
> many rust disks or a few SSDs, the md thread becomes CPU bound, as it
> can only execute on a single core, just as with any other single thread.

This is not the complete truth.

For RAID1 and RAID10, successful IO requests do not involved the kernel
thread, so the fact that there is only one should be irrelevant.
Failed requests are retried using the thread and it is also involved it
resync/recovery so those processes may be limited by the single thread.

RAID5/6 does not use the thread for read requests on a non-degraded array.
However all write requests go through the single thread so there could be
issues there.

Have you  actually measured md/raid10 being slower than raid0 over raid1?

I have a vague memory from when this came up before that there was some ext=
ra
issue that I was missing, but I cannot recall it just now....

NeilBrown


>=20
> This issue is becoming more relevant as folks move to the latest
> generation of server CPUs that trade clock speed for higher core count.
>  Imagine the surprise of the op who buys a dual socket box with 2x 16
> core AMD Interlagos 2.0GHz CPUs, 256GB RAM, and 32 SSDs in md RAID 10,
> only to find he can only get a tiny fraction of the SSD throughput.
> Upon investigation he finds a single md thread peaking one core while
> the rest are relatively idle but for the application itself.
>=20
> As I understand Neil's explanation, the md RAID 0 and linear code don't
> run as separate kernel threads, but merely pass offsets to the block
> layer, which is fully threaded.  Thus, by layering md RAID 0 over md
> RAID 1 pairs, the striping load is spread over all cores.  Same with
> linear, avoiding the single thread bottleneck.
>=20
> This layering can be done with any md RAID level, creating RAID50s and
> RAID60s, or concatenations of RAID5/6, as well as of RAID 10.
>=20
> And it shouldn't take anywhere near 32 modern SSDs to saturate a single
> 2GHz core with md RAID 10.  It's likely less than 8 SSDs, which yield
> ~400K IOPS, but I haven't done verufication testing myself at this point.
>=20


--Sig_/hEX9BWtx8meC8vMnt_sG43V
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT7rQ7Dnsnt1WYoG5AQLKPA//ZfrATT5pmt6X2aB2DBCEWdGNfq/aaCjr
sEMyZpUJblxO+U/bQcj+w7HvdViOdntuMu1wWSKM7P95MJ4knCrrJdMr5Uut3hLR
z8PjscWPoakoGdNTGDMecu9x3LuHcxJPjPvsc8lcrkXbg0yZvytKauPUxQWeTxax
8b7oO02bl+qc5Wc0izP3fuIvfvW3tnh1U7KKIQ77rzsL9PJr7NFEug0RuMhY6zG7
L6O08MaO0BE04mftD/BH65pI+zv45igkMQ9SRvHkjXlwZC0aoNlKj5xgRNlVb0yJ
bf3rzpBOK4hE8b9Z3LGoxI7D1BuYpH4/LkKSBoGoX/h/rrVakWA8qtF8bUc/hHsc
BmAskA+AsjdLkEgV1DndMEii/3EsktcSPCwpWw0n7FPm2pNMDKfsctrGEaZ8qmcp
m50Andl4VoLSbyWdywUPAgiCAx93AN4/iqnSqmJFUgEcx5QVG8uBN4Xm+/yR42xJ
YBYKyn5KCZdcgCatP5lH7uq4hjZVQJFms5oKJLdvLKJNuJq9rc9IjfKJqSjNudeD
kYOg7nAV/aDdrYV8Dw6bqCRuHbd9kkqqDg7jPwdAkBrcDUtj8V+q9dZgYHHEie9g
Ux7eV8YhrFVe3JBxpb+GyDQj3FmGRKPWQLBgG4AANUzY2mNd+YCUoLHbPDbEZHOY
tr3qm8qBuo8=
=5Eg0
-----END PGP SIGNATURE-----

--Sig_/hEX9BWtx8meC8vMnt_sG43V--
