Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66C40C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 31 May 2022 06:58:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244393AbiEaG6E (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 31 May 2022 02:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232460AbiEaG6D (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 31 May 2022 02:58:03 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD78A63BDF
        for <linux-raid@vger.kernel.org>; Mon, 30 May 2022 23:58:01 -0700 (PDT)
Received: from [192.168.0.4] (ip5f5aeb8b.dynamic.kabel-deutschland.de [95.90.235.139])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 78F6361EA1929;
        Tue, 31 May 2022 08:57:58 +0200 (CEST)
Message-ID: <047a161f-ad48-a60f-ae2e-af19234df4e0@molgen.mpg.de>
Date:   Tue, 31 May 2022 08:57:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 0/5] mdadm: fix memory leak and double free
Content-Language: en-US
To:     Wu Guanghao <wuguanghao3@huawei.com>
Cc:     linfeilong@huawei.com, lixiaokeng@huawei.com,
        jes@trained-monkey.org, linux-raid@vger.kernel.org
References: <00992179-9572-ceb4-eb49-492c42e67695@huawei.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <00992179-9572-ceb4-eb49-492c42e67695@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Wu,


Thank you for the patches.

Am 31.05.22 um 08:48 schrieb Wu Guanghao:
> Through tool scanning and code review, we found several memory leaks and double free
> 
> Wu Guanghao (5):
>    parse_layout_faulty: fix memleak
>    Detail: fix memleak
>    load_imsm_mpb: fix double free
>    find_disk_attached_hba: fix memleak
>    get_vd_num_of_subarray: fix memleak
> 
>   Detail.c      | 1 +
>   super-ddf.c   | 9 +++++++--
>   super-intel.c | 6 ++++--
>   util.c        | 1 +
>   4 files changed, 13 insertions(+), 4 deletions(-)

If an issues was found by a tool, could you please add a Reported-by tag 
to the corresponding commit message?

Another small nit, could you please add a dot/period at the end of 
sentences in the commit messages?


Kind regards,

Paul
