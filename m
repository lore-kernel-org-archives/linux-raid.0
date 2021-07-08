Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D44D7C07E96
	for <linux-raid@archiver.kernel.org>; Thu,  8 Jul 2021 23:01:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3CF76113C
	for <linux-raid@archiver.kernel.org>; Thu,  8 Jul 2021 23:01:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbhGHXET (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 8 Jul 2021 19:04:19 -0400
Received: from mail.thelounge.net ([91.118.73.15]:45529 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhGHXES (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 8 Jul 2021 19:04:18 -0400
X-Greylist: delayed 1081 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Jul 2021 19:04:17 EDT
Received: from srv-rhsoft.rhsoft.net (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4GLWY015h4zXT2;
        Fri,  9 Jul 2021 00:43:32 +0200 (CEST)
Subject: Re: bad sector and unused area.
To:     Wakko Warner <wakko@animx.eu.org>, linux-raid@vger.kernel.org
References: <YOdyyGBnFKHr7Xyc@animx.eu.org>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
Message-ID: <c2e60c47-68fd-4be2-6a8b-633d651bc2e2@thelounge.net>
Date:   Fri, 9 Jul 2021 00:43:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YOdyyGBnFKHr7Xyc@animx.eu.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 08.07.21 um 23:48 schrieb Wakko Warner:
> I have a raid5 of 3 disks.
> 
> 2 of them have bad sectors.  Sector 1110 and 1118.
> 
> I'm curious to know if these sectors actually contain any data or if they
> can just be overwritten.

the RAID layer don't know anything about data by definition, it even 
don't care what filesystem is running on top
