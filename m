Return-Path: <SRS0=wQ6l=CG=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FORGED_MUA_MOZILLA,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B2EEC433E6
	for <linux-raid@archiver.kernel.org>; Fri, 28 Aug 2020 16:38:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72D2220872
	for <linux-raid@archiver.kernel.org>; Fri, 28 Aug 2020 16:38:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbgH1Qib (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 28 Aug 2020 12:38:31 -0400
Received: from static.214.254.202.116.clients.your-server.de ([116.202.254.214]:57330
        "EHLO ciao.gmane.io" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726524AbgH1Qi3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 28 Aug 2020 12:38:29 -0400
Received: from list by ciao.gmane.io with local (Exim 4.92)
        (envelope-from <linux-raid@m.gmane-mx.org>)
        id 1kBhOU-00018a-3y
        for linux-raid@vger.kernel.org; Fri, 28 Aug 2020 18:38:26 +0200
X-Injected-Via-Gmane: http://gmane.org/
To:     linux-raid@vger.kernel.org
From:   Ian Pilcher <arequipeno@gmail.com>
Subject: Re: [RFC PATCH] Detail: don't display the raid level when it's
 inactive
Date:   Fri, 28 Aug 2020 11:38:21 -0500
Message-ID: <ribbtt$t51$1@ciao.gmane.io>
References: <20200826151658.3493-1-lidong.zhong@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
In-Reply-To: <20200826151658.3493-1-lidong.zhong@suse.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/26/20 10:16 AM, Lidong Zhong wrote:
> ...
> So the misleading "raid0" is shown in this testcase. I think maybe
> the "Raid Level" item shouldn't be displayed any more for the inactive
> array.

As a system administrator, I'd much rather see "unknown" (or something
similar), rather than simply omitting the information.

-- 
========================================================================
                  In Soviet Russia, Google searches you!
========================================================================

