From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: Benchmarks: Linux Kernel RAID vs a Hardware RAID setup
Date: Wed, 16 Jul 2008 06:23:36 +0200
Message-ID: <20080716042336.GB7148@rap.rap.dk>
References: <1216130769.5633.318.camel@sam.localdomain> <20080715163932.GA23164@rap.rap.dk> <8CAB4B2168C7183-B68-AD2@webmail-ng19.sysops.aol.com> <20080715173927.GA24745@rap.rap.dk> <487D3A44.7000008@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <487D3A44.7000008@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: thomas62186218@aol.com, monkeyiq@users.sourceforge.net, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jul 16, 2008 at 12:01:08PM +1200, Richard Scobie wrote:
> Keld J=F8rn Simonsen wrote:
>=20
> >I would actually welcome more tests with specific user profiles, lik=
e
> >many small reads and writes for database  use, and concurrent random
> >reading and writing to simulate the load on a server. What bonnie++ =
is
> >reporting is only equential IO. This is important on work stations, =
but
> >actually not on servers.
>=20
> The following is from the Bonnie++ man page:
>=20
> "There  are  two  sections  to the program's operations. The first is=
 to=20
> test the IO throughput in a fashion that is designed to  simulate  so=
me=20
> types of database applications. The second is to test creation, readi=
ng=20
> and deleting many small files in a fashion similar to the usage patte=
rns=20
> of programs such as Squid or INN."
>=20
> So I guess the author thinks it's valid for more than sequential I/O.

Yes, there are tests in bonnie++ to address some of it. Such as rewrite
end deletes etc.

My understanding tho, is that the IO output and input figures are on
sequential IO. There are no figures on random IO,

> In any case, while we may be in a minority, Justin, I and a few other=
s=20
> are interested in sequential I/O, as we build servers required to rea=
d=20
> and write multiple streams of uncompressed SD and HD video in realtim=
e.

I think this is random IO, that is, a number of users reading
sequentiallly a number of files at the same time. I have similar use,
running a ftp site, and also a video site.

best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
