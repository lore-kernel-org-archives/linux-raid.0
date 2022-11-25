Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8639C4332F
	for <linux-raid@archiver.kernel.org>; Fri, 25 Nov 2022 13:23:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbiKYNXF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 25 Nov 2022 08:23:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiKYNXE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 25 Nov 2022 08:23:04 -0500
Received: from www18.qth.com (www18.qth.com [69.16.238.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7467C248F0
        for <linux-raid@vger.kernel.org>; Fri, 25 Nov 2022 05:23:02 -0800 (PST)
Received: from [73.207.192.158] (port=50658 helo=jpo)
        by www18.qth.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <davidtg-robot@justpickone.org>)
        id 1oyYfZ-0000dj-Sz
        for linux-raid@vger.kernel.org;
        Fri, 25 Nov 2022 07:23:01 -0600
Date:   Fri, 25 Nov 2022 13:22:59 +0000
From:   David T-G <davidtg-robot@justpickone.org>
To:     Linux RAID list <linux-raid@vger.kernel.org>
Subject: Re: how do i fix these RAID5 arrays?
Message-ID: <20221125132259.GG19721@jpo>
References: <20221123220736.GD19721@jpo>
 <20221124032821.628cd042@nvm>
 <20221124211019.GE19721@jpo>
 <512a4cdd-9013-e158-7c77-7409cd0dc3a1@youngman.org.uk>
 <CAAMCDecPXmZsxaAPcSOOY4S7_ieRZC8O_u7LjLLH-t8L-6+21Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAMCDecPXmZsxaAPcSOOY4S7_ieRZC8O_u7LjLLH-t8L-6+21Q@mail.gmail.com>
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
% Based on those messages The re-add would be expected to work fine.  it

Sure enough, it did:

  diskfarm:~ # mdadm -D /dev/md5[123456] | egrep '^/dev|Stat|Size'
  /dev/md51:
	  Array Size : 4881773568 (4.55 TiB 5.00 TB)
       Used Dev Size : 1627257856 (1551.87 GiB 1666.31 GB)
	       State : clean 
	  Chunk Size : 512K
      Number   Major   Minor   RaidDevice State
  /dev/md52:
	  Array Size : 4881773568 (4.55 TiB 5.00 TB)
       Used Dev Size : 1627257856 (1551.87 GiB 1666.31 GB)
	       State : clean 
	  Chunk Size : 512K
      Number   Major   Minor   RaidDevice State
  /dev/md53:
	  Array Size : 4881773568 (4.55 TiB 5.00 TB)
       Used Dev Size : 1627257856 (1551.87 GiB 1666.31 GB)
	       State : clean 
	  Chunk Size : 512K
      Number   Major   Minor   RaidDevice State
  /dev/md54:
	  Array Size : 4881773568 (4.55 TiB 5.00 TB)
       Used Dev Size : 1627257856 (1551.87 GiB 1666.31 GB)
	       State : clean 
	  Chunk Size : 512K
      Number   Major   Minor   RaidDevice State
  /dev/md55:
	  Array Size : 4881773568 (4.55 TiB 5.00 TB)
       Used Dev Size : 1627257856 (1551.87 GiB 1666.31 GB)
	       State : clean 
	  Chunk Size : 512K
      Number   Major   Minor   RaidDevice State
  /dev/md56:
	  Array Size : 4881773568 (4.55 TiB 5.00 TB)
       Used Dev Size : 1627257856 (1551.87 GiB 1666.31 GB)
	       State : clean 
	  Chunk Size : 512K
      Number   Major   Minor   RaidDevice State

That's a great first step.  Whew!  And the little arrays are even the right
size:

  diskfarm:~ # fdisk -l /dev/md51
  Disk /dev/md51: 4.6 TiB, 4998936133632 bytes, 9763547136 sectors
  Units: sectors of 1 * 512 = 512 bytes
  Sector size (logical/physical): 512 bytes / 4096 bytes
  I/O size (minimum/optimal): 524288 bytes / 1572864 bytes

Yay.  But ...  The striped device never grew:

  diskfarm:~ # parted /dev/md50 p free
  Model: Linux Software RAID Array (md)
  Disk /dev/md50: 20.0TB
  Sector size (logical/physical): 512B/4096B
  Partition Table: gpt
  Disk Flags: 
  
  Number  Start   End     Size    File system  Name         Flags
	  17.4kB  3146kB  3128kB  Free Space
   1      3146kB  20.0TB  20.0TB  xfs          10Traid50md
	  20.0TB  20.0TB  3129kB  Free Space

Even though I think I'm gonna go with md linear instead of learning
something else, which means I'll rebuild the striped top layer, which
means I should get the whole 30T, I'm curious as to why I don't see it
now.  It appears that one cannot grow

  diskfarm:~ # mdadm --grow /dev/md50 --size max
  mdadm: Cannot set device size in this type of array.

a striped array.  Soooo ...  What to do?  More to the point, what will I
need to do when I add the next 10T drive?


% appears that the machine was shutdown wrong and/or crashed and kicked
...
% something goes wrong you always need to check messages and see what
% the underlying issue is/was.
[snip]

Thanks.  That's what had me confused ... :-/


Thanks again & HAND

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

