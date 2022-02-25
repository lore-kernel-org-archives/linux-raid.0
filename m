Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C858DC433F5
	for <linux-raid@archiver.kernel.org>; Fri, 25 Feb 2022 00:55:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236217AbiBYA4U (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 24 Feb 2022 19:56:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231271AbiBYA4U (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 24 Feb 2022 19:56:20 -0500
X-Greylist: delayed 2260 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 24 Feb 2022 16:55:47 PST
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EDC11DFDF5
        for <linux-raid@vger.kernel.org>; Thu, 24 Feb 2022 16:55:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:Date:Message-ID:From:Cc:To
        :references:content-disposition:in-reply-to;
        bh=D6kpix887SPlrzykQLaJNFmCQEzZ4+yRxALKNcv5WeU=; b=f+LTCov/qVcvnXpfs7OUOUWlaw
        F0glXV0IQ6aBj4seut/k9wDDs9hFyrfTFWfvCQZ2zdZaZgixfNjoCRMVCPJshdgX/MbI5bJpuyMNO
        e8Sg9cQkVeqkeqzmKe6CB6lLYpdPo12hzl6yM5F77gKoMzNYYrPCtQm5qGcfwpj15M0BM9YP6QAY2
        xt0nbHECAYYGIka2RcXOL1LJioJU0lKmRQOnU+6/UrVUt/V9kjosIAcyyn3RHseLdWZc2EdGSyjjt
        0WuAQpwQFA10zUTIEo1UTEn+QpwN52KzKcp6c1OcgkRh9mhCa4VjdnTK6702RfLuL79cBu7KdY2+X
        6MbkGDWA==;
Received: from s0106a84e3fe8c3f3.cg.shawcable.net ([24.64.144.200] helo=[192.168.0.10])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1nNOJ5-008DZQ-V0; Thu, 24 Feb 2022 17:18:01 -0700
To:     linux-raid@vger.kernel.org
Cc:     Shaohua Li <shli@kernel.org>, Shaohua Li <shli@fb.com>,
        Song Liu <song@kernel.org>
From:   Logan Gunthorpe <logang@deltatee.com>
Message-ID: <11cfe3aa-b778-b3e5-a152-50abc6c054ac@deltatee.com>
Date:   Thu, 24 Feb 2022 17:17:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 24.64.144.200
X-SA-Exim-Rcpt-To: song@kernel.org, shli@fb.com, shli@kernel.org, linux-raid@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Raid5 Batching Question
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello,

We've been looking at trying to improve sequential write performance out
of Raid5 on modern hardware. Our profiling so far seems to indicate that
one of the issues is high CPU due handling all the stripe heads, one for
each page. Some investigation shows that Shaohua already added a
batching feature back in 2015 which seems like it is exactly what we need.

However, after adding some additional debug prints we're not seeing any
batching occurring in our basic testing and I find myself rather
confused by the code.

I see that batches are supposed to be created at the end of
add_stripe_bio() with a call to stripe_add_to_batch_list(). But in our
testing stripe_can_batch() never returns true.

stripe_can_batch() calls is_full_stripe_write() which returns the
following formula:

  overwrite_disks == (disks - max_degraded)

In our simple tests, disks is 3 and this is raid5 so max_degraded is 1.
However, overwrite_disks is also always 1. So, 1 != (3-1) and
is_full_stripe_write() always seems to return false.

overwrite_disks appears to be incremented on the stripe only once
earlier in add_stripe_bio() after seeming to check if all sectors in the
page are being written. But I don't see how overwrite_disks would ever
be 2 for a single stripe.

What am I missing? How can I ensure batches are being used with large
sequential writes?

Thanks,

Logan



