Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C0E9C4332F
	for <linux-raid@archiver.kernel.org>; Fri,  3 Nov 2023 12:08:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232729AbjKCMIh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 3 Nov 2023 08:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233485AbjKCMIg (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 3 Nov 2023 08:08:36 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B751ED62
        for <linux-raid@vger.kernel.org>; Fri,  3 Nov 2023 05:08:30 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id e9e14a558f8ab-35809893291so7873425ab.1
        for <linux-raid@vger.kernel.org>; Fri, 03 Nov 2023 05:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699013310; x=1699618110; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y9Zj9oSHULwmYKKw6RC8txlQwcfvku87fKEHCSiaA0Y=;
        b=dDwF0BtvBiR/O7WKu0MI8LHm6jZu65+AU1/OihOMRM/olAM0uZoux7LkVsEdOLL3DJ
         aGdtNAniBDRRFHef8AQKzjFVDsM+A6eERTufWyQzRBTmdQXeKBrRWsdEJ/Qu/aTJcGsF
         suCVygdhR9kRnyhx6kWVFrHGdbrP0pKdC+BpJSDDwnD305GKlDvujf11DQpW0ORwJque
         LQ8xmBjuOIWHj9b03bXL2ZMjgDsgUJGUhe3EfGP9mSpoQbi4zJ5q1gtvg4gO69U8fbD3
         y1hiP6A9MhJRu5TStXlaLuUrq/omLJc+5Z1WblX7FwvA7k9Xqpb90eQ63OBaLQnWWCTE
         aJpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699013310; x=1699618110;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y9Zj9oSHULwmYKKw6RC8txlQwcfvku87fKEHCSiaA0Y=;
        b=uacjU/GPjalULy1shN2uex3us6Dcx3gIBUbpgSj5VBhb0KTVKj1x7+2Am2J6gse4E2
         koEVRkq8Vgh/ZQEbbt5TkzUsrtyWCw5hqhlvhtIaMfH56xlOoXyGDajCxv01CAWdscri
         SYMBlyMYifHjDQexo9Xh3L379BRc9JDLsUOAT9VaIA2r9RwLo8naEgJVZgTO+t9fO5kX
         aAwj5yWJJWzjoPj/84upIG8WzwG+N80GStTaXV/a5bjYbgSgFZWvlUPXI6HyB4Zj6jSe
         YPILIjfw8BwjP9r8MP8PUZuzmEG4wSIgql9z481AvDddJMLMlAGiLxJGA6uEd3QA1BCe
         bBOw==
X-Gm-Message-State: AOJu0YxbkHOco2NXZ3JS1+nGLxxXEPBK8n+wkY3Ax9bysltxhnCjqb+8
        3hBS6HUxWSE3HuknzS5DV8DrjDUG/yxipyFXDKXL0U03
X-Google-Smtp-Source: AGHT+IFWbi/6KlU324IEjI6/bnC/Oy6s8UopJHaP4u3C7t8eslYLrd6o+wPXP+9m7ILJSYFLuQ8cSvCcQMRnD7Nqkrs=
X-Received: by 2002:a05:6602:2e14:b0:79f:99f5:fadd with SMTP id
 o20-20020a0566022e1400b0079f99f5faddmr27073073iow.6.1699013309865; Fri, 03
 Nov 2023 05:08:29 -0700 (PDT)
MIME-Version: 1.0
References: <87273fc6-9531-4072-ae6c-06306e9a269d@eyal.emu.id.au>
 <CAAMCDecjCJz3qPve-54wpd_eX3dTgLYrMVupX6i3JNfBq2mNPw@mail.gmail.com>
 <ZUByq7Wg-KFcXctW@fisica.ufpr.br> <577244fc-f43a-4e1f-bf34-d1c194fd90b4@eyal.emu.id.au>
 <CAAMCDedPoNcdacRHNykOtG0yw4mDV3WFpowU1WtoQJgdNAKjDg@mail.gmail.com>
 <0dc5a117-97be-4ed1-9976-1f754a6abf91@eyal.emu.id.au> <CAAMCDecobWVOxGOxFt47Y4ZC2JCNVH1T2oQ8X=6BHOz9PemNEQ@mail.gmail.com>
 <37b6265a-b925-4910-b092-59177b639ca9@eyal.emu.id.au> <CAAMCDefUcuz2Nzh7AvP9m50uq86ZBK3AhEAEynVG_mmmY_f0jQ@mail.gmail.com>
 <ZUNfK1jqBNsm97Q-@vault.lan> <22339749-c498-459e-9dbe-c12859be0580@eyal.emu.id.au>
 <CAAMCDecMvSN9KnNhu3QyRQah016uJhg_vXtjO90WECBCMr8W9w@mail.gmail.com>
 <1b453db1-b260-4e0b-978e-f15928d10151@eyal.emu.id.au> <CAAMCDec1acjdpVx0qPqQWhDCpAVmMQP-g8tMGc4-iXPbNZV6kg@mail.gmail.com>
 <bd60ac9f-7acd-494e-bfb6-b146a5add0d9@eyal.emu.id.au>
In-Reply-To: <bd60ac9f-7acd-494e-bfb6-b146a5add0d9@eyal.emu.id.au>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Fri, 3 Nov 2023 07:08:18 -0500
Message-ID: <CAAMCDef9TDLAiKqyHHub6gaXp+ar0ABEgzamtjTcAvw6hS1jOw@mail.gmail.com>
Subject: Re: problem with recovered array
To:     eyal@eyal.emu.id.au
Cc:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Nov 2, 2023 at 6:31=E2=80=AFPM <eyal@eyal.emu.id.au> wrote:
>
> On 03/11/2023 04.05, Roger Heflin wrote:
> > You need to add the -x for extended stats on iostat.  That will catch
> > if one of the disks has difficulty recovering bad blocks and is being
> > super slow.
> >
> > And that super slow will come and go based on if you are touching the
> > bad blocks.
>
> I did not know about '-x'. I see that the total columns (kB_read, kB_wrtn=
) are not included:-(
>
> Here is one.
>
> Device            r/s     rkB/s   rrqm/s  %rrqm r_await rareq-sz     w/s =
    wkB/s   wrqm/s  %wrqm w_await wareq-sz     d/s     dkB/s   drqm/s  %drq=
m d_await dareq-sz     f/s f_await  aqu-sz  %util
> md127            1.88    116.72     0.00   0.00   11.27    62.19    6.31 =
  1523.93     0.00   0.00  218.42   241.61    0.00      0.00     0.00   0.0=
0    0.00     0.00    0.00    0.00    1.40   1.72
> sdb              0.67     67.42    16.17  96.02   11.61   100.68    3.74 =
   367.79    89.35  95.98    7.65    98.33    0.00      0.00     0.00   0.0=
0    0.00     0.00    2.02    6.25    0.05   1.92
> sdc              0.81     89.74    21.61  96.39   15.30   110.94    3.74 =
   367.58    89.29  95.98    7.70    98.20    0.00      0.00     0.00   0.0=
0    0.00     0.00    2.02    5.15    0.05   1.73
> sdd              0.87    102.17    24.66  96.59   16.75   117.28    3.73 =
   367.34    89.24  95.99   15.00    98.45    0.00      0.00     0.00   0.0=
0    0.00     0.00    2.02    3.28    0.08   3.92
> sde              0.87    101.87    24.58  96.56   19.38   116.46    3.72 =
   367.45    89.28  96.00   16.20    98.71    0.00      0.00     0.00   0.0=
0    0.00     0.00    2.02    3.30    0.08   3.94
> sdf              0.81     90.11    21.70  96.39   16.24   110.80    3.73 =
   367.15    89.20  95.99   14.19    98.51    0.00      0.00     0.00   0.0=
0    0.00     0.00    2.02    3.17    0.07   3.91
> sdg              0.68     67.91    16.28  95.97   12.17    99.30    3.73 =
   367.20    89.21  95.98   13.28    98.32    0.00      0.00     0.00   0.0=
0    0.00     0.00    2.02    3.10    0.06   3.86
>
> Interesting to see that sd[bc] have lower w_await,aqu-sz and %util and hi=
gher f_await.
> Even not yet understanding what these mean, I see that sd[bc] are model S=
T12000NM001G (recently replaced) while the rest are the original ST12000NM0=
007 (now 5yo).
> I expect this shows different tuning in the device fw.
>
> I do not expect this to be relevant to the current situation.
>
> I need to understand the r vs w also. I see wkB/s identical for all membe=
rs, rkB/s is not.
> I expected this to be similar, but maybe md reads different disks at diff=
erent times to make up for the missing one?
>
> Still, thanks for your help.

I would expect the reads to be slightly different.   Note MD is
reading 116kb/sec but the underlying disks hare having to do
500kb/sec.   MD is doing 1523kb/sec writes and doing 2200kb/sec.  So
the rads are doing needing to do 4x the real reads to recover/rebuilt
the data.   The interesting columns are r/s, rkb/s, r_await (how long
a read takes in ms) and w/s, rkb/s, w_await (how long an write takes
in ms) and the %util.   rrqm is read requests and if you divide kb/s
-> requests it indicates average io is around 4k.

The %util column  is the one to watch.   If the disk is having
internal issues %util will hit close to 100% on lowish reads/writes.
If it gets close to 100% that  is a really bad sign.

You might see what that data looks like when the disk is having
issues.  You might also start using dirty_bytes and
dirty_background_bytes that makes the io suck less when your array
gets slow.

My array has mythtv stuff and security cam images.  During the day I
save all of that to a 500GB ssd, and then at midnight move it to the
long term spinning disk, and during that window my disks are really
busy.  And depending on if a rebuild is running and/or if something
else is going on with the array how long that takes varies with the
amount collected during the day and if there are array issues it takes
longer.  I have been keeping a spare to use in emergencies.
