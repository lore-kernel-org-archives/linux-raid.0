Return-Path: <SRS0=7JT0=CJ=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 408E8C433E6
	for <linux-raid@archiver.kernel.org>; Mon, 31 Aug 2020 19:00:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25E6920719
	for <linux-raid@archiver.kernel.org>; Mon, 31 Aug 2020 19:00:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbgHaTAk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 31 Aug 2020 15:00:40 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:52144 "EHLO
        mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727993AbgHaTAk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 31 Aug 2020 15:00:40 -0400
Received: from loom (nix@sidle.srvr.nix [192.168.14.8])
        by mail.esperi.org.uk (8.15.2/8.15.2) with ESMTP id 07VJ0ZS3006896;
        Mon, 31 Aug 2020 20:00:35 +0100
From:   Nix <nix@esperi.org.uk>
To:     Zhong Lidong <lidong.zhong@suse.com>
Cc:     Ian Pilcher <arequipeno@gmail.com>, linux-raid@vger.kernel.org
Subject: Re: [RFC PATCH] Detail: don't display the raid level when it's inactive
References: <20200826151658.3493-1-lidong.zhong@suse.com>
        <ribbtt$t51$1@ciao.gmane.io>
        <0468dc70-7309-44b1-f094-67b617bf4c98@suse.com>
Emacs:  well, why *shouldn't* you pay property taxes on your editor?
Date:   Mon, 31 Aug 2020 20:00:35 +0100
In-Reply-To: <0468dc70-7309-44b1-f094-67b617bf4c98@suse.com> (Zhong Lidong's
        message of "Mon, 31 Aug 2020 09:28:09 +0800")
Message-ID: <87wo1emyi4.fsf@esperi.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC--Metrics: loom 1481; Body=3 Fuz1=3 Fuz2=3
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 31 Aug 2020, Zhong Lidong told this:

> On 8/29/20 12:38 AM, Ian Pilcher wrote:
>> On 8/26/20 10:16 AM, Lidong Zhong wrote:
>>> ...
>>> So the misleading "raid0" is shown in this testcase. I think maybe
>>> the "Raid Level" item shouldn't be displayed any more for the inactive
>>> array.
>> 
>> As a system administrator, I'd much rather see "unknown" (or something
>> similar), rather than simply omitting the information.
>> 
> Thanks for the suggestion.
> Yeah, just removing the Raid Level info is not the best option. I also
> considered to show it as "inactive Raid1" in such case.

If it would be a raid1 when activated, it is still a raid1 when
inactive: the data on disk doesn't suddenly become not a raid array
simply because the kernel isn't able to access it right now. This is
valuable information to expose to the sysadmin and should not be
concealed (and *certainly* not described as a raid level it actually
isn't).

I think it should say as much (if the system knows at this stage, which
if there is a device node, it presumably does).
