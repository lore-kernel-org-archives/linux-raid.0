Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A641EE49BF
	for <linux-raid@archiver.kernel.org>; Sun, 10 Sep 2023 03:12:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345603AbjIJDMD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 9 Sep 2023 23:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233350AbjIJDMD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 9 Sep 2023 23:12:03 -0400
Received: from www18.qth.com (www18.qth.com [69.16.238.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B949F188
        for <linux-raid@vger.kernel.org>; Sat,  9 Sep 2023 20:11:57 -0700 (PDT)
Received: from [73.207.192.158] (port=49026 helo=jpo)
        by www18.qth.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <davidtg-robot@justpickone.org>)
        id 1qfAre-0002p2-2h
        for linux-raid@vger.kernel.org;
        Sat, 09 Sep 2023 22:11:56 -0500
Date:   Sun, 10 Sep 2023 03:11:55 +0000
From:   David T-G <davidtg-robot@justpickone.org>
To:     Linux RAID list <linux-raid@vger.kernel.org>
Subject: assemble didn't quite (was "Re: all of my drives are spares")
Message-ID: <20230910031155.GE1085@jpo>
Reply-To: Linux RAID list <linux-raid@vger.kernel.org>
References: <20230908025035.GB1085@jpo>
 <20230909112656.GC1085@jpo>
 <ed6b9df8-93c6-6f5e-3a1c-7aa5b9d51352@youngman.org.uk>
 <20230910025554.GD1085@jpo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230910025554.GD1085@jpo>
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

...and then David T-G home said...
% 
% ...and then Wol said...
% 
...
% % I wonder if a controlled reboot would fix it. Or just do a --stop followed
% 
% I've tried a couple of reboots; they're stuck that way.  I'll try the
% stop and assemble.
[snip]

Stopping was easy:

  diskfarm:~ # for A in 51 52 53 54 55 56 ; do mdadm --stop /dev/md$A ;
  done
  mdadm: stopped /dev/md51
  mdadm: stopped /dev/md52
  mdadm: stopped /dev/md53
  mdadm: stopped /dev/md54
  mdadm: stopped /dev/md55
  mdadm: stopped /dev/md56

Restarting wasn't as impressive:

  diskfarm:~ # for A in 51 52 53 54 55 56 ; do mdadm --assemble /dev/md$A /dev/sd[dcblfk]$A ; done
  mdadm: /dev/md51 assembled from 3 drives - not enough to start the array.
  mdadm: /dev/md52 assembled from 3 drives - not enough to start the array.
  mdadm: /dev/md53 assembled from 3 drives - not enough to start the array.
  mdadm: /dev/md54 assembled from 3 drives - not enough to start the array.
  mdadm: /dev/md55 assembled from 3 drives - not enough to start the array.
  mdadm: /dev/md56 assembled from 3 drives - not enough to start the array.

  diskfarm:~ # mdadm --detail /dev/md51
  /dev/md51:
	     Version : 1.2
	  Raid Level : raid5
       Total Devices : 6
	 Persistence : Superblock is persistent
  
	       State : inactive
     Working Devices : 6
  
		Name : diskfarm:51  (local to host diskfarm)
		UUID : 9330e44f:35baf039:7e971a8e:da983e31
	      Events : 46655
  
      Number   Major   Minor   RaidDevice
  
	 -     259       39        -        /dev/sdl51
	 -     259        9        -        /dev/sdb51
	 -     259       31        -        /dev/sdk51
	 -     259       16        -        /dev/sdd51
	 -     259        2        -        /dev/sdc51
	 -     259       23        -        /dev/sdf51
  diskfarm:~ # grep md51 /proc/mdstat
  md51 : inactive sdk51[6](S) sdl51[4](S) sdf51[5](S) sdc51[1](S) sdd51[3](S) sdb51[0](S)

Still all spares.  And here I was hoping this would be easy ...


Thanks again

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

