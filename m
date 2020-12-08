Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81528C433FE
	for <linux-raid@archiver.kernel.org>; Tue,  8 Dec 2020 14:17:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 474C323A33
	for <linux-raid@archiver.kernel.org>; Tue,  8 Dec 2020 14:17:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729820AbgLHOQa (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 8 Dec 2020 09:16:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729817AbgLHOQa (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 8 Dec 2020 09:16:30 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C69E2C0613D6
        for <linux-raid@vger.kernel.org>; Tue,  8 Dec 2020 06:15:43 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id o8so17049616ioh.0
        for <linux-raid@vger.kernel.org>; Tue, 08 Dec 2020 06:15:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aFEq0S7a57DGwr5Vv73yvEZmzOjbCOIiqXWdjglEIDM=;
        b=hguXzE2N/SqwhTAkfIFMN5D2kcOoRovIkcFN8Sm8Y8WbZ9PYL6fpRqVJSwl9isgOj9
         80nVcKEdADHigrpy+4eIXwjRtMT2knvOgcGVjHDGFRM4aOhVMhSFQIhMQHdGpzVCDpW8
         ZKLvxs7+FpyAvSGtYG79QjrKTuK4TWoKDcAtsdWVzaBCKY567YVj9jJAeiBF4Dlfsfwq
         llXkyBcDEpJFj3Z0FiZ9tyRxmJA+Dbt+yK8p/N2Q26kcXwFnNU42nX41I3NMUctrMGbG
         9RhsvwW12O210fb96Njx1T+wXTZbLcj/jMV2OXNP42ByLMQr/PArBXLsl9IYO/HjChH5
         jVDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aFEq0S7a57DGwr5Vv73yvEZmzOjbCOIiqXWdjglEIDM=;
        b=E4yO8NTDHyLAKmfzDeytaYb9x7DvvG2zKF0Ao91sKia+ifHjepauR73flmJwXo6uyS
         TX51Iof2AMx5Gipo9NYIwZJhupg09iS5mMwjPpk8FEiaOBMy4XwCQ6GSCmBCOZ2U0Ois
         HY8VeAbcww5HReGZwQ3/hIrsp6xk0wGiK7vIv+ij1tOzKY3nmM+NRLJar3RWlK2WKZnm
         tlfBj2EQsyMOrd4AObI7ECHbnkoQSH85UgAJkAcBtLeOGdCSOr+MwK8jqEuHfcw8LNWv
         DFKX0rEZ4GCTQxpzxXvW2RsfYxGI5YzxNf3ULIovfDZ2Eb5AZbn0JyGBux3NyTcxacI2
         Z3pQ==
X-Gm-Message-State: AOAM5337tKy4ehfyAK8mnTRghShOwcYmPR5sAAbOOJAVNRWDSK54ADCH
        7dv6B0DZvYi89jqYZixJOgrUhwf0xnZz0g==
X-Google-Smtp-Source: ABdhPJzD7k++Tng4C23t2AsnQOqZkMhInrVVHvjmUGn3gedrlrpTsFJu1dm1X/5LMt9jMiPy6Cba9Q==
X-Received: by 2002:a02:b02:: with SMTP id 2mr16161804jad.15.1607436943117;
        Tue, 08 Dec 2020 06:15:43 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id h70sm7716957iof.31.2020.12.08.06.15.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 06:15:42 -0800 (PST)
Subject: Re: store a pointer to the block_device in struct bio (again)
To:     Christoph Hellwig <hch@lst.de>, Qian Cai <qcai@redhat.com>
Cc:     Tejun Heo <tj@kernel.org>, Coly Li <colyli@suse.de>,
        Song Liu <song@kernel.org>, dm-devel@redhat.com,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-block@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
References: <20201201165424.2030647-1-hch@lst.de>
 <920899710c9e8dcce16e561c6d832e4e9c03cd73.camel@redhat.com>
 <20201208110403.GA22179@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <cc95b9eb-6278-4b0d-6cf9-19c35714bfe7@kernel.dk>
Date:   Tue, 8 Dec 2020 07:15:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201208110403.GA22179@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 12/8/20 4:04 AM, Christoph Hellwig wrote:
> Hi Qian,
> 
> can you send me details of your device mapper setup, e.g. which targets
> are used, are they used on top of whole device or partitions.  Do you
> use partitions on top of the dm devices?  Are any other stacking devices
> involved?

Don't think this needs anything fancy at all - I know Pavel got his
test box corrupted, and mine did as well. Looks like it pretty much
affected everyone that got unlucky enough to try it, not great...

Mine is just ext4 root on nvme.

-- 
Jens Axboe

