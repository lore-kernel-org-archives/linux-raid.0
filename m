Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B6D0C43219
	for <linux-raid@archiver.kernel.org>; Thu, 24 Nov 2022 21:20:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbiKXVUO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 24 Nov 2022 16:20:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiKXVUN (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 24 Nov 2022 16:20:13 -0500
Received: from www18.qth.com (www18.qth.com [69.16.238.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC4DE93CDD
        for <linux-raid@vger.kernel.org>; Thu, 24 Nov 2022 13:20:11 -0800 (PST)
Received: from [73.207.192.158] (port=49598 helo=jpo)
        by www18.qth.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <davidtg-robot@justpickone.org>)
        id 1oyJdk-00051P-Gl
        for linux-raid@vger.kernel.org;
        Thu, 24 Nov 2022 15:20:11 -0600
Date:   Thu, 24 Nov 2022 21:20:07 +0000
From:   David T-G <davidtg-robot@justpickone.org>
To:     Linux RAID list <linux-raid@vger.kernel.org>
Subject: Re: how do i fix these RAID5 arrays?
Message-ID: <20221124212007.GF19721@jpo>
References: <20221123220736.GD19721@jpo>
 <20221124032821.628cd042@nvm>
 <CAAMCDedMhATuEPx8yFzAwxf5zS7CXFhz6702rmUCg7pXQX4qSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAMCDedMhATuEPx8yFzAwxf5zS7CXFhz6702rmUCg7pXQX4qSA@mail.gmail.com>
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

Roger, et al --

...and then Roger Heflin said...
...
% 
%  I use LVM on a 4 section raid built very similar to his, except mine
% is a linear lvm so no raid0 seek issues.

Got any pointers to instructions?


% 
% I think we need to see a grep -E 'md5|sdk' /var/log/messages to see
% where sdk went.
[snip]

Oops!  I knew I had overlooked something.  Not much to see, though :-/

  diskfarm:~ # for M in /var/log/messages-* ; do echo $M ; xz -d $M | egrep 'md5|sdk' ; echo '' ; done                                
  /var/log/messages-20221109.xz
  
  /var/log/messages-20221112.xz
  
  /var/log/messages-20221115.xz
  
  /var/log/messages-20221118.xz
  
  /var/log/messages-20221121.xz
  
  /var/log/messages-20221124.xz
  
  diskfarm:~ # egrep 'md5|sdk' /var/log/messages
  2022-11-24T03:00:35.886257+00:00 diskfarm smartd[1766]: Device: /dev/sdk [SAT], starting scheduled Short Self-Test.
  2022-11-24T03:30:32.154462+00:00 diskfarm smartd[1766]: Device: /dev/sdk [SAT], previous self-test completed without error


Thanks again

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

