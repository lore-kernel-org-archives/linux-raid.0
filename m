From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: The chunk size paradox
Date: Thu, 02 Jan 2014 19:19:51 -0500
Message-ID: <52C60227.7040809@ubuntu.com>
References: <52C1C01A.7010407@ubuntu.com> <52C57C7B.80400@shiftmail.org> <52C588A7.6010207@hardwarefreak.com> <52C59468.6080200@ubuntu.com> <52C5A9AA.9090300@hardwarefreak.com> <52C5BC28.2020003@gmail.com> <52C5EB62.1090807@hardwarefreak.com> <52C5EE8F.3090204@aei.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52C5EE8F.3090204@aei.mpg.de>
Sender: linux-raid-owner@vger.kernel.org
To: Carsten Aulbert <Carsten.Aulbert@aei.mpg.de>, stan@hardwarefreak.com
Cc: Joe Landman <joe.landman@gmail.com>, joystick <joystick@shiftmail.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 01/02/2014 05:56 PM, Carsten Aulbert wrote:
> Why would one need to align to 4k if the on disk layout would be
> 512bytes?
> 
> Or did I miss something?

Because they are providing 512 byte sector emulation on top of 4k
physical sectors.  If they were pure 4k sectors, there would be no
need for special alignment.  I believe that all WD drives do this, but
I've seen a few people report that some seagate drives skip the 512
emulation.  For that matter I have a first generation WD "Green" AF
drive that I am retiring because it has been throwing uncorrectable
errors but not reallocating on write, and often having no problem
reading those sectors later.  That drive isn't even nice enough to
report that its really using 4k physical sectors ( despite my requests
for them to fix this firmware bug, they never released an updated
firmware ), though my new blue drives do at least indicate they are 4k
physical.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBCgAGBQJSxgInAAoJEI5FoCIzSKrwW1kH/2+2rdIm3ZE4TB2eyjDP3HQO
OGHlr+BhIPIrATeEjZA+7EnTog8Xk36Pis4zPrCWUGZ5rVjVQnMR0lWmoeOGGjyR
xAcX/g60ia1sqKUQaTmGevzRYfIycglW3wALSTu0mm2i6EaGm4BSl+cZruPAKPxl
iBoNKyagIQccWtKxLH+6tCPpCqFRDnXg3PFQ0+K49CxUoh9Nb1Sk1FkPEjuMz5YF
zENlt1WHNaG4ZcKtgLVAZZLDnjt3kdFxDwOWNIU/CEr2qUQ3hXyaSAp9b/MjeBfb
9S+PdjB67ZEBOLPY0CUA4Im/ixu/B4AT91uCVRL69yqasW3i4jX6St2UjdcPkDw=
=U9uU
-----END PGP SIGNATURE-----
