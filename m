Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FB22C433C1
	for <linux-raid@archiver.kernel.org>; Wed, 24 Mar 2021 14:52:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E78DF61A0B
	for <linux-raid@archiver.kernel.org>; Wed, 24 Mar 2021 14:52:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236316AbhCXOwN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 Mar 2021 10:52:13 -0400
Received: from mail.thelounge.net ([91.118.73.15]:47017 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236391AbhCXOvq (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 24 Mar 2021 10:51:46 -0400
X-Greylist: delayed 1049 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Mar 2021 10:51:45 EDT
Received: from srv-rhsoft.rhsoft.net (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4F59jK73g4zXLs;
        Wed, 24 Mar 2021 15:34:13 +0100 (CET)
Subject: Re: MDRaid Rollback
To:     Shaun Glass <shaunglass@gmail.com>, linux-raid@vger.kernel.org
References: <CA+OzjxLW2Vw-ecs7jNELecpYxoBbK767pXEV8rFVaQp_HXfjOg@mail.gmail.com>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
Message-ID: <0865690e-2a55-5e66-3ddf-26a8c107f218@thelounge.net>
Date:   Wed, 24 Mar 2021 15:34:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CA+OzjxLW2Vw-ecs7jNELecpYxoBbK767pXEV8rFVaQp_HXfjOg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 24.03.21 um 12:04 schrieb Shaun Glass:
> Would just like to know if it is possible at all to break a mirror and
> convert a md device back to its original state without losing data?

i don't undertsand what exactly are you trying to do

"break a mirror" - how?
"convert a md device back to its original state" - what?
