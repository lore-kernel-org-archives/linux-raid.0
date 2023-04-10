Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93E7CC76196
	for <linux-raid@archiver.kernel.org>; Mon, 10 Apr 2023 15:16:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbjDJPQk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 10 Apr 2023 11:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbjDJPQj (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 10 Apr 2023 11:16:39 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA5918D
        for <linux-raid@vger.kernel.org>; Mon, 10 Apr 2023 08:16:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1681139763; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=OqflisF6KZ54o+gLsNU7o1Svpi1nWjy3AjY5faowdDxgEiCm01Gkwz/4oasaKz9myd0mTGzwY9S4RsedGGmIu8/b5fxAWD48p7cd/miA6vg1EYKvLiKeLQvStL6L+TSFdmkAf5DTTIsrju5lzAg6ernmZbcs4BEirtrujDwFA0s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1681139763; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=Q4xV6kTPK/P4crU9m7H2EXvUN2UFjISt3FVbraOZfNQ=; 
        b=C0UPRgnNsoxNv277QSwyqgzjSZDugBEy7ckxxgGAF+GHSSiUiR9a8UWaqB70vciEjT40HIlSh/GbsN+KpkS1XovAUV98qBOB6rqWiYf/llEfS9ZSsCHGO/PsPFcA/Vdw5JB6TXZsyFrLkuFSZ2t6HYPgbv6iuaymUCYKwGvUXNA=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1681139761864260.1101230782466; Mon, 10 Apr 2023 17:16:01 +0200 (CEST)
Message-ID: <774b4061-1f62-c6df-6358-ff324ebc54a0@trained-monkey.org>
Date:   Mon, 10 Apr 2023 11:15:59 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] Fix null pointer for incremental in mdadm
Content-Language: en-US
To:     miaoguanqin <miaoguanqin@huawei.com>,
        mariusz.tkaczyk@linux.intel.com, pmenzel@molgen.mpg.de,
        linux-raid@vger.kernel.org
Cc:     linfeilong@huawei.com, lixiaokeng@huawei.com,
        louhongxiang@huawei.com
References: <20230404113124.1555782-1-miaoguanqin@huawei.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20230404113124.1555782-1-miaoguanqin@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 4/4/23 07:31, miaoguanqin wrote:
> when we excute mdadm --assemble, udev-md-raid-assembly.rules is triggered.
> Then we stop array, we found an coredump for mdadm --incremental.func
> stack are as follows:
> 
> #0  enough (level=10, raid_disks=4, layout=258, clean=1, 
>     avail=avail@entry=0x0) at util.c:555
> #1  0x0000562170c26965 in Incremental (devlist=<optimized out>, 
>     c=<optimized out>, st=0x5621729b6dc0) at Incremental.c:514
> #2  0x0000562170bfb6ff in main (argc=<optimized out>, 
>     argv=<optimized out>) at mdadm.c:1762
> 
> func enough() use array avail,avail allocate space in func count_active,
> it may not alloc space, causing a coredump.We fix this coredump.
> 
> Signed-off-by: Guanqin Miao <miaoguanqin@huawei.com>
> Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
> ---
>  Incremental.c | 3 +++
>  1 file changed, 3 insertions(+)

Applied!

Thanks,
Jes


