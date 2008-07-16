From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Benchmarks: Linux Kernel RAID vs a Hardware RAID setup
Date: Wed, 16 Jul 2008 12:01:08 +1200
Message-ID: <487D3A44.7000008@sauce.co.nz>
References: <1216130769.5633.318.camel@sam.localdomain> <20080715163932.GA23164@rap.rap.dk> <8CAB4B2168C7183-B68-AD2@webmail-ng19.sysops.aol.com> <20080715173927.GA24745@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080715173927.GA24745@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: thomas62186218@aol.com, monkeyiq@users.sourceforge.net, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Keld J=F8rn Simonsen wrote:

> I would actually welcome more tests with specific user profiles, like
> many small reads and writes for database  use, and concurrent random
> reading and writing to simulate the load on a server. What bonnie++ i=
s
> reporting is only equential IO. This is important on work stations, b=
ut
> actually not on servers.

The following is from the Bonnie++ man page:

"There  are  two  sections  to the program's operations. The first is t=
o=20
test the IO throughput in a fashion that is designed to  simulate  some=
=20
types of database applications. The second is to test creation, reading=
=20
and deleting many small files in a fashion similar to the usage pattern=
s=20
of programs such as Squid or INN."

So I guess the author thinks it's valid for more than sequential I/O.

In any case, while we may be in a minority, Justin, I and a few others=20
are interested in sequential I/O, as we build servers required to read=20
and write multiple streams of uncompressed SD and HD video in realtime.

Regards,

Richard
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
