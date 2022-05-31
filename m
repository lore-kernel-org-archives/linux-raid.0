Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47E20C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 31 May 2022 06:48:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244355AbiEaGst (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 31 May 2022 02:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244329AbiEaGst (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 31 May 2022 02:48:49 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22A95703DD
        for <linux-raid@vger.kernel.org>; Mon, 30 May 2022 23:48:47 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LC2pr1CfmzBrnJ;
        Tue, 31 May 2022 14:45:40 +0800 (CST)
Received: from dggpemm500014.china.huawei.com (7.185.36.153) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 31 May 2022 14:48:45 +0800
Received: from [10.174.177.211] (10.174.177.211) by
 dggpemm500014.china.huawei.com (7.185.36.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 31 May 2022 14:48:45 +0800
Message-ID: <00992179-9572-ceb4-eb49-492c42e67695@huawei.com>
Date:   Tue, 31 May 2022 14:48:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
From:   Wu Guanghao <wuguanghao3@huawei.com>
To:     <jes@trained-monkey.org>, <linux-raid@vger.kernel.org>
CC:     <linfeilong@huawei.com>, <lixiaokeng@huawei.com>
Subject: [PATCH 0/5] mdadm: fix memory leak and double free
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.211]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500014.china.huawei.com (7.185.36.153)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Through tool scanning and code review, we found several memory leaks and double free

Wu Guanghao (5):
  parse_layout_faulty: fix memleak
  Detail: fix memleak
  load_imsm_mpb: fix double free
  find_disk_attached_hba: fix memleak
  get_vd_num_of_subarray: fix memleak

 Detail.c      | 1 +
 super-ddf.c   | 9 +++++++--
 super-intel.c | 6 ++++--
 util.c        | 1 +
 4 files changed, 13 insertions(+), 4 deletions(-)

-- 
2.27.0
