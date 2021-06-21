Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A971C49EA2
	for <linux-raid@archiver.kernel.org>; Mon, 21 Jun 2021 07:49:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14C2560234
	for <linux-raid@archiver.kernel.org>; Mon, 21 Jun 2021 07:49:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbhFUHvz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 21 Jun 2021 03:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbhFUHvy (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 21 Jun 2021 03:51:54 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06EE3C061574;
        Mon, 21 Jun 2021 00:49:41 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id b1so1308624pls.3;
        Mon, 21 Jun 2021 00:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=DjKS9vGE5sSYyaVRLzs5LXYRJqRewmPN1nZgRkw061w=;
        b=DO7aThUgoQXk7XZNrpVhR+WukvC0BB7vCbNxFmK7I1v51EfTWi5bldqduGW+Osxgn4
         Gc5DTqbsEqjXXNOds0b90PSfjNJ0flHT0dYGSP6y8cWPPbjhN6D2JG2ZWVvJ7VG1j4rz
         N7yHC37j36z8Oi2HBkAcFplPUcDLdeP2q4WfO3tzn2JSL/jmzB3otnep8dGs15l401cf
         u16djVfw6pvvg8pW7mNnLRoKhhZwFF+AuLIz9CNpHDkHrElAe4rJDCI94DKcmVmxHiYr
         garv+ImZBtUxBE4Jvx5Ixc5tu1UJYUcqJmXeBWj9k3wd8Uun/0/Yhc7xbvc1fTMW9PPi
         9sVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=DjKS9vGE5sSYyaVRLzs5LXYRJqRewmPN1nZgRkw061w=;
        b=S+i5c6Y8l5GzEdSBOPWQQpZTj74xXGOboZb4ovxiS1J/OsmUOolmVBKgfHaTY9N6rI
         D1kp2LBMuoiX54rWCRQlgN+yMyu/LdooWIGz6RO5d+nohg/w1r3KCdEY9NXJnT3uRoq1
         eXx2CaqwNcQaKS33hSxhvc2OX0dVxnTsmBrizbsqjTddm/QnAtCnitvcaopG2o7gpWSl
         220K+gYGt2qTuVpkP6ffRYxJKaAB4I76wHHVK27eICcvLWCMe3qRKgUYHJbKkbVbnd/x
         LHMWTStmINrORogMmMh9qjwgIzeQplfiuB7IzeWzqG8+8uxEPzCUARzymbKwJoF/gJfz
         ZvXA==
X-Gm-Message-State: AOAM533AOz0MrYw3UGxwJQL1qVIN0xGmvVdAIDXZX67M21LBor+6B7ZS
        eaEQSqlRZYmOSyp1fQLubhA=
X-Google-Smtp-Source: ABdhPJx4RcNjlv6FXz1VId2Uju31XutNajPF6PPJ2s5pERvF5C5P7G996HKvs8l6JHvxQxejSchCFA==
X-Received: by 2002:a17:90b:393:: with SMTP id ga19mr25555736pjb.182.1624261780539;
        Mon, 21 Jun 2021 00:49:40 -0700 (PDT)
Received: from [10.7.3.1] ([133.130.111.179])
        by smtp.gmail.com with ESMTPSA id z6sm15799794pgs.24.2021.06.21.00.49.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Jun 2021 00:49:40 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.6\))
Subject: Re: [Bug Report] Discard bios cannot be correctly merged in blk-mq
From:   Wang Shanker <shankerwangmiao@gmail.com>
In-Reply-To: <CALTww29rcAwSfbpsBzM_pnVSuVTYyt-YJryeUaNkHetCjXktCg@mail.gmail.com>
Date:   Mon, 21 Jun 2021 15:49:33 +0800
Cc:     Ming Lei <ming.lei@redhat.com>, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <5EFF6838-7ED8-4B14-BD43-4D4E67628149@gmail.com>
References: <85F98DA6-FB28-4C1F-A47D-C410A7C22A3D@gmail.com>
 <YL4Z/QJCKc0NCV5L@T590> <C866C380-7A71-4722-957F-2CE65BDACF26@gmail.com>
 <YMAOO3XjOUl2IG+4@T590> <1C6DB607-B7BE-4257-8384-427BB490C9C0@gmail.com>
 <CALTww28L7afRdVdBf-KsyF6Hvf-8-CORSCpZJAvnVbDRo6chDQ@mail.gmail.com>
 <ED5B1993-9D44-4B9C-A7DF-72BD2375A216@gmail.com>
 <13C1B2E3-B177-4B05-9FF3-AEE57E964605@gmail.com>
 <CALTww29rcAwSfbpsBzM_pnVSuVTYyt-YJryeUaNkHetCjXktCg@mail.gmail.com>
