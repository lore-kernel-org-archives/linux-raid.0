Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10E43C77B7F
	for <linux-raid@archiver.kernel.org>; Mon,  8 May 2023 22:53:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234049AbjEHWxp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 8 May 2023 18:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234009AbjEHWxo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 8 May 2023 18:53:44 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3824C8A7C
        for <linux-raid@vger.kernel.org>; Mon,  8 May 2023 15:53:37 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id ca18e2360f4ac-760ec550833so395110639f.3
        for <linux-raid@vger.kernel.org>; Mon, 08 May 2023 15:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683586416; x=1686178416;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KBzzpRi5MOsAxncoK9dP1z2sYxXozNLBKNc5KHuOse4=;
        b=W6CV18Oq6AmJKut2gBrrSJrc53WQF0+Q3oudzE8qczy0S3yJ6nAf5F9ez8TTVU4f/D
         W6571YFUEWk/cFztyfzkFJTzLrB7x4b4WBzK8D8Iqj0Pa4BXcUoev4UO4NoTJq2DpK7k
         JXB4ygYt6tP9pqpdKCR7A6ab8Bywe1fCEM9N3GtjtyOqLugSXMAWVtTiobcXs03RSzzX
         MxKspOBefzuASkj93UTPNE+3/e77Oi5mxj6rW69ICoh37wz4abRnTnVJCW0+Iou5AACD
         hzAr8F45h+1QIH/0VYAVIfvVhDYmW666bdXPgMHefKiJLWehAF5DgJ50LrVCJpO3H68B
         snYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683586416; x=1686178416;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KBzzpRi5MOsAxncoK9dP1z2sYxXozNLBKNc5KHuOse4=;
        b=YoODinq3w3zg3lEz1Xbqt+sk2tZg0MI+/GrbZkpkzRs3dtXu8sDMVU1RtZrbfL5jOQ
         JevX49ej2nx+67d8T3ONkt/rmGuB9AHuSQVBh42EpTafCKjZG4m6WelUwMvx1FYhR5CN
         Z9Ap5rrVR9o5kvErG5dBfjdr5sYEd7dNCI1dNfHYvYMv/I6k3oBeItMcmisQhq5+K+/W
         4r5owBWLpjnPMxe4h23r2fVs1aDJPqDEJBW/URnLtWIYmXe3sdwr6DsFbjNXbFTgmQn8
         eizlsBuR1IprskFxsiuH7BSKBgktxBHfm0OtP9AgyHZggv+Xme2zzvmJUjQiGItzLd88
         i/sw==
X-Gm-Message-State: AC+VfDxRXXD2OuMYzhnX7ANVQLD6bOVjOKJRSdvQ8Tr2xBpaHO0Rq0MQ
        hDEhYgcGbo6G8bHAw9fhD2LuRu8mrx3eDGEve3o=
X-Google-Smtp-Source: ACHHUZ6kWMtqWPUckE7qXU1GLq81czRdstpbtfFcrOKcuPrRW5Fo7+hkeAmpk1lYbCi7kJGdT+/zZ9OnP4owrcXwl9o=
X-Received: by 2002:a6b:e819:0:b0:76c:320a:3670 with SMTP id
 f25-20020a6be819000000b0076c320a3670mr5767219ioh.2.1683586416461; Mon, 08 May
 2023 15:53:36 -0700 (PDT)
MIME-Version: 1.0
References: <CAO2ABipzbw6QL5eNa44CQHjiVa-LTvS696Mh9QaTw+qsUKFUCw@mail.gmail.com>
 <6fcbab2f-8211-774a-7aa9-883ed5d74168@huaweicloud.com> <CAO2ABiq5bB0cD7c+cS1Vw2PqSZNadyXUgonfEH6Gwsz8d9OiTQ@mail.gmail.com>
 <04036a22-c0b0-8ca1-0220-a531c47a1e25@huaweicloud.com> <CAO2ABioUC9Wy=7FaPAP+AUmd5S-Xanj2d9JJYkqU4BL8DxW5Bg@mail.gmail.com>
 <b1252ee9-4309-a1a9-d2c4-3e278a3e70b6@huaweicloud.com> <CAO2ABioXHT9c4qPx5S4dKsMZLyE0xLGBzST5tSTu8YPmX4FxYQ@mail.gmail.com>
 <51a28406-f850-5f4e-1d2d-87c06df75a9d@huaweicloud.com> <CAO2ABiqEoi4iB__b7KdYu_jQqmeB8joh5xurHNeXj9583mcjjA@mail.gmail.com>
 <1392b816-bdaf-da5f-acc8-b6677aa71e3b@huaweicloud.com> <CAO2ABiqkg7HobNvXRWrid36+uYwZ3yHqLmbft_FQwzD9-B7mRg@mail.gmail.com>
In-Reply-To: <CAO2ABiqkg7HobNvXRWrid36+uYwZ3yHqLmbft_FQwzD9-B7mRg@mail.gmail.com>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Mon, 8 May 2023 17:53:24 -0500
Message-ID: <CAAMCDec_qt0wsfQ6d1CWc4e3hYtzXabw_sK9ChjMUSkA0cPxXg@mail.gmail.com>
Subject: Re: mdadm grow raid 5 to 6 failure (crash)
To:     David Gilmour <dgilmour76@gmail.com>
Cc:     Yu Kuai <yukuai1@huaweicloud.com>, linux-raid@vger.kernel.org,
        Song Liu <song@kernel.org>, "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, May 8, 2023 at 6:57=E2=80=AFAM David Gilmour <dgilmour76@gmail.com>=
 wrote:
>
> Ok, well I'm willing to try anything at this point. Do you need
> anything from me for a patch? Here is my current kernel details:

grep -i mdadm /etc/udev/rules.d/* /lib/udev/rules.d/*

If you can find a udev rule that starts up the monitor then move that
rule out of the directory, so that on the next assemble try it does
not get started.

If this is the recent bug that is being discussed then anything
accessing the array after the reshape will deadlock the array and the
reshape.
