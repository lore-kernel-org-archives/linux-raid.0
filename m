Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 200B0C4338F
	for <linux-raid@archiver.kernel.org>; Fri, 30 Jul 2021 14:04:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 047B960F4B
	for <linux-raid@archiver.kernel.org>; Fri, 30 Jul 2021 14:04:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239127AbhG3OES (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 30 Jul 2021 10:04:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42145 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239137AbhG3OEP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Fri, 30 Jul 2021 10:04:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627653850;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z1Pc6Zj3lawvPSw8quTMgdkxFCkPh2Ccmo/F2yPWTpY=;
        b=O+EOg1850rj+xuqX0yneZaE+/uOFUngfwRoLDP+83tx6x3b+W7o6ZebPdANOW2EJQhO0EQ
        loREopK0aY9RJ6a3IPglFHGl1SPqLOhK229KfOgscSuR/s5eZqey72BKi6QCDBL+0XkVva
        c45RP1KM9i+1U3wVc16JyjB/AZTQ2Ao=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-Eaa2gjuRO3O5WvDxaTS1Yg-1; Fri, 30 Jul 2021 10:04:08 -0400
X-MC-Unique: Eaa2gjuRO3O5WvDxaTS1Yg-1
Received: by mail-ej1-f71.google.com with SMTP id q19-20020a170906b293b029058a1e75c819so3113078ejz.16
        for <linux-raid@vger.kernel.org>; Fri, 30 Jul 2021 07:04:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=z1Pc6Zj3lawvPSw8quTMgdkxFCkPh2Ccmo/F2yPWTpY=;
        b=jIevIF+fyp85ZLr1fg+3N1xq+RYmil/sR6cavXWlIuGgg0w5H1gu+hdChOjqq8NvgE
         PmtBzEL1GRRaLiJJTrOsOXAKfLaLfe6b18OH6cdyCSfk7YHfe+BqjiA4J2636rOfN9bg
         AocgAjshc1Sfm09ANr2g4ZZT8MbQJ+QqkFvmnN/DbEGrrAUk38DqUfhovzlbqtOAXs6Q
         TJKZLHSYvWTqCxtL8NfU3SKAPNAlGZ3+YQzflAsF2ujsLN8DZNEGm2WJDRsw0Ah4eP8s
         1kPDL0lYjYG9lPCmU5ZmN6LoNAxxYSjC1VxOT/hPGXxHi21pxZaOi6rk3WcWGSt9AZ/h
         cdhQ==
X-Gm-Message-State: AOAM532PbS/msoPAfjgeQs0LMGnVkLYkRIkkGl5U5MkOBgdENDk/Xj1C
        ENsJuRLDjjvmi0qAcvyD5DU0dl3Wvc5EDpA24U4LV1H56RV5vlwUvLx6j7mR8QGF3U9tlc8+ce7
        vgxpbO7DSmtlGis9qOijkiRLvbZTcNwtK9nG30Q==
X-Received: by 2002:a17:906:839a:: with SMTP id p26mr2709047ejx.547.1627653847023;
        Fri, 30 Jul 2021 07:04:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx+LQGqOlougmwxdVYMJJ6OgWo2woDBHts1hIwI9q8gfFnGX8sCyvrPfo10uwuMMVcMdvFsYexq76yy6KRDYFs=
X-Received: by 2002:a17:906:839a:: with SMTP id p26mr2709024ejx.547.1627653846751;
 Fri, 30 Jul 2021 07:04:06 -0700 (PDT)
MIME-Version: 1.0
References: <5EAED86C53DED2479E3E145969315A2385841062@UMECHPA7B.easf.csd.disa.mil>
 <07195088-7E4B-4586-BB45-04890265BD62@madmonks.org> <5EAED86C53DED2479E3E145969315A23858411D1@UMECHPA7B.easf.csd.disa.mil>
 <21187A73-4000-4017-B016-15C03D19B799@madmonks.org> <5EAED86C53DED2479E3E145969315A23858415CB@UMECHPA7B.easf.csd.disa.mil>
 <EF5FF3B7-927D-44E5-89CE-CEB86BB225FF@madmonks.org> <CD53203D-6A23-40F8-9FD4-A60019F67B37@gmail.com>
 <5EAED86C53DED2479E3E145969315A2385841727@UMECHPA7B.easf.csd.disa.mil>
In-Reply-To: <5EAED86C53DED2479E3E145969315A2385841727@UMECHPA7B.easf.csd.disa.mil>
From:   Doug Ledford <dledford@redhat.com>
Date:   Fri, 30 Jul 2021 10:03:25 -0400
Message-ID: <CAGbH50v1P4LvEpyBvAq5OHrxXMc06X=SCH6CyrzzAZqpeEUv9A@mail.gmail.com>
Subject: Re: [Non-DoD Source] Can't get RAID5/RAID6 NVMe randomread IOPS - AMD
 ROME what am I missing?????
To:     "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>
Cc:     Miao Wang <shankerwangmiao@gmail.com>,
        Matt Wallis <mattw@madmonks.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

You can try btrfs in lieu of zfs.  As long as metadata is raid1, data
can be raid5/6 and things are ok.  The raid5 write issue only applies
to metadata.

On Fri, Jul 30, 2021 at 6:09 AM Finlayson, James M CIV (USA)
<james.m.finlayson4.civ@mail.mil> wrote:
>
> There is interest in ZFS.   We're waiting for the direct I/O patches to s=
ettle in Open ZFS because we couldn't find any way to get around the ARC (e=
verything has to touch the ARC).  ZFS spins an entire CPU core or more worr=
ying about which ARC entries it has to evict.      I know who is doing the =
work.   Once it settles, I'll see if they are willing to publish to zfs-dis=
cuss.
>
> -----Original Message-----
> From: Miao Wang <shankerwangmiao@gmail.com>
> Sent: Friday, July 30, 2021 4:46 AM
> To: Finlayson, James M CIV (USA) <james.m.finlayson4.civ@mail.mil>
> Cc: Matt Wallis <mattw@madmonks.org>; linux-raid@vger.kernel.org
> Subject: Re: [Non-DoD Source] Can't get RAID5/RAID6 NVMe randomread IOPS =
- AMD ROME what am I missing?????
>
> Hi Jim,
>
> Nice to hear about your findings on how to let linux md work better on fa=
st nvme drives, because previously I was also stuck in a similar problem an=
d finally gave up. Since it is very difficult to find such environment with=
 so many fast nvme drives, I wonder if you have any interest in ZFS. Maybe =
