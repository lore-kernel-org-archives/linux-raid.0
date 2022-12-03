Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D480C352A1
	for <linux-raid@archiver.kernel.org>; Sat,  3 Dec 2022 05:52:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbiLCFwZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 3 Dec 2022 00:52:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbiLCFwX (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 3 Dec 2022 00:52:23 -0500
Received: from www18.qth.com (www18.qth.com [69.16.238.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A740DE5D7
        for <linux-raid@vger.kernel.org>; Fri,  2 Dec 2022 21:52:22 -0800 (PST)
Received: from [73.207.192.158] (port=34144 helo=jpo)
        by www18.qth.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <davidtg-robot@justpickone.org>)
        id 1p1LRm-0008TV-6v
        for linux-raid@vger.kernel.org;
        Fri, 02 Dec 2022 23:52:22 -0600
Date:   Sat, 3 Dec 2022 05:52:20 +0000
From:   David T-G <davidtg-robot@justpickone.org>
To:     Linux RAID list <linux-raid@vger.kernel.org>
Subject: stripe size checking (was "Re: about linear and about RAID10")
Message-ID: <20221203055220.GS19721@jpo>
Reply-To: Linux RAID list <linux-raid@vger.kernel.org>
References: <20221123220736.GD19721@jpo>
 <20221124032821.628cd042@nvm>
 <20221124211019.GE19721@jpo>
 <512a4cdd-9013-e158-7c77-7409cd0dc3a1@youngman.org.uk>
 <20221125133050.GH19721@jpo>
 <CAAMCDee6cyM5Uw6DitWtBL3W8NbW7j0DZcUp8A2CXWZbYceXeA@mail.gmail.com>
 <20221128144630.GN19721@jpo>
 <CAAMCDee_YrhXo+5hp31YXgUHkyuUr-zTXOqi0-HUjMrHpYMkTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAMCDee_YrhXo+5hp31YXgUHkyuUr-zTXOqi0-HUjMrHpYMkTQ@mail.gmail.com>
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
% How big is your stripe size set to?   The bigger the stripe size on the
% md40 main raid the closer it gets to linear.

I don't know ... and I don't know how to tell.

  davidtg@jpo:~> sudo mdadm -D /dev/md40
  /dev/md40:
	     Version : 1.2
       Creation Time : Mon Aug  8 12:15:12 2022
	  Raid Level : raid0
	  Array Size : 3906488320 (3.64 TiB 4.00 TB)
	Raid Devices : 2
       Total Devices : 2
	 Persistence : Superblock is persistent
  
	 Update Time : Mon Aug  8 12:15:12 2022
	       State : clean 
      Active Devices : 2
     Working Devices : 2
      Failed Devices : 0
       Spare Devices : 0
  
	      Layout : -unknown-
	  Chunk Size : 512K
  
  Consistency Policy : none
  
		Name : jpo:40  (local to host jpo)
		UUID : 4735f53c:7cdf7758:e212bec6:aa2942e8
	      Events : 0
  
      Number   Major   Minor   RaidDevice State
	 0       9       41        0      active sync   /dev/md/md41
	 1       9       42        1      active sync   /dev/md/md42
  
  davidtg@jpo:~> sudo mdadm -E /dev/md40
  /dev/md40:
     MBR Magic : aa55
  Partition[0] :   4294967295 sectors at            1 (type ee)

Is it the 512k chunk size?

% 
% And I think I did miss one behavior that explains it being faster with
% larger, and not sucking as bad as I expected.  On disks the internal cache
% is supposed to cache the entire track as it goes under the head, so when

Sounds familiar.


% you ask for the data theoriticaly requiring a seek the drive may already
% have the data still in its cache and hence not need to do a seek.   The
% performance would then be ok so long as the data is still in the cache.

Right.  Everything is awesome when the data is cached :-)


% But given your tests md40 at best gets close to the underlying raids
% performance.  When linear the underlying performance should be roughly
% equal.

Now that I understand linear, that makes sense.


Thanks again & HANN

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

