Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B0AFC4338F
	for <linux-raid@archiver.kernel.org>; Fri, 30 Jul 2021 08:45:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4945460F6B
	for <linux-raid@archiver.kernel.org>; Fri, 30 Jul 2021 08:45:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238009AbhG3Ipp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 30 Jul 2021 04:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237992AbhG3Ipo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 30 Jul 2021 04:45:44 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB3AC061765
        for <linux-raid@vger.kernel.org>; Fri, 30 Jul 2021 01:45:39 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id z3so8942791plg.8
        for <linux-raid@vger.kernel.org>; Fri, 30 Jul 2021 01:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Hfp5g2X6Xi71wSCDoGL3am9dJLHTp8f+Bg7hG2EuC2o=;
        b=vUjbg9KlAiEmF6D3jLqvcTRx5oa3x5tzobv/bVrSwrRNpgV87HEQHHOko2sMDBWWtD
         ytO5DUtdXLKhSYXSr8rtzSOKdu+QiPPtN1nys6hqxHJ59IMUQ28+NeNfUNaA1j448jeZ
         YIGLoGsrZiyXPLbADeWkPpEIKcE7UgboO14aCSOe/7etJ5pfs0jzDTX8y8ULVLlR8H0Z
         mYW54LMC3NZ/0QWpeSPHVjdhyKiuDGNafTm/Z3IAMj8XwWpZI3Jt4m15jAB3u5/mxPdC
         O94I6e0siZqIEXpgYoGsfnlQfq9X9vY38fJkqgDePiKLuIlhHOk+yRbpFS7pf0/DCiDt
         8Qyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Hfp5g2X6Xi71wSCDoGL3am9dJLHTp8f+Bg7hG2EuC2o=;
        b=Wx9seWuXh1zCd/tK1Fond7MV0SMM+XRks2c+nGJXvqWGqJ/w1fsrXEimZwcdKbGJXo
         4dIVh4pSliv7OaV9pWqmHSicGvLRydACZ2bNM24ZlmmqrboslCQiii57bgjDcznV5PXo
         NsR0fCyJXFP+sdLyBHAa92KmAB0r3ZM9Ymp8SuGb96mMVuIARHP/W7lMi73+pqRkrqZa
         yW1pk/RBS12H2kGMn3zGZazqspB6PqIBC4DKWYNhNDw1z7+yVpyShJsM2L5mN3l9oqqx
         ukvvLXiHq2tfftthzuMV2Bzg4e3664sPRT6HrnrhNveHeJNM7NUYHc0w7KHiWXa4jwoy
         Mjfw==
X-Gm-Message-State: AOAM531JuP27h7IbADywY31dbsgQBkCPjS3DZ/Qs1QtCJ5LMKDFVoKNF
        QXHC9sbfVazK/I3JPPqkqT4=
X-Google-Smtp-Source: ABdhPJyWVggOUH3tWFRrOljAAY+hI7YLpzhC7KrlewEwQaP19zA1hjddZkBDL2NoiairebfZtRVEJw==
X-Received: by 2002:a17:90a:564a:: with SMTP id d10mr1980395pji.120.1627634738832;
        Fri, 30 Jul 2021 01:45:38 -0700 (PDT)
Received: from [10.7.3.1] ([133.130.111.179])
        by smtp.gmail.com with ESMTPSA id u62sm1517983pfb.19.2021.07.30.01.45.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Jul 2021 01:45:38 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.6\))
Subject: Re: [Non-DoD Source] Can't get RAID5/RAID6 NVMe randomread IOPS - AMD
 ROME what am I missing?????
