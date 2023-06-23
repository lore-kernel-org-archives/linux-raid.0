Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4456EB64DD
	for <linux-raid@archiver.kernel.org>; Fri, 23 Jun 2023 09:53:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbjFWJxP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 23 Jun 2023 05:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbjFWJxN (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 23 Jun 2023 05:53:13 -0400
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B104E48;
        Fri, 23 Jun 2023 02:53:12 -0700 (PDT)
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 5658D61E5FE03;
        Fri, 23 Jun 2023 11:52:23 +0200 (CEST)
Message-ID: <2cfb7dd4-ef6e-c460-8132-5c1c49cf6877@molgen.mpg.de>
Date:   Fri, 23 Jun 2023 11:52:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 0/3] md/raid10: optimize and fix read error
Content-Language: en-US
To:     linan666@huaweicloud.com
References: <20230623173236.2513554-1-linan666@huaweicloud.com>
Cc:     song@kernel.org, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, linan122@huawei.com,
        yukuai3@huawei.com, yi.zhang@huawei.com, houtao1@huawei.com,
        yangerkun@huawei.com
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20230623173236.2513554-1-linan666@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Li,


Thank you for your patches.

Am 23.06.23 um 19:32 schrieb linan666@huaweicloud.com:
> From: Li Nan <linan122@huawei.com>

Just a note, that the date/timestamps of your patches are from the 
future. (Yu’s patches had the same problem.) Could you please make sure 
to set up the system time correctly.

     Received: from huaweicloud.com (unknown [10.175.104.67])
             by APP4 (Coremail) with SMTP id 
gCh0CgCXaK8TZ5VkaZ1hMQ--.14505S4;
             Fri, 23 Jun 2023 17:34:11 +0800 (CST)
     […]
     Date:   Sat, 24 Jun 2023 01:32:33 +0800

[…]


Kind regards,

Paul
