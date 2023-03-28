Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0BFFC77B60
	for <linux-raid@archiver.kernel.org>; Tue, 28 Mar 2023 11:21:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbjC1LVS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 28 Mar 2023 07:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjC1LVR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 28 Mar 2023 07:21:17 -0400
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A38AB
        for <linux-raid@vger.kernel.org>; Tue, 28 Mar 2023 04:21:16 -0700 (PDT)
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 5CAB861CC40F9;
        Tue, 28 Mar 2023 13:21:12 +0200 (CEST)
Message-ID: <10ffc219-2ffc-8f0b-d18e-54d7c76ee7bc@molgen.mpg.de>
Date:   Tue, 28 Mar 2023 13:21:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 1/4] Fix memory leak in file Assemble
To:     miaoguanqin@huawei.com
Cc:     jes@trained-monkey.org, mariusz.tkaczyk@linux.intel.com,
        linux-raid@vger.kernel.org, linfeilong@huawei.com,
        lixiaokeng@huawei.com, louhongxiang@huawei.com
References: <20230323013053.3238005-1-miaoguanqin@huawei.com>
 <20230323013053.3238005-2-miaoguanqin@huawei.com>
Content-Language: en-US
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20230323013053.3238005-2-miaoguanqin@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Miao,


Thank you for your patches.

Am 23.03.23 um 02:30 schrieb miaoguanqin:
> When we test mdadm with asan,we found some memory leaks in Assemble.c
> We fix these memory leaks based on code logic.
> 
> Signed-off-by: miaoguanqin <miaoguanqin@huawei.com>
> Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>

It’d be great if you used the full names (also in your From: field) 
instead of usernames. For example, Li Xiao Keng.

     git config --global user.name "…"
     git commit --amend --author="… <miaoguanqin@huawei.com>"


Kind regards,

Paul
