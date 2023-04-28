Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08286C77B61
	for <linux-raid@archiver.kernel.org>; Fri, 28 Apr 2023 16:38:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345627AbjD1QiM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 28 Apr 2023 12:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjD1QiL (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 28 Apr 2023 12:38:11 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57C1B46A0
        for <linux-raid@vger.kernel.org>; Fri, 28 Apr 2023 09:38:10 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id ca18e2360f4ac-763af6790a3so73839f.0
        for <linux-raid@vger.kernel.org>; Fri, 28 Apr 2023 09:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1682699889; x=1685291889;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GTOx8u8s/sU+gZCcxOo3Opfqn5TH6m1kEmxXCF58HwI=;
        b=ie18b7GB1hTtGKohFiTVdEdMXEQiXG9KIL8qYKjIH3DLLxy6Pn4WMic46EIH5znhRb
         TSz27U+PsWMmlKpfxEn2PaN/z99KVLB1esdkWL2/JTn6wn+724d4VmhtZpDWBSRX9xJy
         GLYV3jnn7SwVkA+9mKZ4m/nJoFo9vwVsG4xY7d6OQ5eSorTsO4voJylRgB2b7K4oTCEo
         HENBEnT0WnBmpi86IAKNDL0rLocodGvaDwBqZ20tsaLMPr24jrinNSXUtoE64tDiOUaq
         yXt3+RxhINsxh1dINGYl4sJs+3P5pl5yAWmws5WTUKbAUUGKnlgkJ5+/BhseDiGxcqPx
         3qLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682699889; x=1685291889;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GTOx8u8s/sU+gZCcxOo3Opfqn5TH6m1kEmxXCF58HwI=;
        b=U1x5yE5Qam1AyRpVGYEoQ+Kvqoh0a3nFkW/eNtvZPcSalsLdc3Uie4QGzF/Ecvpkct
         jsDw+bbsvuI5bqt/NHtVtWoUP9uGCh4DPH26hkpo9PCY6bk3+gu6xdOvtN7awVnd2BiH
         9qJGWgwmtPH3zh9UH87HOgJ1dQ5xMSvJjH+Y2epX9XrIl+W5KVd5e49jNf/BCO/5dGDw
         8pgZOJLGiuYeNoC2Vo083EhpexE5euclVvYTWy0cowtkYzeKdTAOK5vldH2ws80iwCTe
         lUckKCpRFiNLPJU/Y/U+2uFJKXkLL7hFwUSyw3F6v0USqUaM+ZV1X7XC3BT4iTNy0Tvj
         3TdA==
X-Gm-Message-State: AC+VfDytSPQiuZrGcxjKKZpNpwJqWWWuMF1dlxASJFTq3mnRRKodf+lp
        Ny129lKJWD/NN5R1jpCFfQVU/Q==
X-Google-Smtp-Source: ACHHUZ4bvwM1TmbHKt6p/fd2DwFrltYVAfrkt63p0zfNG7hUTamoep7iNaBMeg9KqaBQ1BBjEn1HPg==
X-Received: by 2002:a05:6602:5c5:b0:760:ea9d:4af6 with SMTP id w5-20020a05660205c500b00760ea9d4af6mr1584439iox.1.1682699889694;
        Fri, 28 Apr 2023 09:38:09 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id o11-20020a92dacb000000b00326ceaf3d96sm5542524ilq.71.2023.04.28.09.38.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Apr 2023 09:38:09 -0700 (PDT)
Message-ID: <cea39134-8f3a-fb10-0bf0-ff65e8ca2024@kernel.dk>
Date:   Fri, 28 Apr 2023 10:38:08 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [GIT PULL] md-next 2023-04-28
Content-Language: en-US
To:     Song Liu <songliubraving@meta.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Jan Kara <jack@suse.cz>,
        Jonathan Derrick <jonathan.derrick@linux.dev>,
        Yu Kuai <yukuai3@huawei.com>,
        "Reviewed-by: Logan Gunthorpe" <logang@deltatee.com>
References: <64602C04-36AA-42D2-A6CE-6039BF4D8EB7@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <64602C04-36AA-42D2-A6CE-6039BF4D8EB7@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 4/28/23 10:31 AM, Song Liu wrote:
> 1. Improve raid5 sequential IO performance on spinning disks, which fix a 
>    regression since v6.0, by Jan Kara.
> 2. Fix bitmap offset types, which fixes an issue introduced in this merge 
>    window, by Jonathan Derrick. 

Pulled, thanks.

-- 
Jens Axboe


