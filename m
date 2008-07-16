From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: Benchmarks: Linux Kernel RAID vs a Hardware RAID setup
Date: Tue, 15 Jul 2008 19:20:27 -0500
Message-ID: <cccedfc60807151720x62cdbb3cx2c772ac884f97fde@mail.gmail.com>
References: <1216130769.5633.318.camel@sam.localdomain>
	 <20080715163932.GA23164@rap.rap.dk>
	 <8CAB4B2168C7183-B68-AD2@webmail-ng19.sysops.aol.com>
	 <20080715173927.GA24745@rap.rap.dk> <487D3A44.7000008@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <487D3A44.7000008@sauce.co.nz>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>, thomas62186218@aol.com, monkeyiq@users.sourceforge.net, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jul 15, 2008 at 7:01 PM, Richard Scobie <richard@sauce.co.nz> w=
rote:
> Keld J=F8rn Simonsen wrote:
>
>> I would actually welcome more tests with specific user profiles, lik=
e
>> many small reads and writes for database  use, and concurrent random
>> reading and writing to simulate the load on a server. What bonnie++ =
is
>> reporting is only equential IO. This is important on work stations, =
but
>> actually not on servers.
>
> The following is from the Bonnie++ man page:
>
> "There  are  two  sections  to the program's operations. The first is=
 to
> test the IO throughput in a fashion that is designed to  simulate  so=
me
> types of database applications. The second is to test creation, readi=
ng and
> deleting many small files in a fashion similar to the usage patterns =
of
> programs such as Squid or INN."
>
> So I guess the author thinks it's valid for more than sequential I/O.
>
> In any case, while we may be in a minority, Justin, I and a few other=
s are
> interested in sequential I/O, as we build servers required to read an=
d write
> multiple streams of uncompressed SD and HD video in realtime.

In that case, the 'fstest' program (google for it, it's associated
with the samba folks IIRC), might be just the ticket.
You specify the number of children (real children, not threads), the
number of files each child will open, populate, verify, and then
delete, the size of the files, and a few other options. It very nicely
simulates a set of totally greedy I/O intensive processes.


--=20
Jon
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
