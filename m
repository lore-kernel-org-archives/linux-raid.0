Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8A5BC00144
	for <linux-raid@archiver.kernel.org>; Tue,  2 Aug 2022 02:14:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233027AbiHBCO4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 1 Aug 2022 22:14:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231374AbiHBCOz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 1 Aug 2022 22:14:55 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2EC3340E
        for <linux-raid@vger.kernel.org>; Mon,  1 Aug 2022 19:14:54 -0700 (PDT)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Lxdnr232lzGpKQ;
        Tue,  2 Aug 2022 10:13:36 +0800 (CST)
Received: from dggpemm500014.china.huawei.com (7.185.36.153) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 2 Aug 2022 10:14:52 +0800
Received: from [10.174.177.211] (10.174.177.211) by
 dggpemm500014.china.huawei.com (7.185.36.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 2 Aug 2022 10:14:52 +0800
Message-ID: <11b7eff6-56a0-49ee-b2fd-50b402c3dde1@huawei.com>
Date:   Tue, 2 Aug 2022 10:14:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
To:     Jes Sorensen <jes@trained-monkey.org>,
        <linux-raid@vger.kernel.org>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
CC:     linfeilong <linfeilong@huawei.com>, <lixiaokeng@huawei.com>
From:   Wu Guanghao <wuguanghao3@huawei.com>
Subject: [PATCH 0/5 v2 resend] mdadm: fix memory leak and double free
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.211]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
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
