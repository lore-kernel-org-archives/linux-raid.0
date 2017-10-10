From: NeilBrown <neilb@suse.com>
Subject: Re: hung grow
Date: Wed, 11 Oct 2017 07:47:02 +1100
Message-ID: <874lr6ybll.fsf@notabene.neil.brown.name>
References: <CADg2FGbgdgHWbaJN94p36-SUjfDEKNi2VYuyHXJN1pDJ9Kdg7w@mail.gmail.com> <89992d1f-172f-9fc6-3a1e-50df34e11d3b@turmel.org> <CADg2FGaPFTNLuQPussL=YFDCRndRDFX99D-KjnWfD93MqGJXmg@mail.gmail.com> <CADg2FGZNs9KmkKGvbCf-dwsqxYN5ftJd5v7RTJ1M=rLP=v6wJg@mail.gmail.com> <CADg2FGa5iUGVqVvy5MrJf00fCqH4NEVXrODPHS6Dc=jsrBx2PQ@mail.gmail.com> <87po9xyv0r.fsf@notabene.neil.brown.name> <CADg2FGaeuptaWRnM5+Z_aAR08vG-311s8p6OrBwZUNeCrNGu1g@mail.gmail.com> <87d15xymgc.fsf@notabene.neil.brown.name> <CADg2FGbzr_JcrGfvU6kpGc_5vJ=+L2gXx3PcfpOTsst8BeNA-Q@mail.gmail.com> <CADg2FGaFt4_4UHPUSnY8tr=LeJMKKojR_QrPE-YoXvWmgXXZxQ@mail.gmail.com> <0d4987d9-e8ff-0cdb-6e45-7f962b75c189@turmel.org> <3e5766b0-1437-2857-4806-264386d1633f@youngman.org.uk> <6d4b7055-c26c-951e-b63c-273a7fe447b8@turmel.org> <CADg2FGad+Tpu-4
 Z4rx1Kx_U1Tw64nQ_FqGuPRn5ODV=_pYFuDw@mail.gmail.com> <e8dce17e-d231-0004-e9a1-511abacfcfda@turmel.org> <CADg2FGZ-=VP2Q++qkKqfQ06zeBho1TR3=biqbdxT7-4pMCcLLQ@mail.gmail.com> <5a3fb3ec-299a-67c9-9d1c-e
 f28ca2164dd@turmel.org> <CADg2FGYQti9hFAqtRMEH8B-i4kwJJ3fYRdrRauD5F3OSZ_Q0vw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADg2FGYQti9hFAqtRMEH8B-i4kwJJ3fYRdrRauD5F3OSZ_Q0vw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Curt <lightspd@gmail.com>, Phil Turmel <philip@turmel.org>
Cc: Anthony Youngman <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Tue, Oct 10 2017, Curt wrote:

>>
>> Just --freeze-reshape, not --update.
>>
> Ok, here's the output
> mdadm --detail /dev/md127
> /dev/md127:
>            Version : 0.91
>      Creation Time : Fri Jun 15 15:52:05 2012
>         Raid Level : raid6
>         Array Size : 9767519360 (9315.03 GiB 10001.94 GB)
>      Used Dev Size : 1953503872 (1863.01 GiB 2000.39 GB)
>       Raid Devices : 8
>      Total Devices : 6
>    Preferred Minor : 127
>        Persistence : Superblock is persistent
>
>        Update Time : Tue Oct 10 15:11:26 2017
>              State : clean, FAILED, reshaping
>     Active Devices : 5
>    Working Devices : 6
>     Failed Devices : 0
>      Spare Devices : 1
>
>             Layout : left-symmetric
>         Chunk Size : 64K
>
> Consistency Policy : unknown
>
>     Reshape Status : 0% complete
>      Delta Devices : 1, (7->8)
>
>               UUID : 714a612d:9bd35197:36c91ae3:c168144d
>             Events : 0.11559682
>
>     Number   Major   Minor   RaidDevice State
>        0       8       97        0      active sync   /dev/sdg1
>        1       8       49        1      active sync   /dev/sdd1
>        2       8       33        2      active sync   /dev/sdc1
>        3       8        1        3      active sync   /dev/sda1
>        4      65      145        4      active sync   /dev/sdz1
>        -       0        0        5      removed
>        6       8       16        6      spare rebuilding   /dev/sdb
>        -       0        0        7      removed
>
> But in my dmesg, I'm seeing task md127_reshape blocked for 120
> seconds, and when I cat sync_action, it shows reshape.  Which
> shouldn't it be frozen or something like that?  Also md127_raid6 task
> is using 100% cpu.  I was going to paste the assemble output, but hit
> clear instead of copy.  It didn't show any errors I saw, just starting
> with 6 drives. reshape isn't using any cpu
>
> If I do a cat of /proc/pid/stack, all I get is
> [<ffffffffffffffff>] 0xffffffffffffffff
>
> Should I just let it run?

Clearly a kernel bug.
What kernel are you using?  Can you try a newer one easily?

Can you please
  mkdir /tmp/dump
  mdadm --dump=/dev/dump /dev...list.all.devices.in.the.array
  tar czf --sparse /tmp/dump.tgz /tmp/dump

and send me /tmp/dump.tgz.  It will only contains the metadata.
I can then create an identical looking array and experiment.

I doubt if letting it run will bring benefits.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlndMcYACgkQOeye3VZi
gbk3fxAAlbITHHexO1SAbnwzoLHN/Xq4M0IT4RqYVM9HbXeaSUCY0ObgG8DkrCF7
q0lE7ClB2oOjD9JYsry806Po5JgU5DEAM58gnCzSYuEceSm81bl/Qv1gXrh85goL
ix4+KiGYQ7pLQaSbSKl7DSVtX/Z0sIQLqU0sVeqPa2RPydOSGK0ok3nJn7pPzeN/
xhwQQ7orgtznYUGMFjawcNodgEXcLz7OD30fM/kC8Wd80wCac3Q2xbLiRo24Qr2R
RYq4hx0ow95eDi6w3TC4MgLlzVzRm9kUUojz+ySZA3QJjFG48MFHXP6NdfkXX1m1
Jv98QzvAbcwwQtIFF11aVG0UqDPo2Xkn1q4F1kC/RuyGA7yFuN/kXAgfQ74pJMHn
6h+7o/VQHWuoUKB0jKGJ5jg2r4EsKTkOEXEHjb8PvZcP27GNGaZiSSz3ssikJpK4
xwJ8mjVoM+UU/6MkZUxFAly5DeOwhCHPQUqE/B6VQ1TNpNLqzGRYHP5dSq8HKpwo
PS7pb3W/pnTIwzuLVQ+Q3v6erLDnnjX4p4CU19QyYa6rG9yeTT0ggqhxYh9sVveR
dGp+Mgjq4EGtetZ7W3Xl4gvlrDFD/LArMEEKrirhRpRA5TdSgb/uPSNxVw1md1OX
taNubMR/KYyvmI0ZD/DoKqZZKgyaCc+WNnKaeBeuQ0scNdLxLJI=
=hHOP
-----END PGP SIGNATURE-----
--=-=-=--
