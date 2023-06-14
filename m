Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25F50EB64D8
	for <linux-raid@archiver.kernel.org>; Wed, 14 Jun 2023 12:59:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244344AbjFNM7k (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 14 Jun 2023 08:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244235AbjFNM7i (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 14 Jun 2023 08:59:38 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C2051721
        for <linux-raid@vger.kernel.org>; Wed, 14 Jun 2023 05:59:37 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-657c4bcad0bso1726781b3a.1
        for <linux-raid@vger.kernel.org>; Wed, 14 Jun 2023 05:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1686747577; x=1689339577;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yUDHTEsRSnAvJvn9S43DcnSQXoug5ctu4I+MSkz+QWo=;
        b=vVK/JrxtCkfyu7Mj6QKYXQEnfpftmxGizyoBh5Oqb9qHXVYzZRcDGNUWkO/NotrJax
         fnrcPmpWhPshBDa9KxQhw+eYVhK4q7uYK/x0NJ/GjjfuEu6puWc1f34iihOA0ML/qls0
         jJLefcBKnneUEHvkVCjBom6ZzoTg5US1R/ChS5B/bv57/7G18pvUUXzPhguElOi9fS3r
         zDMDr5uFg5mpdsdPAE/MEhoRuggZqvaSOzRUPZoYLWKtEKmXT7uKq7mbeLv0IC3hGpsD
         NTnh5L62dIaYy2p56QYKy6HsJbJ9vFF550ccc6p8Z5wIMpnyYAaQkXF8PT86kRJdTAsk
         b+cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686747577; x=1689339577;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yUDHTEsRSnAvJvn9S43DcnSQXoug5ctu4I+MSkz+QWo=;
        b=OpjMrSKlHo5/FsLXallyVjOhgRrIu9GRXJ9TPKdFk06bad3Tix1WehTQQGW3Qyd5qW
         eHi10b7kcRggoRub9zpiLucFVjH4N/vVs9sgotB5IPI5uyVknTzDCLar/12cmYppjw4e
         oMJ0rjQZ2jzJzhxlvgBRkXhQTyB+8F8oNqWbv3kElPYRTYT3MS4aSL2vph4VQfCkiQSZ
         chMQTE5w6gz7iCBSvwfQRao+E8X1WSPSIMpUmM7PfJ+QMmwpX50N0xbXYOaGjcN3z+xP
         eqjJG6lrYTerUcvaGwnXO/cAGKjNTMBfQTQ5GnpHC8he9IvSgY69eRruQ3ewxGaVkL29
         kR8Q==
X-Gm-Message-State: AC+VfDybAqimEPd5AmHD5LIwV5+6iP6j2s0J5ApmYdogP5cdxf0jVYC/
        nXynNKru1pxRilokndwiXVVZmQ==
X-Google-Smtp-Source: ACHHUZ5WM+1OLfuWFmkeaYQ+qRIWtma7ixHquorDSbPMfwpOTdutYggfWdTHOGHGr3BhnEksXKyRXQ==
X-Received: by 2002:a05:6a00:2493:b0:663:ee78:f02c with SMTP id c19-20020a056a00249300b00663ee78f02cmr13063508pfv.1.1686747576820;
        Wed, 14 Jun 2023 05:59:36 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id n2-20020a62e502000000b006634d0fe2c6sm10295558pff.203.2023.06.14.05.59.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jun 2023 05:59:36 -0700 (PDT)
Message-ID: <532b9d16-46f3-138f-8366-a0e9d835cec1@kernel.dk>
Date:   Wed, 14 Jun 2023 06:59:35 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [GIT PULL] md-next 20230613
Content-Language: en-US
To:     Song Liu <songliubraving@meta.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Yu Kuai <yukuai3@huawei.com>, Li Nan <linan122@huawei.com>,
        Arnd Bergmann <arnd@arndb.de>
References: <89E405DB-3E86-4741-971A-18ED541EEAE8@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <89E405DB-3E86-4741-971A-18ED541EEAE8@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 6/13/23 11:58 PM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following changes for md-next on top of your
> for-6.5/block branch. The major changes are:
> 
> 1. Protect md_thread with rcu, by Yu Kuai;
> 2. Various non-urgent raid5 and raid1/10 fixes, by Yu Kuai;
> 3. Non-urgent raid10 fixes, by Li Nan.

Pulled, thanks.

-- 
Jens Axboe


