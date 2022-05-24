Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2BF0C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 24 May 2022 15:58:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239133AbiEXP6b (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 24 May 2022 11:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236688AbiEXP6a (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 24 May 2022 11:58:30 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 741BE986DA
        for <linux-raid@vger.kernel.org>; Tue, 24 May 2022 08:58:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=E1uFF9aj084RYtJXelJvV22dz7rDNxnN2SYl98ONQ/w=; b=UR6KqX+1AGu3azc274LcP1RPb1
        iC9rcTG8+marQ0QIfSNms3Tj1aJMdsI3v0VuM31vRzHAI4o4PhiP6+8M3GWEP5H7Q1ih7SpWLSABP
        5zPNPaPBjOz5WRSnQpwWgJ4312HhrdQfx9cFeJTPjwzQrM4NbViOd7C3hFk1V8ZDYHfxAZVmCrsxO
        HNXf+YcI7sTmCmA8vjzdVu7OxGj2pLkoIjGLpK+u/naIMIBvmmv2JZkJRzpA0GWOKuQGMwhSTSnZS
        1SAlb3399N1f7w48pyqONBwOF2uy+e5ppUiWVCIpi4oq1pQVGWZdyDMwdiicsYUjiCVUsL641/n+I
        mkfJPHtA==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1ntWvR-006R8z-9X; Tue, 24 May 2022 09:58:26 -0600
Message-ID: <7fd20544-40e4-e180-861d-0e9ce27c9e69@deltatee.com>
Date:   Tue, 24 May 2022 09:58:24 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-CA
To:     Donald Buczek <buczek@molgen.mpg.de>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>
References: <20220505081641.21500-1-guoqing.jiang@linux.dev>
 <20220506113656.25010-1-guoqing.jiang@linux.dev>
 <CAPhsuW6mGnkg4x5xm6x5n06JXxF-7PNubpQiZNmX0BH9Zo1ncA@mail.gmail.com>
 <141b4110-767e-7670-21d5-6a5f636d1207@linux.dev>
 <CAPhsuW6U3g-Xikbw4mAJOH1-kN42rYHLiq_ocv==436azhm33g@mail.gmail.com>
 <b4244eab-d9e2-20a0-ebce-1a96e8fadb91@deltatee.com>
 <836b2a93-65be-8d6c-8610-18373b88f86d@molgen.mpg.de>
 <5b0584a3-c128-cb53-7c8a-63744c60c667@linux.dev>
 <4edc9468-d195-6937-f550-211bccbd6756@molgen.mpg.de>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <4edc9468-d195-6937-f550-211bccbd6756@molgen.mpg.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: buczek@molgen.mpg.de, guoqing.jiang@linux.dev, song@kernel.org, linux-raid@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [Update PATCH V3] md: don't unregister sync_thread with
 reconfig_mutex held
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2022-05-22 23:41, Donald Buczek wrote:
>> Looks like bfq or block issue, will try it from my side.
> 
> FYI: I've used loop devices on a virtio disk.
> 
> I later discovered Logans patches [1], which I were not aware of, as I'm not subscribed to the lists.
> 
> [1]: https://lore.kernel.org/linux-raid/20220519191311.17119-6-logang@deltatee.com/T/#u
> 
> The series seems to acknowledge that there are open problems and tries to fix them.
> So I've used his md-bug branch from https://github.com/sbates130272/linux-p2pmem but it didn't look better.
> 
> So I understand, the mdadm tests *are* supposed to work and every bug I see here is worth analyzing? Or is Logan hunting down everything anyway?

I'm not hunting down everything. There's too much brokenness. I've done
a bunch of work: there's that series plus an mdadm branch I'll send to
the list later (just linked it on my previous email). But even after all
that, I still have ~25 broken tests, but I've marked those tests and
they shouldn't stop the test script from running everything.

Logan
