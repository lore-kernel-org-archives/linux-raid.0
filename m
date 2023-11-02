Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 227B9C4332F
	for <linux-raid@archiver.kernel.org>; Thu,  2 Nov 2023 11:57:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345566AbjKBL5l (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 2 Nov 2023 07:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234223AbjKBL5k (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 2 Nov 2023 07:57:40 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84C0F197
        for <linux-raid@vger.kernel.org>; Thu,  2 Nov 2023 04:57:35 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id ca18e2360f4ac-7a66b5f7ea7so34284439f.2
        for <linux-raid@vger.kernel.org>; Thu, 02 Nov 2023 04:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698926255; x=1699531055; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q/EAsUr3Yui5vvuSDmdKtcBmO/FhHW7KsoNgj2I7jq0=;
        b=hDS9GgRk5LDRu95FEGs+af29cdWXjAJBopQQIpiOH9IlsufhAu0B4L5sdFCSvHvopU
         bEMBVRW69T8FPGmY4ls64hqJDjQ2wvwF/0waFE8pEX9vQCjcReZlWXDK/WThmm8T8nG6
         e2pzetUUs9F9e10hOyuawxShJDouLUjrNVayjRYBvlFJHaVKAacNBUMzzgOV28YM0pf8
         cG++tUiquTRQaphKPi7Is60MO6aaKPj7kqDCju6fLYRcGqyT2TSGruGDobllOxtEDQ4r
         Q1ObcImGAQpHZkXjsRlIuTfvA/ygXX1PpFm3nilXFEgkpJ+o/LQvaKv1lzpj0fXhsISp
         CK1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698926255; x=1699531055;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q/EAsUr3Yui5vvuSDmdKtcBmO/FhHW7KsoNgj2I7jq0=;
        b=gmuDQzgpy4MXEdWd9WRyh9c9VWrbFe5D2lRlFcAgNwH6je9wdQZh9UvEuhmBuWib5q
         P8MGCL2Ljm0gufMXLLKnT70TuPwAtyBS6Mt2mNcxaBc7hMU2a0G4mOa8MVnVvToA4h1p
         yY6BAmXwU4O8HYOBAgSYYJXuLJBGqfNnJe6cUZckH2gXHBuKjDGt9LOZ31L5yMVmfoFo
         mi4leUCNPFokVOyS2Kg0Q8+B2lI/eqwpf8cgPTtqq8BaaCKeOeN6OhWRi1XIydKE0EmE
         bF/E8sBv0Dei2+9yLSB3Ktw10X6agF/Z9M99a92yPBk3v/bAoCBcEzXhtnJT23U3otRC
         LHpQ==
X-Gm-Message-State: AOJu0Yx4Us57YRTT0SI8Yi+5ixAoPmtzYZKmot3PjRlP9V6oZtEHypZ2
        duzdE3ynTlrtgq+sqIt5BnBez93IJQZIMzNwD8iI8Cib
X-Google-Smtp-Source: AGHT+IHeWjIelccOuPehPhkOQbYk1HLO06vLdGeJmkmpIH4LWIvAvkm9ykw/yo+tIKrC6vTbUhvflCde1epdcY3MQWA=
X-Received: by 2002:a05:6e02:3304:b0:359:37e2:29db with SMTP id
 bm4-20020a056e02330400b0035937e229dbmr7977179ilb.24.1698926254597; Thu, 02
 Nov 2023 04:57:34 -0700 (PDT)
MIME-Version: 1.0
References: <87273fc6-9531-4072-ae6c-06306e9a269d@eyal.emu.id.au>
 <CAAMCDecjCJz3qPve-54wpd_eX3dTgLYrMVupX6i3JNfBq2mNPw@mail.gmail.com>
 <ZUByq7Wg-KFcXctW@fisica.ufpr.br> <577244fc-f43a-4e1f-bf34-d1c194fd90b4@eyal.emu.id.au>
 <CAAMCDedPoNcdacRHNykOtG0yw4mDV3WFpowU1WtoQJgdNAKjDg@mail.gmail.com>
 <0dc5a117-97be-4ed1-9976-1f754a6abf91@eyal.emu.id.au> <CAAMCDecobWVOxGOxFt47Y4ZC2JCNVH1T2oQ8X=6BHOz9PemNEQ@mail.gmail.com>
 <37b6265a-b925-4910-b092-59177b639ca9@eyal.emu.id.au> <CAAMCDefUcuz2Nzh7AvP9m50uq86ZBK3AhEAEynVG_mmmY_f0jQ@mail.gmail.com>
 <ZUNfK1jqBNsm97Q-@vault.lan> <22339749-c498-459e-9dbe-c12859be0580@eyal.emu.id.au>
In-Reply-To: <22339749-c498-459e-9dbe-c12859be0580@eyal.emu.id.au>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Thu, 2 Nov 2023 06:57:22 -0500
Message-ID: <CAAMCDecMvSN9KnNhu3QyRQah016uJhg_vXtjO90WECBCMr8W9w@mail.gmail.com>
Subject: Re: problem with recovered array
To:     eyal@eyal.emu.id.au
Cc:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

you need the iostat  data from the disks under md127 to see what
mdraid is having to do to internally.   Get the list of sd devices and
do iostat -x  | grep -E 'Device|sdX|sxy|sdz'    (putting into the list
the whole non-partitioned sd devices in your array)

The slowness of clearing dirty and what perf top showed (ext4* calls)
indicates it is creating entries for small files and putting data in
those files.   Creating entries for small files requires a lot of both
read and write seeks and seeks are expensive.   At most I would expect
you to be able to rsync/copy around 30-50 files/second (when the array
is healthy and once the size gets small enough the mb/sec does not
matter anymore as the seeks dominate).

On my array I do a nightly copy in of data written during the day to a
SSD (security cams).   And without any array issues that makes my
array really busy.   Anything wrong with the array and that process
takes several times as long.

On Thu, Nov 2, 2023 at 6:34=E2=80=AFAM <eyal@eyal.emu.id.au> wrote:
>
> On 02/11/2023 19.34, Johannes Truschnigg wrote:
> > Hi list,
> >
> > for the record, I do not think that any of the observations the OP made=
 can be
> > explained by non-pathological phenomena/patterns of behavior. Something=
 is
> > very clearly wrong with how this system behaves (the reported figures d=
o not
> > at all match the expected performance of even a degraded RAID6 array in=
 my
> > experience) and how data written to the filesystem apparently fails to =
make it
> > into the backing devices in acceptable time.
> >
> > The whole affair reeks either of "subtle kernel bug", or maybe "subtle
> > hardware failure", I think.
> >
> > Still, it'd be interesting to know what happens when writes to the arra=
y thru
> > the file system are performed with O_DIRECT in effect, i.e., using `dd
> > oflag=3Ddirect status=3Dprogress ...` - does this yield any observable =
(via
> > `iostat` et al.) thruput to the disks beneath? What transfer speeds doe=
s `dd`
> > report this way with varying block sizes? Are there no concerning messa=
ges in
> > the debug ringbuffer (`dmesg`) at this time?
> >
> > I'm not sure how we'd best learn more about what the participating busy=
 kernel
> > threads (Fedora 38 might have more convenient devices up its sleeve tha=
n
> > ftrace?) are spending their time on in particular, but I think that's w=
hat's
> > needed to be known to pin down the underlying cause of the problem.
>
> To clarify what may be lost on this thread.
>
> I can dd to this fs just fine, The Dirty count does not go above about 4G=
B. The machine has 32KB.
> It is cleared very fast. Tested writing 100GB.
>
> The Dirty blocks rise to the max then drain quickly.
>
> 2023-11-02 21:28:27 Dirty:               236 kB
> 2023-11-02 21:28:37 Dirty:                 8 kB
> 2023-11-02 21:28:47 Dirty:                40 kB
> 2023-11-02 21:28:57 Dirty:                68 kB
> 2023-11-02 21:29:07 Dirty:               216 kB
> 2023-11-02 21:29:17 Dirty:               364 kB
> 2023-11-02 21:29:27 Dirty:                20 kB
> 2023-11-02 21:29:37 Dirty:                48 kB
> 2023-11-02 21:29:47 Dirty:                24 kB
> 2023-11-02 21:29:57 Dirty:                36 kB
> 2023-11-02 21:30:07 Dirty:                28 kB
> 2023-11-02 21:30:17 Dirty:                52 kB
> 2023-11-02 21:30:27 Dirty:                36 kB
> 2023-11-02 21:30:37 Dirty:           4112980 kB
> 2023-11-02 21:30:47 Dirty:           3772396 kB
> 2023-11-02 21:30:57 Dirty:           3849688 kB
> 2023-11-02 21:31:07 Dirty:           3761132 kB
> 2023-11-02 21:31:17 Dirty:           3846216 kB
> 2023-11-02 21:31:27 Dirty:           3855060 kB
> 2023-11-02 21:31:37 Dirty:           3902212 kB
> 2023-11-02 21:31:47 Dirty:           4173524 kB
> 2023-11-02 21:31:57 Dirty:           3849856 kB
> 2023-11-02 21:32:07 Dirty:           3940632 kB
> 2023-11-02 21:32:17 Dirty:           2212008 kB
> 2023-11-02 21:32:27 Dirty:               244 kB
> 2023-11-02 21:32:37 Dirty:               288 kB
> 2023-11-02 21:32:47 Dirty:                60 kB
>
> rsync'ing a large tree into this same fs is different.
> When killed less than 3GB were copied. Mostly small files in many directo=
ries.
> Something like 92,059 files using 2,519MB.
>
> Note how slowly the dirty blocks are cleared.
>
> 2023-11-02 21:36:28 Dirty:               296 kB
> 2023-11-02 21:36:38 Dirty:            277412 kB
> 2023-11-02 21:36:48 Dirty:            403928 kB
> 2023-11-02 21:36:58 Dirty:            606916 kB
> 2023-11-02 21:37:08 Dirty:            753888 kB
> 2023-11-02 21:37:18 Dirty:            641624 kB
> 2023-11-02 21:37:28 Dirty:            744560 kB
> 2023-11-02 21:37:38 Dirty:            946864 kB
> 2023-11-02 21:37:48 Dirty:           1355964 kB
> 2023-11-02 21:37:58 Dirty:           2365632 kB
> 2023-11-02 21:38:08 Dirty:           2451948 kB
> ### at this point the rsync was cancelled as I see the kthread start
> 2023-11-02 21:38:18 Dirty:           2451752 kB
> 2023-11-02 21:38:28 Dirty:           2440496 kB
> 2023-11-02 21:38:38 Dirty:           2440308 kB
> 2023-11-02 21:38:48 Dirty:           2440136 kB
> 2023-11-02 21:38:58 Dirty:           2440036 kB
> 2023-11-02 21:39:08 Dirty:           2440240 kB
> 2023-11-02 21:39:18 Dirty:           2405768 kB
> 2023-11-02 21:39:28 Dirty:           2405784 kB
> 2023-11-02 21:39:38 Dirty:           2406012 kB
> 2023-11-02 21:39:48 Dirty:           2405908 kB
> 2023-11-02 21:39:58 Dirty:           2405848 kB
> 2023-11-02 21:40:08 Dirty:           2405876 kB
> 2023-11-02 21:40:18 Dirty:           2405704 kB
> 2023-11-02 21:40:28 Dirty:           2405628 kB
> 2023-11-02 21:40:38 Dirty:           2405544 kB
> 2023-11-02 21:40:48 Dirty:           2405484 kB
> 2023-11-02 21:40:58 Dirty:           2405416 kB
> 2023-11-02 21:41:08 Dirty:           2405412 kB
> 2023-11-02 21:41:18 Dirty:           2405240 kB
> 2023-11-02 21:41:28 Dirty:           2405148 kB
> 2023-11-02 21:41:38 Dirty:           2405132 kB
> 2023-11-02 21:41:48 Dirty:           2404428 kB
> 2023-11-02 21:41:58 Dirty:           2405056 kB
> 2023-11-02 21:42:08 Dirty:           2404944 kB
> 2023-11-02 21:42:18 Dirty:           2404904 kB
> 2023-11-02 21:42:28 Dirty:           2404316 kB
> 2023-11-02 21:42:38 Dirty:           2395340 kB
> 2023-11-02 21:42:48 Dirty:           2394540 kB
> 2023-11-02 21:42:58 Dirty:           2394368 kB
> 2023-11-02 21:43:08 Dirty:           2394520 kB
> 2023-11-02 21:43:18 Dirty:           2394132 kB
> 2023-11-02 21:43:28 Dirty:           2394032 kB
> 2023-11-02 21:43:38 Dirty:           2394276 kB
> 2023-11-02 21:43:48 Dirty:           2386960 kB
> 2023-11-02 21:43:58 Dirty:           2387420 kB
> 2023-11-02 21:44:08 Dirty:           2386620 kB
> 2023-11-02 21:44:18 Dirty:           2386828 kB
> 2023-11-02 21:44:28 Dirty:           2386104 kB
> 2023-11-02 21:44:38 Dirty:           2386328 kB
> 2023-11-02 21:44:48 Dirty:           2382520 kB
> 2023-11-02 21:44:58 Dirty:           2382024 kB
> 2023-11-02 21:45:08 Dirty:           2381344 kB
> 2023-11-02 21:45:18 Dirty:           2380776 kB
> 2023-11-02 21:45:28 Dirty:           2380424 kB
> 2023-11-02 21:45:38 Dirty:           2379672 kB
> 2023-11-02 21:45:48 Dirty:           2380180 kB
> 2023-11-02 21:45:58 Dirty:           2373272 kB
> 2023-11-02 21:46:08 Dirty:           2372416 kB
> 2023-11-02 21:46:18 Dirty:           2372052 kB
> 2023-11-02 21:46:28 Dirty:           2372176 kB
> ... and so on
>
> At the same time I see the kthread in top:
>
>      PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ C=
OMMAND
> 1491995 root      20   0       0      0      0 R  97.3   0.0  12:50.67 kw=
orker/u16:2+flush-9:127
>
> And iostat of md127 shows slow writing like this:
>           Device             tps    kB_read/s    kB_wrtn/s    kB_dscd/s  =
  kB_read    kB_wrtn    kB_dscd
> 21:59:52 md127             3.50         0.00        30.40         0.00   =
       0        304          0
> 22:00:02 md127             3.10         0.00        31.20         0.00   =
       0        312          0
> 22:00:12 md127             2.00         0.00        64.40         0.00   =
       0        644          0
> 22:00:22 md127             3.40         0.00        22.80         0.00   =
       0        228          0
>
> So, why the slow clearing of the dirty blocks?
>
> I will leave the machine to clear it into the night...
>
> BTW, if I try to shutdown in this situation, it will get stuck, and if I =
force a sysrq boot I get
> an array of all spares on restart. At least this is what happened twice a=
lready.
>
> HTH
>
> --
> Eyal at Home (eyal@eyal.emu.id.au)
>
