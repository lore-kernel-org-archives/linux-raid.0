Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEB76C83F10
	for <linux-raid@archiver.kernel.org>; Thu, 31 Aug 2023 09:26:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234793AbjHaJ0l (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 31 Aug 2023 05:26:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbjHaJ0k (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 31 Aug 2023 05:26:40 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC00194
        for <linux-raid@vger.kernel.org>; Thu, 31 Aug 2023 02:26:37 -0700 (PDT)
Received: from kwepemi500002.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Rbwjd3MsGzrSKX;
        Thu, 31 Aug 2023 17:24:53 +0800 (CST)
Received: from [10.174.179.167] (10.174.179.167) by
 kwepemi500002.china.huawei.com (7.221.188.171) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Thu, 31 Aug 2023 17:26:33 +0800
Message-ID: <72867401-8805-4bdb-abe4-c34ff2f06f07@huawei.com>
Date:   Thu, 31 Aug 2023 17:26:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Content-Language: en-US
To:     Jes Sorensen <jes@trained-monkey.org>,
        Martin Wilck <mwilck@suse.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>, <colyli@suse.de>,
        <linux-raid@vger.kernel.org>
CC:     linfeilong <linfeilong@huawei.com>, <louhongxiang@huawei.com>,
        <lixiaokeng@huawei.com>
From:   miaoguanqin <miaoguanqin@huawei.com>
Subject: [Question] mdadm CVE-2023-28736 and CVE-2023-28938 problem
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.167]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemi500002.china.huawei.com (7.221.188.171)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear mdadm committers:

Hi! I noticed that the community did not provide the concrete patch
that could fix CVE-2023-28736 and CVE-2023-28938. Intel, in specific,
suggests upgrading mdadm to version 4.2-rc2 or later [1], to get rid of
the issue, however, without finding the root cause or providing further
explanation.I would like to know if there is such a specific patch,
or a set of patches that actually solve these two CVE problems.

[1] 
https://www.intel.com/content/www/us/en/security-center/advisory/intel-sa-00690.html

Many thanks in advance!

Best wishes,
Guanqin Miao
