From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: Why 4k native drives haven't arrived
Date: Wed, 22 Jan 2014 21:19:34 -0500
Message-ID: <52E07C36.5080109@ubuntu.com>
References: <52C61807.6050906@hardwarefreak.com> <CANBHLUjceX=NOqwdWWSGS3w=GrJaVt1OvH0PMrgQ5Ce30O+Smg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANBHLUjceX=NOqwdWWSGS3w=GrJaVt1OvH0PMrgQ5Ce30O+Smg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dimitri John Ledkov <xnox@debian.org>, stan@hardwarefreak.com
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 01/03/2014 06:27 AM, Dimitri John Ledkov wrote:
> And even if one would buy a 4k native drive, i would have thought 
> there'd be other obstacles in trying it out e.g. not having a SATA 
> port =) considering it was created two years after Windows XP =)
> or since a 4k native drive is likely to be 2TB+ in size, GPT
> support is required to address the whole drive...

Actually, 4k native drives can use MBR up to 16 TB.  The limitation on
the MBR partition table is 32 bits to address sectors, so larger
sectors => higher addressable size.  Some of the fakeraid controllers
on the market take advantage of this fact and report a 1k or 2k
physical sector size to allow MBR partitioning on larger arrays.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBCgAGBQJS4Hw2AAoJEI5FoCIzSKrwX5YH/joOvhkO9wHpZOgbCfPhTvzC
Zax4nNuv9m0jAHzx+D0jqWzq/maf6ju0Xu3Sc49Iyy1ZfCeNXe64KrLnXyF2He9W
TMMqDoAe0pIqdSxMtLr/1G/kJa1pxIcaoYvtc2val3MPxz/dw32XFk60fyBBSGYC
n5f2Hs1TB4H0uo1gE4ywtN+fLtAQoqhZpHYIb0rS26zdwMJ3ho3qKwJeONy4FkhQ
pKh4TTJBBMKe/Iz4v4+5RP+yq3Jlx860c+CMHq8amtGHPiBmGBL4WpE6lul/MHGn
WBBv0g/VNd5M7K9Q/g01sIIRwyFisEImMmvamC9ctsUlcFzMEtkRfRyM1C+2SfU=
=bHlp
-----END PGP SIGNATURE-----
