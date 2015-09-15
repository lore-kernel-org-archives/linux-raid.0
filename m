From: Neil Brown <neilb@suse.de>
Subject: Re: raid5-cache I/O path improvements V2
Date: Tue, 15 Sep 2015 09:23:44 +0200
Message-ID: <87a8so6t8f.fsf@notabene.neil.brown.name>
References: <1442038638-6947-1-git-send-email-hch@lst.de> <D21C6812.74CB%shli@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D21C6812.74CB%shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, Christoph Hellwig <hch@lst.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

Shaohua Li <shli@fb.com> writes:

> On 9/11/15, 11:17 PM, "Christoph Hellwig" <hch@lst.de> wrote:
>
>>Hi Shaohua, hi Neil,
>>
>>this series contains a few updates to the raid5-cache feature.
>>
>>The first patch just ports it to the post-4.2 block layer.  As part of
>>that
>>I noticed that it currently doesn't handle I/O errors - fixes for that
>>will
>>follow.
>>
>>The second and third patch simplify the I/O unit state machine and reduce
>>latency and memory usage for the I/O units.  The remainder are just a
>>couple
>>of cleanups in this area that I stumbled upon.
>>
>>Changes since V1:
>> - only use REQ_FUA if supported natively by the log device
>
> Hi Christoph,
>
> I finally got some data with a Samsung SSD, which supports fua. Controller
> is ahci.
> Test is a simple fio with all full stripe write.
>
> libata.fua=0, throughput 247m/s
> libata.fua=1, throughput 74m/s

Eek!  That's a big price to pay!

>
> fua is significantly slower. I think we need a sysfs config to enable fua.

I don't want a sysfs config if we can possibly avoid it.

Christoph's code sets FUA on every block written to the log, both data
and metadata.  Is that really what we want?

I don't know much of the hardware details, but wouldn't setting FUA and
FLUSH on the last block written be just as effective and possibly faster
(by giving more flexibility to lower layers)??

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJV98eAAAoJEDnsnt1WYoG5qSsP/1lz5gsAcu6uDq9QQ5PIvRxO
zsMrV1W+WSXkx0JPhyfkSPXPWNS+HcS8w0Q4i7NtNUdDb2YCi0FkQxiGVERKwJsm
7l84sl6whClhG1vOnq3sUyyJ44aIozLE4BEx3+DUx2oiDk09s7nrveVa6G/nGT7K
3mpkZlasO+q7MQhifdu9rxzlSDhSnVjtnjpR+Ga2jiKITBYCnBFM7jw7oyGFZ5bk
RUgJS7uBhvGlgcwYzvFZOtP4toM7mYvMb0AgV0f0QvxHs8BNaY98EUCYilzjY3ej
nVmcBAjXS5akR/yh/5mJj7Po9jVnfQ39D+f/pmJchpSP0qxhCjPpVP1k3yLBPXey
SAtErWIyhQvnJnW5qyr0edEeI+j+bXY29542yyLYDPrGBhA0hy/9OHCtiZF5nWD0
rdMSI6IFE4sZxsUwTuZlycdL65xSMW+CPNdFUKwCpSX55POTi7WThqbGrpZdJCDN
dHTHJcm/NMBWf4tVdKUVlrql9x1qwsc3QqqnelJ9i8gBGso0gTCjWr1Qa5fisjGY
s4bWN8EEPt/JmbUsI5hkclB7unMOZLb7QL51xqRFaVYEqKdBwYi5/NaRNdxxdQKf
G9Cnkm0pHOjbbHhxzr8TfqR/wks2uBcexN4aZYB3He4T3+6Z1LGsOaWhcNWYMoD3
/A2r4TogHrVYqxlndtln
=KO/g
-----END PGP SIGNATURE-----
--=-=-=--
