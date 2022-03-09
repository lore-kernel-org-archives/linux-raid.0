Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D3E2C433F5
	for <linux-raid@archiver.kernel.org>; Wed,  9 Mar 2022 03:00:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbiCIDBB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 8 Mar 2022 22:01:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231497AbiCIDBA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 8 Mar 2022 22:01:00 -0500
Received: from www18.qth.com (www18.qth.com [69.16.238.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9619A13DE13
        for <linux-raid@vger.kernel.org>; Tue,  8 Mar 2022 19:00:01 -0800 (PST)
Received: from [73.207.192.158] (port=42292 helo=justpickone.org)
        by www18.qth.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <davidtg-robot@justpickone.org>)
        id 1nRmYS-0007hj-H0
        for linux-raid@vger.kernel.org; Tue, 08 Mar 2022 21:00:00 -0600
Date:   Tue, 8 Mar 2022 21:59:58 -0500
From:   David T-G <davidtg-robot@justpickone.org>
To:     Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: striping 2x500G to mirror 1x1T
Message-ID: <20220309025958.GE4455@justpickone.org>
References: <20220305044704.GB4455@justpickone.org>
 <9b00eff9-1540-228c-60af-d33c32e1b45a@sotapeli.fi>
 <20220309043447.70281a4d@nvm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220309043447.70281a4d@nvm>
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

Hi again, all --

...and then Roman Mamedov said...
% 
...
% And a very good point that Wols mentioned, the 1TB-disk member can be set as
% --write-mostly, since the 2x500GB RAID0 is likely to overshoot the performance
% of a single 1TB disk, even if its individual disks were slower. Not to mention
% it has two independent head sets for the same amount of data. (If we're still
% talking rotational here...)

Thanks so much for all of the input!  This sounds like the right way to
go.

I had completely forgotten the "strange magic" ;-) of RAID10 on just
two drives by reordering the two partitions on the second drive, but I
don't think that that applies here and I don't imagine it's worth the
complexity of striping two mirrors, half of each of which are partitions
on the 1T drive, so I'll just stripe [partions on] the two 500s.


Thanks again & have a great day!

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

