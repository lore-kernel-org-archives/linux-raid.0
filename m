Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A92B4C61DA4
	for <linux-raid@archiver.kernel.org>; Mon, 13 Mar 2023 14:17:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbjCMORv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 13 Mar 2023 10:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230522AbjCMORs (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 13 Mar 2023 10:17:48 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E30E1115D
        for <linux-raid@vger.kernel.org>; Mon, 13 Mar 2023 07:17:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1678717029; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=PRLbPwfJjz5ACN/De9AZVk1tSHXEReZ9dXBVLDWlQJZS1CFY2spjEYE6aZX2DQhR1nzCdaEYj6xXzONzbTw93GVrm34oJ7/H5JvTx/07OF5wjM/T6QJy5PR6vOWPeB+s3gzUqWup0WsVuFYNwnuwz/FDgao9pXWd/k5m607yHdU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1678717029; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=adX6ErEySqGhRFTUE4avrMuVB76Y74rVdCe70C+W/Bw=; 
        b=TJtZKjVyWxBXbxqw5G1l1tgB4/avAVinTGeJ42DqSP4HBcTFRy3Ol1gy1yBwk+siYiK2EyDbIL6wkQw49KqSj47XKLIiHbiA5v5y/xDs/my9LtgJ7RTccY1mSxJZRcl/dTUhCFmqCoOZVGaZox2vGtAmB2KtLJUlmBYYQQ0P4d8=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1678717027051434.4171373574128; Mon, 13 Mar 2023 15:17:07 +0100 (CET)
Message-ID: <a3e571d9-ccfb-44d3-fe43-f0f2b85b26ea@trained-monkey.org>
Date:   Mon, 13 Mar 2023 10:17:04 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] Fix memory leak for function Manage_subdevs Manage_add
 Kill V2
Content-Language: en-US
To:     miaoguanqin <miaoguanqin@huawei.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>, linux-raid@vger.kernel.org
Cc:     linfeilong <linfeilong@huawei.com>,
        "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>,
        Wu Guanghao <wuguanghao3@huawei.com>, lixiaokeng@huawei.com
References: <5ab784a2-df14-62d7-873a-622b34b6a646@huawei.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <5ab784a2-df14-62d7-873a-622b34b6a646@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 2/22/23 03:30, miaoguanqin wrote:
> When we test mdadm with asan,we found some memory leaks.
> We fix these memory leaks based on code logic.
> 
> Signed-off-by: miaoguanqin <miaoguanqin@huawei.com>

Hi,

Your mail client sent the patch with format=flowed which is bad and
prevents it from being applied. Can you please resend.

Thanks,
Jes


