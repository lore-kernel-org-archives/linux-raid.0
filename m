Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E0A5C77B61
	for <linux-raid@archiver.kernel.org>; Mon, 10 Apr 2023 15:50:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbjDJPuL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 10 Apr 2023 11:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbjDJPuJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 10 Apr 2023 11:50:09 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0DE61702
        for <linux-raid@vger.kernel.org>; Mon, 10 Apr 2023 08:50:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1681141801; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=bvOeooiCP7THSSUlvyPZW0MemdkdiXviNpoAJsIeLu16FnsLLLuhkpSiZmTFM4YoiSdANvvhHcQjB8QOPJYXyZhTUxwTGVy3tHUDgYWwrhwtcxGGQxK/dz6+KrT7ge7ZU2nFJGV0UsN+IQj7g3jr9lQWsXi2qYK2BalP3ABX6dg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1681141801; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=AKxp9eX5jMTdWZJg80926KQk7BLPlCzzYBLMiPfdp/U=; 
        b=TTpa/UXAFlZBtB/PnGzw03IPyzhPfkN41ZTUmNxqAseB4ZEqDzXpAV4uyZAikKxQlROjl8cylWVyD1Png30zAb08l/sD//8YFd9UxRM66MUDmEnha205WqA4tFCImikZmuHbhdT1UkIGJotIL/5QE9lfI94/BQnF334B9OkduTI=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1681141800940191.61191959051132; Mon, 10 Apr 2023 17:50:00 +0200 (CEST)
Message-ID: <e8ed86bb-4162-7d8e-ece9-eb75e045bcc5@trained-monkey.org>
Date:   Mon, 10 Apr 2023 11:49:59 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US
To:     "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>
Cc:     NeilBrown <neilb@suse.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Subject: mdadm minimum kernel version requirements?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

I bumped the minimum kernel version required for mdadm to 2.6.32.

Should we drop support for anything prior to 3.10 at this point, since
RHEL7 is 3.10 based and SLES12 seems to be 3.12 based.

Thoughts?

Jes
