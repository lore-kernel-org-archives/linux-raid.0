Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25CFFC433FE
	for <linux-raid@archiver.kernel.org>; Mon,  9 May 2022 09:49:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbiEIJxH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 9 May 2022 05:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238692AbiEIJgv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 9 May 2022 05:36:51 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 491A81E029A
        for <linux-raid@vger.kernel.org>; Mon,  9 May 2022 02:32:49 -0700 (PDT)
Received: from host86-155-180-61.range86-155.btcentralplus.com ([86.155.180.61] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1nnzkt-0007Am-9w;
        Mon, 09 May 2022 10:32:39 +0100
Message-ID: <c2917c23-c218-e600-7e10-31a504c844e2@youngman.org.uk>
Date:   Mon, 9 May 2022 10:32:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [Update PATCH V3] md: don't unregister sync_thread with
 reconfig_mutex held
Content-Language: en-GB
To:     Guoqing Jiang <guoqing.jiang@linux.dev>, Song Liu <song@kernel.org>
Cc:     Donald Buczek <buczek@molgen.mpg.de>,
        linux-raid <linux-raid@vger.kernel.org>
References: <20220505081641.21500-1-guoqing.jiang@linux.dev>
 <20220506113656.25010-1-guoqing.jiang@linux.dev>
 <CAPhsuW6mGnkg4x5xm6x5n06JXxF-7PNubpQiZNmX0BH9Zo1ncA@mail.gmail.com>
 <141b4110-767e-7670-21d5-6a5f636d1207@linux.dev>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <141b4110-767e-7670-21d5-6a5f636d1207@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 09/05/2022 09:09, Guoqing Jiang wrote:
> I can switch back to V2 if you think that is the correct way to do 
> though no
> one comment about the change in dm-raid.

DON'T QUOTE ME ON THIS

but it is very confusing, as I believe dm-raid is part of Device 
Managment, which is actually nothing to do with md-raid (apart from, 
like many block layer drivers, md-raid uses dm to manage the device 
beneath it.)

Cheers,
Wol
