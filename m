Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A901C388F7
	for <linux-raid@archiver.kernel.org>; Tue, 10 Nov 2020 14:24:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABB56206A1
	for <linux-raid@archiver.kernel.org>; Tue, 10 Nov 2020 14:24:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZfmMVbJ0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730703AbgKJOY5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 10 Nov 2020 09:24:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730368AbgKJOY5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 10 Nov 2020 09:24:57 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F1EAC0613CF
        for <linux-raid@vger.kernel.org>; Tue, 10 Nov 2020 06:24:57 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id ed14so5897380qvb.4
        for <linux-raid@vger.kernel.org>; Tue, 10 Nov 2020 06:24:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=Xqnr7MmWc72/0Z0Ixvf6k91L/3A9E9Oc79mqJbMWn2k=;
        b=ZfmMVbJ0845DnGqDuuC47PIT9YH9EUFaK4+EsMhQK9DwRA5D2VZPVq9vrdZ3OXcANd
         axQqx5Q2oAxEj1xAwcr2NdVH3+RQHAFtyjVIAHwGm938rER880DZqwS13JHUSZWbuShb
         eLsIpak2JXLApWZ+15qk0bMUMpnc/d0WO0HF1ocDRNFJoMC0cbIR8a/K6KAV+fnmHA6s
         9tCuufJQE0uLRpF+dNY6KPiatim6Q9oGqMDKg83X9Mq/eVjcQvsFMngtdbZDYhGLR2E2
         nUI9EWDL4kF7L82dFA+ebnTpvCH0GhtueiDAdX/R2i+bHvUKDRnu84v4Z69KIPHTcZuH
         t2Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=Xqnr7MmWc72/0Z0Ixvf6k91L/3A9E9Oc79mqJbMWn2k=;
        b=n+lVPgvDjutnEHCthKpAFAmqCeyuKw5lxIvFWo+/Z0R+8i9ZIdH7cnEJgrDu57GNCV
         Nm3VQbSNiGB0GA+j3j8lwafXV6CGdvauoob4Lc9tVgCqqICAWVc7g7LUU5/bHyeHCsqK
         bQSU4ZkFoRTbcDI1xZqkal1YdKz3nMlcruNodoFnRv8DUbJfSaTTKT4qt4qGBx0IKD78
         JMFLDuMKF3KRQwH3GP44jdt0AOy9JXpFKuY0jDwFB2fZgpdS5NjJeuKlDLBZ+PRy4t3K
         p/xnyVraPq+rBJMBX9zMpGQwaCaEHszcVi77wlJgUIGYbP50jy4gihV79OF67/EdORhD
         6q4g==
X-Gm-Message-State: AOAM5317lI3ozVBsJIRn+7LolCWB3LNNieJoopyV5OaNXiByJlbnsLOR
        ofhM9nwCYRf+aEEFTKSnszjiYOOY5xI=
X-Google-Smtp-Source: ABdhPJxwScRbMrjh/yyr5+SbeLoAqT6rvP/61VFQJxwYGN3wRMV/30lbGVVHXLEt6+6It1ERjuI68Q==
X-Received: by 2002:a0c:f607:: with SMTP id r7mr8922179qvm.47.1605018296243;
        Tue, 10 Nov 2020 06:24:56 -0800 (PST)
Received: from biodora.local ([104.238.233.190])
        by smtp.gmail.com with ESMTPSA id l28sm8504255qkl.7.2020.11.10.06.24.55
        for <linux-raid@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2020 06:24:55 -0800 (PST)
To:     linux-raid@vger.kernel.org
From:   =?UTF-8?Q?Jorge_F=c3=a1bregas?= <jorge.fabregas@gmail.com>
Subject: Events Counter - How it increments
Message-ID: <819ff80e-10d0-8cc6-b34c-418fdea7b57a@gmail.com>
Date:   Tue, 10 Nov 2020 10:24:54 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi everyone,

I'm new to Linux RAID. I've searched for a clear explanation on this but
couldn't find it.

How does the "Events" counter (as shown with mdadm --examine) gets
incremented? On what sort of events?

I was initially confused about the "Events" (thinking on the different
events as reported by mdadm --monitor) but I see this is another thing.
I've seen explanations about it incrementing after performing writes but
I've done some test writes and I don't see the counters changing at all
on my RAID1 arrays.  I've also seen explanations that it increments
whenever there are changes to the superblock?

Thank you.

-- 
Jorge
