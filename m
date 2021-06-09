Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68073C47095
	for <linux-raid@archiver.kernel.org>; Wed,  9 Jun 2021 09:04:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B97861181
	for <linux-raid@archiver.kernel.org>; Wed,  9 Jun 2021 09:04:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237789AbhFIJGh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 9 Jun 2021 05:06:37 -0400
Received: from mail-pj1-f54.google.com ([209.85.216.54]:53038 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237085AbhFIJGh (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 9 Jun 2021 05:06:37 -0400
Received: by mail-pj1-f54.google.com with SMTP id h16so975392pjv.2;
        Wed, 09 Jun 2021 02:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=p509XquklGPlHgIgLviWSLP6RC8IGBzAqX0rlKOEPB0=;
        b=arQmByQXbbDKQBLqyclwq5I0Fm2ow+XetxFCyzjadndLtrmHo+Lf/AWvEu7/LACjJS
         2KcfUQCQRXfyX1u4c4CdC/v+L3WM6A7wTdCzA0Ih7/UKkJGcWZ2IGxum+H0y1euuO80P
         sh1jo528WfjWEfVXbJJ9mkUuIScDKOK0ArRP9uque7qjTXfDHE+1wyBaJz92PyLTtGq/
         Q/5RMnTncYG6Zwu55T5JUmuHQlY7x5qgUQyBDLomrrfhGBZgZ2+Euz38KsHm82KZGeMQ
         mUnV0Fa9d65Dk5dO9vHjlHEItRx+k1WkD+bu7GSupweYzRgJNbY/3vkr7dBn8m1uE5ep
         FC1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=p509XquklGPlHgIgLviWSLP6RC8IGBzAqX0rlKOEPB0=;
        b=VMtLDqPC9kZIucM10Gu58q4Gg3NTPw/N1mgnjBuZdlEcvbFqXTj+TiTkuEUl5MgbEu
         L3+OUwSrkQiQER71LwBL7ifWPvf6ZemMMhy+ZkeC6kBpVLP+aHSFtt9/1BlRmtop8/qR
         vfaijGRvVTBDwbLfALCAzu1Hq7JRcJ578vvOwQa/ZqJdOQGWc8pU5QtZtX53oj/Cr/vS
         gprXlP80S0Zty8c5xY5fZ+Eb4NG4++scZh3eUF1yehrbUXmn3lG4Sv2r2x0AUWePFgC4
         vge1CeLTNtjm3GppanAymCiN+wCDOQJ3cHbigpuFyYnEe1Z2ZWE5mB7+CW4UXGvqLJtD
         ouQA==
X-Gm-Message-State: AOAM531XeMvF1iTZJ0W4XpswD9NmPPHcKAmdODnv2b7JZYocWdwHGKI6
        zpiwMn5sXWGHDjwXjQL0EmM=
X-Google-Smtp-Source: ABdhPJwnJjEeG/UnQ9HkZG2AGk2j8LX0p5mr5IbXIQAQlGbykdC126JUSdkQ3T1basqET5VuuDBk3Q==
X-Received: by 2002:a17:902:8484:b029:101:7016:fb7b with SMTP id c4-20020a1709028484b02901017016fb7bmr4015286plo.23.1623229407608;
        Wed, 09 Jun 2021 02:03:27 -0700 (PDT)
Received: from [10.7.3.1] ([133.130.111.179])
        by smtp.gmail.com with ESMTPSA id s3sm14846565pgs.62.2021.06.09.02.03.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Jun 2021 02:03:27 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.6\))
Subject: Re: [Bug Report] Discard bios cannot be correctly merged in blk-mq
From:   Wang Shanker <shankerwangmiao@gmail.com>
In-Reply-To: <CALTww28L7afRdVdBf-KsyF6Hvf-8-CORSCpZJAvnVbDRo6chDQ@mail.gmail.com>
Date:   Wed, 9 Jun 2021 17:03:22 +0800
Cc:     Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-raid@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <ED5B1993-9D44-4B9C-A7DF-72BD2375A216@gmail.com>
References: <85F98DA6-FB28-4C1F-A47D-C410A7C22A3D@gmail.com>
 <YL4Z/QJCKc0NCV5L@T590> <C866C380-7A71-4722-957F-2CE65BDACF26@gmail.com>
 <YMAOO3XjOUl2IG+4@T590> <1C6DB607-B7BE-4257-8384-427BB490C9C0@gmail.com>
 <CALTww28L7afRdVdBf-KsyF6Hvf-8-CORSCpZJAvnVbDRo6chDQ@mail.gmail.com>
To:     Xiao Ni <xni@redhat.com>
X-Mailer: Apple Mail (2.3608.120.23.2.6)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


> 2021=E5=B9=B406=E6=9C=8809=E6=97=A5 16:44=EF=BC=8CXiao Ni =
<xni@redhat.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hi all
>=20
> Thanks for reporting about this. I did a test in my environment.
> time blkdiscard /dev/nvme5n1  (477GB)
> real    0m0.398s
> time blkdiscard /dev/md0
> real    9m16.569s
>=20
> I'm not familiar with the block layer codes. I'll try to understand
> the codes related with discard request and
> try to fix this problem.
>=20
> I have a question for raid5 discard, it needs to consider more than
> raid0 and raid10. For example, there is a raid5 with 3 disks.
> D11 D21 P1 (stripe size is 4KB)
> D12 D22 P2
> D13 D23 P3
> D14 D24 P4
> ...  (chunk size is 512KB)
> If there is a discard request on D13 and D14, and there is no discard
> request on D23 D24. It can't send
> discard request to D13 and D14, right? P3 =3D D23 xor D13. If we =
discard
> D13 and disk2 is broken, it can't
> get the right data from D13 and P3. The discard request on D13 can
> write 0 to the discard region, right?

Yes. It can be seen at the beginning of make_discard_request(), where
the requested range being discarded is aligned to ``stripe_sectors",=20
which should be chunk_sectors * nr_data_disks.

Cheers,

Miao Wang

