Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77EB5C433E0
	for <linux-raid@archiver.kernel.org>; Tue,  9 Mar 2021 09:52:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 395F765248
	for <linux-raid@archiver.kernel.org>; Tue,  9 Mar 2021 09:52:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbhCIJw2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 9 Mar 2021 04:52:28 -0500
Received: from mifritscher.de ([188.40.170.105]:59608 "EHLO
        mail.mifritscher.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbhCIJwT (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 9 Mar 2021 04:52:19 -0500
X-Greylist: delayed 404 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Mar 2021 04:52:19 EST
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail.mifritscher.de (Postfix) with ESMTP id 3494A3A9D61;
        Tue,  9 Mar 2021 10:45:33 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at mifritscher.vserverkompetenz.de
Received: from mail.mifritscher.de ([127.0.0.1])
        by localhost (mail.mifritscher.vserverkompetenz.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id zYm4JAq5yDXc; Tue,  9 Mar 2021 10:45:32 +0100 (CET)
Received: from [192.168.99.235] (55d4343a.access.ecotel.net [85.212.52.58])
        by mail.mifritscher.de (Postfix) with ESMTPSA id AB24F3A141E;
        Tue,  9 Mar 2021 10:45:32 +0100 (CET)
Subject: Re: [PATCH] mdmonitor: check if udev has finished events processing
To:     Wols Lists <antlists@youngman.org.uk>,
        "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>,
        Jes Sorensen <jes@trained-monkey.org>,
        Oleksandr Shchirskyi <oleksandr.shchirskyi@intel.com>
Cc:     linux-raid@vger.kernel.org
References: <20210114141416.42934-1-oleksandr.shchirskyi@intel.com>
 <a5f929eb-5103-1646-b321-65886157c9cc@trained-monkey.org>
 <51ec46c1-c632-b3a9-010f-8f13aee0e02c@linux.intel.com>
 <60473C1F.4080602@youngman.org.uk>
From:   Michael Fritscher <michael@fritscher.net>
Message-ID: <1b5b0495-c645-7f81-24f4-07fbad54ca0e@fritscher.net>
Date:   Tue, 9 Mar 2021 10:45:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <60473C1F.4080602@youngman.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Am 09.03.21 um 10:13 schrieb Wols Lists:
> Is udev part of systemd? Are there alternate implementations for the
> anti-systemd-holdouts? Iirc you don't need systemd itself to have udev,
> but it might provoke a few screams ...
> 
> My current (gentoo) system is OpenRC, but that's still on KDE4 and
> hasn't been updated in a couple of years (don't ask why). My new system
> is currently being built and is gentoo/systemd, but it's clear the
> anti-systemd sentiment is still strong ...
> 
> Cheers,
> Wol
> 

Good day,

there is e.g. eudev ( https://wiki.gentoo.org/wiki/Project:Eudev ) with
the explicit target to be used without systemd.

Best regards,
Michael Fritscher