From:   Miao Wang <shankerwangmiao@gmail.com>
In-Reply-To: <EF5FF3B7-927D-44E5-89CE-CEB86BB225FF@madmonks.org>
Date:   Fri, 30 Jul 2021 16:45:32 +0800
Cc:     Matt Wallis <mattw@madmonks.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <CD53203D-6A23-40F8-9FD4-A60019F67B37@gmail.com>
References: <5EAED86C53DED2479E3E145969315A2385841062@UMECHPA7B.easf.csd.disa.mil>
 <07195088-7E4B-4586-BB45-04890265BD62@madmonks.org>
 <5EAED86C53DED2479E3E145969315A23858411D1@UMECHPA7B.easf.csd.disa.mil>
 <21187A73-4000-4017-B016-15C03D19B799@madmonks.org>
 <5EAED86C53DED2479E3E145969315A23858415CB@UMECHPA7B.easf.csd.disa.mil>
 <EF5FF3B7-927D-44E5-89CE-CEB86BB225FF@madmonks.org>
To:     "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>
X-Mailer: Apple Mail (2.3608.120.23.2.6)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jim,

Nice to hear about your findings on how to let linux md work better on =
fast nvme drives, because previously I was also stuck in a similar =
problem and finally gave up. Since it is very difficult to find such =
environment with so many fast nvme drives, I wonder if you have any =
interest in ZFS. Maybe you can set up a similar raidz configuration on =
those drives and see whether its performance is better or worse.

Cheers,

Miao Wang

> 2021=E5=B9=B407=E6=9C=8830=E6=97=A5 16:28=EF=BC=8CMatt Wallis =
<mattw@madmonks.org> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hi Jim,
>=20
> That=E2=80=99s significantly better than I expected, I need to see if =
I can get someone to send me the box I was using so I can spend some =
more time on it.
>=20
> Good luck with the rest of it, the bit I was looking for as a next =
step was going to be potentially tweaking stripe widths and the like to =
see how much difference it made on different workloads.
>=20
> Matt.=20
>=20
>> On 30 Jul 2021, at 08:05, Finlayson, James M CIV (USA) =
<james.m.finlayson4.civ@mail.mil> wrote:
>>=20
>> Matt,
>> Thank you for the tip.   I have put 32 partitions on each of my NVMe =
drives, made 32 raid5 stripes and then made an LVM from the 32 raid5 =
stripes.   I then created one physical volume per 10 NVMe drives on each =
socket.    I believe I have successfully harnessed "alien technology" =
(inside joke) to create a Frankenstein's monster.   These are =
substantially better than doing a RAID0 stripe over the partitioned md's =
in the past.  I whipped all of this together in two 15 minute sessions =
last night and just right now, so I might run some more extensive tests =
when I have the cycles.   I didn't intend to leave the thread hanging.
>> BLUF -  fio detailed output below.....
>> 9 drives per socket raw
>> socket0, 9 drives, raw 4K random reads 13.6M IOPS , socket1 9 drives, =
raw 4K random reads , 12.3M IOPS
>> %Cpu(s):  4.4 us, 25.6 sy,  0.0 ni, 56.7 id,  0.0 wa, 13.1 hi,  0.2 =
si,  0.0 st
>>=20
>> 9 data drives per socket RAID5/LVM raw (9+1)
>> socket0, 9 drives, raw 4K random reads 8.57M IOPS , socket1 9 drives, =
raw 4K random reads , 8.57M IOPS
>> %Cpu(s):  7.0 us, 22.3 sy,  0.0 ni, 58.4 id,  0.0 wa, 12.1 hi,  0.2 =
si,  0.0 st
>>=20
>>=20
>> All,
>> I intend to test the 4.15 kernel patch next week.   My SA would =
prefer if the patch has made it into the kernel-ml stream yet, so he =
could install an rpm, but I'll get him to build the kernel if need be.
>> If the 4.15 kernel patch doesn't alleviate the issues, I have a =
strong desire to have mdraid made better.
>>=20
>>=20
>> Quick fio results:
>> socket0: (g=3D0): rw=3Drandread, bs=3D(R) 4096B-4096B, (W) =
4096B-4096B, (T) 4096B-4096B, ioengine=3Dlibaio, iodepth=3D128
>> ...
>> socket1: (g=3D1): rw=3Drandread, bs=3D(R) 4096B-4096B, (W) =
4096B-4096B, (T) 4096B-4096B, ioengine=3Dlibaio, iodepth=3D128
>> ...
>> socket0-lv: (g=3D2): rw=3Drandread, bs=3D(R) 4096B-4096B, (W) =
4096B-4096B, (T) 4096B-4096B, ioengine=3Dlibaio, iodepth=3D128
>> ...
>> socket1-lv: (g=3D3): rw=3Drandread, bs=3D(R) 4096B-4096B, (W) =
4096B-4096B, (T) 4096B-4096B, ioengine=3Dlibaio, iodepth=3D128
>> ...
>> fio-3.26
>> Starting 256 processes
>>=20
>> socket0: (groupid=3D0, jobs=3D64): err=3D 0: pid=3D64032: Thu Jul 29 =
21:48:32 2021
>> read: IOPS=3D13.6M, BW=3D51.7GiB/s (55.6GB/s)(3105GiB/60003msec)
>>   slat (nsec): min=3D1292, max=3D1376.7k, avg=3D2545.32, =
stdev=3D2696.74
>>   clat (usec): min=3D36, max=3D71580, avg=3D600.68, stdev=3D361.36
>>    lat (usec): min=3D38, max=3D71616, avg=3D603.30, stdev=3D361.38
>>   clat percentiles (usec):
>>    |  1.00th=3D[  169],  5.00th=3D[  231], 10.00th=3D[  277], =
20.00th=3D[  347],
>>    | 30.00th=3D[  404], 40.00th=3D[  457], 50.00th=3D[  519], =
60.00th=3D[  594],
>>    | 70.00th=3D[  676], 80.00th=3D[  791], 90.00th=3D[  996], =
95.00th=3D[ 1205],
>>    | 99.00th=3D[ 1909], 99.50th=3D[ 2409], 99.90th=3D[ 3556], =
99.95th=3D[ 3884],
>>    | 99.99th=3D[ 5538]
>>  bw (  MiB/s): min=3D39960, max=3D56660, per=3D20.94%, avg=3D53040.69, =
stdev=3D49.61, samples=3D7488
>>  iops        : min=3D10229946, max=3D14504941, avg=3D13578391.80, =
stdev=3D12699.61, samples=3D7488
>> lat (usec)   : 50=3D0.01%, 100=3D0.01%, 250=3D6.83%, 500=3D40.06%, =
750=3D29.92%
>> lat (usec)   : 1000=3D13.42%
>> lat (msec)   : 2=3D8.91%, 4=3D0.82%, 10=3D0.04%, 20=3D0.01%, 50=3D0.01%=

