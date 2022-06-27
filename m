Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87AECCCA473
	for <linux-raid@archiver.kernel.org>; Mon, 27 Jun 2022 11:06:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234400AbiF0LGH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 27 Jun 2022 07:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234168AbiF0LGF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 27 Jun 2022 07:06:05 -0400
Received: from rin.romanrm.net (rin.romanrm.net [IPv6:2001:bc8:2dd2:1000::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 574836468
        for <linux-raid@vger.kernel.org>; Mon, 27 Jun 2022 04:06:03 -0700 (PDT)
Received: from nvm (nvm2.home.romanrm.net [IPv6:fd39::4a:3cff:fe57:d6b5])
        by rin.romanrm.net (Postfix) with SMTP id B3BD15C1;
        Mon, 27 Jun 2022 11:05:59 +0000 (UTC)
Date:   Mon, 27 Jun 2022 16:05:58 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     Alexander Shenkin <al@shenkin.org>
Cc:     Pascal Hambourg <pascal@plouf.fr.eu.org>,
        Wols Lists <antlists@youngman.org.uk>,
        Stephan <linux@psjt.org>, Linux-RAID <linux-raid@vger.kernel.org>
Subject: Re: Upgrading motherboard + CPU
Message-ID: <20220627160558.0ec507ae@nvm>
In-Reply-To: <b1c6b0c2-ff7b-59e0-580c-81d57b8f8ddb@shenkin.org>
References: <CAPpdf59G6UjOe-80oqgwPmMY14t0_E=D20cbUwDwtOT8=AFcLQ@mail.gmail.com>
        <81c50899-7edb-e629-3bbc-16cfa8f17e34@youngman.org.uk>
        <b777865e-b265-1e83-dae0-f89654e86332@plouf.fr.eu.org>
        <5cbd9dd1-73fc-ce11-4a9d-8752f7bea979@youngman.org.uk>
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
        <f971e15d-9cd4-e6de-c174-f3c6bd338bb6@plouf.fr.eu.org>
        <b1c6b0c2-ff7b-59e0-580c-81d57b8f8ddb@shenkin.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sun, 26 Jun 2022 18:32:26 -0700
Alexander Shenkin <al@shenkin.org> wrote:

> Ok all.  I've put in the new mobo + CPU, and the BIOS isn't finding any 
> bootable devices.  Suggestions for next steps?  Thanks in advance...

As mentioned before, did you find and enable CSM and "Boot mode: UEFI and
Legacy" in BIOS?

If you have trouble finding any of that, perhaps post the motherboard model,
we could check the exact settings to look for.

-- 
With respect,
Roman
