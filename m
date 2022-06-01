Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43E3CC433EF
	for <linux-raid@archiver.kernel.org>; Wed,  1 Jun 2022 23:25:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232545AbiFAXZH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Jun 2022 19:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232543AbiFAXZG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Jun 2022 19:25:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE1D23148
        for <linux-raid@vger.kernel.org>; Wed,  1 Jun 2022 16:25:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01648B81D7B
        for <linux-raid@vger.kernel.org>; Wed,  1 Jun 2022 23:25:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F71DC34119
        for <linux-raid@vger.kernel.org>; Wed,  1 Jun 2022 23:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654125902;
        bh=MjkhCErnYmFL5ghUQOTG8Npy4zM+zvTgn/jBkqNjaCk=;
        h=From:Date:Subject:To:Cc:From;
        b=nMY6o0HQwr4rsMHfdjPuU6s7gHBFycGpzSLej0qIKETchglddw1lwoJW/KsEAg2Zr
         X4E8tzEasrCVoZGKX1HHBOHopzqjnycwvAi+wEeugPPfn5dXF9Ct5uM3zApz1LA2UT
         G68Hn+oUEur98ZG51bY+d9/nw6vftfWkvMN6AFAnryIOz/9m8S3mxyY00iHibSengo
         I6xG1lwQGLfiBB7Yybhyco+D26OD+8KtTLma9joAbPKfqyqy+877ENsuLMsjTzHf6/
         11+uyaAVxyHrhRbLkDGN2rL1P/OM9DtEXoow36OviaEhEU19Aqi99V+1IZiGLk60tb
         Mzg38XlvIF50Q==
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-300628e76f3so34723817b3.12
        for <linux-raid@vger.kernel.org>; Wed, 01 Jun 2022 16:25:02 -0700 (PDT)
X-Gm-Message-State: AOAM530bVhID9ybltCJDTHNuBwcDmOSAcceUoQj2XbJt4FtG6TrPEUi8
        h6hDfuHflfqBBydoYvlyyd2Dk7vkWakcZ/eRlwI=
X-Google-Smtp-Source: ABdhPJwCVqQtzhbqvTMtwPkUb78dQ6HXwlWkkFo9200XW8W1HfveIoNtKlQlCDa633Um0Jrz2/dQqI58/BP3WEpRQq0=
X-Received: by 2002:a81:7505:0:b0:30c:45e3:71bc with SMTP id
 q5-20020a817505000000b0030c45e371bcmr2363616ywc.460.1654125901464; Wed, 01
 Jun 2022 16:25:01 -0700 (PDT)
MIME-Version: 1.0
From:   Song Liu <song@kernel.org>
Date:   Wed, 1 Jun 2022 16:24:51 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7z++hrU2GpSix1vdMEyRpdzQb4gTtCHBXRW9R7jKhGfg@mail.gmail.com>
Message-ID: <CAPhsuW7z++hrU2GpSix1vdMEyRpdzQb4gTtCHBXRW9R7jKhGfg@mail.gmail.com>
Subject: patchwork for md and mdadm development
To:     linux-raid <linux-raid@vger.kernel.org>
Cc:     Jes.Sorensen@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Sharing here for more visibility.

We recently created a patchwork project for md and mdadm, which can be found at:

   https://patchwork.kernel.org/project/linux-raid/list/

This should help the patch review. This will also help us build a CI
framework similar to the bpf CI [1].

Please let us know if you have questions and suggestions on this.

Thanks,
Song & Jes

[1] http://vger.kernel.org/bpfconf2022_material/lsfmmbpf2022-bpf-ci.pdf
