Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB3E6C001B0
	for <linux-raid@archiver.kernel.org>; Tue,  8 Aug 2023 17:14:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234210AbjHHROu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 8 Aug 2023 13:14:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232807AbjHHROO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 8 Aug 2023 13:14:14 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A749726B1;
        Tue,  8 Aug 2023 09:05:54 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 965BE67373; Tue,  8 Aug 2023 18:05:20 +0200 (CEST)
Date:   Tue, 8 Aug 2023 18:05:20 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     hch@lst.de, song@kernel.org, bugfood-ml@fatooh.org,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        yukuai3@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH -next] md/raid5-cache: fix null-ptr-deref for
 r5l_flush_stripe_to_raid()
Message-ID: <20230808160520.GA16024@lst.de>
References: <20230808104912.1254342-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230808104912.1254342-1-yukuai1@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

