Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 535DCECAAA1
	for <linux-raid@archiver.kernel.org>; Mon, 12 Sep 2022 08:18:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbiILISh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 12 Sep 2022 04:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbiILISg (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 12 Sep 2022 04:18:36 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC5A627B34
        for <linux-raid@vger.kernel.org>; Mon, 12 Sep 2022 01:18:34 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id f9so12827830lfr.3
        for <linux-raid@vger.kernel.org>; Mon, 12 Sep 2022 01:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=yLcbOxldMeOmHsRwdcsUB1WoSkYkkRYXb/1v234rdy4=;
        b=a3GsA6691EqRyTl16MHR3/Hb+LvnyOB+IiNGLFbSO90QW7HEAGtsEkiMwHth+Wa/Jk
         eqYtESG1MF7jJL0Fa6MQE89azi1zA09EMct0XDby6ZrlxsnykJZa2OT2n9bC1UlBaHM0
         8YWPY2bk43hiw9koiZq3o0owqgH2nFq7YB0wkO8hYtE9z7ym03PotQ1QYmWehJWV8Pt5
         RjOWxzlwRtX0IeaKsR3Kf1G/SJJzs3mX35G7twm4ahu9Yz6Gp8nx6uM3RmylcFY9uTdC
         KLLfoJphHop9RMRl7/pRQneYhhpy3c4DKRgb/zl2/wfROyrYKBwxlabHXzrrpWMYiPu2
         /b9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=yLcbOxldMeOmHsRwdcsUB1WoSkYkkRYXb/1v234rdy4=;
        b=fVlPOf8FrVYqr8m8d+wLiYbGAgboRI80eJ/CGKhlRsabjUTPQcrLy9fMolzs5cfV9d
         61MpTry7m6NMMGp5MkPaqnR9gi3zB4DIu2mKTEXm9lM0WjktKULQ2zfkUXZqX4FxhOYk
         mq1fBuv/V1OH0q8P/+Ie8X7b+AwjMCiNOFz+rZUMc86XLsHieaq0P5BMIa/XdPYMTg9W
         M3P3FnhdnZx88CiDcAyL0fTd8Txqa5BGjye7mTCV16pelfe+Si2a19my4Vh8jR2TaGao
         AMzI2mub/tFOwE4nD7lDq99Y92Yslre7BuQkT4wYFcUfJL45fjdklSzZ6wTcyL4MrUo7
         MGrg==
X-Gm-Message-State: ACgBeo1Q3q6qe1AWWTvgsGvJn8ynsBHSr50UkDn4F/ecJJB3N4mrmmtY
        vnzeI9YGH/QeGvW/onD08H9HIjXI0R7AQwetLIg=
X-Google-Smtp-Source: AA6agR71+Ad8SfnOMes2NwH8LpL8wgcWiZQltb57eSaKwol5OWRWB6VGR0Tbldp+vJpEhNC1qrXPiEFTFGJnqAAGewM=
X-Received: by 2002:a05:6512:311a:b0:498:f5dc:799d with SMTP id
 n26-20020a056512311a00b00498f5dc799dmr5274681lfb.501.1662970713070; Mon, 12
 Sep 2022 01:18:33 -0700 (PDT)
MIME-Version: 1.0
References: <CAJH6TXj0y_bfJ1q50S7xnTyz_4BSrgNboim9e+zK1nKZX9MR3g@mail.gmail.com>
 <53f5754d-e3e2-a8ba-bedb-07eb2b594595@thelounge.net> <CAJH6TXi=pCvV2xcyWcOD4KVDP6BcoPdgdMqhSwyW9BMVEhtzYA@mail.gmail.com>
 <dcef59a2-b8f6-ef8b-2fd6-2c8bfdfba4ad@thelounge.net> <2bcebfce-6def-38f8-99be-1f5702905f94@youngman.org.uk>
 <fe532dc9-daef-e096-f729-d1cd752f18d2@thelounge.net>
In-Reply-To: <fe532dc9-daef-e096-f729-d1cd752f18d2@thelounge.net>
From:   Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Date:   Mon, 12 Sep 2022 10:18:20 +0200
Message-ID: <CAJH6TXhXxs=qeYFq1gumDeK=k9PBUuMFwGx-TPt21foMPiJ5VA@mail.gmail.com>
Subject: Re: 3 way mirror
To:     Reindl Harald <h.reindl@thelounge.net>
Cc:     Wols Lists <antlists@youngman.org.uk>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Il giorno lun 12 set 2022 alle ore 10:16 Reindl Harald
<h.reindl@thelounge.net> ha scritto:
> i don't expect any SMART error at all and if one hits after years of
> uptime fine that the drive don't fail completly - but would i trust it? no!

Same here.
