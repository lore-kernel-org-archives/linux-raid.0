From: NeilBrown <neilb@suse.com>
Subject: Re: on assembly and recovery of a hardware RAID
Date: Wed, 15 Mar 2017 13:56:13 +1100
Message-ID: <87d1djdz8y.fsf@notabene.neil.brown.name>
References: <CAAZLhTdaVM4fagN5=bqWpPx-DjyU6UZ69bJFf51FWMX7oeyJNw@mail.gmail.com> <87tw6weubu.fsf@notabene.neil.brown.name> <CAAZLhTcEhn2GezDSDJHOLv2VNSynzT-he0FRrVNbz1xtakLsMQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAZLhTcEhn2GezDSDJHOLv2VNSynzT-he0FRrVNbz1xtakLsMQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alfred Matthews <asm13243546@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Tue, Mar 14 2017, Alfred Matthews wrote:

>> Does
>>   dmraid -b /dev/sda /dev/sdb /dev/sdc
>> tell you anything useful?
>>
>
> # dmraid -b /dev/sdb /dev/sdc
> /dev/sdc:   5860533168 total, "WD-WCAWZ2927144"
> /dev/sdb:   5860533168 total, "WD-WCAWZ2939730"


No, not useful.

Your other output also doesn't show anything interesting.
I had another look at the lsdrv output you showed before and I'm
wondering if there really is anything "hardware RAID" here at all.

Both drives (sdb and sdc) are partitioned into a 200MB EFI partition, a
2.75TB hfsplus (Apple file system) / unknown partition, and a 128M
hfsplus boot partition.

Maybe the two 2.75TB paritions were raided together.
sdc looks like the "first" device if this were the case.
Try:

  mdadm --build /dev/md0 --level=0 -n2 --chunk=512M /dev/sdc2 /dev/sdb2

Then try fsck.hfs of hpfsck ... in the "hfsplus" package on Debian.
 hpfsck /dev/md0
maybe.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljIrU0ACgkQOeye3VZi
gblc9Q//XXVHEaR7xpfufi4p2eWNZUXm2HPy0i4hGWuwr5T5+3Nru3HEdVzdqhmO
iwOlv+I4kOtpymFQ526OgjdgXRPggOcrJsx7Qd35ZECfqWVpGScsz9fm6+aTAaOC
Ejr7FK0XvLzs7wm8YS4Tef+N4Cae/FtDy0QmHGuN7o1dBHUxDfQTEWifst+tykps
oafp2ErMfPp00joRP7/5jTiKrghdEceQCGhDaP97FPTRRgJmfmwyLQvl4ffBswKk
W/aDGZ4j8OLk2SGtI9JA1R6v7PLH+4WBJmGZkiE9WfofDEo9twb1/tPUw4Z6OS4R
Tjg4Z9v8WVHumqc9EkF8YqS5BMSkmuQvPQWxRGgWp+I+zWppEPO6ks8UnmVezXsv
CtM18bqDl+3ZD71/HSbM1ms2AS60VQiRBctblEiWKx5rHD2k0tGV88d42cl7RoBf
JY28A1HPV39phXbHmISSiIrwGBfXZdYe/fZBcSof4MK/47BZSRiXm7H8Fb/x6Bp4
K0MrVVpVo+0ohYMPzpuou1uIezRWj/ZUMCaDegs34CQM31W2okvn+zkXCIFP/WEt
UQeHiAJw+vb+vDTM3qOvIbBtc6ng0q6d+CaXDTgrU0jN1WumZ7UfG86In2PznDdr
G5mad9DzMAuKFPGii1LRj/wKmRZXBDuizbz/KMeMmvDesp5Fnl0=
=5HN6
-----END PGP SIGNATURE-----
--=-=-=--
