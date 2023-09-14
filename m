Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B446EEEAA52
	for <linux-raid@archiver.kernel.org>; Thu, 14 Sep 2023 16:00:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241310AbjINQAI (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 14 Sep 2023 12:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241340AbjINQAH (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 14 Sep 2023 12:00:07 -0400
Received: from www18.qth.com (www18.qth.com [69.16.238.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECBC81BE5
        for <linux-raid@vger.kernel.org>; Thu, 14 Sep 2023 09:00:02 -0700 (PDT)
Received: from [73.207.192.158] (port=52144 helo=jpo)
        by www18.qth.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <davidtg-robot@justpickone.org>)
        id 1qgol7-0006eg-0W
        for linux-raid@vger.kernel.org;
        Thu, 14 Sep 2023 11:00:01 -0500
Date:   Thu, 14 Sep 2023 15:59:59 +0000
From:   David T-G <davidtg-robot@justpickone.org>
To:     Linux RAID list <linux-raid@vger.kernel.org>
Subject: Re: assemble didn't quite
Message-ID: <20230914155959.GI1085@jpo>
References: <20230908025035.GB1085@jpo>
 <20230909112656.GC1085@jpo>
 <ed6b9df8-93c6-6f5e-3a1c-7aa5b9d51352@youngman.org.uk>
 <20230910025554.GD1085@jpo>
 <20230910031155.GE1085@jpo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230910031155.GE1085@jpo>
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

...and then David T-G home said...
% ...and then David T-G home said...
% % 
% % ...and then Wol said...
% % 
% ...
% % % I wonder if a controlled reboot would fix it. Or just do a --stop followed
% % 
% % I've tried a couple of reboots; they're stuck that way.  I'll try the
% % stop and assemble.
% [snip]
% 
% Stopping was easy:
...
% 
% Restarting wasn't as impressive:
% 
%   diskfarm:~ # for A in 51 52 53 54 55 56 ; do mdadm --assemble /dev/md$A /dev/sd[dcblfk]$A ; done
%   mdadm: /dev/md51 assembled from 3 drives - not enough to start the array.
...
%   diskfarm:~ # grep md51 /proc/mdstat
%   md51 : inactive sdk51[6](S) sdl51[4](S) sdf51[5](S) sdc51[1](S) sdd51[3](S) sdb51[0](S)
% 
% Still all spares.  And here I was hoping this would be easy ...

In the end, after a few more tries, 

  --stop /dev/mdNN
  --assemble --force /dev/mdNN /dev/sd{d,c,b,l,f,k}NN

worked, at which point md50 the linear array happily lit itself up.  So
far, all seems good.  Yay!

Now about the size ...


Thanks again & HAND

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

