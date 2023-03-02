Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BFFAC678D4
	for <linux-raid@archiver.kernel.org>; Thu,  2 Mar 2023 15:59:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbjCBP7a (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 2 Mar 2023 10:59:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCBP73 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 2 Mar 2023 10:59:29 -0500
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80C4946080
        for <linux-raid@vger.kernel.org>; Thu,  2 Mar 2023 07:59:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1677772762; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=k4IMb816yzapEzl8x5chJ+/NnNTrHU5IAXwKUek0kIuddjWEHk5jgBSkOqRlrA90FVriaeTSbdim96TcG7rqwetOJjKqdpzxk55LRX/LbdgN/jJKD9/ZSa4ikj1HTfOKfeNp+L9L6Y1BejzVgYDcFNjcSWK9jPm9e8ZDcsepprU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1677772762; h=Content-Type:Content-Transfer-Encoding:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=0ILXq+N721W+mc0Y94+NV/pCjPXKM8XaiU9sFygMtq4=; 
        b=hb5X0kq2x3oT0OYjKbs5TPXGaOfbz5o71APTGpdJp7AwEosBMNpaP4+oFtR9lP74dqJmjQS3TLb3Y9qoP/HVkhkKWcfnt5JY1WzNQr1r9MJ/jx2D3tp+8Yp+AqaHl9rVmC8jNTZIzKu8nZcssG7ABC8zfBJ8N89S/F+zNq41ErE=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1677772761457276.83620251740524; Thu, 2 Mar 2023 16:59:21 +0100 (CET)
Message-ID: <337d01d2-2a54-5949-a1a8-a252637f53e0@trained-monkey.org>
Date:   Thu, 2 Mar 2023 10:59:20 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3 7/8] Mdmonitor: Improve udev event handling
Content-Language: en-US
To:     Mateusz Grzonka <mateusz.grzonka@intel.com>,
        linux-raid@vger.kernel.org
References: <20230202112706.14228-1-mateusz.grzonka@intel.com>
 <20230202112706.14228-8-mateusz.grzonka@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20230202112706.14228-8-mateusz.grzonka@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 2/2/23 06:27, Mateusz Grzonka wrote:
> Mdmonitor is waiting for udev queue to become empty.
> Even if the queue becomes empty, udev might still be processing last event.
> However we want to wait and wake up mdmonitor when udev finished
> processing events..
> 
> Also, the udev queue interface is considered legacy and should not be
> used outside of udev.
> 
> Use udev monitor instead, and wake up mdmonitor on every event triggered
> by udev for md block device.
> 
> We need to generate more change events from kernel, because they are
> missing in some situations, for example, when rebuild started.
> This will be addressed in a separate patch.
> 
> Move udev specific code into separate functions, and place them in udev.c file.
> Also move use_udev() logic from lib.c into newly created file.
> 
> Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
> ---

This one breaks for me too :(

Jes


