Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5609DC43334
	for <linux-raid@archiver.kernel.org>; Fri, 24 Jun 2022 18:20:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbiFXSU4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 24 Jun 2022 14:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbiFXSU4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 24 Jun 2022 14:20:56 -0400
Received: from rin.romanrm.net (rin.romanrm.net [IPv6:2001:bc8:2dd2:1000::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2EEC53A4D
        for <linux-raid@vger.kernel.org>; Fri, 24 Jun 2022 11:20:54 -0700 (PDT)
Received: from nvm (nvm2.home.romanrm.net [IPv6:fd39::4a:3cff:fe57:d6b5])
        by rin.romanrm.net (Postfix) with SMTP id 7778C5C1;
        Fri, 24 Jun 2022 18:20:51 +0000 (UTC)
Date:   Fri, 24 Jun 2022 23:20:49 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     Pascal Hambourg <pascal@plouf.fr.eu.org>
Cc:     Wols Lists <antlists@youngman.org.uk>,
        o1bigtenor <o1bigtenor@gmail.com>,
        Linux-RAID <linux-raid@vger.kernel.org>
Subject: Re: a new install - - - putting the system on raid
Message-ID: <20220624232049.502a541e@nvm>
In-Reply-To: <1de4bf1f-242b-7d02-23dc-a6d05893db81@plouf.fr.eu.org>
References: <CAPpdf59G6UjOe-80oqgwPmMY14t0_E=D20cbUwDwtOT8=AFcLQ@mail.gmail.com>
        <81c50899-7edb-e629-3bbc-16cfa8f17e34@youngman.org.uk>
        <b777865e-b265-1e83-dae0-f89654e86332@plouf.fr.eu.org>
        <5cbd9dd1-73fc-ce11-4a9d-8752f7bea979@youngman.org.uk>
        <1de4bf1f-242b-7d02-23dc-a6d05893db81@plouf.fr.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, 24 Jun 2022 00:27:45 +0200
Pascal Hambourg <pascal@plouf.fr.eu.org> wrote:

> > Raid is meant to protect your data. The benefit for raiding your swap is 
> > much less, and *should* be negligible.
> 
> No, this is what backup is meant to. RAID does not protect your data 
> against accidental or malicious deletion or corruption. RAID is meant to 
> provide availabity. The benefit of having everything including swap on 
> RAID is that the system as a whole will continue to operate normally 
> when a drive fails.

I think the key decider in whether or not a RAIDed swap should be a must-have,
is whether the system has hot-swap bays for drives.

Also, it seemed like the discussion began in the context of setting up a home
machine, or something otherwise not as mission-critical. And in those cases,
almost nobody will have hot-swap.

As such, if you have to bring down the machine to replace a drive anyway, might
as well tolerate the risk of it going down with a bang (due to a part of swap
going away), and enjoy a faster swap on either RAID0 or multiple independent
swap zones for the rest of the time.

-- 
With respect,
Roman
