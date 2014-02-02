From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: Very long raid5 init/rebuild times
Date: Sun, 02 Feb 2014 13:53:57 -0500
Message-ID: <52EE9445.2020202@ubuntu.com>
References: <21217.9977.5869.747472@quad.stoffel.home> <20140121073540.GF10140@merlins.org> <20140121163755.GG10140@merlins.org> <52DF7976.6070808@hardwarefreak.com> <20140122174854.GF26014@merlins.org> <52E0807D.2030608@hardwarefreak.com> <20140123091319.GB2306@merlins.org> <52E10A07.3070302@hardwarefreak.com> <20140123210155.GJ10046@merlins.org> <52E1F685.3050300@hardwarefreak.com> <20140125083630.GA7555@merlins.org> <52E76054.5090900@hardwarefreak.com> <52EABA63.2060701@ubuntu.com> <52ED77A3.6020509@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52ED77A3.6020509@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com, Marc MERLIN <marc@merlins.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 02/01/2014 05:39 PM, Stan Hoeppner wrote:
> Phillip, you seem to be arguing application performance.  For an 
> application/data type that doesn't need fsync you'd be correct.
> 
> However, the purpose of this exchange has been to determine the
> maximum hardware throughput of the OP's array.  It's not possible
> to accurately measure IO throughput doing buffered writes.  Thus
> O_DIRECT is needed.

No, you can get there just fine with buffered IO as well, unless you
have an obscenely fast array and very slow ram, the overhead of
buffering won't really matter for IO throughput ( just the extra cpu ).


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBCgAGBQJS7pRFAAoJEI5FoCIzSKrw/5AH/2EUXwPjdaqKyg9oD5igX92p
VLLjCCDJyzd2MaC3u4DPpQUtzIXPEkjuKT6hBMNwx/+gFnODXQjssZ3siXVgc2Mi
JAGYwRWYbLDYQscKagYyQFDiNjg5b1zA/KEjKYTO5hpkFQELDgE115PPn6NhV/Q9
r/vjzEtvDLjuN5Y7uQDpZv87bEy2O7aJX1TFygPN0MazJo6O93yFfweUwI2JUm1H
q1DL96Evd/CCfzhPWiPnWrP4MpuUG7B1OKjwfXnlw5tW1tj7wRA6tRnyuCeAHCfb
1/wvxXm426rxflSNa85sP///amh8mnccN+4ZcOYEql4XSt8qh8G2sdH35Kp3og8=
=BnZb
-----END PGP SIGNATURE-----
