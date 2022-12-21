Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4974C4332F
	for <linux-raid@archiver.kernel.org>; Wed, 21 Dec 2022 09:03:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234122AbiLUJD6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 21 Dec 2022 04:03:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234336AbiLUJD5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 21 Dec 2022 04:03:57 -0500
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F49C20981
        for <linux-raid@vger.kernel.org>; Wed, 21 Dec 2022 01:03:55 -0800 (PST)
Received: from [141.14.12.17] (g017.RadioFreeInternet.molgen.mpg.de [141.14.12.17])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id EB21A60027FC0;
        Wed, 21 Dec 2022 10:03:51 +0100 (CET)
Message-ID: <20580e58-0c20-0e9e-17d9-59a957da7b74@molgen.mpg.de>
Date:   Wed, 21 Dec 2022 10:03:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH V3] Fix NULL dereference in super_by_fd
To:     Li Xiao Keng <lixiaokeng@huawei.com>
Cc:     Jes Sorensen <jes@trained-monkey.org>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        linux-raid@vger.kernel.org, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com, Wu Guang Hao <wuguanghao3@huawei.com>
References: <44edac17-12c8-a512-3d27-f2f22e82b990@huawei.com>
Content-Language: en-US
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <44edac17-12c8-a512-3d27-f2f22e82b990@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Li,


Thank you for the third iteration.

Am 20.12.22 um 12:27 schrieb lixiaokeng:

[…]

> Signed-off-by: Li Xiao Keng <lixiaokeng@huawei.com>
> Signed-off-by: Wu Guang Hao <wuguanghao3@huawei.com>

The From field of your email still contains lixiaokeng. It looks like 
you are using Mozilla Thunderbird. You can configure that in the 
accounts settings. Otherwise, using `git send-email` should work in the 
future.


Kind regards,

Paul
