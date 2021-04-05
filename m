Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F2F5C433ED
	for <linux-raid@archiver.kernel.org>; Mon,  5 Apr 2021 19:22:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 590A66128B
	for <linux-raid@archiver.kernel.org>; Mon,  5 Apr 2021 19:22:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240027AbhDETWF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 5 Apr 2021 15:22:05 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:54867 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232387AbhDETWD (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 5 Apr 2021 15:22:03 -0400
Received: from [192.168.0.2] (ip5f5ae8a6.dynamic.kabel-deutschland.de [95.90.232.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 44B72206473C3;
        Mon,  5 Apr 2021 21:21:55 +0200 (CEST)
Subject: Re: systemd black magic (was "Re: Question about mdcheck")
To:     Jeffery Small <jeff@cjsa.com>,
        David T-G <davidtg-robot@justpickone.org>
References: <CAOLErMXeBKoC=7Bq0XddmVShJdSNrhTms+tbBnqih8nnXCF-iA@mail.gmail.com>
 <CAOLErMWW4vxQgJkY_hBedmm_oTx34vNhGWZet-1bkJV8qSDH_w@mail.gmail.com>
 <20210405190646.GI1415@justpickone.org>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     linux-raid@vger.kernel.org
Message-ID: <ad32e57b-d962-29d2-d968-15d56c48c4f1@molgen.mpg.de>
Date:   Mon, 5 Apr 2021 21:21:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210405190646.GI1415@justpickone.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Jeffery, dear David,


Am 05.04.21 um 21:06 schrieb David T-G:
> Jeffery, et al --
> 
> ...and then Jeffery Small said...
> %
> ...
> % I do not want to edit the files under /lib/systemd/system/
> % which would certainly be overwritten with future updates.
> % Can I place copies of these files in /etc/systemd/system
> % and completely override the entries under /lib/systemd?
> 
> Yes.  That is exactly the right way to do it.  In fact, there's a
> way you can only make changes such as adding a param (but not removing;
> that DOES require wholesale overriding) so that you don't have to
> maintain the entire separate copy, which might then diverge with nice
> changes across updates.  On the other hand, it can be nice to have
> absolute control over what happens.

Yes, extending or overriding a unit is part of systemd’s design. Often 
drop-in snippets allow you to only change specific things, so you get 
the other updates, in case the software (often distribution package) 
changes something.

You can easily use `systemctl edit …` to do extend or override a unit 
[1][2].


Kind regards,

Paul


[1]: 
https://www.freedesktop.org/software/systemd/man/systemctl.html#edit%20UNIT%E2%80%A6
[2]: 
https://www.digitalocean.com/community/tutorials/how-to-use-systemctl-to-manage-systemd-services-and-units
