From: NeilBrown <neilb@suse.com>
Subject: Re: RAID6 rebuild oddity
Date: Wed, 29 Mar 2017 15:08:00 +1100
Message-ID: <87zig467z3.fsf@notabene.neil.brown.name>
References: <9eb215dd-437e-ac62-c4df-f3307d8fc4b4@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9eb215dd-437e-ac62-c4df-f3307d8fc4b4@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 24 2017, Brad Campbell wrote:

> I'm in the process of setting up a new little array. 8 x 6TB drives in a=
=20
> RAID6. While I have the luxury of a long burn in period I've been=20
> beating it up and have seen some odd performance anomalies.
>
> I have one in front of me now, so I thought I'd lay out the data and see=
=20
> if anyone has any ideas as to what might be going on.
>
> Here's the current state. I did this by removing and adding /dev/sdb=20
> without a write intent bitmap to deliberately cause a rebuild.
>
> /dev/md0:
>          Version : 1.2
>    Creation Time : Wed Mar 22 14:01:41 2017
>       Raid Level : raid6
>       Array Size : 35162348160 (33533.43 GiB 36006.24 GB)
>    Used Dev Size : 5860391360 (5588.90 GiB 6001.04 GB)
>     Raid Devices : 8
>    Total Devices : 8
>      Persistence : Superblock is persistent
>
>      Update Time : Fri Mar 24 15:34:28 2017
>            State : clean, degraded, recovering
>   Active Devices : 7
> Working Devices : 8
>   Failed Devices : 0
>    Spare Devices : 1
>
>           Layout : left-symmetric
>       Chunk Size : 64K
>
>   Rebuild Status : 0% complete
>
>             Name : test:0  (local to host test)
>             UUID : 93a09ba7:f159e9f5:7c478f16:6ca8858e
>           Events : 394
>
>      Number   Major   Minor   RaidDevice State
>         8       8       16        0      spare rebuilding   /dev/sdb
>         1       8       32        1      active sync   /dev/sdc
>         2       8       48        2      active sync   /dev/sdd
>         3       8       64        3      active sync   /dev/sde
>         4       8       80        4      active sync   /dev/sdf
>         5       8       96        5      active sync   /dev/sdg
>         6       8      128        6      active sync   /dev/sdi
>         7       8      144        7      active sync   /dev/sdj
>
>
> Here's the iostat output (hope it doesn't wrap).
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>             0.05    0.00   10.42    7.85    0.00   81.68
>
> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s=20
> avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
> sda               0.00     1.60    0.00    1.40     0.00     8.80=20
> 12.57     0.02   12.86    0.00   12.86  12.86   1.80
> sdb               0.00 18835.60    0.00  657.80     0.00 90082.40=20
> 273.89     3.72    4.71    0.00    4.71   0.85  55.80
> sdc           20685.80     0.00  244.20    0.00 87659.20     0.00=20
> 717.93     8.65   34.10   34.10    0.00   2.15  52.40
> sdd           20664.60     0.00  244.60    0.00 87652.00     0.00=20
> 716.70     8.72   34.28   34.28    0.00   2.19  53.60
> sde           20647.80     0.00  240.40    0.00 87556.80     0.00=20
> 728.43     9.13   36.54   36.54    0.00   2.30  55.40
> sdf           20622.40     0.00  242.40    0.00 87556.80     0.00=20
> 722.42     8.73   34.60   34.60    0.00   2.20  53.40
> sdg           20596.00     0.00  239.20    0.00 87556.80     0.00=20
> 732.08     9.32   37.54   37.54    0.00   2.37  56.60
> sdh               0.00     1.60    0.00    1.40     0.00     8.80=20
> 12.57     0.01    7.14    0.00    7.14   7.14   1.00
> sdi           20575.80     0.00  238.20    0.00 86999.20     0.00=20
> 730.47     8.53   34.06   34.06    0.00   2.20  52.40
> sdj           22860.80     0.00  475.80    0.00 101773.60     0.00=20
> 427.80   245.09  513.25  513.25    0.00   2.10 100.00
> md1               0.00     0.00    0.00    0.00     0.00     0.00=20
> 0.00     0.00    0.00    0.00    0.00   0.00   0.00
> md2               0.00     0.00    0.00    2.00     0.00     8.00=20
> 8.00     0.00    0.00    0.00    0.00   0.00   0.00
> md0               0.00     0.00    0.00    0.00     0.00     0.00=20
> 0.00     0.00    0.00    0.00    0.00   0.00   0.00
>
> The long and short is /dev/sdj is the last drive in the array, and is=20
> getting hit with a completely different read pattern to the other=20
> drives, causing it to bottleneck the rebuild process.

