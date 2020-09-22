Return-Path: <SRS0=yBIz=DA=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBA11C4727D
	for <linux-raid@archiver.kernel.org>; Wed, 23 Sep 2020 00:18:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F3492085B
	for <linux-raid@archiver.kernel.org>; Wed, 23 Sep 2020 00:18:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbgIWASI (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 22 Sep 2020 20:18:08 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:44281 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727034AbgIWASI (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 22 Sep 2020 20:18:08 -0400
X-Greylist: delayed 3580 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Sep 2020 20:18:07 EDT
Received: from host86-136-163-47.range86-136.btcentralplus.com ([86.136.163.47] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1kKrYI-0002U6-Em; Wed, 23 Sep 2020 00:18:26 +0100
Subject: Re: "--re-add for /dev/sdb1 to /dev/md0 is not possible"
To:     Roy Sigurd Karlsbakk <roy@karlsbakk.net>,
        Andy Smith <andy@strugglers.net>
Cc:     Linux Raid <linux-raid@vger.kernel.org>
References: <20200915102736.GE13298@bitfolk.com>
 <913919976.4679345.1600770460519.JavaMail.zimbra@karlsbakk.net>
From:   antlists <antlists@youngman.org.uk>
Message-ID: <13ffabf0-b848-c29a-eee6-d017e569f098@youngman.org.uk>
Date:   Wed, 23 Sep 2020 00:18:26 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <913919976.4679345.1600770460519.JavaMail.zimbra@karlsbakk.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 22/09/2020 11:27, Roy Sigurd Karlsbakk wrote:
> It would be very nice if someone at linux-raid could prioritise this rather obvious bug in the bbl code, where the bbl keeps replicating itself over and over, regardless of any actual failures on the disks. IMHO the whole BBL should be scrapped, as mentioned earlier, since it really has no function. Mapping out bad sectors is for the drive to decide and if it can't handle it, it should be kicked out of the array.

Well, I guess if you want a volunteer, you're it! Thanks for steping up 
to the plate!

Cheers,
Wol