To:     Xiao Ni <xni@redhat.com>
X-Mailer: Apple Mail (2.3608.120.23.2.6)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi, Xiao

Many thanks for your reply. I realized that this problem is not limited=20=

to discard requests. For normal read/write requests, they are also first
get split into 4k-sized ones and then merged into larger ones. The =
merging
of bio's is limited by queue_max_segments, which leads to small trunks =
of
io operations issued to physical devices. It seems that such behavior is
not optimal and should be improved.

I'm not so familiar with raid456. Could you have a look of its code when =
you
are free? It seems that improving this may result in big changes.

Cheers,

Miao Wang

> 2021=E5=B9=B406=E6=9C=8818=E6=97=A5 20:49=EF=BC=8CXiao Ni =
<xni@redhat.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hi Miao
>=20
> So you plan to fix this problem now? The plan is to submit the discard
> bio directly to disk similar with raid0/raid10.
> As we talked, it needs to consider the discard region. It should be
> larger than chunk_sectors * nr_data_disks. It needs
> to split the bio when its size not aligned with chunk_sectors *
> nr_data_disks. And it needs to consider the start address
> of the bio too. If it's not aligned with a start address of
> chunk_sectors, it's better to split this part too.
>=20
> I'm working on another job. So I don't have time to do this now. If
> you submit the patches, I can help to review :)
>=20
> Regards
> Xiao
>=20
> On Fri, Jun 18, 2021 at 2:28 PM Wang Shanker =
<shankerwangmiao@gmail.com> wrote:
>>=20
>> Hi, Xiao
>>=20
>> Any ideas on this issue?
>>=20
>> Cheers,
>>=20
>> Miao Wang
>>=20
>>> 2021=E5=B9=B406=E6=9C=8809=E6=97=A5 17:03=EF=BC=8CWang Shanker =
<shankerwangmiao@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>>>=20
>>>>=20
>>>> 2021=E5=B9=B406=E6=9C=8809=E6=97=A5 16:44=EF=BC=8CXiao Ni =
<xni@redhat.com> =E5=86=99=E9=81=93=EF=BC=9A
>>>>=20
>>>> Hi all
>>>>=20
>>>> Thanks for reporting about this. I did a test in my environment.
>>>> time blkdiscard /dev/nvme5n1  (477GB)
>>>> real    0m0.398s
>>>> time blkdiscard /dev/md0
>>>> real    9m16.569s
>>>>=20
>>>> I'm not familiar with the block layer codes. I'll try to understand
>>>> the codes related with discard request and
>>>> try to fix this problem.
>>>>=20
>>>> I have a question for raid5 discard, it needs to consider more than
>>>> raid0 and raid10. For example, there is a raid5 with 3 disks.
>>>> D11 D21 P1 (stripe size is 4KB)
>>>> D12 D22 P2
>>>> D13 D23 P3
>>>> D14 D24 P4
>>>> ...  (chunk size is 512KB)
>>>> If there is a discard request on D13 and D14, and there is no =
discard
>>>> request on D23 D24. It can't send
>>>> discard request to D13 and D14, right? P3 =3D D23 xor D13. If we =
discard
>>>> D13 and disk2 is broken, it can't
>>>> get the right data from D13 and P3. The discard request on D13 can
>>>> write 0 to the discard region, right?
>>>=20
>>> Yes. It can be seen at the beginning of make_discard_request(), =
where
>>> the requested range being discarded is aligned to ``stripe_sectors",
>>> which should be chunk_sectors * nr_data_disks.
>>>=20
>>> Cheers,
>>>=20
>>> Miao Wang
>>=20
>=20