sdj is getting twice the utilization of the others but only about 10%
more rKB/sec.  That suggests lots of seeking.

Does "fuser /dev/sdj" report anything funny?

Is there filesystem IO happening? If so, what filesystem?
Have you told the filesystem about the RAID layout?
Maybe the filesystem keeps reading some index blocks that are always on
the same drive.

>
> I *thought* the rebuild process was "read one stripe, calculate the=20
> missing bit and write it out to the drive being rebuilt".

Yep, that is what it does.


>
> I've seen this behaviour now a number of times, but this is the first=20
> time I've been able to reliably reproduce it. Of course it takes about=20
> 20 hours to complete the rebuild, so it's a slow diagnostic process.
>
> I've set the stripe cache size to 8192. Didn't make a dent.
>
> The bottleneck drive seems to change depending on the load. I've seen it=
=20
> happen simply dd'ing the array to /dev/null where the transfer rate=20
> slows to < 150MB/s. Stop and restart the transfer and it's back up to=20
> 500MB/s.

So the problem moves from drive to drive?  Strongly suggests filesystem
metadata access to me.

>
> I've reproduced this on kernel 4.6.4 & 4.10.5, so I'm not sure what is=20
> going on at the moment. There is obviously a sub-optimal read pattern=20
> getting fed to sdj. I had a look at it with blocktrace, but went cross=20
> eyed trying to figure out what was going on.

If you can capture several seconds of trace on all drives plus the
array, compress it and host it somewhere, I can pick it up and have
look.

NeilBrown

>
> The drives are all on individual lanes on a SAS controller, are set with=
=20
> the deadline scheduler and I can get about 160MB/s sustained from all=20
> drives simultaneously using dd.
>
> It's not important, but I thought since I was seeing it and I have a=20
> month or so of extra time with this array before it needs to do useful=20
> work, I'd ask.
>
> Regards,
> Brad
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljbMyEACgkQOeye3VZi
gbn7PQ/+JhkY3JzKijHfmMUZ7s6z8TSW6tbYLBes05YpFqTh8azpV5UEotpySOSV
+t4bKU4Pusv3sco/eFHaulQg6RpCp/Z10numP+PlfpXM5POC8bilxLO300bafjFu
XWm8KVAEjo8p2uJ0YnnS6n9vIcX5cx0N3WvXWUAsmyPVnrq53A3R9e2/p/X64Lst
HQ2D874CVASpi6M84HoPYAB4XBgY8dq9NBYDhMcRKSn/meXsj/6iurr62754A/Op
V4Ocoq3nP7sjf23Zxr/QHL9peHXMEO9Z0u7uEPwbOYG3ZXGTKTupV2+LZAs+hxQO
ySGo4zBL4HLnIRGueg8tWFm/gN6UH9sqsxwF1asI7h30feUbRc0YdRT1mIMuteNq
NPdC1BZAreL0Onp3gT8lPiVuTht9KIN+6+MMEWqkBgoNRg/o/ahkXCFmjhD4s68v
S7JYzburY1ZiGSxpz/LBebMNvnpJb4EiOxBe2FHezyRkVYfOTVnFo/UvXXFCessK
wZoA5lgf6WwOtp3yarRWLsZu9umqmqWUAvPqGdnUOA+D/dscY2yXlm81CgeJt1K8
D0uzqDAaix+ZgB8wH5iUPlLBQ/VFY1LmWX6J1VqFhs8RIes97Nw65J9fSVFpSHvA
TOEcSqhIQxSBVedXbH5FNkE5xvEP6f+3vGp0VaS1gtFyyHe7BgY=
=w4b7
-----END PGP SIGNATURE-----
--=-=-=--
