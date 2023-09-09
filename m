Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34F5DEEB589
	for <linux-raid@archiver.kernel.org>; Sat,  9 Sep 2023 11:27:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344607AbjIIL1F (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 9 Sep 2023 07:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235561AbjIIL1F (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 9 Sep 2023 07:27:05 -0400
Received: from www18.qth.com (www18.qth.com [69.16.238.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F29BAE46
        for <linux-raid@vger.kernel.org>; Sat,  9 Sep 2023 04:27:00 -0700 (PDT)
Received: from [73.207.192.158] (port=48604 helo=jpo)
        by www18.qth.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <davidtg-robot@justpickone.org>)
        id 1qew7C-0001pr-03
        for linux-raid@vger.kernel.org;
        Sat, 09 Sep 2023 06:26:59 -0500
Date:   Sat, 9 Sep 2023 11:26:56 +0000
From:   David T-G <davidtg-robot@justpickone.org>
To:     Linux RAID list <linux-raid@vger.kernel.org>
Subject: Re: all of my drives are spares
Message-ID: <20230909112656.GC1085@jpo>
References: <20230908025035.GB1085@jpo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230908025035.GB1085@jpo>
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

Hi, all --

...and then David T-G home said...
% Hi, all --
% 
% After a surprise reboot the other day, I came home to find diskfarm's
% RAID5 arrays all offline with all disks marked as spares.  wtf?!?
[snip]

Wow ...  I'm used to responses pointing out either what I've left
out or how stupid my setup is, but total silence ...  How did I
offend and how can I fix it?

I sure could use advice on the current hangup before perhaps just
destroying my entire array with the wrong commands ...


With fingers crossed,
:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

