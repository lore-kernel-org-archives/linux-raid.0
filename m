Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BD75C7EE2E
	for <linux-raid@archiver.kernel.org>; Tue, 13 Jun 2023 12:27:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242422AbjFMM1D (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 13 Jun 2023 08:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236063AbjFMM1C (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 13 Jun 2023 08:27:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7052410DE
        for <linux-raid@vger.kernel.org>; Tue, 13 Jun 2023 05:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686659172;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kdc7U94xkVs29WOVZE2o7NQmpfO54OWwBKACRIySOxQ=;
        b=B0Rahmq0hKjXRhS+CTCnNKkmRkVsY/ZJXUzOoMbnu5IDy3KrrvOT5Ge5wRxSemOG4qkAHa
        dTrFx4XjuM7U2EPns7uJZaBa/hqepsRZI60Lesi5ob8i4Q3x4jsv7EfqY5z8UBqNWIy3zr
        IcVwNNkjVpt6WwqHbsQNLQmGEDJWfkI=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-324-W7iM8unaPm227QpZE81Avw-1; Tue, 13 Jun 2023 08:26:11 -0400
X-MC-Unique: W7iM8unaPm227QpZE81Avw-1
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-39cdb840b72so1679102b6e.0
        for <linux-raid@vger.kernel.org>; Tue, 13 Jun 2023 05:26:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686659170; x=1689251170;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kdc7U94xkVs29WOVZE2o7NQmpfO54OWwBKACRIySOxQ=;
        b=Fh2FeWq707Lw53kJi5jEQtHb9hCoKXdYnpTgv+JJhGIDUUU0rabDt8upIYCHpj2IBy
         c6z8egilAIx1Lo43y1PqKCGYS7g+tfNZbRVMo79JEHeBjlaEd033X/j2k7UsJIizymXU
         WY+hTGwghp6OQTghAo1eE5iuyfjz8vanseI5wIL1Dxn/Yi63HiGz/W+iTRmbGYw8RydD
         JVpfAl/7Y22y3ZosqbQfnyD2eh+fveS64WTcmFUO5fy1VDeSNUHI13nuXBuNKqf7pIO6
         zROl4oBlOZFnXNwUohZKQ8CMtHQJkXT0mFIsNqxOwZ+y7JIwP87gMwdEtU3b2J55BFoB
         AnOQ==
X-Gm-Message-State: AC+VfDyDDoUPcxgXLR1w29o2Z6EyUA1kSKM8GE+QWMbI6SHtkDAO1U3Z
        ltOmcui5KyhhbNyLCQu4COCJEE1Az6P7FwWmqRw7ykv6cO1n/rZSADf7rDW7eZ3GD2uxpBUryuk
        ig7EP/sMqZRG3eriVTSDyUnI8JxmUeX8zjEgsnw==
X-Received: by 2002:a05:6808:aa6:b0:39c:7a71:945 with SMTP id r6-20020a0568080aa600b0039c7a710945mr6665216oij.56.1686659170676;
        Tue, 13 Jun 2023 05:26:10 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ78NH/EDUObpqeiuWTv/ei0rcNTq2G3JcAYYkdP6lUVZNrwES4dFqTfrj6xUXLkqd2QPOhn4hynFlH1BTjrtsI=
X-Received: by 2002:a05:6808:aa6:b0:39c:7a71:945 with SMTP id
 r6-20020a0568080aa600b0039c7a710945mr6665199oij.56.1686659170481; Tue, 13 Jun
 2023 05:26:10 -0700 (PDT)
MIME-Version: 1.0
References: <20230529132037.2124527-1-yukuai1@huaweicloud.com>
 <20230529132037.2124527-3-yukuai1@huaweicloud.com> <b780ccfd-66b1-fdd1-b33e-aa680fbd86f1@redhat.com>
 <1aaf9150-bbd3-87a8-8d54-8b5d63ab5ed3@huaweicloud.com>
In-Reply-To: <1aaf9150-bbd3-87a8-8d54-8b5d63ab5ed3@huaweicloud.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Tue, 13 Jun 2023 20:25:59 +0800
Message-ID: <CALTww2-ta1NUJxcT3Dq5KP7iunnVx24X7RKj1OKYTYwEPeDNrg@mail.gmail.com>
Subject: Re: [dm-devel] [PATCH -next v2 2/6] md: refactor action_store() for
 'idle' and 'frozen'
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     guoqing.jiang@linux.dev, agk@redhat.com, snitzer@kernel.org,
        dm-devel@redhat.com, song@kernel.org, yi.zhang@huawei.com,
        yangerkun@huawei.com, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Jun 13, 2023 at 8:00=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2023/06/13 16:02, Xiao Ni =E5=86=99=E9=81=93:
> >
> > =E5=9C=A8 2023/5/29 =E4=B8=8B=E5=8D=889:20, Yu Kuai =E5=86=99=E9=81=93:
> >> From: Yu Kuai <yukuai3@huawei.com>
> >>
> >> Prepare to handle 'idle' and 'frozen' differently to fix a deadlock,
> >> there
> >> are no functional changes except that MD_RECOVERY_RUNNING is checked
> >> again after 'reconfig_mutex' is held.
> >
> >
> > Can you explain more about why it needs to check MD_RECOVERY_RUNNING
> > again here?
>
> As I explain in the following comment:

Hi

Who can clear the flag before the lock is held?

Regards
Xiao
> >> +    /*
> >> +     * Check again in case MD_RECOVERY_RUNNING is cleared before lock=
 is
> >> +     * held.
> >> +     */
> >> +    if (!test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
> >> +        mddev_unlock(mddev);
> >> +        return;
> >> +    }
>
> Thanks,
> Kuai
>

