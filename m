Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00C8FCCA479
	for <linux-raid@archiver.kernel.org>; Mon, 18 Jul 2022 19:48:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236314AbiGRTsW (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 18 Jul 2022 15:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbiGRTsV (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 18 Jul 2022 15:48:21 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC15431910;
        Mon, 18 Jul 2022 12:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=jiYDnRlg8vD8I3boxOMCBSw0y+zNL0+9apdYiwcaldM=; b=ib2fiI9WwzOyDvkFi4yiKqYc0K
        iG1QiG+JVB/VmwcL8YX6NVeG7SXqA2xKmiWH8n7GHnu8F9fLTbFK27G093k02UWdg61s+5t14wyC0
        OBZtMQWHZqZ3cr2upNiVMVOWcdN4rHfOn0wB6AV1tXuZMUfs5Q3Wml4N1JqtiTDjtLWNnxzOONH8i
        gPvjly+vVrb3kc27U8/ao+hS+VJHHJICjVVY2o/ALmdtDE5QmOoXcfijzmdhf6lH0SiMTm9Y6OhDp
        w0S6ZCEDppru1RNmUE3fTjWCUK5Wv2Yf02PXJg3hJ1XL5uOI36Pf1PZUH+J2y2eJww57yAalkl+xz
        /qWqkOlg==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1oDWiz-000iAS-Fl; Mon, 18 Jul 2022 13:48:14 -0600
Message-ID: <d69c2adc-c75a-1ba0-ef72-1e736e5c4fe5@deltatee.com>
Date:   Mon, 18 Jul 2022 13:48:12 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-CA
To:     Christoph Hellwig <hch@lst.de>, Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org, linux-block@vger.kernel.org
References: <20220718063410.338626-1-hch@lst.de>
 <20220718063410.338626-2-hch@lst.de>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20220718063410.338626-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: hch@lst.de, song@kernel.org, linux-raid@vger.kernel.org, linux-block@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH 01/10] md: fix mddev->kobj lifetime
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2022-07-18 00:34, Christoph Hellwig wrote:
> Once a kobject is initialized, the containing object should not be
> directly freed.  So delay initialization until it is added.  Also
> remove the kobject_del call as the last put will remove the kobject as
> well.  The explicitly delete isn't needed here, and dropping it will
> simplify further fixes.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>

Logan
