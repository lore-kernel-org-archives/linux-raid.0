Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9236CC6FD1C
	for <linux-raid@archiver.kernel.org>; Tue, 14 Mar 2023 14:58:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231361AbjCNO6k (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 14 Mar 2023 10:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231366AbjCNO6i (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 14 Mar 2023 10:58:38 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 766D3305FA
        for <linux-raid@vger.kernel.org>; Tue, 14 Mar 2023 07:58:36 -0700 (PDT)
Received: from kwepemm600010.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Pbc5N0LC9zSkwR;
        Tue, 14 Mar 2023 22:55:20 +0800 (CST)
Received: from [10.174.177.197] (10.174.177.197) by
 kwepemm600010.china.huawei.com (7.193.23.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 22:58:33 +0800
To:     Jes Sorensen <jes@trained-monkey.org>,
        Martin Wilck <mwilck@suse.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>, Coly Li <colyli@suse.de>,
        <linux-raid@vger.kernel.org>
CC:     linfeilong <linfeilong@huawei.com>, <louhongxiang@huawei.com>,
        "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>,
        miaoguanqin <miaoguanqin@huawei.com>
From:   Li Xiao Keng <lixiaokeng@huawei.com>
Subject: [QUESTION] How to fix the race of "mdadm --add" and "mdadm mdadm
 --incremental --export"
Message-ID: <252cdcda-afcd-ce76-00cf-c138136e70ab@huawei.com>
Date:   Tue, 14 Mar 2023 22:58:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.197]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600010.china.huawei.com (7.193.23.86)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,
   Here we meet a question. When we add a new disk to a raid, it may return
-EBUSY.
   The main process of --add（for example md0, sdf):
       1.dev_open(sdf)
       2.add_to_super
       3.write_init_super
       4.fsync(fd)
       5.close(fd)
       6.ioctl(ADD_NEW_DISK).
   However, there will be some udev(change of sdf) event after step5. Then
"/usr/sbin/mdadm --incremental --export $devnode --offroot $env{DEVLINKS}"
will be run, and the sdf will be added to md0. After that, step6 will return
-EBUSY.
   It is a problem to user. First time adding disk does not return success
but disk is actually added. And I have no good idea to deal with it. Please
give some great advice.

Regards,
Li Xiao Keng
