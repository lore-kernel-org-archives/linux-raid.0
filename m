Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B23ECEC8747
	for <linux-raid@archiver.kernel.org>; Fri,  8 Sep 2023 03:05:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235026AbjIHDFY convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 7 Sep 2023 23:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231545AbjIHDFX (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 7 Sep 2023 23:05:23 -0400
X-Greylist: delayed 877 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 07 Sep 2023 20:05:15 PDT
Received: from www18.qth.com (www18.qth.com [69.16.238.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A0B1BD8
        for <linux-raid@vger.kernel.org>; Thu,  7 Sep 2023 20:05:15 -0700 (PDT)
Received: from [73.207.192.158] (port=47680 helo=jpo)
        by www18.qth.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <davidtg-robot@justpickone.org>)
        id 1qeRZu-0001l2-0P
        for linux-raid@vger.kernel.org;
        Thu, 07 Sep 2023 21:50:37 -0500
Date:   Fri, 8 Sep 2023 02:50:35 +0000
From:   David T-G <davidtg-robot@justpickone.org>
To:     Linux RAID list <linux-raid@vger.kernel.org>
Subject: all of my drives are spares
Message-ID: <20230908025035.GB1085@jpo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
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

After a surprise reboot the other day, I came home to find diskfarm's
RAID5 arrays all offline with all disks marked as spares.  wtf?!?

After some googling around I found

  https://ronhks.hu/2021/01/07/mdadm-raid-5-all-disk-became-spare/

(for recent example) that it has happened to others, and at least the
pieces are all there rather than completely destroyed, but before I try
stopping and reassembling each array I thought I should double check :-)

Below is the output of a big ol' debugging run.  I tried to dump only what
is interesting :-)  [The smartctl-disks-timeout.sh script is based on the
wiki site script to check and set as necessary.]  I'm not sure why sd[dbc]
show a missing device while sd[lkf] are happy on each array, and I wonder
what happened to md53 with the widely differing event counter that may
make assembly interesting (and why does md52 have such a low event count
when the six of these are linear striped into a big fat array?).