you can set up a similar raidz configuration on those drives and see whethe=
r its performance is better or worse.
>
> Cheers,
>
> Miao Wang
>
> > 2021=E5=B9=B407=E6=9C=8830=E6=97=A5 16:28=EF=BC=8CMatt Wallis <mattw@ma=
dmonks.org> =E5=86=99=E9=81=93=EF=BC=9A
> >
> > Hi Jim,
> >
> > That=E2=80=99s significantly better than I expected, I need to see if I=
 can get someone to send me the box I was using so I can spend some more ti=
me on it.
> >
> > Good luck with the rest of it, the bit I was looking for as a next step=
 was going to be potentially tweaking stripe widths and the like to see how=
 much difference it made on different workloads.
> >
> > Matt.
> >
> >> On 30 Jul 2021, at 08:05, Finlayson, James M CIV (USA) <james.m.finlay=
son4.civ@mail.mil> wrote:
> >>
> >> Matt,
> >> Thank you for the tip.   I have put 32 partitions on each of my NVMe d=
rives, made 32 raid5 stripes and then made an LVM from the 32 raid5 stripes=
.   I then created one physical volume per 10 NVMe drives on each socket.  =
  I believe I have successfully harnessed "alien technology" (inside joke) =
to create a Frankenstein's monster.   These are substantially better than d=
oing a RAID0 stripe over the partitioned md's in the past.  I whipped all o=
f this together in two 15 minute sessions last night and just right now, so=
 I might run some more extensive tests when I have the cycles.   I didn't i=
ntend to leave the thread hanging.
> >> BLUF -  fio detailed output below.....
> >> 9 drives per socket raw
> >> socket0, 9 drives, raw 4K random reads 13.6M IOPS , socket1 9 drives,
> >> raw 4K random reads , 12.3M IOPS
> >> %Cpu(s):  4.4 us, 25.6 sy,  0.0 ni, 56.7 id,  0.0 wa, 13.1 hi,  0.2
> >> si,  0.0 st
> >>
> >> 9 data drives per socket RAID5/LVM raw (9+1) socket0, 9 drives, raw
> >> 4K random reads 8.57M IOPS , socket1 9 drives, raw 4K random reads ,
> >> 8.57M IOPS
> >> %Cpu(s):  7.0 us, 22.3 sy,  0.0 ni, 58.4 id,  0.0 wa, 12.1 hi,  0.2
> >> si,  0.0 st
> >>
> >>
> >> All,
> >> I intend to test the 4.15 kernel patch next week.   My SA would prefer=
 if the patch has made it into the kernel-ml stream yet, so he could instal=
