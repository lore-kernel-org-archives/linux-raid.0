From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: with raid-6 any writes access all disks
Date: Thu, 27 Oct 2011 00:30:23 +0200
Message-ID: <4EA889FF.90002@zytor.com>
References: <CAGtzr3c65BXDfWZq4ejKwCZv7hPZmdCpvQP17RgFS-Vrn2YF5Q@mail.gmail.com> <20111027082331.01e1fc7a@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111027082331.01e1fc7a@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Chris Pearson <kermit4@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 10/26/2011 11:23 PM, NeilBrown wrote:
> On Wed, 26 Oct 2011 16:01:19 -0500 Chris Pearson
> <kermit4@gmail.com> wrote:
> 
>> In 2.6.39.1, any writes to a raid-6 array cause all disks to be 
>> accessed.  Though I don't understand the math behind raid-6, I
>> have tested on LSI cards that it is possible to only access 3
>> disks.
> 
> You are correct.  md/raid6 doesn't do the required maths.
> 
> i.e.  it always adds all data together to calculate the parity. It
> never subtracts old data from the parity, then add new data.
> 
> This was a decision made by the original implementer (hpa) and
> no-one has offered code to change it.
> 
> (yes, I review and accept patches :-)
> 

This was based on benchmarks at the time that indicated that
performance suffered more than it helped.  However, since then CPUs
have gotten much faster whereas disks haven't.  There was also the
issue of getting something working reliably first.

Getting a set of hardware acceleration routines for arbitrary GF
multiplies (as is possible with SSSE3) might change that tradeoff
dramatically.

	-hpa


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJOqIn1AAoJEL2gYIVJO6zkKX0QAKCNUaxXnA22+e/Xas2G1M2z
5EXKvMxJqFeDojGkQ5H0cFW+CoU5h93EY3WaVGWz9IW9fiWnMGaIoPszYcKzw3Hr
OkCyzytvLpeJK/sgPX3+/o2K8ZbNFWIJopdUnZivhWvPqyWFDwvquIv1Pgyj0RQc
74nPs03m4EV1zMrCgv34/JpQatiabBBSvMXzNs1kWLbQfUHr2SLMMGML02utakMb
w74FdBfLaZpWlXC+Lu3G6i97+Xv8LZ9+4Z5Iqj2jVf3JjriBLOT02nChuauJ1c5y
DL6vLmPedxJ3GTKUNb4fcwLOwDW1a1TqQl4QU+kytL25Ico1uXvXgjwgmO/JssfV
z26+NEPOeMfth7+f6tIIOKxnIYTrCvs3p5L66TJ3h7LaHg8M3f6wtq6nmXdavc5P
rwTdYKe5WlO3e8vooWExts+yWcjMufQA3gopkrLJF3gPFVYZaAlEeIIudxU11ofa
b+akxIvUSze7Dqvt6GmggIP+AaAwBGNSMMEYx7XyHJqFjm6rCaUjeo1eUmDUpVbX
o9rSQT3x8lgOs2yh9jNuBZtD1unXEbhXCK+nhB+UKMcKE43rxP+WztJNVG4Dkn6k
pjnO3MnivlrU3WjUlZ6tEzzoxsKbYr2oSzWBM8dKGFKg9eMr+v81sSfF9HETh2ia
lBcAujjR/lgnSpdKk93U
=GHON
-----END PGP SIGNATURE-----
