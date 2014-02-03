From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: Very long raid5 init/rebuild times
Date: Mon, 03 Feb 2014 09:42:22 -0500
Message-ID: <52EFAACE.40906@ubuntu.com>
References: <21217.9977.5869.747472@quad.stoffel.home> <20140121073540.GF10140@merlins.org> <20140121163755.GG10140@merlins.org> <52DF7976.6070808@hardwarefreak.com> <20140122174854.GF26014@merlins.org> <52E0807D.2030608@hardwarefreak.com> <20140123091319.GB2306@merlins.org> <52E10A07.3070302@hardwarefreak.com> <20140123210155.GJ10046@merlins.org> <52E1F685.3050300@hardwarefreak.com> <20140125083630.GA7555@merlins.org> <52E76054.5090900@hardwarefreak.com> <52EABA63.2060701@ubuntu.com> <52ED77A3.6020509@hardwarefreak.com> <52EE9445.2020202@ubuntu.com> <52EF3865.4000106@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52EF3865.4000106@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com, Marc MERLIN <marc@merlins.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 2/3/2014 1:34 AM, Stan Hoeppner wrote:
> Please reread my statement above.  Now let me restate that as:
> 
> Measuring disk throughput when writing through the buffer cache
> isn't a measurement of disk throughput as much as it is a
> measurement of cache throughput.  Thus, such measurements do not
> demonstrate actual disk throughput.
> 
> Do you disagree?

Yes, I do because cache throughput is >>>> disk throughput.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJS76rMAAoJEI5FoCIzSKrw+1oH/1xdPTZwoaw4MKQrwQV22sgM
zu1BXTs1+/wEjyxJdwr9Rpa6W/aLlaMYmoriNWVXG+MLm2aemrGq4nHD5i3GhESU
T1R65IY92fVPqCAYNUjYQftGryYcZjWxiNurHI4/Tt0BH4hPn0Ol34xwuTE7/mg7
ozn7mzqYFxJltomRjtARuXulJz4DW5p0tKjsgBRnqAqXyywU/bEC5fpb0xuqhNWK
xm4asE9FPJxCxV8QuqQUwehU+IAQ3ObqgDIsdcCX0wSZurDQCbPBfbW2OuYpSBSd
QOrjulMciutBxIyejA1OC20z9DEPhoWfJEn2HSUrMEMgpvuz/+q7ybBkCcHDs5Y=
=4ti3
-----END PGP SIGNATURE-----
