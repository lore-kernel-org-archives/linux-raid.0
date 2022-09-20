Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57F0FC6FA82
	for <linux-raid@archiver.kernel.org>; Tue, 20 Sep 2022 02:28:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbiITC2w (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 19 Sep 2022 22:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbiITC2v (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 19 Sep 2022 22:28:51 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F9E85756E
        for <linux-raid@vger.kernel.org>; Mon, 19 Sep 2022 19:28:50 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MWlk30HxXzlW3W;
        Tue, 20 Sep 2022 10:24:43 +0800 (CST)
Received: from huawei.com (10.175.127.227) by canpemm500010.china.huawei.com
 (7.192.105.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 20 Sep
 2022 10:28:48 +0800
From:   Ye Bin <yebin10@huawei.com>
To:     <song@kernel.org>, <linux-raid@vger.kernel.org>
CC:     <yebin10@huawei.com>
Subject: [PATCH -next 0/3] do some cleanup for md_ioctl
Date:   Tue, 20 Sep 2022 10:39:35 +0800
Message-ID: <20220920023938.3273598-1-yebin10@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Ye Bin (3):
  md: refactor md ioctl cmd check
  md: factor out __md_set_array_info()
  md: introduce md_ro_state to make code easy to understand

 drivers/md/md.c | 249 +++++++++++++++++++++++++-----------------------
 1 file changed, 131 insertions(+), 118 deletions(-)

-- 
2.31.1

