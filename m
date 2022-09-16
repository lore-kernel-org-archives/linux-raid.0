Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF7E5ECAAD8
	for <linux-raid@archiver.kernel.org>; Fri, 16 Sep 2022 18:35:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiIPSfv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 16 Sep 2022 14:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiIPSft (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 16 Sep 2022 14:35:49 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D53AC979C4;
        Fri, 16 Sep 2022 11:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=kJIc7NqcYR1MP3Jy8goJn5/NXsx5nBAkLTWuvTAL5Fk=; b=AaIrBbZEl3QaLssyMYrqkucXOc
        VvwN8gndZkxkUjLcYdZ0Ve0+SpJgdVz3MlUMgUSchTR19j4crJj7sTMqCEfLZBzxzevYh8SUrAeaC
        PJDKhSb+Zp2LhRllXy/6G5mD8eTHhjxU8+Fezp09BnlA6hyllghGx1aGZGyrvdbWt6FOdZmTniIvU
        YKZpxjUSwu3HMCq2FgOkvJPsUTtk2tpKP/GaJxCrhsGjmHjBXgtAiFk4qcTBAR2TRY73EQmdvt0F/
        t4z5xd+oqLs07sIsCNInBD1o9q/GCh8kwNYXhGao90wwFdxLmb08ZjzfY83Chtgs3Bq7BCOipj7tO
        EhO/VfGA==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1oZGBU-003JOk-6m; Fri, 16 Sep 2022 12:35:29 -0600
Message-ID: <d3f4ca12-a9dd-9eca-580e-938165a75d65@deltatee.com>
Date:   Fri, 16 Sep 2022 12:35:23 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Content-Language: en-CA
To:     Yu Kuai <yukuai1@huaweicloud.com>, song@kernel.org,
        guoqing.jiang@linux.dev, pmenzel@molgen.mpg.de
Cc:     linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        yukuai3@huawei.com, yi.zhang@huawei.com
References: <20220916113428.774061-1-yukuai1@huaweicloud.com>
 <20220916113428.774061-2-yukuai1@huaweicloud.com>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20220916113428.774061-2-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: yukuai1@huaweicloud.com, song@kernel.org, guoqing.jiang@linux.dev, pmenzel@molgen.mpg.de, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH v3 1/5] md/raid10: factor out code from wait_barrier() to
 stop_waiting_barrier()
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2022-09-16 05:34, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> Currently the nasty condition in wait_barrier() is hard to read. This
> patch factors out the condition into a function.
> 
> There are no functional changes.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> Acked-by: Paul Menzel <pmenzel@molgen.mpg.de>

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>

