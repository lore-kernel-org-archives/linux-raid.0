Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C10FFCA0FE1
	for <linux-raid@archiver.kernel.org>; Fri,  1 Sep 2023 15:51:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234727AbjIAPvb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 1 Sep 2023 11:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235364AbjIAPvb (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 1 Sep 2023 11:51:31 -0400
Received: from sender-op-o9.zoho.eu (sender-op-o9.zoho.eu [136.143.169.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D07010EF
        for <linux-raid@vger.kernel.org>; Fri,  1 Sep 2023 08:51:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1693582562; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=azh1H70tg342Qw3+SnWrZ4Xzg8SV0kxmbC5ffEdGTRePdtIlP9gEoFUCOfKEQbKHKnNqwbSFz4kWr02/fyCIeUi5VKkb8EgmmQQvo+OxiIPUVh+eduR/mtG5NPGX4CiHHFJK3G14acBgFU/eQSDXxIKgKT9/gWsAUsBCjF6TrbI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1693582562; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
        bh=a7d4ly5jdTg0LjUgp4IlVJj4l1AVouEJVRBYw/cmNy4=; 
        b=KhAlXPLxUH3w+DbljA7PtPdQ3F3dOBqbL3Iq22ITYkHVOXmvP1tnU7p36prTy/CFpOXu3X2v8YukxrAXWAVdK9FETgC38pduTT3DTVO/CMcgsjohwR9PJas8lKOMQVM2nFzCeu6fz28pVfDOas39QN/2F5LGOlpNiV2ua8VDyMM=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1693582560000277.6982892516347; Fri, 1 Sep 2023 17:36:00 +0200 (CEST)
Message-ID: <52f43128-6f68-49fd-9b25-c3026d007d83@trained-monkey.org>
Date:   Fri, 1 Sep 2023 11:35:57 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v4 1/2] Mdmonitor: Improve udev event handling
Content-Language: en-US
To:     Mateusz Grzonka <mateusz.grzonka@intel.com>,
        linux-raid@vger.kernel.org
References: <20230705145020.31144-1-mateusz.grzonka@intel.com>
Cc:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20230705145020.31144-1-mateusz.grzonka@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 7/5/23 10:50, Mateusz Grzonka wrote:
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

Generally looks good to me.

One question, is there a minimum version of udev required for this to
work or has it been around long enough that we don't need to worry?

Thanks,
Jes