l an rpm, but I'll get him to build the kernel if need be.
> >> If the 4.15 kernel patch doesn't alleviate the issues, I have a strong=
 desire to have mdraid made better.
> >>
> >>
> >> Quick fio results:
> >> socket0: (g=3D0): rw=3Drandread, bs=3D(R) 4096B-4096B, (W) 4096B-4096B=
, (T)
> >> 4096B-4096B, ioengine=3Dlibaio, iodepth=3D128 ...
> >> socket1: (g=3D1): rw=3Drandread, bs=3D(R) 4096B-4096B, (W) 4096B-4096B=
, (T)
> >> 4096B-4096B, ioengine=3Dlibaio, iodepth=3D128 ...
> >> socket0-lv: (g=3D2): rw=3Drandread, bs=3D(R) 4096B-4096B, (W) 4096B-40=
96B,
> >> (T) 4096B-4096B, ioengine=3Dlibaio, iodepth=3D128 ...
> >> socket1-lv: (g=3D3): rw=3Drandread, bs=3D(R) 4096B-4096B, (W) 4096B-40=
96B,
> >> (T) 4096B-4096B, ioengine=3Dlibaio, iodepth=3D128 ...
> >> fio-3.26
> >> Starting 256 processes
> >>
> >> socket0: (groupid=3D0, jobs=3D64): err=3D 0: pid=3D64032: Thu Jul 29 2=
1:48:32
> >> 2021
> >> read: IOPS=3D13.6M, BW=3D51.7GiB/s (55.6GB/s)(3105GiB/60003msec)
> >>   slat (nsec): min=3D1292, max=3D1376.7k, avg=3D2545.32, stdev=3D2696.=
74
> >>   clat (usec): min=3D36, max=3D71580, avg=3D600.68, stdev=3D361.36
> >>    lat (usec): min=3D38, max=3D71616, avg=3D603.30, stdev=3D361.38
> >>   clat percentiles (usec):
> >>    |  1.00th=3D[  169],  5.00th=3D[  231], 10.00th=3D[  277], 20.00th=
=3D[  347],
> >>    | 30.00th=3D[  404], 40.00th=3D[  457], 50.00th=3D[  519], 60.00th=
=3D[  594],
> >>    | 70.00th=3D[  676], 80.00th=3D[  791], 90.00th=3D[  996], 95.00th=
=3D[ 1205],
> >>    | 99.00th=3D[ 1909], 99.50th=3D[ 2409], 99.90th=3D[ 3556], 99.95th=
=3D[ 3884],
> >>    | 99.99th=3D[ 5538]
> >>  bw (  MiB/s): min=3D39960, max=3D56660, per=3D20.94%, avg=3D53040.69,=
 stdev=3D49.61, samples=3D7488
