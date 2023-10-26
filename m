Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDE4CC25B48
	for <linux-raid@archiver.kernel.org>; Thu, 26 Oct 2023 21:44:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344874AbjJZVoQ convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 26 Oct 2023 17:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234964AbjJZVoM (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 26 Oct 2023 17:44:12 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE97810F7
        for <linux-raid@vger.kernel.org>; Thu, 26 Oct 2023 14:43:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1698356564; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=K4wTpaZK8wHYRP0jwrw9CHDjSwc7kMHeBTvoWvP53+Wu2gLm7/pc//fWqzNcXBXTnxEuKKWoWQBT6mNEtJoBk8lMI2iKylEPu2Nyl1Aeh3o9JBK6EjCtqbFKfcVcgzSRva7h+ysAcyIhaOBuYaV/Do8LcZCP98TXpS6iEe2jX/M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1698356564; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
        bh=+osDMo2jFE3XtQTzmUsP4IjA787HjENnj/7TuRqtd3c=; 
        b=jGIn4DPDJVn4F5jAst3jzxnMdaM8pMs9IC4Qnsshn5qbTH4S5/+I9XQ2uz4/bquIceOpwDxAnPoBif4luH/OtbcpXuJT4XaYbS7I1Wstm51Wv5a3F2pxVZ8Sb9zsOWdfrxkdGQ8F3XZ144MeccAsF+bae0ON3Kh6QEVKaUBrFOA=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1698356561393808.8828833919055; Thu, 26 Oct 2023 23:42:41 +0200 (CEST)
Date:   Thu, 26 Oct 2023 17:42:39 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v3] Fix race of "mdadm --add" and "mdadm --incremental"
Content-Language: en-US
To:     Li Xiao Keng <lixiaokeng@huawei.com>,
        Martin Wilck <mwilck@suse.com>, Coly Li <colyli@suse.de>,
        linux-raid@vger.kernel.org
Cc:     louhongxiang@huawei.com, miaoguanqin <miaoguanqin@huawei.com>
References: <a25e4d75-ebc3-0841-832c-34b8e5f4cbb7@huawei.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <cc19fa8a-55e8-9b34-5de9-1c78b0762ed9@trained-monkey.org>
In-Reply-To: <a25e4d75-ebc3-0841-832c-34b8e5f4cbb7@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/7/23 07:37, Li Xiao Keng wrote:
> There is a raid1 with sda and sdb. And we add sdc to this raid,
> it may return -EBUSY.
> 
> The main process of --add:
> 1. dev_open（sdc) in Manage_add
> 2. store_super1(st, di->fd) in write_init_super1
> 3. fsync(fd) in store_super1
> 4. close(di->fd) in write_init_super1
> 5. ioctl(ADD_NEW_DISK)
> 
> Step 2 and 3 will add sdc to metadata of raid1. There will be
> udev(change of sdc) event after step4. Then "/usr/sbin/mdadm
> --incremental --export $devnode --offroot $env{DEVLINKS}"
> will be run, and the sdc will be added to the raid1. Then
> step 5 will return -EBUSY because it checks if device isn't
> claimed in md_import_device()->lock_rdev()->blkdev_get_by_dev()
> ->blkdev_get().
> 
> It will be confusing for users because sdc is added first time.
> The "incremental" will get map_lock before add sdc to raid1.
> So we add map_lock before write_init_super in "mdadm --add"
> to fix the race of "add" and "incremental".
> 
> Signed-off-by: Li Xiao Keng <lixiaokeng@huawei.com>
> Signed-off-by: Guanqin Miao <miaoguanqin@huawei.com>

Applied!

Thanks,
Jes



