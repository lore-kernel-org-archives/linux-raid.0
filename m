Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D73BAC77B7F
	for <linux-raid@archiver.kernel.org>; Sat,  6 May 2023 13:07:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbjEFNHc (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 6 May 2023 09:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232295AbjEFNHa (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 6 May 2023 09:07:30 -0400
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6820B19D61
        for <linux-raid@vger.kernel.org>; Sat,  6 May 2023 06:07:29 -0700 (PDT)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-55a2cb9788dso41294387b3.2
        for <linux-raid@vger.kernel.org>; Sat, 06 May 2023 06:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683378448; x=1685970448;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MrHATtZrICLkiT/yVjJ6S+uolPcN4hoVSAdf2jMrimg=;
        b=Tu7JRLyaYW9tR8GXN8Wc+ORqGYtbyCa24yjH2Bghrvb/z66He2t+HfVecOjBLaSpT1
         P1lA5D7sXt+xmpZYgPCkVanPj+dtqRKAxa7+kYWB+pP4WdHsFvVJSaJld/uVDQ9s2sOa
         hMau3KJXOQ8U6EdN6wd12bONLK/7pJsNF55CKUwi5IE4JPTDDy4pJSOuLi6XJPRgy+aK
         88cNXzKIO1BIQA1lI6DXlHpMwwy6mbvFnI/7TYCEri4FF3G3/OyTysG2Ym9dH7DB5LcI
         XkK+9vmP1nwgUf4BEJ8fwZypJcQraBNeeyWZMOaIJ1qBls+jaJKPGq5jqXQiMtj47in0
         Yk7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683378448; x=1685970448;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MrHATtZrICLkiT/yVjJ6S+uolPcN4hoVSAdf2jMrimg=;
        b=B83takx0kY37S5+Id/J/SObvipoVhlu8Np0aMNsTEBF5/TKRFtBjr3TDa//PRVFMou
         FxGTg++x5qmLMw7PPf1jbk31XXG9K2BLp+fUsI8eIYntuP9wiw9X5sRgmbLvkVeLoFOn
         SLQIgGN/hW2p6MPUzKUXt4bHT+VJ6PLMGxyO8IVthMGdAegU2s8rHwCeaWub4ckvHaaM
         +RleT2NN4hgFMZXnuAsHGz4wwDzjAe/BAApwV3WVQKc1GJp+p+KMz7xOoDY9MS+JUmVe
         KjfoWOpJGWFnhwkBXu4A9yPuczimyUiIhgxPpITTKqNABI3Tz/UQvDgyE+9irUMpujAY
         ryaA==
X-Gm-Message-State: AC+VfDxZ61nvcx8alFOYji9qaG/pQrPWxKQnUc+y90Krz6QNw9UTMxWx
        4BcWlGyODamtLxtWpM/wq1TJcnEMktVXF/a1EmQzKQOgKjMCjQ==
X-Google-Smtp-Source: ACHHUZ7obr58CniMqvz9joWWi2vQruLeRoKOD6xpnY+g2ZLouBWbRW7GocZOpiKF/6Am17e1GvZW7hwpwy0Mu+ZPGVA=
X-Received: by 2002:a0d:e701:0:b0:55a:1c6b:1ea7 with SMTP id
 q1-20020a0de701000000b0055a1c6b1ea7mr4443065ywe.6.1683378448575; Sat, 06 May
 2023 06:07:28 -0700 (PDT)
MIME-Version: 1.0
References: <CAFig2csUV2QiomUhj_t3dPOgV300dbQ6XtM9ygKPdXJFSH__Nw@mail.gmail.com>
 <63d92097-5299-2ae8-9697-768c52678578@huaweicloud.com> <CAFig2ct4BJZ0A9BKuXn8RM71+KrUzB8vKGQY0fSjNZiNenQZBg@mail.gmail.com>
 <c71c8381-f26e-f7de-c6f5-3c4411f08b15@huaweicloud.com> <d159161d-a5eb-8790-49c4-b7013e66ba65@youngman.org.uk>
 <6f391690-992f-1196-3109-6d422b3522f7@huaweicloud.com> <CAFig2ct+ZbHYEho7p9eubaz-kozGR+GkSJ1tVL+LGaciUBixyw@mail.gmail.com>
 <bc698b03-446b-a42e-cf0c-5c1b3cb62559@huaweicloud.com>
In-Reply-To: <bc698b03-446b-a42e-cf0c-5c1b3cb62559@huaweicloud.com>
From:   Jove <jovetoo@gmail.com>
Date:   Sat, 6 May 2023 15:07:17 +0200
Message-ID: <CAFig2csN8qSEafSehM5oN-kO3FsK=6+vvyEeiYcbvqRkmoiN7Q@mail.gmail.com>
Subject: Re: Raid5 to raid6 grow interrupted, mdadm hangs on assemble command
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     Wol <antlists@youngman.org.uk>, linux-raid@vger.kernel.org,
        "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Kuai,

Just to confirm, the array seems fine after the reshape. Copying files now.

Would it be best if I scrap this array and create a new one or is this
array safe to use in the long term? It had to use the --invalid-backup
flag to get it to reshape, so there might be corruption before that
resume point?

I have to do a reshape anyway, to 5 raid devices.

> In the meantime, I'll try to fix this deadlock, hope you don't mind a
> reported-by tag.

I would not, thank you.

I still have the backup images of the drive in reshape. If you wish I
can test any fix you create.

> I have no idea why systemd-udevd is accessing the array.

My guess is it is accessing this array is because it checks it for the
lvm layout so it can automatically create the /dev/mapper entries.
With systemd-udevd disabled, these entries to not automatically
appear.

And thank you again for getting me my data back.

Best regards,

   Johan
