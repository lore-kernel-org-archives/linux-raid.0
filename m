Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AE7DC43334
	for <linux-raid@archiver.kernel.org>; Mon, 18 Jul 2022 19:48:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236358AbiGRTsw (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 18 Jul 2022 15:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236311AbiGRTsq (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 18 Jul 2022 15:48:46 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7784D3204C;
        Mon, 18 Jul 2022 12:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=Qxu5nFolr4coYnXxIWZ80l31DwePvDjK5Ag1K5lxBk8=; b=a9WddXHXblkEFGWjvKBb3YBWx5
        pxJUdpaPV70Ug/BUknrmRWk9MIxs2Bx8v6SVMwxyHhhnh3M7xonvfVLp+mjO2linnuh4oV78hQPGR
        DApIm3Pvg5IdfJi3NyRXbBbrjJJ5NbPO8UX3JeyN9qseA3XY0rRJEiwMqVzc4/8n7dvt4OJJnjUUd
        srIwTvlE8IeCSmxPlQq6FDKpMcXF5jBPmvpu8UmMVoSFqfFV13Dqcl31Fg2E/CmBAoI2neJcIOk7L
        FilH9bFjbJ7dfPa3vRzuD4GX3WObLH7vPxl/33h+4lh+3kux0rObHHWRJhczq8FBnd7s9EQG3ZkyZ
        6IwBxbHw==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1oDWjJ-000iAi-TK; Mon, 18 Jul 2022 13:48:34 -0600
Message-ID: <0ee4626e-08c6-ce2b-c338-e043b3619d49@deltatee.com>
Date:   Mon, 18 Jul 2022 13:48:33 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-CA
To:     Christoph Hellwig <hch@lst.de>, Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org, linux-block@vger.kernel.org
References: <20220718063410.338626-1-hch@lst.de>
 <20220718063410.338626-3-hch@lst.de>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20220718063410.338626-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: hch@lst.de, song@kernel.org, linux-raid@vger.kernel.org, linux-block@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH 02/10] md: fix error handling in md_alloc
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2022-07-18 00:34, Christoph Hellwig wrote:
> Error handling in md_alloc is a mess.  Untangle it to just free the mddev
> directly before add_disk is called and thus the gendisk is globally
> visible.  After that clear the hold flag and let the mddev_put take care
> of cleaning up the mddev through the usual mechanisms.
> 
> Fixes: 5e55e2f5fc95 ("[PATCH] md: convert compile time warnings into runtime warnings")
> Fixes: 9be68dd7ac0e ("md: add error handling support for add_disk()")
> Fixes: 7ad1069166c0 ("md: properly unwind when failing to add the kobject in md_alloc")
> Signed-off-by: Christoph Hellwig <hch@lst.de>


Reviewed-by: Logan Gunthorpe <logang@deltatee.com>

Logan