>> lat (msec)   : 100=3D0.01%
>> cpu          : usr=3D14.82%, sys=3D46.57%, ctx=3D35564249, majf=3D0, =
minf=3D9754
>> IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, =
32=3D0.1%, >=3D64=3D100.0%
>>    submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
>>    complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.1%
>>    issued rwts: total=3D813909201,0,0,0 short=3D0,0,0,0 =
dropped=3D0,0,0,0
>>    latency   : target=3D0, window=3D0, percentile=3D100.00%, =
depth=3D128
>> socket1: (groupid=3D1, jobs=3D64): err=3D 0: pid=3D64096: Thu Jul 29 =
21:48:32 2021
>> read: IOPS=3D12.3M, BW=3D46.9GiB/s (50.3GB/s)(2812GiB/60003msec)
>>   slat (nsec): min=3D1292, max=3D1672.2k, avg=3D2672.21, =
stdev=3D2742.06
>>   clat (usec): min=3D25, max=3D73526, avg=3D663.35, stdev=3D611.06
>>    lat (usec): min=3D28, max=3D73545, avg=3D666.09, stdev=3D611.08
>>   clat percentiles (usec):
>>    |  1.00th=3D[  143],  5.00th=3D[  190], 10.00th=3D[  227], =
20.00th=3D[  285],
>>    | 30.00th=3D[  338], 40.00th=3D[  400], 50.00th=3D[  478], =
60.00th=3D[  586],
>>    | 70.00th=3D[  725], 80.00th=3D[  930], 90.00th=3D[ 1254], =
95.00th=3D[ 1614],
>>    | 99.00th=3D[ 3490], 99.50th=3D[ 4146], 99.90th=3D[ 6390], =
99.95th=3D[ 6980],
>>    | 99.99th=3D[ 8356]
>>  bw (  MiB/s): min=3D28962, max=3D55326, per=3D12.70%, avg=3D48036.10, =
stdev=3D96.75, samples=3D7488
>>  iops        : min=3D7414327, max=3D14163615, avg=3D12297214.98, =
stdev=3D24768.82, samples=3D7488
>> lat (usec)   : 50=3D0.01%, 100=3D0.03%, 250=3D13.75%, 500=3D38.84%, =
750=3D18.71%
>> lat (usec)   : 1000=3D11.55%
>> lat (msec)   : 2=3D14.30%, 4=3D2.23%, 10=3D0.60%, 20=3D0.01%, =
50=3D0.01%
>> lat (msec)   : 100=3D0.01%
>> cpu          : usr=3D13.41%, sys=3D44.44%, ctx=3D39379711, majf=3D0, =
minf=3D9982
>> IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, =
32=3D0.1%, >=3D64=3D100.0%
>>    submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
>>    complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.1%
>>    issued rwts: total=3D737168913,0,0,0 short=3D0,0,0,0 =
dropped=3D0,0,0,0
>>    latency   : target=3D0, window=3D0, percentile=3D100.00%, =
depth=3D128
>> socket0-lv: (groupid=3D2, jobs=3D64): err=3D 0: pid=3D64166: Thu Jul =
29 21:48:32 2021
>> read: IOPS=3D8570k, BW=3D32.7GiB/s (35.1GB/s)(1962GiB/60006msec)
>>   slat (nsec): min=3D1873, max=3D11085k, avg=3D4694.47, stdev=3D4825.39=