> >>  iops        : min=3D10229946, max=3D14504941, avg=3D13578391.80, stde=
v=3D12699.61, samples=3D7488
> >> lat (usec)   : 50=3D0.01%, 100=3D0.01%, 250=3D6.83%, 500=3D40.06%, 750=
=3D29.92%
> >> lat (usec)   : 1000=3D13.42%
> >> lat (msec)   : 2=3D8.91%, 4=3D0.82%, 10=3D0.04%, 20=3D0.01%, 50=3D0.01=
%
> >> lat (msec)   : 100=3D0.01%
> >> cpu          : usr=3D14.82%, sys=3D46.57%, ctx=3D35564249, majf=3D0, m=
inf=3D9754
> >> IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, 32=
=3D0.1%, >=3D64=3D100.0%
> >>    submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 6=
4=3D0.0%, >=3D64=3D0.0%
> >>    complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 6=
4=3D0.0%, >=3D64=3D0.1%
> >>    issued rwts: total=3D813909201,0,0,0 short=3D0,0,0,0 dropped=3D0,0,=
0,0
> >>    latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D1=
28
> >> socket1: (groupid=3D1, jobs=3D64): err=3D 0: pid=3D64096: Thu Jul 29 2=
1:48:32
> >> 2021
> >> read: IOPS=3D12.3M, BW=3D46.9GiB/s (50.3GB/s)(2812GiB/60003msec)
> >>   slat (nsec): min=3D1292, max=3D1672.2k, avg=3D2672.21, stdev=3D2742.=
06
> >>   clat (usec): min=3D25, max=3D73526, avg=3D663.35, stdev=3D611.06
> >>    lat (usec): min=3D28, max=3D73545, avg=3D666.09, stdev=3D611.08
> >>   clat percentiles (usec):
> >>    |  1.00th=3D[  143],  5.00th=3D[  190], 10.00th=3D[  227], 20.00th=
=3D[  285],
> >>    | 30.00th=3D[  338], 40.00th=3D[  400], 50.00th=3D[  478], 60.00th=
=3D[  586],
> >>    | 70.00th=3D[  725], 80.00th=3D[  930], 90.00th=3D[ 1254], 95.00th=
=3D[ 1614],
> >>    | 99.00th=3D[ 3490], 99.50th=3D[ 4146], 99.90th=3D[ 6390], 99.95th=
=3D[ 6980],
> >>    | 99.99th=3D[ 8356]
> >>  bw (  MiB/s): min=3D28962, max=3D55326, per=3D12.70%, avg=3D48036.10,=
 stdev=3D96.75, samples=3D7488
