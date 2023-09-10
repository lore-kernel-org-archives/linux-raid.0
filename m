Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14A87EE7FF4
	for <linux-raid@archiver.kernel.org>; Sun, 10 Sep 2023 03:44:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233059AbjIJDoi (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 9 Sep 2023 23:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbjIJDog (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 9 Sep 2023 23:44:36 -0400
Received: from www18.qth.com (www18.qth.com [69.16.238.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B7DC18F
        for <linux-raid@vger.kernel.org>; Sat,  9 Sep 2023 20:44:30 -0700 (PDT)
Received: from [73.207.192.158] (port=49042 helo=jpo)
        by www18.qth.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <davidtg-robot@justpickone.org>)
        id 1qfBN9-0000c1-2H
        for linux-raid@vger.kernel.org;
        Sat, 09 Sep 2023 22:44:29 -0500
Date:   Sun, 10 Sep 2023 03:44:28 +0000
From:   David T-G <davidtg-robot@justpickone.org>
To:     Linux RAID list <linux-raid@vger.kernel.org>
Subject: timing (was "Re: all of my drives are spares")
Message-ID: <20230910034427.GF1085@jpo>
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

One more time this evening ...

...and then David T-G home said...
% 
% ...and then Wol said...
...
% % that's just struck me, this is often caused by a drive failing some while
% % back, and then a glitch on a second drive brings the whole thing down. When
% % did you last check your array was fully functional?
% 
% Let me get back to you on that.  It's actually been a couple of weeks in
% this state just waiting to get to it; life has been interesting here,
[snip]

Apparently less than a couple of weeks after all.  That's what I get for
not knowing where I'll sleep each night and losing track of the days as a
result...

Anyway, here are a couple of clips from 08/29:

  ######################################################################
   02:55:01  up  22:42,  0 users,  load average: 6.41, 6.73, 6.49
  Personalities : [raid1] [raid6] [raid5] [raid4] [linear]
  md50 : active linear md52[1] md54[3] md56[5] md51[0] md53[2] md55[4]
	29289848832 blocks super 1.2 0k rounding

  md4 : active raid1 sde4[0] sda4[2]
	142972224 blocks super 1.2 [2/2] [UU]
	bitmap: 1/2 pages [4KB], 65536KB chunk

  md3 : active raid1 sde3[0] sda3[2]
	35617792 blocks super 1.2 [2/2] [UU]

  md56 : active raid5 sdd56[3] sdc56[1] sdb56[0] sdf56[5] sdl56[4] sdk56[6]
	8136309760 blocks super 1.2 level 5, 512k chunk, algorithm 2 [6/6] [UUUUUU]
	  resync=DELAYED
	bitmap: 0/13 pages [0KB], 65536KB chunk

  md55 : active raid5 sdd55[3] sdc55[1] sdb55[0] sdf55[5] sdl55[4] sdk55[6]
	8136309760 blocks super 1.2 level 5, 512k chunk, algorithm 2 [6/6] [UUUUUU]
	  resync=DELAYED
	bitmap: 0/13 pages [0KB], 65536KB chunk

  md53 : active raid5 sdd53[3] sdc53[1] sdb53[0] sdf53[5] sdl53[4] sdk53[6]
	8136309760 blocks super 1.2 level 5, 512k chunk, algorithm 2 [6/6] [UUUUUU]
	[>....................]  check =  4.2% (69399936/1627261952) finish=7901.9min speed=3285K/sec
	bitmap: 0/13 pages [0KB], 65536KB chunk

  md51 : active raid5 sdb51[0] sdd51[3] sdc51[1] sdf51[5] sdl51[4] sdk51[6]
	8136309760 blocks super 1.2 level 5, 512k chunk, algorithm 2 [6/6] [UUUUUU]
	bitmap: 0/13 pages [0KB], 65536KB chunk

  md54 : active raid5 sdd54[3] sdc54[1] sdb54[0] sdf54[5] sdl54[4] sdk54[6]
	8136309760 blocks super 1.2 level 5, 512k chunk, algorithm 2 [6/6] [UUUUUU]
	  resync=DELAYED
	bitmap: 0/13 pages [0KB], 65536KB chunk

  md52 : active raid5 sdd52[3] sdc52[1] sdb52[0] sdf52[5] sdl52[4] sdk52[6]
	8136309760 blocks super 1.2 level 5, 512k chunk, algorithm 2 [6/6] [UUUUUU]
	  resync=DELAYED
	bitmap: 0/13 pages [0KB], 65536KB chunk

  md2 : active raid1 sde2[0] sda2[2]
	35617792 blocks super 1.2 [2/2] [UU]

  md1 : active raid1 sde1[0] sda1[2]
	35609600 blocks super 1.2 [2/2] [UU]

  unused devices: <none>
  ...
  ######################################################################
   03:00:01  up  22:47,  0 users,  load average: 3.75, 5.86, 6.28
  Personalities : [raid1] [raid6] [raid5] [raid4] [linear]
  md50 : active linear md52[1] md54[3] md56[5] md51[0] md53[2] md55[4]
	29289848832 blocks super 1.2 0k rounding

  md4 : active raid1 sde4[0] sda4[2]
	142972224 blocks super 1.2 [2/2] [UU]
	bitmap: 1/2 pages [4KB], 65536KB chunk

  md3 : active raid1 sde3[0] sda3[2]
	35617792 blocks super 1.2 [2/2] [UU]

  md56 : active raid5 sdd56[3] sdc56[1] sdb56[0] sdf56[5] sdl56[4]
	8136309760 blocks super 1.2 level 5, 512k chunk, algorithm 2 [6/5] [UUUU_U]
	bitmap: 0/13 pages [0KB], 65536KB chunk

  md55 : active raid5 sdd55[3] sdc55[1] sdb55[0] sdf55[5] sdl55[4]
	8136309760 blocks super 1.2 level 5, 512k chunk, algorithm 2 [6/5] [UUUU_U]
	bitmap: 0/13 pages [0KB], 65536KB chunk

  md53 : active raid5 sdd53[3] sdc53[1] sdb53[0] sdf53[5] sdl53[4] sdk53[6](F)
	8136309760 blocks super 1.2 level 5, 512k chunk, algorithm 2 [6/5] [UUUU_U]
	[>....................]  check =  4.2% (69789932/1627261952) finish=17276.4min speed=1502K/sec
	bitmap: 0/13 pages [0KB], 65536KB chunk

  md51 : active raid5 sdb51[0] sdd51[3] sdc51[1] sdf51[5] sdl51[4]
	8136309760 blocks super 1.2 level 5, 512k chunk, algorithm 2 [6/5] [UUUU_U]
	bitmap: 0/13 pages [0KB], 65536KB chunk

  md54 : active raid5 sdd54[3] sdc54[1] sdb54[0] sdf54[5] sdl54[4]
	8136309760 blocks super 1.2 level 5, 512k chunk, algorithm 2 [6/5] [UUUU_U]
	bitmap: 0/13 pages [0KB], 65536KB chunk

  md52 : active raid5 sdd52[3] sdc52[1] sdb52[0] sdf52[5] sdl52[4]
	8136309760 blocks super 1.2 level 5, 512k chunk, algorithm 2 [6/5] [UUUU_U]
	bitmap: 0/13 pages [0KB], 65536KB chunk

  md2 : active raid1 sde2[0] sda2[2]
	35617792 blocks super 1.2 [2/2] [UU]

  md1 : active raid1 sde1[0] sda1[2]
	35609600 blocks super 1.2 [2/2] [UU]

  unused devices: <none>
  /dev/sdn: Avolusion PRO-5X:  drive supported, but it doesn't have a temperature sensor.
  /dev/sdo: Seagate BUP BL:  drive supported, but it doesn't have a temperature sensor.
  /dev/sda: SATA SSD: 33302260C
  /dev/sdb: TOSHIBA HDWR11A: 43302260C
  /dev/sdc: TOSHIBA HDWR11A: 41302260C
  /dev/sdd: TOSHIBA HDWR11A: 42302260C
  /dev/sde: SATA SSD: 33302260C
  /dev/sdf: : S.M.A.R.T. not available
  /dev/sdg: : S.M.A.R.T. not available
  /dev/sdh: : S.M.A.R.T. not available
  /dev/sdp: WDC WD2500BEKT-75A25T0: S.M.A.R.T. not available
  /dev/sdq: WDC WD3200BEVT-60ZCT0: S.M.A.R.T. not available
  /dev/sdr: WD easystore 25FB: S.M.A.R.T. not available
  /dev/sds: WD easystore 264D: S.M.A.R.T. not available
  /dev/sdt: ST9120822A: S.M.A.R.T. not available
  /dev/sdu: WD Elements 25A3: S.M.A.R.T. not available

That's where sdk, a brand new EXOS 20T drive, apparently keeled over.
Hmmmmm.  Notice the temps check display; half of the SATA expansion card
(sdf - sdm) is missing.  Ouch.

Things ran fine like that for a day, until early on 08/30 we seem to
have keeled over.

  ######################################################################
   01:10:01  up 1 day 20:57,  0 users,  load average: 2.31, 2.11, 1.12
  Personalities : [raid1] [raid6] [raid5] [raid4] [linear]
  md50 : active linear md52[1] md54[3] md56[5] md51[0] md53[2] md55[4]
	29289848832 blocks super 1.2 0k rounding

  md4 : active raid1 sde4[0] sda4[2]
	142972224 blocks super 1.2 [2/2] [UU]
	bitmap: 0/2 pages [0KB], 65536KB chunk

  md3 : active raid1 sde3[0] sda3[2]
	35617792 blocks super 1.2 [2/2] [UU]

  md56 : active raid5 sdd56[3] sdc56[1] sdb56[0] sdf56[5] sdl56[4]
	8136309760 blocks super 1.2 level 5, 512k chunk, algorithm 2 [6/5] [UUUU_U]
	bitmap: 0/13 pages [0KB], 65536KB chunk

  md55 : active raid5 sdd55[3] sdc55[1] sdb55[0] sdf55[5] sdl55[4]
	8136309760 blocks super 1.2 level 5, 512k chunk, algorithm 2 [6/5] [UUUU_U]
	bitmap: 0/13 pages [0KB], 65536KB chunk

  md53 : active raid5 sdd53[3] sdc53[1] sdb53[0] sdf53[5] sdl53[4] sdk53[6](F)
	8136309760 blocks super 1.2 level 5, 512k chunk, algorithm 2 [6/5] [UUUU_U]
	bitmap: 0/13 pages [0KB], 65536KB chunk

  md51 : active raid5 sdb51[0] sdd51[3] sdc51[1] sdf51[5] sdl51[4]
	8136309760 blocks super 1.2 level 5, 512k chunk, algorithm 2 [6/5] [UUUU_U]
	bitmap: 0/13 pages [0KB], 65536KB chunk

  md54 : active raid5 sdd54[3] sdc54[1] sdb54[0] sdf54[5] sdl54[4]
	8136309760 blocks super 1.2 level 5, 512k chunk, algorithm 2 [6/5] [UUUU_U]
	bitmap: 1/13 pages [4KB], 65536KB chunk

  md52 : active raid5 sdd52[3] sdc52[1] sdb52[0] sdf52[5] sdl52[4]
	8136309760 blocks super 1.2 level 5, 512k chunk, algorithm 2 [6/5] [UUUU_U]
	bitmap: 0/13 pages [0KB], 65536KB chunk

  md2 : active raid1 sde2[0] sda2[2]
	35617792 blocks super 1.2 [2/2] [UU]

  md1 : active raid1 sde1[0] sda1[2]
	35609600 blocks super 1.2 [2/2] [UU]

  unused devices: <none>
  ...
  ######################################################################
   01:15:02  up 1 day 21:02,  0 users,  load average: 0.16, 0.84, 0.84
  Personalities : [raid1] [raid6] [raid5] [raid4] [linear]
  md50 : active linear md52[1] md54[3] md56[5] md51[0] md53[2] md55[4]
	29289848832 blocks super 1.2 0k rounding

  md4 : active raid1 sde4[0] sda4[2]
	142972224 blocks super 1.2 [2/2] [UU]
	bitmap: 0/2 pages [0KB], 65536KB chunk

  md3 : active raid1 sde3[0] sda3[2]
	35617792 blocks super 1.2 [2/2] [UU]

  md56 : active raid5 sdd56[3] sdc56[1] sdb56[0] sdf56[5] sdl56[4]
	8136309760 blocks super 1.2 level 5, 512k chunk, algorithm 2 [6/5] [

We came up again at 0240 the next day (08/31), and everything was a
spare.

  ######################################################################
   02:40:01  up   0:18,  27 users,  load average: 0.00, 0.03, 0.10
  Personalities : [raid1]
  md4 : active raid1 sde4[0] sda4[2]
	142972224 blocks super 1.2 [2/2] [UU]
	bitmap: 0/2 pages [0KB], 65536KB chunk

  md3 : active raid1 sde3[0] sda3[2]
	35617792 blocks super 1.2 [2/2] [UU]

  md55 : inactive sdd55[3](S) sdc55[1](S) sdb55[0](S) sdl55[4](S) sdk55[6](S) sdf55[5](S)
	9763571712 blocks super 1.2

  md56 : inactive sdd56[3](S) sdb56[0](S) sdc56[1](S) sdl56[4](S) sdk56[6](S) sdf56[5](S)
	9763571712 blocks super 1.2

  md53 : inactive sdd53[3](S) sdc53[1](S) sdb53[0](S) sdl53[4](S) sdk53[6](S) sdf53[5](S)
	9763571712 blocks super 1.2

  md54 : inactive sdd54[3](S) sdc54[1](S) sdb54[0](S) sdl54[4](S) sdk54[6](S) sdf54[5](S)
	9763571712 blocks super 1.2

  md52 : inactive sdd52[3](S) sdb52[0](S) sdc52[1](S) sdl52[4](S) sdk52[6](S) sdf52[5](S)
	9763571712 blocks super 1.2

  md51 : inactive sdd51[3](S) sdb51[0](S) sdc51[1](S) sdl51[4](S) sdk51[6](S) sdf51[5](S)
	9763571712 blocks super 1.2

  md1 : active raid1 sde1[0] sda1[2]
	35609600 blocks super 1.2 [2/2] [UU]

  md2 : active raid1 sde2[0] sda2[2]
	35617792 blocks super 1.2 [2/2] [UU]

  unused devices: <none>
  /dev/sdb: TOSHIBA HDWR11A: drive is sleeping
  /dev/sdc: TOSHIBA HDWR11A: drive is sleeping
  /dev/sdd: TOSHIBA HDWR11A: drive is sleeping
  /dev/sdf: ST20000NM007D-3DJ103: drive is sleeping
  /dev/sdk: ST20000NM007D-3DJ103: drive is sleeping
  /dev/sdl: TOSHIBA HDWR11A: drive is sleeping
  /dev/sdn: Avolusion PRO-5X:  drive supported, but it doesn't have a temperature sensor.
  /dev/sdo: Seagate BUP BL:  drive supported, but it doesn't have a temperature sensor.
  /dev/sda: SATA SSD: 33302260C
  /dev/sde: SATA SSD: 33302260C
  /dev/sdg: WDC WD7500BPKX-75HPJT0: 31302260C
  /dev/sdh: TOSHIBA MQ01ABD064: 33302260C
  /dev/sdi: ST3500413AS: 37302260C
  /dev/sdj: TOSHIBA MQ01ABD100: 33302260C
  /dev/sdm: Hitachi HDE721010SLA330: 43302260C
  /dev/sdp: WDC WD2500BEKT-75A25T0: S.M.A.R.T. not available
  /dev/sdq: WDC WD3200BEVT-60ZCT0: S.M.A.R.T. not available
  /dev/sdr: ST9120822A: S.M.A.R.T. not available
  /dev/sds: WD Elements 25A3: S.M.A.R.T. not available
  /dev/sdt: WD easystore 264D: S.M.A.R.T. not available
  /dev/sdu: WD easystore 25FB: S.M.A.R.T. not available

The whole SATA card is present, too; yay.  So rebooting helps.  But ...
Now I'm not sure how to get back to reassembly.


Thanks again and good night to all

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

