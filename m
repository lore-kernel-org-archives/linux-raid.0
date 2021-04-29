Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5358CC433ED
	for <linux-raid@archiver.kernel.org>; Thu, 29 Apr 2021 22:14:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1467A61463
	for <linux-raid@archiver.kernel.org>; Thu, 29 Apr 2021 22:14:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbhD2WO7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 29 Apr 2021 18:14:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36436 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbhD2WO7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 29 Apr 2021 18:14:59 -0400
Received: from mail-pg1-f197.google.com ([209.85.215.197])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <matthew.ruffell@canonical.com>)
        id 1lcEv7-0006TW-E7
        for linux-raid@vger.kernel.org; Thu, 29 Apr 2021 22:14:05 +0000
Received: by mail-pg1-f197.google.com with SMTP id m36-20020a634c640000b02901fbb60ec3a6so23675808pgl.15
        for <linux-raid@vger.kernel.org>; Thu, 29 Apr 2021 15:14:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=QgsWf7Yqqo+/RN9txyd7qvZjC+YxWkPrNWjS7tr+Hig=;
        b=ozo6tq7f+CGzjNE0tTaBTZvE5vUWD/H3c6xxRQosMajF0xAliFLZMlaVKmEGKHtStm
         ri5ZbIe/Htr/YkOK2rRrK69bv9dWSTifJVcd6gIW7LQIphJFj9wUYWykXxVz2jeq7juW
         9QY4t9blybWonnwURyefK2cUinIjbFODX+16wO4oUFB+Q+bKlfinf/IRdl25183gtU+M
         X5hOHZ1r4LoIVfnu4qJwfAKu0UxXt+Xtfde8OC1No50pgURWtrfeEnNF5jgLM53O9+ig
         FagLapn+VphA6GC2CrMIT2oHIfPTgttgwoGlziTqHnCOSSCUrTgq1orIxYPIRwAjqAXh
         pA/w==
X-Gm-Message-State: AOAM533lC/GxH5wtHaOvSxWiYJ5DdOnbSi3iutoFqDf4gtRDAlEQ2ZLJ
        EdiQ6gTgwOpQvLrbT0YQW2ernzFVzL9pAW8Fasztx/RRZKHLg4zn1Qo66+m2Ez70W5DXhoMdqlk
        I6Fu0/LGoV+BkZKO90dPqCKEJjq0H+EDNMludlKQ=
X-Received: by 2002:a05:6a00:150d:b029:27a:ce95:bb0e with SMTP id q13-20020a056a00150db029027ace95bb0emr1867081pfu.64.1619734443996;
        Thu, 29 Apr 2021 15:14:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxjb2FNHAo8qT/cTKTND0W0E5SX3CTE/GBTiKsKTK0gpPeOj9qqn7zYzH74htmkVEXtb4+Vmw==
X-Received: by 2002:a05:6a00:150d:b029:27a:ce95:bb0e with SMTP id q13-20020a056a00150db029027ace95bb0emr1867068pfu.64.1619734443733;
        Thu, 29 Apr 2021 15:14:03 -0700 (PDT)
Received: from [192.168.1.107] (122-58-78-211-adsl.sparkbb.co.nz. [122.58.78.211])
        by smtp.gmail.com with ESMTPSA id n20sm890386pgv.15.2021.04.29.15.14.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Apr 2021 15:14:03 -0700 (PDT)
To:     Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc:     linux-raid <linux-raid@vger.kernel.org>, Xiao Ni <xni@redhat.com>
From:   Matthew Ruffell <matthew.ruffell@canonical.com>
Subject: Raid1 and Raid10 Discard Limit Fixups for 5.13 Merge Window
Message-ID: <158e5646-ee2c-ae9c-adb1-1c0d4db1ca6d@canonical.com>
Date:   Fri, 30 Apr 2021 10:13:57 +1200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Mike,

The Raid10 block discard performance patchset from Xiao Ni has reached mainline
this morning in the following commits:

254c271da071 md/raid10: improve discard request for far layout
d30588b2731f md/raid10: improve raid10 discard request
f2e7e269a752 md/raid10: pull the code that wait for blocked dev into one function
c2968285925a md/raid10: extend r10bio devs to raid disks
cf78408f937a md: add md_submit_discard_bio() for submitting discard bio

I was wondering, are you planning to resubmit your patches to fixup discard
limits for raid1 and raid10 this merge cycle?

commit e0910c8e4f87bb9f767e61a778b0d9271c4dc512
Author: Mike Snitzer <snitzer@redhat.com>
Date: Thu Sep 24 13:14:52 2020 -0400
Subject: dm raid: fix discard limits for raid1 and raid10
Link: https://github.com/torvalds/linux/commit/e0910c8e4f87bb9f767e61a778b0d9271c4dc512

commit f0e90b6c663a7e3b4736cb318c6c7c589f152c28
Author: Mike Snitzer <snitzer@redhat.com>
Date: Thu Sep 24 16:40:12 2020 -0400
Subject: dm raid: remove unnecessary discard limits for raid10
Link: https://github.com/torvalds/linux/commit/f0e90b6c663a7e3b4736cb318c6c7c589f152c28

Thanks,
Matthew
