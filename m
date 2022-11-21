Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBEB2C4332F
	for <linux-raid@archiver.kernel.org>; Mon, 21 Nov 2022 16:46:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbiKUQqU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 21 Nov 2022 11:46:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiKUQqT (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 21 Nov 2022 11:46:19 -0500
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5E948B85B
        for <linux-raid@vger.kernel.org>; Mon, 21 Nov 2022 08:46:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=rxH+rcMH365LmnYKgb8IKsJHoPv7z6XELCmxRYmICxw=; b=Baxmd+VJUfg/uX/JnIEVdNfW1G
        isgQY6Pw5jNAcM5UZrnoTq6YYbwyARbGqbyVeb78VeU2Z6hO2CSsMd32IZhjscXE9gE9IbVbdKQDn
        erb/Qp+zr1cHJp9hAYoV1sahcK9TCe1FKLxrfUxjXLX2kcf+eoOFfkwD15A2nRMIArp5m1gEeRGFH
        7TL/kLypcksiy+J308Kkrvf8Z65okykhesks1ht9BXi5qGAr6cBu9DXZ/xGatv2s4Zmlb24gmtKmM
        u/NCdNkIHiPIRgwfjdOIvtsz/foN9ye1nFBfKK3Lq8WypUrP8fVY4FSyj63/3AQfkeuwZzmGXoc0H
        79sHExDg==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1ox9vy-007pwU-JN; Mon, 21 Nov 2022 09:46:15 -0700
Message-ID: <6318dccf-0cb4-58ab-91b4-04d027b1c9bc@deltatee.com>
Date:   Mon, 21 Nov 2022 09:46:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Content-Language: en-CA
To:     Xiao Ni <xni@redhat.com>
Cc:     linux-raid@vger.kernel.org, Jes Sorensen <jes@trained-monkey.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Jonmichael Hands <jm@chia.net>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>,
        Kinga Tanska <kinga.tanska@linux.intel.com>
References: <20221116235009.79875-1-logang@deltatee.com>
 <20221116235009.79875-6-logang@deltatee.com>
 <CALTww2-e+K66J=hekxyc7rC7=yMrP-uiJPDgQWtiPuZSV29tYg@mail.gmail.com>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <CALTww2-e+K66J=hekxyc7rC7=yMrP-uiJPDgQWtiPuZSV29tYg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: xni@redhat.com, linux-raid@vger.kernel.org, jes@trained-monkey.org, guoqing.jiang@linux.dev, mariusz.tkaczyk@linux.intel.com, colyli@suse.de, chaitanyak@nvidia.com, jm@chia.net, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com, kinga.tanska@linux.intel.com
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH mdadm v5 5/7] mdadm: Add --write-zeros option for Create
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2022-11-21 08:00, Xiao Ni wrote:
> Hi Logan
> 
> I did a test, but it always fails to create the raid device.
> Maybe it's better to init interrupted to false?

Oops, yes, my mistake. I'll send an updated patch later this week.

Thanks,

Logan
