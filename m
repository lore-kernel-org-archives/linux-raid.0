Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93E97C77B7A
	for <linux-raid@archiver.kernel.org>; Wed, 24 May 2023 06:04:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239563AbjEXGEl (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 May 2023 02:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239598AbjEXGEk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 24 May 2023 02:04:40 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0108419D;
        Tue, 23 May 2023 23:04:36 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7F65468CFE; Wed, 24 May 2023 08:04:33 +0200 (CEST)
Date:   Wed, 24 May 2023 08:04:33 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     hch@lst.de, song@kernel.org, axboe@kernel.dk,
        chaitanya.kulkarni@wdc.com, johannes.thumshirn@wdc.com,
        damien.lemoal@wdc.com, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, yukuai3@huawei.com,
        yi.zhang@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH] md/raid5: fix miscalculation of 'end_sector' in
 raid5_read_one_chunk()
Message-ID: <20230524060433.GA19611@lst.de>
References: <20230524014118.3172781-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230524014118.3172781-1-yukuai1@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
