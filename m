Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02923C49361
	for <linux-raid@archiver.kernel.org>; Fri, 18 Jun 2021 06:28:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA82760C41
	for <linux-raid@archiver.kernel.org>; Fri, 18 Jun 2021 06:28:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbhFRGa2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 18 Jun 2021 02:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbhFRGa2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 18 Jun 2021 02:30:28 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DECFFC061574;
        Thu, 17 Jun 2021 23:28:18 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id o88-20020a17090a0a61b029016eeb2adf66so7304169pjo.4;
        Thu, 17 Jun 2021 23:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=M6beGftZ6HzB/2zLejc0x0KUVBzu5WNGnCTq45AAQ6M=;
        b=k3u3gvyOEfxusX0cqTRVlj+dZW17lVZZ+oUc/l6cg8oBfzo2w6+R3Yvhjt6ID/rGIh
         y3q8GTo0F5NQA6dsH2wr9ABXxbdpgyVySIV1CBCsxgeknlZbg0SseW+RjAobEXNc3QRO
         sEq+Alr+WdH3GLFjAw3SqCzlaSNj8IwGdRS48x+8gY43clkBWOO5hS2EdmWr6mYYGyiQ
         KArBQbGRPyyHxWJ4sY3kudnBjPFlIfdkPqoFw6Z62MMXtrnCAKEEu0KfQCSYDE9zIapF
         Az1vSyfHyrsp6AeCUCNQM2VNbeMTocTF+5p7A5BunvBD9okIL7vKP2/rWX41mNw6nYfm
         nPeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=M6beGftZ6HzB/2zLejc0x0KUVBzu5WNGnCTq45AAQ6M=;
        b=mm8xiqvlJrZmHfklEz51kY52nSgVEfKZEhWkrHSZ4X5r7zQdQlr3IW9mBcgphQc8iz
         sZHcnfRqPlndWJfEhXmn8PS3KVyGzlcnwk4zChi5XKw2q4Dq5rcWntK3Gr9ii9QHUB7E
         jXHXek0c/cmftAxu+j1QUep8WZwd6bi9jtcOBo8Gs3yEB1e1bQ2v7rNmtHl2+xh9yrAi
         49mqI2RgwZn8gzHH4WYKoKmz5mlW/rJAXbBuHqRU7fMlJRq8dgyH71Poce/Museeo6JG
         vywqCJ/BJqaAV801Wk6xrrrRtY+kUzlBx4s+DwuylN6Fp8BSQmcrKXdxESCJVz5b0b70
         ORzA==
X-Gm-Message-State: AOAM5305BGmRr+w2CLRgE58RwXhBUeBFJLX9kwu4Vw9HL8YQwUeHKkve
        aE0MkxOU493c75/ucORseQw=
X-Google-Smtp-Source: ABdhPJzRtGJ6PRu7uu7Kf4LjKkm4vJl9S6XnSR5bFbXW6D+W6qR0LCXk/B7RnhJ+F4SSHnD6DMMKxg==
X-Received: by 2002:a17:90a:7345:: with SMTP id j5mr20249127pjs.64.1623997698426;
        Thu, 17 Jun 2021 23:28:18 -0700 (PDT)
Received: from [10.7.3.1] ([133.130.111.179])
        by smtp.gmail.com with ESMTPSA id t62sm7052643pfc.189.2021.06.17.23.28.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Jun 2021 23:28:17 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.6\))
Subject: Re: [Bug Report] Discard bios cannot be correctly merged in blk-mq
From:   Wang Shanker <shankerwangmiao@gmail.com>
In-Reply-To: <ED5B1993-9D44-4B9C-A7DF-72BD2375A216@gmail.com>
Date:   Fri, 18 Jun 2021 14:28:11 +0800
Cc:     Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-raid@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <13C1B2E3-B177-4B05-9FF3-AEE57E964605@gmail.com>
References: <85F98DA6-FB28-4C1F-A47D-C410A7C22A3D@gmail.com>
 <YL4Z/QJCKc0NCV5L@T590> <C866C380-7A71-4722-957F-2CE65BDACF26@gmail.com>
 <YMAOO3XjOUl2IG+4@T590> <1C6DB607-B7BE-4257-8384-427BB490C9C0@gmail.com>
 <CALTww28L7afRdVdBf-KsyF6Hvf-8-CORSCpZJAvnVbDRo6chDQ@mail.gmail.com>
 <ED5B1993-9D44-4B9C-A7DF-72BD2375A216@gmail.com>
To:     Xiao Ni <xni@redhat.com>
X-Mailer: Apple Mail (2.3608.120.23.2.6)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi, Xiao

Any ideas on this issue?

Cheers,

Miao Wang

> 2021=E5=B9=B406=E6=9C=8809=E6=97=A5 17:03=EF=BC=8CWang Shanker =
<shankerwangmiao@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
>>=20
>> 2021=E5=B9=B406=E6=9C=8809=E6=97=A5 16:44=EF=BC=8CXiao Ni =
<xni@redhat.com> =E5=86=99=E9=81=93=EF=BC=9A
>>=20
>> Hi all
>>=20
>> Thanks for reporting about this. I did a test in my environment.
>> time blkdiscard /dev/nvme5n1  (477GB)
>> real    0m0.398s
>> time blkdiscard /dev/md0
>> real    9m16.569s
>>=20
>> I'm not familiar with the block layer codes. I'll try to understand
>> the codes related with discard request and
>> try to fix this problem.
>>=20
>> I have a question for raid5 discard, it needs to consider more than
>> raid0 and raid10. For example, there is a raid5 with 3 disks.
>> D11 D21 P1 (stripe size is 4KB)
>> D12 D22 P2
>> D13 D23 P3
>> D14 D24 P4
>> ...  (chunk size is 512KB)
>> If there is a discard request on D13 and D14, and there is no discard
>> request on D23 D24. It can't send
>> discard request to D13 and D14, right? P3 =3D D23 xor D13. If we =
discard
>> D13 and disk2 is broken, it can't
>> get the right data from D13 and P3. The discard request on D13 can
>> write 0 to the discard region, right?
>=20
> Yes. It can be seen at the beginning of make_discard_request(), where
> the requested range being discarded is aligned to ``stripe_sectors",=20=

> which should be chunk_sectors * nr_data_disks.
>=20
> Cheers,
>=20
> Miao Wang

