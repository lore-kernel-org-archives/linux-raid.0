Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6AADC43334
	for <linux-raid@archiver.kernel.org>; Sat, 25 Jun 2022 23:50:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233585AbiFYXu1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 25 Jun 2022 19:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231234AbiFYXu0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 25 Jun 2022 19:50:26 -0400
Received: from rin.romanrm.net (rin.romanrm.net [51.158.148.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 516C013E2F
        for <linux-raid@vger.kernel.org>; Sat, 25 Jun 2022 16:50:25 -0700 (PDT)
Received: from nvm (nvm2.home.romanrm.net [IPv6:fd39::4a:3cff:fe57:d6b5])
        by rin.romanrm.net (Postfix) with SMTP id 4FCF62E2;
        Sat, 25 Jun 2022 23:50:23 +0000 (UTC)
Date:   Sun, 26 Jun 2022 04:50:22 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     Reindl Harald <h.reindl@thelounge.net>
Cc:     Alexander Shenkin <al@shenkin.org>,
        Wols Lists <antlists@youngman.org.uk>,
        Stephan <linux@psjt.org>, Linux-RAID <linux-raid@vger.kernel.org>
Subject: Re: Upgrading motherboard + CPU
Message-ID: <20220626045022.3ff82724@nvm>
In-Reply-To: <868008d1-a5ea-f279-bb21-7400f086474a@thelounge.net>
References: <CAPpdf59G6UjOe-80oqgwPmMY14t0_E=D20cbUwDwtOT8=AFcLQ@mail.gmail.com>
        <1de4bf1f-242b-7d02-23dc-a6d05893db81@plouf.fr.eu.org>
        <20220624232049.502a541e@nvm>
        <dab2fe0a-c49e-5da7-5df3-4d01c86a65a7@shenkin.org>
        <20220624234453.43cf4c74@nvm>
        <22102e4b-4738-672d-0d00-bbeccb54fe84@shenkin.org>
        <d85093a4-be3e-d4f2-eca0-e20882584bab@youngman.org.uk>
        <b664e4ce-6ebe-86c6-78d9-d5606c0f6555@shenkin.org>
        <5cb8d159-be2a-aa6c-888a-fcb9ed4555c1@youngman.org.uk>
        <20220625030833.3398d8a4@nvm>
        <ae2288f4-ad06-65af-d30c-4aef6d478f27@plouf.fr.eu.org>
        <s6nh748amrs.fsf@blaulicht.dmz.brux>
        <1b6c6601-22a0-af2a-81a9-34599b1b0fa7@youngman.org.uk>
        <a16b44a7-ae37-7775-24c8-436dcbe69ae8@shenkin.org>
        <cb10aa14-3a52-740c-4f6b-d7816cb31155@youngman.org.uk>
        <414a502b-dffd-d4cc-4eaa-579589877cee@shenkin.org>
        <6257be2f-212f-72ed-228c-324253910666@thelounge.net>
        <20220626034554.4bfe7388@nvm>
        <868008d1-a5ea-f279-bb21-7400f086474a@thelounge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sun, 26 Jun 2022 01:40:19 +0200
Reindl Harald <h.reindl@thelounge.net> wrote:

> https://fedoraproject.org/wiki/Features/DracutHostOnly

Thanks! It feels like this should be carefully weighted whether it adds more
maintenance issues than any actual savings. At least they had the good
judgment to keep "a boot entry "Rescue System" with a full fledged initramfs",
so even if it is "hostonly", it's not the end of the world.

Do you know if any other distros do the same, how about Ubuntu, which the OP
is using?

> except your initrd misses modules needed fater chaneg hardware

Luckily a major one needed both before and after will be "ahci" nowadays, and
not much else comes to mind as to what might be missing.

-- 
With respect,
Roman
