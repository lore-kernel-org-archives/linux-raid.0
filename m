Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5820ECAAA1
	for <linux-raid@archiver.kernel.org>; Fri, 16 Sep 2022 18:36:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbiIPSgE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 16 Sep 2022 14:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiIPSgD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 16 Sep 2022 14:36:03 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 305CDB7EE4;
        Fri, 16 Sep 2022 11:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=PIZS6JKCM/nCyXPDyinQIk8TT3poLAi1Fl5CTo8GQ+U=; b=qwDjT4GZOdxBaEbM4XuvzTgIs6
        evNohzW7HIxYtqD7uDtvgF7h8uk786H3PQPur0g+db0/7ZNowOZc6GCAaCuVpFlXVYV5iQoHoDtAa
        Mq/I2QZQzJpOpkcWgPyvEiS9+QAUbtJmEanm73iK8062rWbidEScR/LNz37lNVBnRCImOuID/A67G
        rLhAmejG47ok+PwZl5RrictanP0q44w2jlAj+YllPZcQF+jY+6fKjGvNFfQHC4wD2ENEmnAbx+SSh
        MGAJzPM+JYdKMnl1jBHnW32XYKOiXz/hV+5TiTWXV5WPVVfyoqqjXkCjMdgTQHLtfOXqaM2vATOgE
        6KoB1yfQ==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1oZGBo-003JP0-3k; Fri, 16 Sep 2022 12:35:48 -0600
Message-ID: <02a974b9-a3d8-339b-1aea-5879286e72f3@deltatee.com>
Date:   Fri, 16 Sep 2022 12:35:47 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Content-Language: en-CA
To:     Yu Kuai <yukuai1@huaweicloud.com>, song@kernel.org,
        guoqing.jiang@linux.dev, pmenzel@molgen.mpg.de
Cc:     linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        yukuai3@huawei.com, yi.zhang@huawei.com
References: <20220916113428.774061-1-yukuai1@huaweicloud.com>
 <20220916113428.774061-3-yukuai1@huaweicloud.com>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20220916113428.774061-3-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: yukuai1@huaweicloud.com, song@kernel.org, guoqing.jiang@linux.dev, pmenzel@molgen.mpg.de, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH v3 2/5] md/raid10: don't modify 'nr_waitng' in
 wait_barrier() for the case nowait
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2022-09-16 05:34, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> For the case nowait in wait_barrier(), there is no point to increase
> nr_waiting and then decrease it.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>

