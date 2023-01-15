Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF3C0C46467
	for <linux-raid@archiver.kernel.org>; Sun, 15 Jan 2023 21:26:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbjAOV0M (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 15 Jan 2023 16:26:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231570AbjAOV0K (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 15 Jan 2023 16:26:10 -0500
Received: from mail-40138.protonmail.ch (mail-40138.protonmail.ch [185.70.40.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B17DF525F
        for <linux-raid@vger.kernel.org>; Sun, 15 Jan 2023 13:26:05 -0800 (PST)
Date:   Sun, 15 Jan 2023 21:25:55 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail3; t=1673817963; x=1674077163;
        bh=z52wRE5BfrX4psGZSy1OMgsG0tg4MlMR1aZ24YeN4qo=;
        h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
         Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID:BIMI-Selector;
        b=S6PlT90cuOsL1bdowU0XFxDnjWS/o72tVBD4qo25r+GlrwUv5spAhAO85MUKycLqe
         uNVcyy4cmh/mb//eLTzNSJJTO1o1/6BJqb2fDA4JEQdrfoB7CFHQGY5Yv4VuiZo07e
         PgDH/pQcMr72K7woyxHxAcG6LenrjTEzkQAnDySOz2ql6iSYGnP0YMIQVEeeR1nBP0
         uTVzxsb3MZ/cywcPTady3sD7toCNbZPEGgMQNKMbXS9oyK26xiP1MnWUCNT+uT4FnM
         DDm5WsAH7uLv0vh6UoGy7W2JULkyCCwCWJW1AdLQSI31eaIVJ6Ep9iB7GDWEgvWN/J
         2HdwLRRWteazg==
To:     anthony <antmbox@youngman.org.uk>
From:   boscabeag <boscabeag@protonmail.com>
Cc:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: Parity distribution when adding disks to md-raid6
Message-ID: <moIqP54ll6VYnb_ngZT_xyboobMPrU3-h5c5-J6WUPVBsFvt40THsGFwYdOObavZ3OF2StdVWZpNOTTnVbldJXK8u-gVxSpRgnBFCGkoqvg=@protonmail.com>
In-Reply-To: <7ef4bb85-2d0f-8f1a-7fb7-336142acf405@youngman.org.uk>
References: <A73A8YRNkUS11zoz7eEaNfvnfZqyj6-vP-7mvI6_FFLdSETs_g6CFYgIL_PyV0F8AE6cXMomd7SznnsQDGQqwLuSJFMi8EbxGzxibvYjZ2s=@protonmail.com> <7ef4bb85-2d0f-8f1a-7fb7-336142acf405@youngman.org.uk>
Feedback-ID: 42495234:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sunday, January 8th, 2023 at 22:20, anthony <antmbox@youngman.org.uk> wr=
ote:

> I'm GUESSING you're trying to move from a non-raid setup.

First of all, thank you for taking the time to respond.

But no, I really am just asking about how and when the parity chunks get di=
stributed across a new device when a md-raid6 group is grown.

There was a time when some raid systems (not naming names, and if I remembe=
r correctly) would NOT re-distribute parity chunks on a grown group.  If th=
e group was built with devices A, B, C, & D, then the parity chunks would r=
emain on those four devices, and added devices E & F, etc. would only ever =
have data chunks, since the placement of parity chunks in a stripe was only=
 done at initial group creation time, even if the stripe was extended to ad=
ditional devices.

I'm not questioning that growing a md-raid group works and is fully functio=
nal.  This is very much a "what happens behind the curtain" question.

I don't know how md-raid6 works at this low and internal level, hence the q=
uestion.

Does the re-sync triggered by the grow re-write the entirety of all stripes=
 and some P & Q chunks get moved to the new device?

If the re-sync does change some P & Q chunks to data chunks to place those =
parity chunks on the new device, is the layout identical to what it would b=
e if the group was created with all devices instead of being grown?

Does it happen when a stripe is re-written through normal activity?  this i=
mplies if a stripe never gets any write activity, it will never re-layout t=
he location of its P & Q chunks.

Does it happen at all?  And the new devices only ever have data chunks like=
 what I remember from older systems?

Thank you!
