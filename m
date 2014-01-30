From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: Very long raid5 init/rebuild times
Date: Thu, 30 Jan 2014 15:47:31 -0500
Message-ID: <52EABA63.2060701@ubuntu.com>
References: <21217.9977.5869.747472@quad.stoffel.home> <20140121073540.GF10140@merlins.org> <20140121163755.GG10140@merlins.org> <52DF7976.6070808@hardwarefreak.com> <20140122174854.GF26014@merlins.org> <52E0807D.2030608@hardwarefreak.com> <20140123091319.GB2306@merlins.org> <52E10A07.3070302@hardwarefreak.com> <20140123210155.GJ10046@merlins.org> <52E1F685.3050300@hardwarefreak.com> <20140125083630.GA7555@merlins.org> <52E76054.5090900@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52E76054.5090900@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com, Marc MERLIN <marc@merlins.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 1/28/2014 2:46 AM, Stan Hoeppner wrote:
> You usually must submit asynchronously or in parallel to reach 
> maximum throughput. Being limited by a PMP it may not matter. But 
> with your direct connected drives of your production array you
> should see a substantial increase in throughput with parallel
> submission.

Not for streaming IO; you just need to make sure your cache is big
enough so the drive is never waiting for the app.

> To significantly increase single streaming throughput you need AIO.
> A faster CPU won't make any difference.  Neither will a better SATA
> card, unless your current one is defective, or limits port
> throughput will more than one port active--I've heard of couple
> that do so.

What AIO gets you is the ability to use O_DIRECT to avoid a memory
copy to/from the kernel page cache.  That saves you some cpu time, but
doesn't make *that* much difference unless you have a crazy fast
storage array, or crazy slow ram.  And since almost nobody uses it,
it's a bit of an unrealistic benchmark.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJS6rpiAAoJEI5FoCIzSKrw6oMH/jDcFOs8Gu2wjbbuE1eoGtG7
aHeUvF6klWWV5VWCVBd4tHieVkj1zyg3nQa3DGaOvqBnz6mtIQUx6Pg5MgYkJAhD
EY1f3zVH+hxBEyJwwmMIDIyVsDCbdsryKndfPuYolaqNSgXLyWpAcL6g/SM9vjoG
nH29w1GC3TJP5Py1DNP4P04Q+kJMTYnY/4AFJOtsMRK5XRpno784YZauS/basEH3
rpSf/JvhcZMbk6nE8jkqIYnMbA35E8f+GfSa60epqDSSM3hU5U1xYnh6vCZSSndK
pMCFv26O9AVoFdyPZTJwM32gqGXdsGkDanK2+0y/j2im5IT0PxKCWO+uCLO/1mQ=
=9NYg
-----END PGP SIGNATURE-----
