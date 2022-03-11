Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BDA3C433FE
	for <linux-raid@archiver.kernel.org>; Fri, 11 Mar 2022 15:58:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349716AbiCKP7q (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 11 Mar 2022 10:59:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233190AbiCKP7j (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 11 Mar 2022 10:59:39 -0500
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A47AD3FD82;
        Fri, 11 Mar 2022 07:58:33 -0800 (PST)
Received: from host86-155-180-61.range86-155.btcentralplus.com ([86.155.180.61] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1nShex-000B7l-5q;
        Fri, 11 Mar 2022 15:58:32 +0000
Message-ID: <86b4e961-3c17-3544-ee1e-b69b0c8417b5@youngman.org.uk>
Date:   Fri, 11 Mar 2022 15:58:31 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH] block: check more requests for multiple_queues in
 blk_attempt_plug_merge
Content-Language: en-GB
To:     Wilson Jonathan <i400sjon@gmail.com>
Cc:     linux-block@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>, stable@vger.kernel.org
References: <20220309064209.4169303-1-song@kernel.org>
 <9516f407-bb91-093b-739d-c32bda1b5d8d@kernel.dk>
 <CAPhsuW5zX96VaBMu-o=JUqDz2KLRBcNFM_gEsT=tHjeYqrngSQ@mail.gmail.com>
 <0d4088b987437788846b7d69879189f4870b90c6.camel@gmail.com>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <0d4088b987437788846b7d69879189f4870b90c6.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 11/03/2022 11:30, Wilson Jonathan wrote:
> I have no idea why the speed of the "check" would seemingly affect the
> apparent responsiveness of the computer and why it would appear that
> the slower the check the slower the responsiveness.

The buffers were filling up, nicking your free ram, and you were having 
to wait longer and longer before they could be flushed to swap your 
applications back in?

Cheers,
Wol
