Return-Path: <SRS0=qvga=BX=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08044C433DF
	for <linux-raid@archiver.kernel.org>; Thu, 13 Aug 2020 12:22:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1D912078D
	for <linux-raid@archiver.kernel.org>; Thu, 13 Aug 2020 12:22:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbgHMMWB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 13 Aug 2020 08:22:01 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:49353 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726053AbgHMMWA (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 13 Aug 2020 08:22:00 -0400
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 60BAF20645E93;
        Thu, 13 Aug 2020 14:21:58 +0200 (CEST)
Subject: Re: mdadm development?
To:     Roy Sigurd Karlsbakk <roy@karlsbakk.net>
References: <1637821313.22423838.1597320925127.JavaMail.zimbra@karlsbakk.net>
Cc:     Linux RAID Mailing List <linux-raid@vger.kernel.org>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <8f344b7e-4bd2-7053-a982-a5cc03881984@molgen.mpg.de>
Date:   Thu, 13 Aug 2020 14:21:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <1637821313.22423838.1597320925127.JavaMail.zimbra@karlsbakk.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Roy,


Am 13.08.20 um 14:15 schrieb Roy Sigurd Karlsbakk:

> Looking around to debug an issue (see previous email about badblocks), I wanted to find the latest version of mdadm. It seems it's 4.1 from october 2018. I can't find anything newer. Has development of mdadm halted or is it declared "perfect" or something?

Please look at the git repository [1].

> --
> Roy Sigurd Karlsbakk
> (+47) 98013356

[…]

Please use the standard signature delimiter (missing trailing space), so 
email programs can remove it from the reply.


Kind regards,

Paul


[1]: https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/
[2]: https://en.wikipedia.org/wiki/Signature_block#Standard_delimiter
