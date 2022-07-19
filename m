Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62271C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 19 Jul 2022 18:45:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbiGSSp1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 19 Jul 2022 14:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiGSSp0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 19 Jul 2022 14:45:26 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE92B54645
        for <linux-raid@vger.kernel.org>; Tue, 19 Jul 2022 11:45:25 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id c16so6886685ils.7
        for <linux-raid@vger.kernel.org>; Tue, 19 Jul 2022 11:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=UeGizcQzHp97kXef1KfNY4iKepPNZXDRRLwstQZfw3Q=;
        b=aCNE0VY3T/lcEWrG9exo5V5U/+QmsOybLM0ZYddD7MI8HNIB79r7ZLNg1/NUV2crfc
         aGpQ44Yfqcjp1Er4xECSv6VpNChjUar3aYuVo3vxNyqoHo4Xt9RwZUePxXTisVFYXIne
         Rwfazd1bUfQBG+Q8ueRcus2nspDANRC8yIPoX4CDmiL1B0fSmICW6kpLucsRw+y0hMNn
         wjgU3xhk3qC27BJ+/LD1FFkNjf6yFIvWtKPmzpR7pxPk9az9fChZkFZY63lVRIZZZ71V
         4+P8Zrm1507MGMhIjrLyA66mXVnTrykbMZkEQl+8s9oZP7YGg8WpWe+QSE9MxWz9Da++
         qDTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=UeGizcQzHp97kXef1KfNY4iKepPNZXDRRLwstQZfw3Q=;
        b=nlsPyIDsl/53INE3y7lnPVP0lGrE3Z3hWUF4ksXi1Dm6fLPjbRL7BvES92cXC77ToD
         oPz50gXDyVRsa3rrpCpfeszrmDf+SRO4bunIby/BhCGoQhoy79s1Whez1PTKa3q65XCx
         CeDcc7VgNgiIHfzIkO8EX1yv7nWL/7U71LHGPXWA7MhrFOHdsIw9LmKZh4+/7Dx22yY6
         KnTDu+jvrnMzQWvN4QBG3X+XnXGGrPG7B8uVBCCA3XOXuhBNxdOAjRxFbADn2uxZB3Cg
         ff383Vo7pfWI4JvfQ/VOJfFhHojqYfUPtvRG17DmQW9ch8NMZw+xD0jgo8FnOyPOgaBd
         Hohg==
X-Gm-Message-State: AJIora95aEvRyBGhxQY5tBzSrYEqvwZA3y9TsdXjtLK/2Pwl5djLXi9E
        YOTW6U1WIxFUOYLki5TRENZc3tGfwVgvWA==
X-Google-Smtp-Source: AGRyM1uCbnDYrDP9hj4uaKdtXOMqGU9o1TYN6S1qkSyQE7uCSyAazQzDm5bA+fWQwMoWDqGcJ2deCg==
X-Received: by 2002:a05:6e02:b2b:b0:2dc:882d:161e with SMTP id e11-20020a056e020b2b00b002dc882d161emr16234721ilu.182.1658256325188;
        Tue, 19 Jul 2022 11:45:25 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id k21-20020a02a715000000b00333fa7a642asm6963613jam.63.2022.07.19.11.45.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jul 2022 11:45:24 -0700 (PDT)
Message-ID: <57876115-7e41-f11e-3cca-738235cd68db@kernel.dk>
Date:   Tue, 19 Jul 2022 12:45:23 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [GIT PULL] md-next 20220719
Content-Language: en-US
To:     Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Logan Gunthorpe <logang@deltatee.com>
References: <5553FDCD-7628-4A40-A228-8E1BEF6FFFA1@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <5553FDCD-7628-4A40-A228-8E1BEF6FFFA1@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 7/19/22 12:43 PM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following changes on top of your for-5.20/drivers
> branch. The major changes are:
> 1. Fix md disk_name lifetime problems, by Christoph Hellwig;
> 2. Convert prepare_to_wait() to wait_woken() api, by Logan Gunthorpe;
> 3. Fix sectors_to_do bitmap issue, by Logan Gunthorpe. 

This has worse conflicts, it looks like. And not particularly trivial.
Do you have a merge resolution?

We might want to consider doing a special branch for this...

-- 
Jens Axboe

