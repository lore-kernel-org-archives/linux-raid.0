Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2E44C433ED
	for <linux-raid@archiver.kernel.org>; Mon,  5 Apr 2021 19:06:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 581D061398
	for <linux-raid@archiver.kernel.org>; Mon,  5 Apr 2021 19:06:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235320AbhDETGy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 5 Apr 2021 15:06:54 -0400
Received: from u17383850.onlinehome-server.com ([74.208.250.170]:59404 "EHLO
        u17383850.onlinehome-server.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232593AbhDETGx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 5 Apr 2021 15:06:53 -0400
Received: by u17383850.onlinehome-server.com (Postfix, from userid 5001)
        id A84CE79A; Mon,  5 Apr 2021 15:06:46 -0400 (EDT)
Date:   Mon, 5 Apr 2021 15:06:46 -0400
From:   David T-G <davidtg-robot@justpickone.org>
To:     Mailing Lists <linux-raid@vger.kernel.org>
Subject: Re: systemd black magic (was "Re: Question about mdcheck")
Message-ID: <20210405190646.GI1415@justpickone.org>
References: <CAOLErMXeBKoC=7Bq0XddmVShJdSNrhTms+tbBnqih8nnXCF-iA@mail.gmail.com>
 <CAOLErMWW4vxQgJkY_hBedmm_oTx34vNhGWZet-1bkJV8qSDH_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOLErMWW4vxQgJkY_hBedmm_oTx34vNhGWZet-1bkJV8qSDH_w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Jeffery, et al --

...and then Jeffery Small said...
% 
...
% I do not want to edit the files under /lib/systemd/system/
% which would certainly be overwritten with future updates.
% Can I place copies of these files in /etc/systemd/system
% and completely override the entries under /lib/systemd?

Yes.  That is exactly the right way to do it.  In fact, there's a
way you can only make changes such as adding a param (but not removing;
that DOES require wholesale overriding) so that you don't have to
maintain the entire separate copy, which might then diverge with nice
changes across updates.  On the other hand, it can be nice to have
absolute control over what happens.


% 
% Clearly, I'm still trying to figure out just how the systemd
% works and how it integrates with the old legacy init system.

Join the club :-/  You now know pretty much as much as I do about
systemd --- which ain't much!


HTH & HAND

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

