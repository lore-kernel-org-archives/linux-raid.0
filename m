Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 245A7C43334
	for <linux-raid@archiver.kernel.org>; Tue, 28 Jun 2022 21:32:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbiF1Vca (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 28 Jun 2022 17:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbiF1Vc3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 28 Jun 2022 17:32:29 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCBE13AA71
        for <linux-raid@vger.kernel.org>; Tue, 28 Jun 2022 14:32:28 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d5so12190133plo.12
        for <linux-raid@vger.kernel.org>; Tue, 28 Jun 2022 14:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shenkin.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=LzOVrIMwMjRwghyBiSOHMTWWg1GxTXQYN8l5kMQ/RmI=;
        b=CiPlMMmjFiFC/Yvl3fWwdejVr9ejh/H9vN/RIbOWqypq29zRQ0sjCYhr/OqvRHPuzb
         0JOKXS+bER49KSOudKcG3Sk3hdSLIRi/9xGb4b6NouHgMGM0pGvfnBxy8RxoH3sLsU0m
         A+aazknwZXQuTu5drvqVUslrJ+TZpehXLqMjw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LzOVrIMwMjRwghyBiSOHMTWWg1GxTXQYN8l5kMQ/RmI=;
        b=UeXE6t4Sr+LpiJl32S+1izajEXdBiXHw+gdMRb2m5/2OqDbAaZLwpOI1i1jMzc2SLq
         YAgbWzPXsJWr68Iv5n6sBKUUF36IludpX7rXFHFQ6ryWZe1QhKe0ZUbKFOy8XzqHtR8R
         aVAOGqcgfZiHogPI+Oq2FL5yjqEVSVtH4OsVA8qPSxDQt4rUcrw5Y/ofyZ24r/Q6k3a/
         UM73+0+PqsP7Dub6A7t0wu/Z4GR9FydSb/V40eF7e66OR2B/2qlZmH2r2nLiuXBPf7Ke
         cFpjM2DKij7nG4AJkXqrgPZ3k3XjKg4IroSbABRtAER1FBuyH8ZYOZPTUhxpYVIkGKAD
         YeDQ==
X-Gm-Message-State: AJIora/uI5+0pbhFv3Pg8drIuyzGievg5x+jw0HFg5oc+P+NdqHa+gNW
        pBsbP0a24j04IGxBfYCKiC6wKmpj978BKPpg
X-Google-Smtp-Source: AGRyM1t9AuQESbZOx5n7ymFo/MUG/MdSXdnD4lzGkTarUnQTUJvIG/m6ewFWYSigvnmkgN1HoapSfA==
X-Received: by 2002:a17:902:f804:b0:16a:da1:1ef7 with SMTP id ix4-20020a170902f80400b0016a0da11ef7mr5653786plb.17.1656451948313;
        Tue, 28 Jun 2022 14:32:28 -0700 (PDT)
Received: from [192.168.1.243] ([47.215.181.107])
        by smtp.googlemail.com with ESMTPSA id x5-20020a1709029a4500b001678e9670d8sm9834966plv.2.2022.06.28.14.32.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jun 2022 14:32:27 -0700 (PDT)
Message-ID: <24ac75be-4e0b-0c50-8d87-b673535f7686@shenkin.org>
Date:   Tue, 28 Jun 2022 14:32:24 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: Upgrading motherboard + CPU
Content-Language: en-US
To:     Pascal Hambourg <pascal@plouf.fr.eu.org>,
        Roman Mamedov <rm@romanrm.net>
Cc:     Wols Lists <antlists@youngman.org.uk>, Stephan <linux@psjt.org>,
        Linux-RAID <linux-raid@vger.kernel.org>
References: <CAPpdf59G6UjOe-80oqgwPmMY14t0_E=D20cbUwDwtOT8=AFcLQ@mail.gmail.com>
 <b777865e-b265-1e83-dae0-f89654e86332@plouf.fr.eu.org>
 <5cbd9dd1-73fc-ce11-4a9d-8752f7bea979@youngman.org.uk>
 <1de4bf1f-242b-7d02-23dc-a6d05893db81@plouf.fr.eu.org>
 <20220624232049.502a541e@nvm>
 <dab2fe0a-c49e-5da7-5df3-4d01c86a65a7@shenkin.org>
 <20220624234453.43cf4c74@nvm>
 <22102e4b-4738-672d-0d00-bbeccb54fe84@shenkin.org>
 <d85093a4-be3e-d4f2-eca0-e20882584bab@youngman.org.uk>
 <b664e4ce-6ebe-86c6-78d9-d5606c0f6555@shenkin.org>
 <5cb8d159-be2a-aa6c-888a-fcb9ed4555c1@youngman.org.uk>
 <20220625030833.3398d8a4@nvm>
 <ae2288f4-ad06-65af-d30c-4aef6d478f27@plouf.fr.eu.org>
 <s6nh748amrs.fsf@blaulicht.dmz.brux>
 <1b6c6601-22a0-af2a-81a9-34599b1b0fa7@youngman.org.uk>
 <f971e15d-9cd4-e6de-c174-f3c6bd338bb6@plouf.fr.eu.org>
 <b1c6b0c2-ff7b-59e0-580c-81d57b8f8ddb@shenkin.org>
 <20220627160558.0ec507ae@nvm> <693d4b1c-ee58-4cc2-854b-4ae445ff7d24@Spark>
 <3e756547-ae18-c0d8-209e-8dd1fc43bb0f@plouf.fr.eu.org>
From:   Alexander Shenkin <al@shenkin.org>
In-Reply-To: <3e756547-ae18-c0d8-209e-8dd1fc43bb0f@plouf.fr.eu.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


On 6/27/2022 7:26 AM, Pascal Hambourg wrote:
> On 27/06/2022 15:57, Alexander Shenkin wrote :
>>
>> CSM is greyed out.  I think I need a graphics card
> 
> Is secure boot disabled? Legacy boot is not compatible with secure boot.

There's no way to completely disable secure boot on this mobo.  It's an 
Asus Prime B560M-A.