> >>  iops        : min=3D7414327, max=3D14163615, avg=3D12297214.98, stdev=
=3D24768.82, samples=3D7488
> >> lat (usec)   : 50=3D0.01%, 100=3D0.03%, 250=3D13.75%, 500=3D38.84%, 75=
0=3D18.71%
> >> lat (usec)   : 1000=3D11.55%
> >> lat (msec)   : 2=3D14.30%, 4=3D2.23%, 10=3D0.60%, 20=3D0.01%, 50=3D0.0=
1%
> >> lat (msec)   : 100=3D0.01%
> >> cpu          : usr=3D13.41%, sys=3D44.44%, ctx=3D39379711, majf=3D0, m=
inf=3D9982
> >> IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, 32=
=3D0.1%, >=3D64=3D100.0%
> >>    submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 6=
4=3D0.0%, >=3D64=3D0.0%
> >>    complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 6=
4=3D0.0%, >=3D64=3D0.1%
> >>    issued rwts: total=3D737168913,0,0,0 short=3D0,0,0,0 dropped=3D0,0,=
0,0
> >>    latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D1=
28
> >> socket0-lv: (groupid=3D2, jobs=3D64): err=3D 0: pid=3D64166: Thu Jul 2=
9
> >> 21:48:32 2021
> >> read: IOPS=3D8570k, BW=3D32.7GiB/s (35.1GB/s)(1962GiB/60006msec)
> >>   slat (nsec): min=3D1873, max=3D11085k, avg=3D4694.47, stdev=3D4825.3=
9
> >>   clat (usec): min=3D24, max=3D21739, avg=3D950.52, stdev=3D948.83
> >>    lat (usec): min=3D51, max=3D21743, avg=3D955.29, stdev=3D948.88
> >>   clat percentiles (usec):
> >>    |  1.00th=3D[  155],  5.00th=3D[  217], 10.00th=3D[  265], 20.00th=
=3D[  338],
> >>    | 30.00th=3D[  404], 40.00th=3D[  486], 50.00th=3D[  594], 60.00th=
=3D[  766],
> >>    | 70.00th=3D[ 1029], 80.00th=3D[ 1418], 90.00th=3D[ 2089], 95.00th=
=3D[ 2737],
> >>    | 99.00th=3D[ 4490], 99.50th=3D[ 5669], 99.90th=3D[ 8586], 99.95th=
=3D[ 9896],
> >>    | 99.99th=3D[12125]
> >>  bw (  MiB/s): min=3D24657, max=3D37453, per=3D-25.17%, avg=3D33516.00=
, stdev=3D35.32, samples=3D7616
> >>  iops        : min=3D6312326, max=3D9588007, avg=3D8580076.03, stdev=
=3D9041.88, samples=3D7616
> >> lat (usec)   : 50=3D0.01%, 100=3D0.01%, 250=3D8.40%, 500=3D33.21%, 750=
=3D17.54%
> >> lat (usec)   : 1000=3D9.89%
> >> lat (msec)   : 2=3D19.93%, 4=3D9.58%, 10=3D1.40%, 20=3D0.05%, 50=3D0.0=
1%
> >> cpu          : usr=3D9.01%, sys=3D51.48%, ctx=3D27829950, majf=3D0, mi=
nf=3D9028
> >> IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, 32=
=3D0.1%, >=3D64=3D100.0%
> >>    submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 6=
4=3D0.0%, >=3D64=3D0.0%
> >>    complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 6=
4=3D0.0%, >=3D64=3D0.1%
> >>    issued rwts: total=3D514275323,0,0,0 short=3D0,0,0,0 dropped=3D0,0,=
0,0
> >>    latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D1=
28
> >> socket1-lv: (groupid=3D3, jobs=3D64): err=3D 0: pid=3D64230: Thu Jul 2=
9
> >> 21:48:32 2021
> >> read: IOPS=3D8571k, BW=3D32.7GiB/s (35.1GB/s)(1962GiB/60006msec)
> >>   slat (nsec): min=3D1823, max=3D14362k, avg=3D4809.30, stdev=3D4940.4=
2
> >>   clat (usec): min=3D50, max=3D22856, avg=3D950.31, stdev=3D948.13
> >>    lat (usec): min=3D54, max=3D22860, avg=3D955.19, stdev=3D948.19
> >>   clat percentiles (usec):
> >>    |  1.00th=3D[  157],  5.00th=3D[  221], 10.00th=3D[  269], 20.00th=
=3D[  343],
> >>    | 30.00th=3D[  412], 40.00th=3D[  490], 50.00th=3D[  603], 60.00th=
=3D[  766],
> >>    | 70.00th=3D[ 1029], 80.00th=3D[ 1418], 90.00th=3D[ 2089], 95.00th=
=3D[ 2737],
> >>    | 99.00th=3D[ 4293], 99.50th=3D[ 5604], 99.90th=3D[ 9503], 99.95th=
=3D[10683],
> >>    | 99.99th=3D[12649]
> >>  bw (  MiB/s): min=3D23434, max=3D36909, per=3D-25.17%, avg=3D33517.14=
, stdev=3D50.36, samples=3D7616
> >>  iops        : min=3D5999220, max=3D9448818, avg=3D8580368.69, stdev=
=3D12892.93, samples=3D7616
> >> lat (usec)   : 100=3D0.01%, 250=3D7.88%, 500=3D33.09%, 750=3D18.09%, 1=
000=3D10.02%
> >> lat (msec)   : 2=3D19.91%, 4=3D9.75%, 10=3D1.16%, 20=3D0.08%, 50=3D0.0=
1%
> >> cpu          : usr=3D9.14%, sys=3D51.94%, ctx=3D25524808, majf=3D0, mi=
nf=3D9037
> >> IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, 32=
=3D0.1%, >=3D64=3D100.0%
> >>    submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 6=
4=3D0.0%, >=3D64=3D0.0%
> >>    complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 6=
4=3D0.0%, >=3D64=3D0.1%
> >>    issued rwts: total=3D514294010,0,0,0 short=3D0,0,0,0 dropped=3D0,0,=
0,0
> >>    latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D1=
28
> >>
> >> Run status group 0 (all jobs):
> >>  READ: bw=3D51.7GiB/s (55.6GB/s), 51.7GiB/s-51.7GiB/s
> >> (55.6GB/s-55.6GB/s), io=3D3105GiB (3334GB), run=3D60003-60003msec
> >>
> >> Run status group 1 (all jobs):
> >>  READ: bw=3D46.9GiB/s (50.3GB/s), 46.9GiB/s-46.9GiB/s
> >> (50.3GB/s-50.3GB/s), io=3D2812GiB (3019GB), run=3D60003-60003msec
> >>
> >> Run status group 2 (all jobs):
> >>  READ: bw=3D32.7GiB/s (35.1GB/s), 32.7GiB/s-32.7GiB/s
> >> (35.1GB/s-35.1GB/s), io=3D1962GiB (2106GB), run=3D60006-60006msec
> >>
> >> Run status group 3 (all jobs):
> >>  READ: bw=3D32.7GiB/s (35.1GB/s), 32.7GiB/s-32.7GiB/s
> >> (35.1GB/s-35.1GB/s), io=3D1962GiB (2107GB), run=3D60006-60006msec
> >>
> >> Disk stats (read/write):
> >> nvme0n1: ios=3D90336694/0, merge=3D0/0, ticks=3D45102163/0,
> >> in_queue=3D45102163, util=3D97.44%
> >> nvme1n1: ios=3D90337153/0, merge=3D0/0, ticks=3D47422886/0,
> >> in_queue=3D47422887, util=3D97.81%
> >> nvme2n1: ios=3D90337516/0, merge=3D0/0, ticks=3D46419782/0,
> >> in_queue=3D46419782, util=3D97.95%
> >> nvme3n1: ios=3D90337843/0, merge=3D0/0, ticks=3D46256374/0,
> >> in_queue=3D46256374, util=3D97.95%
> >> nvme4n1: ios=3D90337742/0, merge=3D0/0, ticks=3D59122226/0,
> >> in_queue=3D59122225, util=3D98.19%
> >> nvme5n1: ios=3D90338813/0, merge=3D0/0, ticks=3D57811758/0,
> >> in_queue=3D57811758, util=3D98.33%
> >> nvme6n1: ios=3D90339194/0, merge=3D0/0, ticks=3D57369337/0,
> >> in_queue=3D57369337, util=3D98.37%
> >> nvme7n1: ios=3D90339048/0, merge=3D0/0, ticks=3D55791076/0,
> >> in_queue=3D55791076, util=3D98.78%
> >> nvme8n1: ios=3D90340234/0, merge=3D0/0, ticks=3D44977001/0,
> >> in_queue=3D44977001, util=3D99.01%
> >> nvme12n1: ios=3D81819608/0, merge=3D0/0, ticks=3D26788080/0,
> >> in_queue=3D26788079, util=3D99.24%
> >> nvme13n1: ios=3D81819831/0, merge=3D0/0, ticks=3D26736682/0,
> >> in_queue=3D26736681, util=3D99.57%
> >> nvme14n1: ios=3D81820006/0, merge=3D0/0, ticks=3D26772951/0,
> >> in_queue=3D26772951, util=3D99.67%
> >> nvme15n1: ios=3D81820215/0, merge=3D0/0, ticks=3D26741532/0,
> >> in_queue=3D26741532, util=3D99.78%
> >> nvme17n1: ios=3D81819922/0, merge=3D0/0, ticks=3D76459192/0,
> >> in_queue=3D76459192, util=3D99.84%
> >> nvme18n1: ios=3D81820146/0, merge=3D0/0, ticks=3D86756309/0,
> >> in_queue=3D86756309, util=3D99.82%
> >> nvme19n1: ios=3D81820481/0, merge=3D0/0, ticks=3D75008919/0,
> >> in_queue=3D75008919, util=3D100.00%
> >> nvme20n1: ios=3D81819690/0, merge=3D0/0, ticks=3D91888274/0,
> >> in_queue=3D91888275, util=3D100.00%
> >> nvme21n1: ios=3D81821809/0, merge=3D0/0, ticks=3D26653056/0,
> >> in_queue=3D26653057, util=3D100.00% -----Original Message-----
> >> From: Matt Wallis <mattw@madmonks.org>
> >> Sent: Wednesday, July 28, 2021 8:54 PM
> >> To: Finlayson, James M CIV (USA) <james.m.finlayson4.civ@mail.mil>
> >> Cc: linux-raid@vger.kernel.org
> >> Subject: Re: [Non-DoD Source] Can't get RAID5/RAID6 NVMe randomread IO=
PS - AMD ROME what am I missing?????
> >>
> >> Hi Jim,
> >>
> >> Totally get the Frankenstein=E2=80=99s monster aspect, I try not to bu=
ild those where I can, but at the moment I don=E2=80=99t think there=E2=80=
=99s much that can be done about it.
> >> Not sure if LVM is better than MDRAID 0, it just gives you more contro=
l over the volumes that can be created, instead of having it all in one big=
 chunk. If you just need one big chunk, then MDRAID 0 is probably fine.
