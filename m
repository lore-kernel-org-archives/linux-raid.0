Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94915C64E7B
	for <linux-raid@archiver.kernel.org>; Mon, 30 Nov 2020 22:05:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45B4C2076C
	for <linux-raid@archiver.kernel.org>; Mon, 30 Nov 2020 22:05:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730394AbgK3WFH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 30 Nov 2020 17:05:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730391AbgK3WFG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 30 Nov 2020 17:05:06 -0500
Received: from u17383850.onlinehome-server.com (u17383850.onlinehome-server.com [IPv6:2607:f1c0:83f:ac00::a6:f62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F2C70C0613CF
        for <linux-raid@vger.kernel.org>; Mon, 30 Nov 2020 14:04:25 -0800 (PST)
Received: by u17383850.onlinehome-server.com (Postfix, from userid 5001)
        id 7613379C; Mon, 30 Nov 2020 17:04:25 -0500 (EST)
Date:   Mon, 30 Nov 2020 17:04:25 -0500
From:   David T-G <davidtg-robot@justpickone.org>
To:     linux-raid@vger.kernel.org
Subject: Re: partitions & filesystems
Message-ID: <20201130220425.GY1415@justpickone.org>
Reply-To: linux-raid@vger.kernel.org
References: <e6b7a61d16a25c433438c670fa4c0b4f@posteo.de>
 <20201130200503.GV1415@justpickone.org>
 <01a571de-8ae8-3d9e-6f3d-16555ad93ea3@youngman.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01a571de-8ae8-3d9e-6f3d-16555ad93ea3@youngman.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Wol, et al --

...and then antlists said...
% 
% On 30/11/2020 20:05, David T-G wrote:
% >
% >output because you have apparently created your filesystem on the entire
% >device (hey, I didn't know one could do that!).
% 
% That, actually, is the norm. It is NOT normal to partition a raid array.

Oh!  That's two things I've learned today :-)


% 
...
% >So the display isn't interesting, although the logic behind that approach
% >certainly is to me.
% 
% Your approach seems to be at odds with *normal* practice, although

Well, that isn't surprising; I haven't been a real^Wprofessional Sys Admin
for a decade or more now.  I don't by any means pretend to even think that
I know what's what :-)  I was happy to just be able to explain why the OP's
"filesystem" was missing.


% there is nothing wrong with it. At the end of the day, as far as
% linux is concerned, one block device is much the same as any other.

True.  TMTOWTDI :-)


% 
% Cheers,
% Wol


Thanks & HAND

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

