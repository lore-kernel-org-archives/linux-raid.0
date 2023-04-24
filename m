Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 225F9C77B61
	for <linux-raid@archiver.kernel.org>; Mon, 24 Apr 2023 08:07:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbjDXIHm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 24 Apr 2023 04:07:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231504AbjDXIHj (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 24 Apr 2023 04:07:39 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 861051707
        for <linux-raid@vger.kernel.org>; Mon, 24 Apr 2023 01:07:36 -0700 (PDT)
Received: from kwepemi500002.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Q4d144N80zSv7Q;
        Mon, 24 Apr 2023 16:03:20 +0800 (CST)
Received: from huawei.com (10.175.101.6) by kwepemi500002.china.huawei.com
 (7.221.188.171) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Mon, 24 Apr
 2023 16:07:34 +0800
From:   Guanqin Miao <miaoguanqin@huawei.com>
To:     <jes@trained-monkey.org>, <mariusz.tkaczyk@linux.intel.com>,
        <pmenzel@molgen.mpg.de>, <linux-raid@vger.kernel.org>
CC:     <linfeilong@huawei.com>, <lixiaokeng@huawei.com>,
        <louhongxiang@huawei.com>
Subject: [PATCH 0/4] Fix memory leak for Manage Assemble Kill mdadm
Date:   Mon, 24 Apr 2023 16:06:33 +0800
Message-ID: <20230424080637.2152893-1-miaoguanqin@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500002.china.huawei.com (7.221.188.171)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

When we test mdadm with asan,i we found some memory leaks.
We fix these memory leaks based on code logic.

Guanqin Miao (4):
  Fix memory leak in file Assemble
  Fix memory leak in file Kill
  Fix memory leak in file Manage
  Fix memory leak in file mdadm

 Assemble.c | 13 +++++++++++--
 Kill.c     |  9 ++++++++-
 Manage.c   | 11 ++++++++++-
 mdadm.c    |  4 ++++
 4 files changed, 33 insertions(+), 4 deletions(-)

-- 
2.33.0

