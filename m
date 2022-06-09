Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58AFEC43334
	for <linux-raid@archiver.kernel.org>; Thu,  9 Jun 2022 03:05:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237390AbiFIDFg (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 8 Jun 2022 23:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232220AbiFIDFf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 8 Jun 2022 23:05:35 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E732B3A2B8B
        for <linux-raid@vger.kernel.org>; Wed,  8 Jun 2022 20:05:33 -0700 (PDT)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4LJTSZ17D2zgYX5;
        Thu,  9 Jun 2022 11:03:42 +0800 (CST)
Received: from dggpemm500014.china.huawei.com (7.185.36.153) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 9 Jun 2022 11:05:32 +0800
Received: from [10.174.177.211] (10.174.177.211) by
 dggpemm500014.china.huawei.com (7.185.36.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 9 Jun 2022 11:05:31 +0800
Message-ID: <fd86d427-2d3e-b337-6de8-d70dcbbd6ce1@huawei.com>
Date:   Thu, 9 Jun 2022 11:05:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
To:     <jes@trained-monkey.org>, <linux-raid@vger.kernel.org>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>
CC:     <linfeilong@huawei.com>, <lixiaokeng@huawei.com>
From:   Wu Guanghao <wuguanghao3@huawei.com>
Subject: [PATCH 0/5 v2] mdadm: fix memory leak and double free
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.211]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500014.china.huawei.com (7.185.36.153)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Through tool scanning and code review, we found several memory leaks and double free.

v2:
- add empty lines to separate declarations and not related code
sections. [1/5]
- free super->buf and set NULL in load_imsm_mpb [3/5]
- optimize code to avoid code duplication. [4/5]

Wu Guanghao (5):
  parse_layout_faulty: fix memleak
  Detail: fix memleak
  load_imsm_mpb: fix double free
  find_disk_attached_hba: fix memleak
  get_vd_num_of_subarray: fix memleak

 Detail.c      | 1 +
 super-ddf.c   | 9 +++++++--
 super-intel.c | 5 +++--
 util.c        | 3 +++
 4 files changed, 14 insertions(+), 4 deletions(-)

--
2.27.0
