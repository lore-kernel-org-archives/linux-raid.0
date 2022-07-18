Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42AF4C43334
	for <linux-raid@archiver.kernel.org>; Mon, 18 Jul 2022 20:02:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233632AbiGRUC1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 18 Jul 2022 16:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233889AbiGRUCX (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 18 Jul 2022 16:02:23 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5F1126126;
        Mon, 18 Jul 2022 13:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=V07QczxyXTEeTxeF6qFc0kkDESoI9T21tjYlPn/PTfY=; b=m8C8JyUWZVXbd0ib/fTGEcvWDe
        PbI/A17rcC3/fIDuPmd0b8Q5zs1VI40GTW9mtRvV7YzX4pY9g+TQCel0dyIZ3kdzFruRJl8xVK5WM
        NlCrDPmbMgsMZUnmclVUaSXOdRDO5dg7m5c48gCXZ636AY0uFYVU9IPuCV3mJvvRgskrYmt2q3BBi
        8ZJ95xOhIxvTyCxpCgbiordOANqeEvh+mhbO/HXsiI+8xmtghjTsj4gdbpJrJD5mIyzikiyrmSC6Y
        Af7F2Z6Ww5pVFfseLtx+tWw6GfSWdlE48rnMQ3yO47nnYqJQy/FnOZUquDw/84MAlqSLwBx4X06dV
        jjORQcTw==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1oDWwd-000iYQ-Pr; Mon, 18 Jul 2022 14:02:20 -0600
Message-ID: <0ac420ab-9c14-a7d9-663a-f752ed9347a8@deltatee.com>
Date:   Mon, 18 Jul 2022 14:02:19 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-CA
To:     Christoph Hellwig <hch@lst.de>, Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org, linux-block@vger.kernel.org
References: <20220718063410.338626-1-hch@lst.de>
 <20220718063410.338626-5-hch@lst.de>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20220718063410.338626-5-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: hch@lst.de, song@kernel.org, linux-raid@vger.kernel.org, linux-block@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH 04/10] md: rename md_free to md_kobj_release
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2022-07-18 00:34, Christoph Hellwig wrote:
> The md_free name is rather misleading, so pick a better one.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>

Logan
