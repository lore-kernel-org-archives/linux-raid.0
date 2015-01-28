From: NeilBrown <neilb@suse.de>
Subject: Re: Monitor Queue Depth for RAID-5 md device
Date: Wed, 28 Jan 2015 11:03:21 +1100
Message-ID: <20150128110321.47c720b5@notabene.brown>
References: <CAB-428m9Za7Y3tdsrZ8Ck6wKg9T8S_03Ag25gu6rdsmaKxoNKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/AlV4_rQ/CtmSXdSOL/MfOWm"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAB-428m9Za7Y3tdsrZ8Ck6wKg9T8S_03Ag25gu6rdsmaKxoNKA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alireza Haghdoost <alireza@cs.umn.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/AlV4_rQ/CtmSXdSOL/MfOWm
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 25 Jan 2015 11:17:38 -0600 Alireza Haghdoost <alireza@cs.umn.edu>
wrote:

> Is there any way to monitor number of outstanding requests on the
> raid-5 md device ?

Depends on exactly what you mean...
You could look at /sys/block/mdXXX/md/stripe_cache_active.
That roughly corresponds to the number of requests that md/raid5 currently
has pending.


>=20
> I have a raid-5 array in /dev/md0 which contains /dev/sd[bcde] drives.
> However, I don't always see 0 in avgqu-sz field of iostat utility:

Did you mean "I DO always see 0".  md/raid5 doesn't use the queue that these
counts refer to.  It uses a very different queue.

>=20
>  # iostat -xk 1 /dev/md0
> Linux 3.13.0Write-Hole-Monitor (mist01-umh)     01/25/2015
> _x86_64_        (8 CPU)
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>            0.12    0.00    0.02    0.05    0.00   99.80
> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
> avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
> md0               0.00     0.00    0.00 15048.00     0.00 60192.00
> 8.00     0.00    0.00    0.00    0.00   0.00   0.00
>=20
> However, when I run iostats for actual devices (/dev/sd[bcde]) I can
> see the queue depth. This is also true for some other fields like
> %util:
>=20
> # iostat -xk 1 /dev/sd[bcde]
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>            0.40    0.00   15.44    0.00    0.00   84.17
> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
> avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
> sdb            9463.00  9057.00  385.00  352.00 39304.00 37480.00
> 208.37     3.04    4.12    3.46    4.84   1.28  94.40
> sde            8966.00  9592.00  355.00  376.00 37196.00 39388.00
> 209.53     2.88    3.93    3.37    4.46   1.27  93.20
> sdd            9467.00  9098.00  374.00  361.00 39364.00 37516.00
> 209.20     2.75    3.73    3.38    4.09   1.25  92.00
> sdc            9171.00  9339.00  368.00  369.00 38160.00 38512.00
> 208.07     3.21    4.34    3.76    4.92   1.27  93.60
>=20
> In this example, there are 209 or 208 requests pending on the queue of
> each device. Can I say that there is like 209 requests is pending on
> the queue in the /dev/md0 device too ? In other word, take the maximum
> value of the backend device queue depth as a queue depth of md device
> ?

You can say that if you like.  It might even mean something.

Why is this important to you?  What are you really trying to find out?

NeilBrown



>=20
> Thanks
> Alireza
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/AlV4_rQ/CtmSXdSOL/MfOWm
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVMgnSTnsnt1WYoG5AQIgvg/9FrG5jkGhzQ5XPKpmVGOS+fUiq3lwto0S
43sUDKyWG7GA02Tp+xVm/ZuPiu2OaapcXcDKyoxEbsCIEEEjCUSJJF7KLV/Ty21u
XsjByqZlNTGXZWwHOLpcYn0Ja2R1Tv5TwifVlXJosXw+3Fg+sZG5N8h+l2Y0Gegr
XTBKEuJiyCPbgHPVzj4D1x1dMKbtECFH7eeLYv2my8VVC1pc2jgYZ9C+J3Or5FGC
5fPqGwZY0c5qBQ0mz8kftiQopQdAKITxmtDOAQRN1yF5bsqloEWcshF5WFL5gOEh
ExUNXRi4VILFCPXgySRVnTxvN4L77gFYk3F5mHzmhEjzV0onHo7xPx07t8QGbHL7
Nzx+S5AMWcGZuNNS15JTpbb/zPUT2a/7mFOq7HKRHlaXefcpwClVFGyeWgrXY040
aiVrRaMU5HpKdmaWQ3tN80lTxuioCg5djKU92J9nQTEAaDAnRvMRcha8FvGMpk3s
tWbU1teb1GUxwDsjAUJl2WjdG2QQzhlYNPq/ta9ViBBjDTyO4FLEbTocdNivPRke
yqBiLG7TsXkKM8zkqkkmHLFCmhNHa31PxV5krMhbm+fXsF21z2m66RsQB1B3tzgC
WhnCzhPDEUTrmb4Y/70HSeb9g6No8wi4Y+ae2/38KuCwsrNFy9NKECfhUe/mW7/e
qomHyhNML2Q=
=XG3p
-----END PGP SIGNATURE-----

--Sig_/AlV4_rQ/CtmSXdSOL/MfOWm--
