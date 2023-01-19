Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95E06C38142
	for <linux-raid@archiver.kernel.org>; Thu, 19 Jan 2023 10:55:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbjASKzT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 19 Jan 2023 05:55:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbjASKzI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 19 Jan 2023 05:55:08 -0500
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F784ABFF
        for <linux-raid@vger.kernel.org>; Thu, 19 Jan 2023 02:55:06 -0800 (PST)
Received: by mail-vs1-xe35.google.com with SMTP id 3so1704739vsq.7
        for <linux-raid@vger.kernel.org>; Thu, 19 Jan 2023 02:55:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HU/pnOZYgJ2SpGrPDXce4RvNZtRSAHBUc68+RlbrRf4=;
        b=KQUpkkI7fwH5bSh62ZwzdnloHQrgrM7kAGV9A9Gf/CXUTJO3YAipzSExFXI9oicHTw
         yQQJDhDfrQtC3tqnJxmKGFyLwcn2GL4R/70paaDjkTEXdB9Lv9/TlOCZoA4+DxgqjZ21
         MhR/sQSgqiBg+4gaUFBKL/i4HFjC5pKfap1n2C3eAEPcJ/bpPRNeyhSe6i+0r79JoQLW
         HENL9zO5b5SSD4xOE26JF1LZ3CJ1TG1Jf7RHgT8sl2KqUH4uQksAs4rrlL4q2w87J2hJ
         qS7A8U3hQfngl16D9Ci4K2EWJH1YRUKD1Vq6+XV2cuWQtG0WzonXsGG4Lm1IG8hF9z/q
         o3vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HU/pnOZYgJ2SpGrPDXce4RvNZtRSAHBUc68+RlbrRf4=;
        b=H7z0Q5/OvSHufJGsMeL923YA0NsVBEPN9lDervaqH2kycvD7dv0srTH//1JsZQjCPI
         qBp8PNaCHepQzveuS1Q7wBH5oFYRehwvb60NORaITp5GKgIr0E51q7YSedN6GuZ57MXm
         dr3VcQtlRysmi29SwrVgQ8PSiHzbg+xxiUJl6XzN1PcSR96iFQlWH6m9L2rqpBVTmchJ
         VsNZJw55xfN/nNvysfTTurQBrTYlgPfOdSFFBiqGqHjPiIJBBkfD/RLDpp6MqZLwV/yE
         pkAAwBNsjEexeLF32DieGzgjmUeJZjxTwaAQTeDEEVN1FAYjeH9oS2mxDFYhdB86ugAE
         aKFA==
X-Gm-Message-State: AFqh2ko0+OscF3Ikm6nIz3Vvdco+n8DH66n0yJxN/KQDtytOWvx4UKsU
        Qm2bl7hizpNUgdkta8YiC6L+xO/8Qf7Y/AoWo0jqR5+I10g=
X-Google-Smtp-Source: AMrXdXuzuJ62FLj4yxwgVb02fgowvx3uO95hok2toa9e6QVdmn/k1vzagC+3LZY1TH1ov/PNWtIHOBd7NVDyGAk0NjM=
X-Received: by 2002:a05:6102:1349:b0:3b1:3552:cb03 with SMTP id
 j9-20020a056102134900b003b13552cb03mr1678184vsl.53.1674125705053; Thu, 19 Jan
 2023 02:55:05 -0800 (PST)
MIME-Version: 1.0
References: <CAMnA3U1b6n34SzNh9RQROyP-=AkN9ZsLunm_aokV+BDAeR2vrw@mail.gmail.com>
 <CAMnA3U00_JONs-e8afbUE+EOf2Zex0wOKSaWc1YxeF5hQh5nQQ@mail.gmail.com>
 <3199b9d7-3974-a953-e101-f48d8661fd2b@youngman.org.uk> <CAMnA3U0NfnunoTfQJ5VmkRVWFP3KCXU4ZZgmY7zTMHaHrL2CUw@mail.gmail.com>
 <02c27a6b-1675-16ca-5261-78b02f7142f4@youngman.org.uk>
In-Reply-To: <02c27a6b-1675-16ca-5261-78b02f7142f4@youngman.org.uk>
From:   Tiago Afonso <tiaafo@gmail.com>
Date:   Thu, 19 Jan 2023 10:54:53 +0000
Message-ID: <CAMnA3U1ZCXYbFsCOCV5ogX77cN0gTOs54CSLRhR4Z5LkFEnVaA@mail.gmail.com>
Subject: Re: Fwd: RAID 5 growing hanged at 0.0%
To:     Wols Lists <antlists@youngman.org.uk>
Cc:     linux-raid@vger.kernel.org, Phil Turmel <philip@turmel.org>,
        NeilBrown <neilb@suse.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,
So, no other ideas?
I'm thinking of buying 4 toshiba N300 drives to clone these 4 drives,
just so I can be safer in messing around.

BR,
Tiago Afonso
