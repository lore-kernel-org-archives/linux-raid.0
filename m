Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99263C5519F
	for <linux-raid@archiver.kernel.org>; Thu, 19 Nov 2020 02:21:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A0C3241A6
	for <linux-raid@archiver.kernel.org>; Thu, 19 Nov 2020 02:21:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M++0K9N+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727316AbgKSCVe (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 18 Nov 2020 21:21:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726340AbgKSCVe (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 18 Nov 2020 21:21:34 -0500
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A54CC0613D4
        for <linux-raid@vger.kernel.org>; Wed, 18 Nov 2020 18:21:34 -0800 (PST)
Received: by mail-qk1-x733.google.com with SMTP id d9so4021590qke.8
        for <linux-raid@vger.kernel.org>; Wed, 18 Nov 2020 18:21:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:references:to:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=LxQ+X5Rd4UnM8jTryEQTNi2vQxSVH2Ujj1G220ZoICY=;
        b=M++0K9N+PimKBeZtOil6PXglVoQ5MOCTdwrdAGR2G8y1xClHbP722kWmsiQLVDdI4m
         1V+N8m4P7NBvddsRhn9Lb537Uihkmse4UseIDuPacRYDLkOH8NaDTbNmnWmVjgFZxSaA
         61dvhnRbz/4qzpPvxTAACCC6QauvKLzKk9Kemk517aAc+dE7l3JQcTlDKRhinAn4s6Me
         MrcdN+hRV9riZCjTqpR6849+lQeIMb2yzUgHL5DWWm/J6xePo5vYw2KWVNgN/m1puuY9
         rw6vDxsna+oYCrr/ST9BNIQoT97/GwgBZ3NC7maU97QLRwck0GrfEWyxBmjcWEcVCd4F
         z67A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:references:to:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LxQ+X5Rd4UnM8jTryEQTNi2vQxSVH2Ujj1G220ZoICY=;
        b=iJGwom7S47ULheh/l0gITaj9a8ztBzTtVfoPam5ynU0antQpIzwrQSzze5mzyLLP5H
         hJwkFY0JOXvoy9nVVNIGx08oWKCqPuts0AKAnuUeOJ11x7jTqXOXiJuOdaQoqsjD7EoI
         RisDA/xAPiFA09kdma3G0YYoE8VrkuYVHMpDy3T7lZlQpxg+9C38+2beQ33OSxfJsEa3
         Kq/Cy1VDa9wMfPPQ6Xi1nBQNOe7SuY0ZJbg3PGcoNpL3wGAkX5fWciIQOW8rVDXHnWaB
         cGHaSc1QCaGaVs/DZHWnHDwpl7vASNiY/iO3pvdxDkk2pUUxqDcL0lsYGYZW5mIINfIg
         4ZIA==
X-Gm-Message-State: AOAM530tt+Hyecv/v25JbHKepGWToygAzJwpPot2PmkguUgP4zi9vtMu
        DxGkhlldruQMftXq4navi5K3O8u4QYIN1g==
X-Google-Smtp-Source: ABdhPJzOGsuGVS3PiExoVhxtHFJmSejN6DiImRCFcJRL3Is/FFviGtu4u72CTcCDw4fMLAQ2e4O+lQ==
X-Received: by 2002:a05:620a:228f:: with SMTP id o15mr8931160qkh.206.1605752493232;
        Wed, 18 Nov 2020 18:21:33 -0800 (PST)
Received: from biodora.local ([104.238.233.190])
        by smtp.gmail.com with ESMTPSA id s16sm18282581qkg.5.2020.11.18.18.21.32
        for <linux-raid@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2020 18:21:32 -0800 (PST)
Subject: Re: Events Counter - How it increments
References: <819ff80e-10d0-8cc6-b34c-418fdea7b57a@gmail.com>
 <567bc78b-cf37-c40b-2e99-b86a80bdfb3e@suse.com>
To:     linux-raid@vger.kernel.org
From:   =?UTF-8?Q?Jorge_F=c3=a1bregas?= <jorge.fabregas@gmail.com>
Message-ID: <f2d69b9a-9e2d-a104-0600-612f5d39084c@gmail.com>
Date:   Wed, 18 Nov 2020 22:21:31 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <567bc78b-cf37-c40b-2e99-b86a80bdfb3e@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 11/18/20 12:45 PM, heming.zhao@suse.com wrote:
> The events is related with (struct mddev) mddev->events. 
> you can search it in kernel source code.

Thank you Heming.  I was expecting more of a general view since I'm a
new user.  Sorry I wasn't clear.

What sort of events cause the Event counter to increase?  If it's mainly
whenever the superblock is updated then my question is: What sort of
events cause the superblock to be updated? I can imagine detection of
failed disk, read errors, array checks, commands by user/admin,
assembly-reassembly etc? If an array operates fine for months - without
user intervention,  will the Event counter increase at all?

Thanks.

-- 
Jorge
