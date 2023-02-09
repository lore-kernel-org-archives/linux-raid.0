Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12A30C636D3
	for <linux-raid@archiver.kernel.org>; Thu,  9 Feb 2023 00:00:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbjBIAAy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 8 Feb 2023 19:00:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjBIAAx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 8 Feb 2023 19:00:53 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A979D1E2AE
        for <linux-raid@vger.kernel.org>; Wed,  8 Feb 2023 16:00:52 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id f6so1015679pln.12
        for <linux-raid@vger.kernel.org>; Wed, 08 Feb 2023 16:00:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Rd/2M5Lw9Bre/ymxMZXiDtXVVwXLhpgtnohMijOYjQY=;
        b=KtylmNKrzei9RSpmHUGIpK96QejXJbx+5hLXcVU0M0WhwKNmrGQtwR6ps2EK1WRutp
         w8KgAcWlw2peBvhVbxshWplAiTBuhtcim8szNf5KhB+vTv9rf9lnCYMgUe5SyGlUaw7V
         eQ32yKcymNVgd8jDYsp5E8D7lMNjzdQDqnCxCjtc+hbR0M8yMi9ng+wGApW2gIc+4vzh
         FDL/fEhmuaKQ5MCSufcuf8r79gLeyBIDIqXoQeucF2x0NBN0BtK/li33Zj7p4M2RRyHV
         10LVE5vUydBK3SrFi63aVC6z66KDamMwXVzodCte39EGQrJKNvIWKSAh0TmkNUv06KV0
         vUIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rd/2M5Lw9Bre/ymxMZXiDtXVVwXLhpgtnohMijOYjQY=;
        b=zr+JYf01GIuemm48UjDKCpCclMPWnjFwMyJonlP1iin3RI2l4zN2D4gthKeZQpr7ob
         MPazvmeNcwG4FE3YyUcVeGiLOrBOzrGJpF5xitjTMfK16u4/qleOU9ktDudk33tn9QmF
         Y2XdVZG956qaEztJniITq87Bdyoy8sali3sqbVbFij+IGttdujLqnqiZshzFIKIhvuyA
         I4RV3QDvWo3EH86Dnp0VRWCdH9r0wIxabAOdxpP2Y90kXh062fOAd6bGbTPoNNaqMdVU
         YyzVhclPkliljlzkd01FkzyPZmDg8By9uuzrc7oqmnFosAQ7u+GN9+tFf4bfiklM2hZy
         j4vA==
X-Gm-Message-State: AO0yUKUGxWhn15LBZdtguqRZGWQzlJ0O88F0YlyxLxvvAu6bH+rCpn9p
        FSaJ4/idmiBQ7oiim4r5GcveTQ==
X-Google-Smtp-Source: AK7set/5WbrAEWN3qzFyAPlcoCnn5fA4YoNvZfDN3vsReG7yXwgnaCooawUU5vlrffxT9+CLlu0NSg==
X-Received: by 2002:a17:902:f805:b0:199:4d43:1342 with SMTP id ix5-20020a170902f80500b001994d431342mr3317308plb.1.1675900852124;
        Wed, 08 Feb 2023 16:00:52 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id y23-20020a1709029b9700b001991d6c6c64sm26672plp.185.2023.02.08.16.00.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Feb 2023 16:00:51 -0800 (PST)
Message-ID: <991d59df-48aa-3336-ff7a-06d56bd2d2c1@kernel.dk>
Date:   Wed, 8 Feb 2023 17:00:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [GIT PULL] md-next 20230208
Content-Language: en-US
To:     Song Liu <songliubraving@meta.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Xiao Ni <xni@redhat.com>
References: <4A5C845C-0EF7-42F8-9804-8C719F2DEADC@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <4A5C845C-0EF7-42F8-9804-8C719F2DEADC@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 2/8/23 4:54 PM, Song Liu wrote:
> Hi Jens,
> 
> Please consider pulling the following change for md-next on top of your 
> for-6.3/block branch. 
> 
> This commit fixes a rare crash during the takeover process. 

Pulled, thanks.

-- 
Jens Axboe


