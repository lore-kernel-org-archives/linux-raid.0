Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3767EC433EF
	for <linux-raid@archiver.kernel.org>; Mon, 27 Jun 2022 10:59:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233876AbiF0K7u (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 27 Jun 2022 06:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233475AbiF0K7s (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 27 Jun 2022 06:59:48 -0400
Received: from www18.qth.com (www18.qth.com [69.16.238.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B914E10FE
        for <linux-raid@vger.kernel.org>; Mon, 27 Jun 2022 03:59:46 -0700 (PDT)
Received: from [73.207.192.158] (port=33404 helo=justpickone.org)
        by www18.qth.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <davidtg-robot@justpickone.org>)
        id 1o5mB5-0005Q8-Uw
        for linux-raid@vger.kernel.org;
        Mon, 27 Jun 2022 05:41:11 -0500
Date:   Mon, 27 Jun 2022 06:41:09 -0400
From:   David T-G <davidtg-robot@justpickone.org>
To:     Linux-RAID <linux-raid@vger.kernel.org>
Subject: what's wrong with RAID-10? (was "Re: moving a working array")
Message-ID: <20220627104109.GJ18273@justpickone.org>
References: <CAPpdf595_7eW8amX8eueMxgjaWvLW-hWHh1SHHaGAt8YyP7yDw@mail.gmail.com>
 <7683b644cf076f8db06d60fdd3e4f88424f35bd2.camel@gmail.com>
 <92378403-adf6-dedb-828c-81b331c1d8c1@youngman.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <92378403-adf6-dedb-828c-81b331c1d8c1@youngman.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - www18.qth.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - justpickone.org
X-Get-Message-Sender-Via: www18.qth.com: authenticated_id: dmail@justpickone.org
X-Authenticated-Sender: www18.qth.com: dmail@justpickone.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Wol, et al --

...and then Wols Lists said...
% 
% On 24/06/2022 15:09, Wilson Jonathan wrote:
% > On Fri, 2022-06-24 at 08:38 -0500, o1bigtenor wrote:
% > > 
% > > I have a working (no issues) raid-10 array in one box.
% 
% Bummer. It's a raid-10. A raid-1 would have been easier.
[snip]

This tripped me.  I presumed that the reason for -10, not least because
he also said "these 4 drives", was because the array space is bigger than
just one hard drive size, ie 6T on 4ea 3T drives.  How would RAID-1 work
for that storage?  And why would it be easier than RAID-10?


TIA

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

