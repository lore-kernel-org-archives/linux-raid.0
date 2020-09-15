Return-Path: <SRS0=ezIp=CY=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0A7BC43461
	for <linux-raid@archiver.kernel.org>; Tue, 15 Sep 2020 22:25:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 975E220659
	for <linux-raid@archiver.kernel.org>; Tue, 15 Sep 2020 22:25:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rF6FLxhF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbgIOWZA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 15 Sep 2020 18:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727661AbgIOQWw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 15 Sep 2020 12:22:52 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F0B8C06178A
        for <linux-raid@vger.kernel.org>; Tue, 15 Sep 2020 08:58:42 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id i17so4402787oig.10
        for <linux-raid@vger.kernel.org>; Tue, 15 Sep 2020 08:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=W2XWjyZ9hGgTd4tIXpXCYZpUPEQmWjaxYl74brc24Zk=;
        b=rF6FLxhFmTGQVTKCu+gR4Zw6XH0FOAmrO5NjPwbeYvHcxzgZzmeJyP4ukKNm39Ok/y
         OyNV1kmBbw/oesdmA8DwlQ3YT0aFRQnr9fErlFOH2FRhMfuxVXreXV2I1R40BF1soNXs
         ZDW2QRLkYk6ytUl3mTpStwpZJQJvQAkvOTQoWbT0g+wwUx+rhRBtLxwPPo0tFvHYO5KZ
         2lQhDyzu69LkHhES8Ahjry2CwBvpc237H50IrhRhwa+P80lL0q3DnyIB/MJtuatb2owO
         jrXbjEAW474tvEQW3cEQCbTfY+u0066qTF2bAd9bDUro3ogu2IwYt9H8WQKzMBPEsDln
         Zt9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=W2XWjyZ9hGgTd4tIXpXCYZpUPEQmWjaxYl74brc24Zk=;
        b=ECEiLs9RBIyBzlFhd7KrLmjNMlxQPOv2rdbYPQE6LXTcy/t2J3aI3LQteY3jzBvMtn
         JZ1Q31ffYkSGeH782xQzOyBce9++o6qLN/xJktym7tpUbgfrHukzr4AdaonpGM/O2+5P
         iIXV9pUiouF3plzCYzNay/HTdndkVDxnTbg/AqFKjhYEwAVhEETvA/D/RqLpg8/HEs1P
         zrQ5CiEWx6IvBKHESGgxDU6wNBxMrwEBZNctCjEwQONJHvl7sni6iQUln5CHIAwV/Ook
         s55CetI0KFIffXEpkdOhnL3E4686v92j9zpJm/t9EPJW388EjcYCuez4nx7AIyfsQ3Db
         j3BA==
X-Gm-Message-State: AOAM530810/9Z0D+LQ3YnsyAmZigORJo65FmMCa7ReGQpdehZYLngLc+
        SRkYAGhVu+qXRh7oj9V9mVSXVXRzJcI=
X-Google-Smtp-Source: ABdhPJxHoJaoiFZ0GIeESuQCjzuikyn0w6Z1n9iYR6htM+G+q3xnLolFNHyqE1IGHw9bmdZPyxM8eQ==
X-Received: by 2002:aca:3056:: with SMTP id w83mr75833oiw.86.1600185520878;
        Tue, 15 Sep 2020 08:58:40 -0700 (PDT)
Received: from ian.penurio.us ([47.184.24.231])
        by smtp.gmail.com with ESMTPSA id j18sm5685756otr.12.2020.09.15.08.58.40
        for <linux-raid@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Sep 2020 08:58:40 -0700 (PDT)
To:     linux-raid@vger.kernel.org
From:   Ian Pilcher <arequipeno@gmail.com>
Subject: IMSM RAID not recognized after kernel update
Message-ID: <2369f081-d9e1-ffa3-d633-d73388ac0017@gmail.com>
Date:   Tue, 15 Sep 2020 10:58:39 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

https://bugzilla.redhat.com/show_bug.cgi?id=1878970

After updating my Fedora kernel package this morning, my IMSM RAID is
no longer recognized:

[pilcher@ian system]$ sudo mdadm --examine --verbose /dev/sdc
/dev/sdc:
    MBR Magic : aa55
Partition[0] :       204800 sectors at         2048 (type 07)
Partition[1] :      2048000 sectors at       206848 (type 83)
Partition[2] :     61440000 sectors at      2254848 (type 07)
Partition[3] :   1889824768 sectors at     63694848 (type 05)

If I boot the older kernel, it says:

[pilcher@ian ~]$ sudo mdadm --examine --verbose /dev/sdc
/dev/sdc:
           Magic : Intel Raid ISM Cfg Sig.
             ⋮

Any tips on what might cause this or how to debug further would be
appreciated.

Thanks!

-- 
========================================================================
                  In Soviet Russia, Google searches you!
========================================================================
