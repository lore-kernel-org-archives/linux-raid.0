Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 087B8C77B75
	for <linux-raid@archiver.kernel.org>; Tue,  9 May 2023 20:36:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbjEIUgi (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 9 May 2023 16:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjEIUgh (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 9 May 2023 16:36:37 -0400
X-Greylist: delayed 1070 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 09 May 2023 13:36:17 PDT
Received: from relay-b02.edpnet.be (relay-b02.edpnet.be [212.71.1.222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59B244C3E
        for <linux-raid@vger.kernel.org>; Tue,  9 May 2023 13:36:16 -0700 (PDT)
X-ASG-Debug-ID: 1683663503-15c43379987553e0001-LoH05x
Received: from atom ([213.219.153.70]) by relay-b02.edpnet.be with ESMTP id ZxqCEJ01DbKDc1I4; Tue, 09 May 2023 22:18:23 +0200 (CEST)
X-Barracuda-Envelope-From: johan@verrept.eu
X-Barracuda-Effective-Source-IP: UNKNOWN[213.219.153.70]
X-Barracuda-Apparent-Source-IP: 213.219.153.70
Received: from [192.168.1.199] (unknown [192.168.1.199])
        by atom (Postfix) with ESMTPSA id 6966420938DF;
        Tue,  9 May 2023 22:18:23 +0200 (CEST)
Message-ID: <753b096d-5dfc-3c47-eee4-07f1e4931b7b@verrept.eu>
Date:   Tue, 9 May 2023 22:18:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: Raid5 to raid6 grow interrupted, mdadm hangs on assemble command
Content-Language: en-US
X-ASG-Orig-Subj: Re: Raid5 to raid6 grow interrupted, mdadm hangs on assemble command
To:     Yu Kuai <yukuai1@huaweicloud.com>, Jove <jovetoo@gmail.com>
Cc:     Wol <antlists@youngman.org.uk>, linux-raid@vger.kernel.org,
        "yukuai (C)" <yukuai3@huawei.com>, songliubraving@meta.com,
        Logan Gunthorpe <logang@deltatee.com>
References: <CAFig2csUV2QiomUhj_t3dPOgV300dbQ6XtM9ygKPdXJFSH__Nw@mail.gmail.com>
 <63d92097-5299-2ae8-9697-768c52678578@huaweicloud.com>
 <CAFig2ct4BJZ0A9BKuXn8RM71+KrUzB8vKGQY0fSjNZiNenQZBg@mail.gmail.com>
 <c71c8381-f26e-f7de-c6f5-3c4411f08b15@huaweicloud.com>
 <d159161d-a5eb-8790-49c4-b7013e66ba65@youngman.org.uk>
 <6f391690-992f-1196-3109-6d422b3522f7@huaweicloud.com>
 <CAFig2ct+ZbHYEho7p9eubaz-kozGR+GkSJ1tVL+LGaciUBixyw@mail.gmail.com>
 <bc698b03-446b-a42e-cf0c-5c1b3cb62559@huaweicloud.com>
 <CAFig2csN8qSEafSehM5oN-kO3FsK=6+vvyEeiYcbvqRkmoiN7Q@mail.gmail.com>
 <5862fb1d-33e0-acb1-d740-dd6fda27eaf4@huaweicloud.com>
From:   Johan Verrept <johan@verrept.eu>
In-Reply-To: <5862fb1d-33e0-acb1-d740-dd6fda27eaf4@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Barracuda-Connect: UNKNOWN[213.219.153.70]
X-Barracuda-Start-Time: 1683663503
X-Barracuda-URL: https://212.71.1.222:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 576
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.108547
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


Hi Kuai,

> Here is the first verion of the fixed patch, I fail the io that is
> waiting for reshape while reshape can't make progress. I tested in my
> VM and it works as I expected. Can you give it a try to see if mdadm
> can still assemble? 

Assemble seems to work fine and the reshape resumed.

I see this error appearing:

     md/raid456:md0: array is suspended or not read write, io accross 
reshape position failed, please try again after reshape.

 From what I can see in your patch, this is what is expected.

Best regards,

     Johan

