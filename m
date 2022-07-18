Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82A81C433EF
	for <linux-raid@archiver.kernel.org>; Mon, 18 Jul 2022 20:03:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233696AbiGRUDS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 18 Jul 2022 16:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231248AbiGRUDR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 18 Jul 2022 16:03:17 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAB421E3C0;
        Mon, 18 Jul 2022 13:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=QjGmLGq+6oFgT5nqLhoGCwa3KsijNnIkus7lQpZyyOY=; b=tW/Z85qby25NGyCOPWSLKtqm5m
        B4OC0qp4EDGkT2lGFkxNSe7ei3j7d9yiDfDz1tZXx5jR8O45m4pJ8PoWXZeP3h+sXEpjrXpXBxE9X
        R/4Y5M2o2xs7DDKDPNWePJykLuTLclvn77ieWlQ3WdDuBvom5s/j1xpmmgoSf7SQIv6MUn/2SyDgA
        38jRso72alFBN6/D2VHQHLYveCZGMr6TDok4i5NhlJ3RDGRz1ZE4qG/OXEsx7j+uwi2CTdUlWkyu5
        1rezkp82kgOLHRgC5xMf+VELVcqR/t1/m47+p1MF3hEWBcJyoIgzDX4uaU8I6jo01fjv14VWge/2N
        l4OvV7Kw==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1oDWxU-000iZT-Kp; Mon, 18 Jul 2022 14:03:13 -0600
Message-ID: <387915b0-dbf8-9436-d770-38225a8c2932@deltatee.com>
Date:   Mon, 18 Jul 2022 14:03:12 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-CA
To:     Christoph Hellwig <hch@lst.de>, Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org, linux-block@vger.kernel.org
References: <20220718063410.338626-1-hch@lst.de>
 <20220718063410.338626-8-hch@lst.de>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20220718063410.338626-8-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: hch@lst.de, song@kernel.org, linux-raid@vger.kernel.org, linux-block@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH 07/10] md: stop using for_each_mddev in md_notify_reboot
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2022-07-18 00:34, Christoph Hellwig wrote:
> Just do a simple list_for_each_entry_safe on all_mddevs, and only grab a
> reference when we drop the lock.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>

Logan
