Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18025C6FD1D
	for <linux-raid@archiver.kernel.org>; Mon, 20 Mar 2023 06:26:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbjCTG0q (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 20 Mar 2023 02:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjCTG0p (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 20 Mar 2023 02:26:45 -0400
Received: from mail-ua1-x92a.google.com (mail-ua1-x92a.google.com [IPv6:2607:f8b0:4864:20::92a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1883CE
        for <linux-raid@vger.kernel.org>; Sun, 19 Mar 2023 23:26:44 -0700 (PDT)
Received: by mail-ua1-x92a.google.com with SMTP id i22so7127299uat.8
        for <linux-raid@vger.kernel.org>; Sun, 19 Mar 2023 23:26:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679293603;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=njiqQA3dfvPD7qZBDbsUICmcJeu2iJVZOJpThgLxyOA=;
        b=Yq9TyE8vnJCN4jtwW3icT+6u8j2R6/1fC7wF98r8umKAqFc8xf2MioEIeYuee1AIsU
         U/5lyA4rM39oF7l6sUcJW2EqvfmRtUsWHhC0WyUHzoWec/SmQXyd0g+Z+pSd5VPA0M2R
         cBhfXx1BdQrVNFBthScc0sk6ynyh8jPVLK0nysPXTMhkj45aJHHv2U7dxTFQKyuChwqh
         IC6T+I8IZerGA4q96/jRYGTK9utqaiJet4TK9rv3dNZvOPGpKfhQ2tJ8256+AG7mZkvO
         ik9ZHHDXEf3bvNSZiIM9oc2WiZBeslb19LPryjAYZgrgIrLfRqdALSAotgAHQukJR3mH
         wQow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679293603;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=njiqQA3dfvPD7qZBDbsUICmcJeu2iJVZOJpThgLxyOA=;
        b=gewfshzoGbYkBa59FmPw95oh5GVAemqZS2hYr9D5UoPTksiLJHUjg9oao8oOO5pHsv
         8A9sz2yZ8TVX19Q9vqV8Y4ld46eWyfZsJN0WDetVrg3x/FeUXgfrVXikQjt/81Gbcv92
         Z7cmOK9k9Iq+5xgbjS2cRHMKIuZt+Rtpt9xU5kSTV4Gocex+0RuUT0+TjEjaVrA3vJqE
         Geum3ugyc20cf1O9/Zs/r/r29plGEUc4d+HmL2JMg+0StUk6Hm8zQHAr3aBgMEmuZMFj
         YonZ60xuRD6xmpGrlGGZviL34EahAHtXScMItyDpmL7APv2+/QzivRIpiNIR7AoSjQf+
         vHMg==
X-Gm-Message-State: AO0yUKWUU0791C4vF9GwuUY0bO3lEQ356Pva8F5HojN4jBBb6TPzSYD0
        X6nWiNrC3Qu75xM5k0N5JyEbrdEDHtzuyGFqDnl463sVQ0MM8A==
X-Google-Smtp-Source: AK7set9ZvMjtkjGnQwDh4aWBFihytbVw44RHNQLEH91Ib8r7bYdZVxWqWy1PsXWMEkQiymP2fApSHXU6a6xHgmDKvvE=
X-Received: by 2002:a05:6130:325:b0:688:d612:2024 with SMTP id
 ay37-20020a056130032500b00688d6122024mr3948645uab.2.1679293603570; Sun, 19
 Mar 2023 23:26:43 -0700 (PDT)
MIME-Version: 1.0
References: <20230216044134.30581-1-kev.friedberg@gmail.com>
In-Reply-To: <20230216044134.30581-1-kev.friedberg@gmail.com>
From:   Kevin Friedberg <kev.friedberg@gmail.com>
Date:   Mon, 20 Mar 2023 02:26:31 -0400
Message-ID: <CAEJbB426WWdu5KESE1T+T0JHSKx3CGjUcpdZ5yhppsxyXNJDvw@mail.gmail.com>
Subject: Re: [PATCH] enable RAID for SATA under VMD
To:     linux-raid@vger.kernel.org, mariusz.tkaczyk@linux.intel.com
Cc:     Kevin Friedberg <kev.friedberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Mariusz,

You mentioned on the previous version of this patch that it might be a
while before it could be tested.  Have you had a chance to try this
revision?