Soooooo ...  What do you guys suggest to get us back up and happy?  TIA


  diskfarm:~ # uname -a ; mdadm --version ; for D in sd{d,c,b,l,k,f} ; do mdadm -E /dev/$D ; smartctl -H -i /dev/$D | egrep 'Model|SMART' | sed -e 's/^/    /' ; done ; echo '' ; for A in 51 52 53 54 55 56 ; do egrep md$A /proc/mdstat ; mdadm -D /dev/md$A | egrep 'Version|State|Events|/dev' ; for D in sd{d,b,c,l,k,f} ; do echo $D$A ; mdadm -E /dev/$D$A | egrep 'Raid|State|Events' ; done ; echo '' ; done ; /usr/local/bin/smartctl-disks-timeout.sh

  Linux diskfarm 5.3.18-lp152.106-default #1 SMP Mon Nov 22 08:38:17 UTC 2021 (52078fe) x86_64 x86_64 x86_64 GNU/Linux
  mdadm - v4.1 - 2018-10-01
  /dev/sdd:
     MBR Magic : aa55
  Partition[0] :   4294967295 sectors at            1 (type ee)
  	Device Model:     TOSHIBA HDWR11A
  	SMART support is: Available - device has SMART capability.
  	SMART support is: Enabled
  	=== START OF READ SMART DATA SECTION ===
  	SMART overall-health self-assessment test result: PASSED
  /dev/sdc:
     MBR Magic : aa55
  Partition[0] :   4294967295 sectors at            1 (type ee)
  	Device Model:     TOSHIBA HDWR11A
  	SMART support is: Available - device has SMART capability.
  	SMART support is: Enabled
  	=== START OF READ SMART DATA SECTION ===
  	SMART overall-health self-assessment test result: PASSED
  /dev/sdb:
     MBR Magic : aa55
  Partition[0] :   4294967295 sectors at            1 (type ee)
  	Device Model:     TOSHIBA HDWR11A
  	SMART support is: Available - device has SMART capability.
  	SMART support is: Enabled
  	=== START OF READ SMART DATA SECTION ===
  	SMART overall-health self-assessment test result: PASSED
  /dev/sdl:
     MBR Magic : aa55
  Partition[0] :   4294967295 sectors at            1 (type ee)
  	Device Model:     TOSHIBA HDWR11A
  	SMART support is: Available - device has SMART capability.
  	SMART support is: Enabled
  	=== START OF READ SMART DATA SECTION ===
  	SMART overall-health self-assessment test result: PASSED
  /dev/sdk:
     MBR Magic : aa55
  Partition[0] :   4294967295 sectors at            1 (type ee)
  	Device Model:     ST20000NM007D-3DJ103
  	SMART support is: Available - device has SMART capability.
  	SMART support is: Enabled
  	=== START OF READ SMART DATA SECTION ===
  	SMART overall-health self-assessment test result: PASSED
  /dev/sdf:
     MBR Magic : aa55
  Partition[0] :   4294967295 sectors at            1 (type ee)
  	Device Model:     ST20000NM007D-3DJ103
  	SMART support is: Available - device has SMART capability.
  	SMART support is: Enabled
  	=== START OF READ SMART DATA SECTION ===
  	SMART overall-health self-assessment test result: PASSED
  
  md51 : inactive sdd51[3](S) sdb51[0](S) sdc51[1](S) sdl51[4](S) sdk51[6](S) sdf51[5](S)
  /dev/md51:
             Version : 1.2
               State : inactive
              Events : 46655
         -     259       39        -        /dev/sdl51
         -     259        9        -        /dev/sdb51
         -     259       31        -        /dev/sdk51
         -     259       16        -        /dev/sdd51
         -     259        2        -        /dev/sdc51
         -     259       23        -        /dev/sdf51
  sdd51
       Raid Level : raid5
     Raid Devices : 6
            State : clean
           Events : 46670
     Array State : AAAA.A ('A' == active, '.' == missing, 'R' == replacing)
  sdb51
       Raid Level : raid5
     Raid Devices : 6
            State : clean
           Events : 46670
     Array State : AAAA.A ('A' == active, '.' == missing, 'R' == replacing)
  sdc51
       Raid Level : raid5
     Raid Devices : 6
            State : clean
           Events : 46670
     Array State : AAAA.A ('A' == active, '.' == missing, 'R' == replacing)
  sdl51
       Raid Level : raid5
     Raid Devices : 6
            State : clean
           Events : 46655
     Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
  sdk51
       Raid Level : raid5
     Raid Devices : 6
            State : clean
           Events : 46655
     Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
  sdf51
       Raid Level : raid5
     Raid Devices : 6
            State : clean
           Events : 46655
     Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
  
  md52 : inactive sdd52[3](S) sdb52[0](S) sdc52[1](S) sdl52[4](S) sdk52[6](S) sdf52[5](S)
  /dev/md52:
             Version : 1.2
               State : inactive
              Events : 16482
         -     259        3        -        /dev/sdc52
         -     259       24        -        /dev/sdf52
         -     259       40        -        /dev/sdl52
         -     259       10        -        /dev/sdb52
         -     259       32        -        /dev/sdk52
         -     259       17        -        /dev/sdd52
  sdd52
       Raid Level : raid5
     Raid Devices : 6
            State : clean
           Events : 16482
     Array State : AAAA.A ('A' == active, '.' == missing, 'R' == replacing)
  sdb52
       Raid Level : raid5
     Raid Devices : 6
            State : clean
           Events : 16482
     Array State : AAAA.A ('A' == active, '.' == missing, 'R' == replacing)
  sdc52
       Raid Level : raid5
     Raid Devices : 6
            State : clean
           Events : 16482
     Array State : AAAA.A ('A' == active, '.' == missing, 'R' == replacing)
  sdl52
       Raid Level : raid5
     Raid Devices : 6
            State : clean
           Events : 16478
     Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
  sdk52
       Raid Level : raid5
     Raid Devices : 6
            State : clean
           Events : 16478
     Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
  sdf52
       Raid Level : raid5
     Raid Devices : 6
            State : clean
           Events : 16478
     Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
  
  md53 : inactive sdd53[3](S) sdc53[1](S) sdb53[0](S) sdl53[4](S) sdk53[6](S) sdf53[5](S)
  /dev/md53:
             Version : 1.2
               State : inactive
              Events : 41470
         -     259       33        -        /dev/sdk53
         -     259       18        -        /dev/sdd53
         -     259        4        -        /dev/sdc53
         -     259       25        -        /dev/sdf53
         -     259       41        -        /dev/sdl53
         -     259       11        -        /dev/sdb53
  sdd53
       Raid Level : raid5
     Raid Devices : 6
            State : clean
           Events : 53337
     Array State : AAAA.A ('A' == active, '.' == missing, 'R' == replacing)
  sdb53
       Raid Level : raid5
     Raid Devices : 6
            State : clean
           Events : 53337
     Array State : AAAA.A ('A' == active, '.' == missing, 'R' == replacing)
  sdc53
       Raid Level : raid5
     Raid Devices : 6
            State : clean
           Events : 53337
     Array State : AAAA.A ('A' == active, '.' == missing, 'R' == replacing)
  sdl53
       Raid Level : raid5
     Raid Devices : 6
            State : clean
           Events : 41470
     Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
  sdk53
       Raid Level : raid5
     Raid Devices : 6
            State : clean
           Events : 41470
     Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
  sdf53
       Raid Level : raid5
     Raid Devices : 6
            State : clean
           Events : 41470
     Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
  
  md54 : inactive sdd54[3](S) sdc54[1](S) sdb54[0](S) sdl54[4](S) sdk54[6](S) sdf54[5](S)
  /dev/md54:
             Version : 1.2
               State : inactive
              Events : 37400
         -     259        5        -        /dev/sdc54
         -     259       26        -        /dev/sdf54
         -     259       42        -        /dev/sdl54
         -     259       12        -        /dev/sdb54
         -     259       34        -        /dev/sdk54
         -     259       19        -        /dev/sdd54
  sdd54
       Raid Level : raid5
     Raid Devices : 6
            State : clean
           Events : 37400
     Array State : AAAA.A ('A' == active, '.' == missing, 'R' == replacing)
  sdb54
       Raid Level : raid5
     Raid Devices : 6
            State : clean
           Events : 37400
     Array State : AAAA.A ('A' == active, '.' == missing, 'R' == replacing)
  sdc54
       Raid Level : raid5
     Raid Devices : 6
            State : clean
           Events : 37400
     Array State : AAAA.A ('A' == active, '.' == missing, 'R' == replacing)
  sdl54
       Raid Level : raid5
     Raid Devices : 6
            State : clean
           Events : 37377
     Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
  sdk54
       Raid Level : raid5
     Raid Devices : 6
            State : clean
           Events : 37377
     Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
  sdf54
       Raid Level : raid5
     Raid Devices : 6
            State : clean
           Events : 37377
     Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
  
  md55 : inactive sdd55[3](S) sdc55[1](S) sdb55[0](S) sdl55[4](S) sdk55[6](S) sdf55[5](S)
  /dev/md55:
             Version : 1.2
               State : inactive
              Events : 42328
         -     259       35        -        /dev/sdk55
         -     259       20        -        /dev/sdd55
         -     259        6        -        /dev/sdc55
         -     259       27        -        /dev/sdf55
         -     259       43        -        /dev/sdl55
         -     259       13        -        /dev/sdb55
  sdd55
       Raid Level : raid5
     Raid Devices : 6
            State : clean
           Events : 42332
     Array State : AAAA.A ('A' == active, '.' == missing, 'R' == replacing)
  sdb55
       Raid Level : raid5
     Raid Devices : 6
            State : clean
           Events : 42332
     Array State : AAAA.A ('A' == active, '.' == missing, 'R' == replacing)
  sdc55
       Raid Level : raid5
     Raid Devices : 6
            State : clean
           Events : 42332
     Array State : AAAA.A ('A' == active, '.' == missing, 'R' == replacing)
  sdl55
       Raid Level : raid5
     Raid Devices : 6
            State : clean
           Events : 42328
     Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
  sdk55
       Raid Level : raid5
     Raid Devices : 6
            State : clean
           Events : 42328
     Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
  sdf55
       Raid Level : raid5
     Raid Devices : 6
            State : clean
           Events : 42328
     Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
  
  md56 : inactive sdd56[3](S) sdb56[0](S) sdc56[1](S) sdl56[4](S) sdk56[6](S) sdf56[5](S)
  /dev/md56:
             Version : 1.2
               State : inactive
              Events : 43091
         -     259        7        -        /dev/sdc56
         -     259       28        -        /dev/sdf56
         -     259       44        -        /dev/sdl56
         -     259       14        -        /dev/sdb56
         -     259       36        -        /dev/sdk56
         -     259       21        -        /dev/sdd56
  sdd56
       Raid Level : raid5
     Raid Devices : 6
            State : clean
           Events : 43091
     Array State : AAAA.A ('A' == active, '.' == missing, 'R' == replacing)
  sdb56
       Raid Level : raid5
     Raid Devices : 6
            State : clean
           Events : 43091
     Array State : AAAA.A ('A' == active, '.' == missing, 'R' == replacing)
  sdc56
       Raid Level : raid5
     Raid Devices : 6
            State : clean
           Events : 43091
     Array State : AAAA.A ('A' == active, '.' == missing, 'R' == replacing)
  sdl56
       Raid Level : raid5
     Raid Devices : 6
            State : clean
           Events : 43087
     Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
  sdk56
       Raid Level : raid5
     Raid Devices : 6
            State : clean
           Events : 43087
     Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
  sdf56
       Raid Level : raid5
     Raid Devices : 6
            State : clean
           Events : 43087
     Array State : AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
  
  [34mDrive timeouts[0m: sda [32mY[0m ; sdb [32mY[0m ; sdc [32mY[0m ; sdd [32mY[0m ; sde [32mY[0m ; sdf [32mY[0m ; sdg [33m180[0m ; sdh [32mY[0m ; sdi [32mY[0m ; sdj [32mY[0m ; sdk [32mY[0m ; sdl [32mY[0m ; sdm [32mY[0m ; 


:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

