From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: Very long raid5 init/rebuild times
Date: Thu, 30 Jan 2014 15:18:37 -0500
Message-ID: <52EAB39D.9040107@ubuntu.com>
References: <20140121073540.GF10140@merlins.org> <20140121163755.GG10140@merlins.org> <52DF7976.6070808@hardwarefreak.com> <20140122174854.GF26014@merlins.org> <52E0807D.2030608@hardwarefreak.com> <20140123091319.GB2306@merlins.org> <52E10A07.3070302@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52E10A07.3070302@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com, Marc MERLIN <marc@merlins.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 1/23/2014 7:24 AM, Stan Hoeppner wrote:
> Increasing stripe_cache_size above the default as I suggested will 
> ALWAYS increase write speed, often by a factor of 2-3x or more on
> modern hardware.  It should speed up destructive resyncs
> considerably, as well as normal write IO.  Once your array has
> settled down after the inits and resyncs and what not, run some
> parallel FIO write tests with the default of 256 and then with
> 2048.  You can try 4096 as well, but with 5 rusty drives 4096 will
> probably cause a slight tailing off of throughput.  2048 should be
> your sweet spot.  You can also just time a few large parallel file
> copies.  You'll be amazed at the gains.

I have never seen it make a difference on destructive syncs on 3 or 4
disk raid5 arrays and when you think about it, that makes perfect
sense.  The point of the cache is to coalesce small random writes into
full stripes so you don't have to do a RMW cycle, so for streaming IO,
it isn't going to do a thing.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJS6rOcAAoJEI5FoCIzSKrwz0YIAJMJG6C0aePvKfXJlQy1mmbp
AaFHQX8MgIgj3kgiNj8s83uWEdVZfzaQpcc3oJcB0PD2FTHxt+204e8C2wZz0b5N
4zZim1YRec67LTRkLwNeko5HrkiapmWf0FYmx95d3gNvb0UGUbh98hRItgSX78NS
Lu+afQWOLCqiv3UjMHpG4Blb37oT0cp2pttuGKbDZTS4OSgd/qWRvcQ5sRQ09338
n40EiCWaIIlWlSQJ0r6GUylTOiys+JziB+qcHK6SvK+9gF3VdYN955GXNKxMn7t1
A3rFbeVsC0MSRcMytVmMk3cFQDn+xhZ1ZvHvkbLagj9i0uLcC+1cR6KIeScdQC4=
=iFoR
-----END PGP SIGNATURE-----
