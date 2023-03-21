Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9B70C74A5B
	for <linux-raid@archiver.kernel.org>; Tue, 21 Mar 2023 13:53:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbjCUNxo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 21 Mar 2023 09:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231322AbjCUNxk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 21 Mar 2023 09:53:40 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C3AB4FA94;
        Tue, 21 Mar 2023 06:53:18 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id r11so59980843edd.5;
        Tue, 21 Mar 2023 06:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679406796;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8W6ejF7gmj1PXpTdZI2xA9f/8wOpeSmMndaGTr9oNFw=;
        b=hUoV97dpkPfmUSFYW4vwoWzUklDsHrRtC38eT2rA4UxLiATRCd9kZdBJfSJ0lvrqio
         hWtKOo3saKK9qyyGKbUJftte/nNlb0bdYnjc51Osghwez7Y4vkGQojC5nlV2pGMhqt+2
         Ghj29IM7cx22VrkFksNf1zyDVVgPEY/EpK59lfqko2VsKkQhXNyNlwL/i0LKXtYaxvfe
         I1OexL8I7Vuv7G8u9YNkZ2TSv1kfEnOVFqJbNNBuGvnfSBJ01JaXjGNSmEu+6i0vbufI
         8wvVYRv4n3R1DuRtGudFKpS4BXygCifbi1j/DTr2YGK5hXKs3dWjtyBq6jpyJvVc86kJ
         1dpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679406796;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8W6ejF7gmj1PXpTdZI2xA9f/8wOpeSmMndaGTr9oNFw=;
        b=a9Hcb0YFLg/QWQzVcYvSgBNK6rrWNQTvwrnk3MRHKpzLFZCrevYNIbj4hVyMY3Z5kA
         sndFNc7wzMvQ6XPgkkYuDJWQIZ8p2E3VaHrG1pAbfiw/FjeKPyy/DlciNZ2lmtSyGUdk
         itrhLdoyY6tRehhRMVBE4u8tD+h+ZYKaAw4pYOXrxWBLoZU9rBJLxDRxFV7aNZOlMPRR
         X3zjUBGHgkmbv5vRGej9tUz798EiwLi2ic54PMVbVqRsZS50OKjYlXZV374QQKoOG57X
         m9/Jjl+dvDcW4nK/OiG9Uhlm9ltzJKS7s2VagU7ACBJy0eNpX0JKNPUsgMx4jRUFi74c
         KMDA==
X-Gm-Message-State: AO0yUKXSS1Q0CalB2N4jr7PlsY+M/B29PmrcjXGCc/kGfRUyCZ/32i9v
        6Y082FMjaH3t1Xai7h6w/GkV5fp1aqCijBVnh9Pfmn9X9U3KOg==
X-Google-Smtp-Source: AK7set/s5RxMFyLJ3g71CZ2H3wSgUc+1I0vaYBez5Vxx/7wCI9wP3s5ElkFf/xSD0ekVeCy826N1b1k+nOXGwbH0HWE=
X-Received: by 2002:a50:ce45:0:b0:4fb:80cf:898b with SMTP id
 k5-20020a50ce45000000b004fb80cf898bmr1595691edj.7.1679406796401; Tue, 21 Mar
 2023 06:53:16 -0700 (PDT)
MIME-Version: 1.0
From:   lacsaP Patatetom <patatetom@gmail.com>
Date:   Tue, 21 Mar 2023 14:52:54 +0100
Message-ID: <CAGhAadc4tfjpB1UJ2WkUVLSkvbsShi+Ek6XUGL=0NbTU9tsGAQ@mail.gmail.com>
Subject: RO device/partition "tampered" by LVM
To:     linux-block@vger.kernel.org
Cc:     linux-raid@vger.kernel.org, dm-devel@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

hello developers,

until recently, I used to modify the `bio_check_ro` function of the
`block/blk-core.c` file to prevent LVM from altering read-only
partitions.

is it possible to get this behavior back after the many changes
applied to the `block/blk-core.c` file and especially to the
`bio_check_ro` function ?
if yes, can you tell me how to do it ?
otherwise, would retrograde only the `block/blk-core.c` file in a
previous version work ?

here is a GitHub page that details what I said :
https://github.com/patatetom/lvm-on-readonly-block-device .

on this subject, do you know of any other technologies such as LVM
that would alter a disk or partition marked as read-only, which would
ignore the administrator's wish ?

regards, lacsaP.