> >>
> >> I think if you can create a couple of scripts that allows the admin to=
 fail a drive out of all the arrays that it=E2=80=99s in at once, then it's=
 not that much worse than managing an MDRAID is normally.
> >>
> >> Matt.
> >>
> >>> On 28 Jul 2021, at 20:43, Finlayson, James M CIV (USA) <james.m.finla=
yson4.civ@mail.mil> wrote:
> >>>
> >>> Matt,
> >>> I have put as many as 32 partitions on a drive (based upon great advi=
ce from this list) and done RAID6 over them, but I was concerned about our =
sustainability long term.     As a researcher, I can do these cool science =
experiments, but I still have to hand designs  to sustainment folks.  I was=
 also running into an issue of doing a mdraid RAID0 on top of the RAID6's s=
o I could toss one  xfs file system on top each of the numa node's drives a=
nd the last RAID0 stripe of all of the RAID6's couldn't generate the queue =
depth needed.    We even recompiled the kernel to change the mdraid nr_requ=
est max from 128 to 1023.
> >>>
> >>> I will have to try the LVM experiment.  I'm an LVM  neophyte, so it m=
ight take me the rest of today/tomorrow to get new results as I tend to let=
 mdraid do all of its volume builds without forcing, so that will take a bi=
t of time also.  Once might be able to argue that configuration isn't too m=
uch of a "Frankenstein's monster" for me to hand it off.
> >>>
> >>> Thanks,
> >>> Jim
> >>>
> >>>
> >>>
> >>>
> >>> -----Original Message-----
> >>> From: Matt Wallis <mattw@madmonks.org>
> >>> Sent: Wednesday, July 28, 2021 6:32 AM
> >>> To: Finlayson, James M CIV (USA) <james.m.finlayson4.civ@mail.mil>
> >>> Cc: linux-raid@vger.kernel.org
> >>> Subject: [Non-DoD Source] Re: Can't get RAID5/RAID6 NVMe randomread I=
OPS - AMD ROME what am I missing?????
> >>>
> >>> Hi Jim,
> >>>
> >>>> On 28 Jul 2021, at 06:32, Finlayson, James M CIV (USA) <james.m.finl=
ayson4.civ@mail.mil> wrote:
> >>>>
> >>>> Sorry, this will be a long email with everything I find to be releva=
nt, but I can get over 110GB/s of 4kB random reads from individual NVMe SSD=
s, but I'm at a loss why mdraid can only do a very small  fraction of it.  =
 I'm at my "organizational world record" for sustained IOPS, but I need pro=
