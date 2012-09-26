From: NeilBrown <neilb@suse.de>
Subject: Re: bug: 4-disk md raid10 far2 can be assembled clean with only two
 disks, causing silent data corruption
Date: Wed, 26 Sep 2012 15:41:07 +1000
Message-ID: <20120926154107.1568a115@notabene.brown>
References: <50606207.7040804@gooseman.cz>
	<20120925141959.0c22de7d@notabene.brown>
	<alpine.DEB.2.00.1209250658250.13902@uplift.swm.pp.se>
	<152edbf7bdad33717477f174f94116b7@192.168.93.35>
	<20120925223227.130ef8e3@notabene.brown>
	<50628B39.90205@gooseman.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/U1=K5qw1bIOWAq8DzwAKxMd"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50628B39.90205@gooseman.cz>
Sender: linux-raid-owner@vger.kernel.org
To: Jakub =?ISO-8859-1?Q?Hus=E1k?= <jakub@gooseman.cz>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/U1=K5qw1bIOWAq8DzwAKxMd
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, 26 Sep 2012 06:57:29 +0200 Jakub Hus=E1k <jakub@gooseman.cz> wrote:

> On 25.9.2012 14:32, NeilBrown wrote:
> > On Tue, 25 Sep 2012 11:48:34 +0200 <jakub@gooseman.cz> wrote:
> >
> >>
> >> Would you please refer to some documentation that this behaviour is
> >> correct? I now tried to fail several disks in raid5, raid0 and raid10-=
near,
> >> in case of r0 and r10n, mdadm didn't even allow me to remove more disks
> >> than is sufficient to access all the data. In case of r5 I was able to=
 fail
> >> 2 out of 3, but the array was correctly marked as FAILED and couldn't =
be
> >> accessed at all. I'd expect that behaviour even in my case of raid10-f=
ar. I
> >> can't even assmenble and run it with less than required count of disks.
> >>
> > Could you please be explicit about exactly how the behaviour that you t=
hink
> > of as "correct" would differ from the current behaviour?  Because I can=
not
> > really see what point you are making - I need a little help.
> >
> > Thanks,
> > NeilBrown
> I think that when two adjacent drives fail, or the array is being=20
> assembled with two adjacent drives missing, the status wouldn't be=20
> "clean, degraded", the array "running"  and reporting some inaccessible=20
> blocks when you try to use it - as it happens in my case of R10F.
> Instead, the array status would be "FAILED " and won't be allowed to=20
> run. R0, R5, R10N behave in that manner (if i tested well), which I=20
> consider correct.
>=20
> The "degraded" status means, at lest for me, that the array is fully=20
> functional, only with limited redundancy.
> R10 with far2 layout and four disks can't be only "degraded" when any=20
> two disks are missing, unlike R10 near2 in some cases.
>=20
> If something is still not clear, please be patient, i'll try to squeeze=20
> maximum out of my torturous English ;)
>=20
> Thaks

Ahh.... I see it now.
There is a bug in the 'enough' function in mdadm and in drivers/md/raid10.c
It doesn't handle 'far' layouts properly.

I'll sort out some patches.

Thanks,
NeilBrown

--Sig_/U1=K5qw1bIOWAq8DzwAKxMd
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUGKVcznsnt1WYoG5AQIt9g/9GguePJ+8MtwkncxJZPe+Sikuhi5puHHW
YPH8t52vwFDYd9gFbq7fQLp+5vrbjKGw9gU/oZQ5f/eGI9pD83AtBI2R1zQd2VMb
LdW/wNsfvK4j0EpgyN5VE5Hl4pSHGGKtKqKA5Vs20xEYQ58WQMnpeLETI5j9tpqB
tMWowJf8ZcZwgt1vF84gQckqfxm/n/oZEqWvfzysuue4SQK5FsUTNacZcMwY0yzI
eJl1jrutnAZGNsim/evmZx82gKtxHzvq8PRYXV2/KzBL4Rnpr7F6BXv6IX5Z6+mK
8sAAZ4EEmaHnvbtil1gO0AyYGkNymGQufLqfDcsysVRonKFez010eqb0aSI0MOk5
rJyucBaReBmIXBK2iKCC1J4FggilRhEumdpKngI+LeZ/aMzQGJVqUf3YqdLIXYFv
72gcqSTDmjXCIWb2BEmR+7E3nR2y7zICuHglTYS0HPlzZX6hEec+xKTqUeoAQ1l1
2xQGwTPzc0MwbiW7o4JcI5ziUkl3THa+mU1DF4NkJXMZILFRX24xxdKNH/YClMmF
DPpIgIdFDgWiWWcjvQADFsTOU3QBMUhgLlg4fk03GOGm+RXg8s9zq2LgOROC91UX
vmvbBX+K6mCFRYP8ezsNQ05h1KGSg9ZLeSisQZfMm4nkOUIzNHjObOhEnQLIcCwi
0TqZKUYzpjY=
=nS81
-----END PGP SIGNATURE-----

--Sig_/U1=K5qw1bIOWAq8DzwAKxMd--
