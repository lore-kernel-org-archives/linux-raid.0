From: Philip Hands <phil@hands.com>
Subject: Re: RAID1 seems not to be able to scrub pending sectors shown by smart
Date: Fri, 23 Dec 2011 21:22:56 +0000
Message-ID: <878vm32dan.fsf@poker.hands.com>
References: <87hb0r2kvq.fsf@poker.hands.com> <CAAMCDedN7nBrt7nLoUq2v26ZoX21ab+htowc3r2A=nOAvfF42A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAMCDedN7nBrt7nLoUq2v26ZoX21ab+htowc3r2A=nOAvfF42A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roger Heflin <rogerheflin@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Fri, 23 Dec 2011 13:59:21 -0600, Roger Heflin <rogerheflin@gmail.com> wr=
ote:
> On Fri, Dec 23, 2011 at 12:39 PM, Philip Hands <phil@hands.com> wrote:
...
> I had 4 1.5tb seagate drives from 2009 (bought at different times in
> 2009) and 3 of those 4 started getting lots of bad sector all within a
> 2 month period and all 3 finally officially failed smart.and when the
> sectors (one after another...lucky they failed out aover 2-3 weeks so
> I had got the replacements in before I lost data-I was down to no
> redundancy for several days in the middle) were failing and being
> rewritten the performance was just ugly--so even if raid1 was
> rewriting the drives it does not do anything for performance when the
> drives are going bad...the only thing that solved my performance was
> getting all of the failing devices to finally fail smart so they could
> be RMAed and replaced at minimal cost..

Well, I suppose that's to some extent the reason I mentioned this.

It seems to me that if a disk is throwing _loads_ of read errors, and
running dreadfully slowly, one could react to that by favouring
different disk(s), and only occasionally throwing a read at the duff
disk, until it either sorts itself out or dies.

My performance went from rubbish to fine simply by removing the
360-pending-sector disk from the RAID.  OK, so if the problem is that
writes are being delayed by the dodgy disk, that's not easy to deal
with, but looking at the logs makes it look like the reads quite often
keep targeting the same disk even when several reads just failed and
got redirected.  This seems suboptimal to me.

Cheers, Phil.
=2D-=20
|)|  Philip Hands [+44 (0)20 8530 9560]    http://www.hands.com/
|-|  HANDS.COM Ltd.                    http://www.uk.debian.org/
|(|  10 Onslow Gardens, South Woodford, London  E18 1NE  ENGLAND

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBCgAGBQJO9PEwAAoJENBLo6ABJdXABSkQALze6D7Rb2UJN5/iUs3S3AUG
Qaa46QFHxtjQFscQPNgyw5rMQVPXmFn1mSUUkojx1AQTMN9cXjDyCqrxJeiQnHqL
HOmsCZ32M/blvAT7VEpe3L+Bz9CCSAPubMVxgzBCEnnHJUO/yiYzxsOhv/1ZxZyd
a0Hn8c5IYVx5J/pUTvfHYDh5Pq/tZaj6tSkjnFvQhqYeoRc6dLVO4+9DgR+5/JNL
W+EAb8vHKKrzhC2vizmaJePgNIl+g2hnXpxCCFw9PeWo8ErDe+oHFKTvAtmN82Us
nVAnPSRRGhaIV2g921z+9Ah8g+PI/gVJw31JozEnUcbSZxoiEVvFVPe3fjV3UBSL
ICosR1mpmJ4btfwgS/2W1mv2LFtw3FuIWmqZvCAoPmROC3nrzzH1LRCSed7nsQ60
fZFN0kEmXNOqsQ/KhORlE1EVwjfQ60BTh9rNv4HxPTlTb0UYaQkem33GsN96QI7V
q8jfSJCdpzAE1sMG4v/VH4xjRqrRneK0oUHaa1EIa8bnRmzgur9uw1OVRrkpQ8s2
dCU1PHU8KqfVj8FkuNpiZHS+FGyMhzqKJvAtYGRSqxCGiH5iiNOVbfgIhJ0Jn9/r
hO1MXDu/AeHVlUhDAIuPfbVvbuv3AudiN+M/BXStpzgmb8xU9zSdI9Ku/NtQklqj
EkYwUFJyeg6m94PzDlTL
=oR2k
-----END PGP SIGNATURE-----
--=-=-=--