>>   clat (usec): min=3D24, max=3D21739, avg=3D950.52, stdev=3D948.83
>>    lat (usec): min=3D51, max=3D21743, avg=3D955.29, stdev=3D948.88
>>   clat percentiles (usec):
>>    |  1.00th=3D[  155],  5.00th=3D[  217], 10.00th=3D[  265], =
20.00th=3D[  338],
>>    | 30.00th=3D[  404], 40.00th=3D[  486], 50.00th=3D[  594], =
60.00th=3D[  766],
>>    | 70.00th=3D[ 1029], 80.00th=3D[ 1418], 90.00th=3D[ 2089], =
95.00th=3D[ 2737],
>>    | 99.00th=3D[ 4490], 99.50th=3D[ 5669], 99.90th=3D[ 8586], =
99.95th=3D[ 9896],
>>    | 99.99th=3D[12125]
>>  bw (  MiB/s): min=3D24657, max=3D37453, per=3D-25.17%, avg=3D33516.00,=
 stdev=3D35.32, samples=3D7616
>>  iops        : min=3D6312326, max=3D9588007, avg=3D8580076.03, =
stdev=3D9041.88, samples=3D7616
>> lat (usec)   : 50=3D0.01%, 100=3D0.01%, 250=3D8.40%, 500=3D33.21%, =
750=3D17.54%
>> lat (usec)   : 1000=3D9.89%
>> lat (msec)   : 2=3D19.93%, 4=3D9.58%, 10=3D1.40%, 20=3D0.05%, =
50=3D0.01%
>> cpu          : usr=3D9.01%, sys=3D51.48%, ctx=3D27829950, majf=3D0, =
minf=3D9028
>> IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, =
32=3D0.1%, >=3D64=3D100.0%
>>    submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
>>    complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.1%
>>    issued rwts: total=3D514275323,0,0,0 short=3D0,0,0,0 =
dropped=3D0,0,0,0
>>    latency   : target=3D0, window=3D0, percentile=3D100.00%, =
depth=3D128
>> socket1-lv: (groupid=3D3, jobs=3D64): err=3D 0: pid=3D64230: Thu Jul =
29 21:48:32 2021
>> read: IOPS=3D8571k, BW=3D32.7GiB/s (35.1GB/s)(1962GiB/60006msec)
>>   slat (nsec): min=3D1823, max=3D14362k, avg=3D4809.30, stdev=3D4940.42=

