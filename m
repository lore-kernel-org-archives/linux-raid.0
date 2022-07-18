Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 764A0C433EF
	for <linux-raid@archiver.kernel.org>; Mon, 18 Jul 2022 20:02:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233100AbiGRUCl (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 18 Jul 2022 16:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233354AbiGRUCj (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 18 Jul 2022 16:02:39 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90BC8220C3;
        Mon, 18 Jul 2022 13:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=VEUK9GR4aoo1fbnmUshlh5uhq5hijq7uKgdb6TfwVo4=; b=YSzLya7hZxsjbzuKdmS1i3+bzj
        2SJ+OoJACVwXRNdmqXifQg+9kUZylARLwymj3zC0yRl83RsTDK2Pg3jL2sYEfEtCY56d0XWRFQF27
        QMGFDu3AJIAGEYbbiCqIR54BWLpr/L9GhcfBgsO2cwzQ2iYoP4v3a9dyD0bympVXg7U4hMrvkGb08
        LQK4wz9ybliboOGbMFOvqmhAWEmv5FN/o9qwm9yqyOhw9xdXe1Az/QEsI5y4RigPOkBLzz3XdWdhO
        3hBR8CLTM7DaskRedr+/WI6VW6adKVQSi93njqhBnJMD6GRrbP+0RgmZVP7Zg24RpKlj6FEjqFznw
        RmYNJURw==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1oDWwt-000iYh-TR; Mon, 18 Jul 2022 14:02:36 -0600
Message-ID: <53317463-90a7-e47c-aef5-6e9ee4a1c186@deltatee.com>
Date:   Mon, 18 Jul 2022 14:02:35 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-CA
To:     Christoph Hellwig <hch@lst.de>, Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org, linux-block@vger.kernel.org
References: <20220718063410.338626-1-hch@lst.de>
 <20220718063410.338626-6-hch@lst.de>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20220718063410.338626-6-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: hch@lst.de, song@kernel.org, linux-raid@vger.kernel.org, linux-block@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH 05/10] md: factor out the rdev overlaps check from
 rdev_size_store
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2022-07-18 00:34, Christoph Hellwig wrote:
> This splits the code into nicely readable chunks and also avoids
> the refcount inc/dec manipulations.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>

Logan
