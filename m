Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92F16C433EF
	for <linux-raid@archiver.kernel.org>; Wed,  9 Mar 2022 08:24:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbiCIIZq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 9 Mar 2022 03:25:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbiCIIZp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 9 Mar 2022 03:25:45 -0500
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A606D4A909;
        Wed,  9 Mar 2022 00:24:46 -0800 (PST)
Received: from [192.168.0.3] (ip5f5aef7a.dynamic.kabel-deutschland.de [95.90.239.122])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id EBC2361E64846;
        Wed,  9 Mar 2022 09:24:44 +0100 (CET)
Message-ID: <487079ff-356c-a50f-097c-45c4a968d44c@molgen.mpg.de>
Date:   Wed, 9 Mar 2022 09:24:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH 2/2] block: remove the per-bio/request write hint.
Content-Language: en-US
To:     Manjong Lee <mj0123.lee@samsung.com>
Cc:     david@fromorbit.com, axboe@kernel.dk, hch@lst.de,
        kbusch@kernel.org, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-raid@vger.kernel.org, sagi@grimberg.me, song@kernel.org,
        seunghwan.hyun@samsung.com, sookwan7.kim@samsung.com,
        nanich.lee@samsung.com, woosung2.lee@samsung.com,
        yt0928.kim@samsung.com, junho89.kim@samsung.com,
        jisoo2146.oh@samsung.com
References: <20220306231727.GP3927073@dread.disaster.area>
 <CGME20220309042324epcas1p111312e20f4429dc3a17172458284a923@epcas1p1.samsung.com>
 <20220309133119.6915-1-mj0123.lee@samsung.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20220309133119.6915-1-mj0123.lee@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Manjong,


Am 09.03.22 um 14:31 schrieb Manjong Lee:

Just a small note, that your message date is from the future. Please 
check your system clock.


Kind regards,

Paul
