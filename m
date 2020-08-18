Return-Path: <SRS0=fBal=B4=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DB7CC433E1
	for <linux-raid@archiver.kernel.org>; Tue, 18 Aug 2020 20:08:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1560520786
	for <linux-raid@archiver.kernel.org>; Tue, 18 Aug 2020 20:08:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgHRUIn (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 18 Aug 2020 16:08:43 -0400
Received: from hermes.turmel.org ([107.191.102.135]:51404 "EHLO
        hermes.turmel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726694AbgHRUIl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 18 Aug 2020 16:08:41 -0400
X-Greylist: delayed 1347 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Aug 2020 16:08:41 EDT
Received: from c-98-192-104-236.hsd1.ga.comcast.net ([98.192.104.236] helo=[192.168.19.160])
        by hermes.turmel.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <philip@turmel.org>)
        id 1k87WM-0000rY-63; Tue, 18 Aug 2020 19:43:46 +0000
Subject: Re: Feature request: Remove the badblocks list
To:     Wols Lists <antlists@youngman.org.uk>,
        Roy Sigurd Karlsbakk <roy@karlsbakk.net>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>
Cc:     =?UTF-8?B?SMOla29u?= <hawken@thehawken.org>
References: <75076966.1748398.1597773608869.JavaMail.zimbra@karlsbakk.net>
 <5F3C2B4F.1050708@youngman.org.uk>
From:   Phil Turmel <philip@turmel.org>
Message-ID: <9affe1a7-c068-0835-153e-dd5f10ef7c3a@turmel.org>
Date:   Tue, 18 Aug 2020 15:43:45 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <5F3C2B4F.1050708@youngman.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/18/20 3:26 PM, Wols Lists wrote:
> On 18/08/20 19:00, Roy Sigurd Karlsbakk wrote:
>> As far as I can understand, this list doesn't have any reason to exist, except to annoy sysadmins.
> 
> Actually, there's at least one good reason for it to exist that I can
> think of - it *could* make recovering a broken array much easier. Think
> about it, I think it's documented in the wiki.

Link please.