>>   clat (usec): min=3D50, max=3D22856, avg=3D950.31, stdev=3D948.13
>>    lat (usec): min=3D54, max=3D22860, avg=3D955.19, stdev=3D948.19
>>   clat percentiles (usec):
>>    |  1.00th=3D[  157],  5.00th=3D[  221], 10.00th=3D[  269], =
20.00th=3D[  343],
>>    | 30.00th=3D[  412], 40.00th=3D[  490], 50.00th=3D[  603], =
60.00th=3D[  766],
>>    | 70.00th=3D[ 1029], 80.00th=3D[ 1418], 90.00th=3D[ 2089], =
95.00th=3D[ 2737],
>>    | 99.00th=3D[ 4293], 99.50th=3D[ 5604], 99.90th=3D[ 9503], =
99.95th=3D[10683],
>>    | 99.99th=3D[12649]
>>  bw (  MiB/s): min=3D23434, max=3D36909, per=3D-25.17%, avg=3D33517.14,=
 stdev=3D50.36, samples=3D7616
>>  iops        : min=3D5999220, max=3D9448818, avg=3D8580368.69, =
stdev=3D12892.93, samples=3D7616
>> lat (usec)   : 100=3D0.01%, 250=3D7.88%, 500=3D33.09%, 750=3D18.09%, =
1000=3D10.02%
>> lat (msec)   : 2=3D19.91%, 4=3D9.75%, 10=3D1.16%, 20=3D0.08%, =
50=3D0.01%
>> cpu          : usr=3D9.14%, sys=3D51.94%, ctx=3D25524808, majf=3D0, =
minf=3D9037
>> IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, =
32=3D0.1%, >=3D64=3D100.0%
>>    submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
>>    complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.1%
>>    issued rwts: total=3D514294010,0,0,0 short=3D0,0,0,0 =
dropped=3D0,0,0,0
>>    latency   : target=3D0, window=3D0, percentile=3D100.00%, =
depth=3D128
>>=20
>> Run status group 0 (all jobs):
>>  READ: bw=3D51.7GiB/s (55.6GB/s), 51.7GiB/s-51.7GiB/s =
(55.6GB/s-55.6GB/s), io=3D3105GiB (3334GB), run=3D60003-60003msec
>>=20
>> Run status group 1 (all jobs):
>>  READ: bw=3D46.9GiB/s (50.3GB/s), 46.9GiB/s-46.9GiB/s =
(50.3GB/s-50.3GB/s), io=3D2812GiB (3019GB), run=3D60003-60003msec
>>=20
>> Run status group 2 (all jobs):
>>  READ: bw=3D32.7GiB/s (35.1GB/s), 32.7GiB/s-32.7GiB/s =
(35.1GB/s-35.1GB/s), io=3D1962GiB (2106GB), run=3D60006-60006msec
>>=20
>> Run status group 3 (all jobs):
>>  READ: bw=3D32.7GiB/s (35.1GB/s), 32.7GiB/s-32.7GiB/s =
(35.1GB/s-35.1GB/s), io=3D1962GiB (2107GB), run=3D60006-60006msec
>>=20
>> Disk stats (read/write):
>> nvme0n1: ios=3D90336694/0, merge=3D0/0, ticks=3D45102163/0, =
in_queue=3D45102163, util=3D97.44%
>> nvme1n1: ios=3D90337153/0, merge=3D0/0, ticks=3D47422886/0, =
in_queue=3D47422887, util=3D97.81%
>> nvme2n1: ios=3D90337516/0, merge=3D0/0, ticks=3D46419782/0, =
in_queue=3D46419782, util=3D97.95%
>> nvme3n1: ios=3D90337843/0, merge=3D0/0, ticks=3D46256374/0, =
in_queue=3D46256374, util=3D97.95%
>> nvme4n1: ios=3D90337742/0, merge=3D0/0, ticks=3D59122226/0, =
in_queue=3D59122225, util=3D98.19%
>> nvme5n1: ios=3D90338813/0, merge=3D0/0, ticks=3D57811758/0, =
in_queue=3D57811758, util=3D98.33%
>> nvme6n1: ios=3D90339194/0, merge=3D0/0, ticks=3D57369337/0, =
in_queue=3D57369337, util=3D98.37%
>> nvme7n1: ios=3D90339048/0, merge=3D0/0, ticks=3D55791076/0, =
in_queue=3D55791076, util=3D98.78%
>> nvme8n1: ios=3D90340234/0, merge=3D0/0, ticks=3D44977001/0, =
in_queue=3D44977001, util=3D99.01%
>> nvme12n1: ios=3D81819608/0, merge=3D0/0, ticks=3D26788080/0, =
in_queue=3D26788079, util=3D99.24%
>> nvme13n1: ios=3D81819831/0, merge=3D0/0, ticks=3D26736682/0, =
in_queue=3D26736681, util=3D99.57%
>> nvme14n1: ios=3D81820006/0, merge=3D0/0, ticks=3D26772951/0, =
in_queue=3D26772951, util=3D99.67%
>> nvme15n1: ios=3D81820215/0, merge=3D0/0, ticks=3D26741532/0, =
in_queue=3D26741532, util=3D99.78%
>> nvme17n1: ios=3D81819922/0, merge=3D0/0, ticks=3D76459192/0, =
in_queue=3D76459192, util=3D99.84%
>> nvme18n1: ios=3D81820146/0, merge=3D0/0, ticks=3D86756309/0, =
in_queue=3D86756309, util=3D99.82%
>> nvme19n1: ios=3D81820481/0, merge=3D0/0, ticks=3D75008919/0, =
in_queue=3D75008919, util=3D100.00%
>> nvme20n1: ios=3D81819690/0, merge=3D0/0, ticks=3D91888274/0, =
in_queue=3D91888275, util=3D100.00%
>> nvme21n1: ios=3D81821809/0, merge=3D0/0, ticks=3D26653056/0, =
in_queue=3D26653057, util=3D100.00%
>> -----Original Message-----
>> From: Matt Wallis <mattw@madmonks.org>=20
>> Sent: Wednesday, July 28, 2021 8:54 PM
>> To: Finlayson, James M CIV (USA) <james.m.finlayson4.civ@mail.mil>
>> Cc: linux-raid@vger.kernel.org
>> Subject: Re: [Non-DoD Source] Can't get RAID5/RAID6 NVMe randomread =
IOPS - AMD ROME what am I missing?????
>>=20
>> Hi Jim,
>>=20
>> Totally get the Frankenstein=E2=80=99s monster aspect, I try not to =
build those where I can, but at the moment I don=E2=80=99t think =
there=E2=80=99s much that can be done about it.
>> Not sure if LVM is better than MDRAID 0, it just gives you more =
control over the volumes that can be created, instead of having it all =
in one big chunk. If you just need one big chunk, then MDRAID 0 is =
probably fine.
>>=20
>> I think if you can create a couple of scripts that allows the admin =
to fail a drive out of all the arrays that it=E2=80=99s in at once, then =
it's not that much worse than managing an MDRAID is normally.=20
>>=20
>> Matt.
>>=20
>>> On 28 Jul 2021, at 20:43, Finlayson, James M CIV (USA) =
<james.m.finlayson4.civ@mail.mil> wrote:
>>>=20
>>> Matt,
>>> I have put as many as 32 partitions on a drive (based upon great =
advice from this list) and done RAID6 over them, but I was concerned =
about our sustainability long term.     As a researcher, I can do these =
cool science experiments, but I still have to hand designs  to =
sustainment folks.  I was also running into an issue of doing a mdraid =
RAID0 on top of the RAID6's so I could toss one  xfs file system on top =
each of the numa node's drives and the last RAID0 stripe of all of the =
RAID6's couldn't generate the queue depth needed.    We even recompiled =
the kernel to change the mdraid nr_request max from 128 to 1023. =20
>>>=20
>>> I will have to try the LVM experiment.  I'm an LVM  neophyte, so it =
might take me the rest of today/tomorrow to get new results as I tend to =
let mdraid do all of its volume builds without forcing, so that will =
take a bit of time also.  Once might be able to argue that configuration =
isn't too much of a "Frankenstein's monster" for me to hand it off.
>>>=20
>>> Thanks,
>>> Jim
>>>=20
>>>=20
>>>=20
>>>=20
>>> -----Original Message-----
>>> From: Matt Wallis <mattw@madmonks.org>=20
>>> Sent: Wednesday, July 28, 2021 6:32 AM
>>> To: Finlayson, James M CIV (USA) <james.m.finlayson4.civ@mail.mil>
>>> Cc: linux-raid@vger.kernel.org
>>> Subject: [Non-DoD Source] Re: Can't get RAID5/RAID6 NVMe randomread =
IOPS - AMD ROME what am I missing?????
>>>=20
>>> Hi Jim,
>>>=20
>>>> On 28 Jul 2021, at 06:32, Finlayson, James M CIV (USA) =
<james.m.finlayson4.civ@mail.mil> wrote:
>>>>=20
>>>> Sorry, this will be a long email with everything I find to be =
relevant, but I can get over 110GB/s of 4kB random reads from individual =
NVMe SSDs, but I'm at a loss why mdraid can only do a very small  =
fraction of it.   I'm at my "organizational world record" for sustained =
IOPS, but I need protected IOPS to do something useful.     This is =
everything I do to a server to make the I/O crank.....My role is that of =
a lab researcher/resident expert/consultant.   I'm just stumped why I =
can't do better.   If there is a fine manual that somebody can point me =
to, I'm happy to read it=E2=80=A6
>>>=20
>>> I am probably going to get corrected on some if not all of this, but =
from what I understand, and from my own little experiments on a similar =
Intel based system=E2=80=A6 1. NVMe is stupid fast, you need a good =
chunk of CPU performance to max it out.
>>> 2. Most block IO in the kernel is limited in terms of threading, it =
may even be essentially single threaded. (This is where I will get =
corrected) 3. AFAICT, this includes mdraid, there=E2=80=99s a single =
thread per RAID device handling all the RAID calculations. (mdX_raid6)
>>>=20
>>> What I did to get IOPs up in a system with 24 NVMe, split up into 12 =
per NUMA domain.
>>> 1. Create 8 partitions on each drive (this may be overkill, I just =
started here for some reason) 2. Create 8 RAID6 arrays with 1 partition =
per drive.
>>> 3. Use LVM to create a single striped logical volume over all 8 RAID =
volumes. RAID 0+6 as it were.
>>>=20
>>> You now have an LVM thread that is basically doing nothing more than =
chunking the data as it comes in, then, sending the chunks to 8 separate =
RAID devices, each with their own threads, buffers, queues etc, all of =
which can be spread over more cores.
>>>=20
>>> I saw a significant (for me, significant is >20%) increase in IOPs =
doing this.=20
>>>=20
>>> You still have RAID6 protection, but you might want to write a =
couple of scripts to help you manage the arrays, because a single failed =
drive now needs to be removed from 8 RAID volumes.=20
>>>=20
>>> There=E2=80=99s not a lot of capacity lost doing this, pretty sure I =
lost less than 100MB to the partitions and the RAID overhead.
>>>=20
>>> You would never consider this on spinning disk of course, way to =
slow and you=E2=80=99re just going to make it slower, NVMe as you =
noticed has the IOPs to spare, so I=E2=80=99m pretty sure it=E2=80=99s =
just that we=E2=80=99re not able to get the data to it fast enough.
>>>=20
>>> Matt