tected IOPS to do something useful.     This is everything I do to a server=
 to make the I/O crank.....My role is that of a lab researcher/resident exp=
ert/consultant.   I'm just stumped why I can't do better.   If there is a f=
ine manual that somebody can point me to, I'm happy to read it=E2=80=A6
> >>>
> >>> I am probably going to get corrected on some if not all of this, but =
from what I understand, and from my own little experiments on a similar Int=
el based system=E2=80=A6 1. NVMe is stupid fast, you need a good chunk of C=
PU performance to max it out.
> >>> 2. Most block IO in the kernel is limited in terms of threading, it
> >>> may even be essentially single threaded. (This is where I will get
> >>> corrected) 3. AFAICT, this includes mdraid, there=E2=80=99s a single =
thread
> >>> per RAID device handling all the RAID calculations. (mdX_raid6)
> >>>
> >>> What I did to get IOPs up in a system with 24 NVMe, split up into 12 =
per NUMA domain.
> >>> 1. Create 8 partitions on each drive (this may be overkill, I just st=
arted here for some reason) 2. Create 8 RAID6 arrays with 1 partition per d=
rive.
> >>> 3. Use LVM to create a single striped logical volume over all 8 RAID =
volumes. RAID 0+6 as it were.
> >>>
> >>> You now have an LVM thread that is basically doing nothing more than =
chunking the data as it comes in, then, sending the chunks to 8 separate RA=
ID devices, each with their own threads, buffers, queues etc, all of which =
can be spread over more cores.
> >>>
> >>> I saw a significant (for me, significant is >20%) increase in IOPs do=
ing this.
> >>>
> >>> You still have RAID6 protection, but you might want to write a couple=
 of scripts to help you manage the arrays, because a single failed drive no=
w needs to be removed from 8 RAID volumes.
> >>>
> >>> There=E2=80=99s not a lot of capacity lost doing this, pretty sure I =
lost less than 100MB to the partitions and the RAID overhead.
> >>>
> >>> You would never consider this on spinning disk of course, way to slow=
 and you=E2=80=99re just going to make it slower, NVMe as you noticed has t=
he IOPs to spare, so I=E2=80=99m pretty sure it=E2=80=99s just that we=E2=
=80=99re not able to get the data to it fast enough.
> >>>
> >>> Matt
>


--=20
Doug Ledford <dledford@redhat.com>
GPG KeyID: B826A3330E572FDD
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

