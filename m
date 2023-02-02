Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DEEEC61DA4
	for <linux-raid@archiver.kernel.org>; Thu,  2 Feb 2023 23:06:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbjBBXGZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 2 Feb 2023 18:06:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjBBXGY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 2 Feb 2023 18:06:24 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FA6813510
        for <linux-raid@vger.kernel.org>; Thu,  2 Feb 2023 15:06:21 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id m15so1425909ilh.9
        for <linux-raid@vger.kernel.org>; Thu, 02 Feb 2023 15:06:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xHUelwzMYDXBfSLXkY4C98T24EyV7E3KKOuN3To5oWk=;
        b=Q8LSjEfP2HYCBpa6Mo2v1dJvtZ0t+sc8sG0x9GcEqiIDDW/fzKNPQAh358vVD/ASrT
         AaaZGw8xYRlLzFtUlUKHfOKhiowNalhV8ZicDLqHfPOkyRE3hY5TAf0VC34xWnyrDth9
         PSZw/NOX67sVACchN81EZt1LAJqX44uniI0Lb+LfC7U8zqIuuVoxjEwihVb4ncBLt8YC
         c5LE7m0TBWIeWltF2Qh0aov7yE4s4KZAuOkhGf+8G2ePB84RhR4hNzoqK2lX2r84F+NX
         ekoLm5888syy1SUPNM8yS8qY/xJ0pEjWPOO4n4zGmLxKAlXly/yNG3TM79vq4rzdorGS
         jKnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xHUelwzMYDXBfSLXkY4C98T24EyV7E3KKOuN3To5oWk=;
        b=KEjUG2qnL5/gQ8vzjqWbTHN67LFzNPS09uU0cn+WC7sICECKOhkT4Od8U9sUGf8Zx4
         4UPOm5NTN7kT1Zy0Pv5K1ZdP8HORinGiuqr5i5ysTBzZCSkczmy6SgUTRPiOOFbdFviM
         lSriztIId1BxS64TJrsLgH+sYqhg3+yF4qR79OWsiARMs/wiXyGZU+/0F9Do1J8M8x5a
         pB/idOzCHIMev9PSaPe0kHr+ir++mXDH60V/sB6SDuxewxwScE6bn1EDTwGuACqxfdH/
         58HOCsxnHCUb/IJ2sDHEnqmZlqDBoA/qorJE/UjRvGXJqXDyYrsv1iryJmizuGgcVJZC
         gc9Q==
X-Gm-Message-State: AO0yUKULIXz1LgHVT+6zHB/0p0iIQD1q278PjM1nKbVAk54EjX/mNmJu
        6QEocr/fHHxUnTUXcRxQqRyUk49zryS+agwk
X-Google-Smtp-Source: AK7set9Ji9N3WmOUDjdNY98q9QeO+AbHf1QePaMKkNCLUKA/FoUGmpXAlSOX5uGBkjtaFkCC7ip0kg==
X-Received: by 2002:a05:6e02:f8e:b0:310:ecea:b488 with SMTP id v14-20020a056e020f8e00b00310eceab488mr4337115ilo.3.1675379180903;
        Thu, 02 Feb 2023 15:06:20 -0800 (PST)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id n20-20020a056638121400b003acde48bdc3sm312659jas.111.2023.02.02.15.06.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Feb 2023 15:06:20 -0800 (PST)
Message-ID: <04e8be4b-38fa-6ae4-4a10-89e0cc01eca3@kernel.dk>
Date:   Thu, 2 Feb 2023 16:06:19 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [GIT PULL] md-next 20230202
To:     Song Liu <songliubraving@meta.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Xiao Ni <xni@redhat.com>, Hou Tao <houtao@huaweicloud.com>
References: <9CFC5FE2-783D-4904-B416-FBD74A3B07D9@fb.com>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <9CFC5FE2-783D-4904-B416-FBD74A3B07D9@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 2/2/23 3:27 PM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following changes for md-next on top of your
> for-6.3/block branch. The major changes are:
> 
> Non-urgent fixes:
>   md: don't update recovery_cp when curr_resync is ACTIVE
>   md: Free writes_pending in md_stop
> 
> Performance optimization:
>   md: Change active_io to percpu

Pulled, thanks.

-- 
Jens Axboe


