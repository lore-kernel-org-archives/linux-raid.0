Return-Path: <SRS0=wpSx=DO=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C631C4363C
	for <linux-raid@archiver.kernel.org>; Wed,  7 Oct 2020 07:26:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02AA4207EA
	for <linux-raid@archiver.kernel.org>; Wed,  7 Oct 2020 07:26:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727661AbgJGH0l (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 7 Oct 2020 03:26:41 -0400
Received: from relay0.allsecuredomains.com ([51.68.204.196]:51369 "EHLO
        relay0.allsecuredomains.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727635AbgJGH0l (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 7 Oct 2020 03:26:41 -0400
Received: from [81.174.144.187] (helo=zebedee.buttersideup.com)
        by relay0.allsecuredomains.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <tim@buttersideup.com>)
        id 1kQ3qP-0007Ca-Vx; Wed, 07 Oct 2020 07:26:38 +0000
Received: from [IPv6:2001:470:1b4a::e9a] (custard.lan [IPv6:2001:470:1b4a::e9a])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by zebedee.buttersideup.com (Postfix) with ESMTPSA id 8C75BA0111;
        Wed,  7 Oct 2020 07:26:36 +0000 (UTC)
Subject: Re: do i need to give up on this setup
To:     Daniel Sanabria <sanabria.d@gmail.com>
Cc:     Roger Heflin <rogerheflin@gmail.com>,
        Roman Mamedov <rm@romanrm.net>,
        Linux-RAID <linux-raid@vger.kernel.org>
References: <CAHscji30ACa2d0qz-nr5vqPYOP642dwjS5BY07g2DQS7GBG-2A@mail.gmail.com>
 <20201005184449.54225175@natsu>
 <CAHscji0pNezf6xCpjWto5-21ayoCeLWm34GTYh5TSgxkOw90mw@mail.gmail.com>
 <20201005190421.4ecd8f1b@natsu>
 <CAHscji1VrccTOaQc4GdWof4E+Bzs5KL0-tJJj0ZUM9Db=QBriw@mail.gmail.com>
 <CAAMCDedZfx+w3NT_QgB0KGkeEQikCtYVy9YuiNEhNaEjXF1C8w@mail.gmail.com>
 <CAHscji01ikKz4fQ_9i4Tb3AraTD+ZcXBbK-Mm+zY4p3p2qbF4Q@mail.gmail.com>
 <CAAMCDeeRNnoC6mdj7L1PdD5Ztek1tzm++UPi3k=hWvBUA=oLxQ@mail.gmail.com>
 <6f2b7a81-fea3-bc05-a6d3-fc1331e249db@buttersideup.com>
 <CAHscji1r8=4bKr3fx_MJ2nxnb9QYcRhnY8uZkoemnrjNLAmiMQ@mail.gmail.com>
From:   Tim Small <tim@buttersideup.com>
Autocrypt: addr=tim@buttersideup.com; keydata=
 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
Message-ID: <aff73c49-78e3-dedf-f77c-b9fd89044f56@buttersideup.com>
Date:   Wed, 7 Oct 2020 08:26:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <CAHscji1r8=4bKr3fx_MJ2nxnb9QYcRhnY8uZkoemnrjNLAmiMQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

If you want to keep the Marvell controller in use, then I found them a
lot more stable with Tagged Command Queueing disabled:

echo 1 > /sys/block/sdX/device/queue_depth

Otherwise you might also look for a firmware update for the WD Green
drives which you are having problems with (they might be hidden on
vendor support sites like those of Dell and Lenovo, if you can find
particular PC models which shipped with the same models of WD drives
that you have).

Also if possible, consider switching for the ASMedia controllers if
possible - the two port versions are available for under €10.

Tim.

