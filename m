Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	STOX_REPLY_TYPE,STOX_REPLY_TYPE_WITHOUT_QUOTES autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94A3EC433E0
	for <linux-raid@archiver.kernel.org>; Sat,  6 Feb 2021 03:28:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CA0364F9C
	for <linux-raid@archiver.kernel.org>; Sat,  6 Feb 2021 03:28:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbhBFD2t (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 5 Feb 2021 22:28:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231260AbhBFDTz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 5 Feb 2021 22:19:55 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62BF8C061788
        for <linux-raid@vger.kernel.org>; Fri,  5 Feb 2021 19:19:15 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id f16so7540032wmq.5
        for <linux-raid@vger.kernel.org>; Fri, 05 Feb 2021 19:19:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:message-id:reply-to:to:references:in-reply-to:subject:date
         :mime-version:content-transfer-encoding:importance;
        bh=Qw8XOngMRwTLkVjjdtMRAj/st0YIoR4EAN8lkPp0eeQ=;
        b=MzDpewCtwchiCPo4iLPVMutV0kRMt2hFTYvwM1SqFzDhYrqQQPmP7BU/Q3x4Fl8fD5
         /8MxXeWFutDJx7jON81X09fF1YDZL87hPQh85Ura0zcvRpCa7L5ljtk2h8P8Djzu8on5
         MnqJLs2RVTVTKfOW9w98vWK3iIPFmb6DgBJ0DEfbKTLhtCk3U2bRA/Ny6pbMyQQBVzFJ
         RuDtLlrkfoJsaHSAIFtOkgqLD3Vpoydt9XcdOyERWO3ebOI0akHhjSi1v4UpbR+jewEh
         YuIWRh2uMUtJLbVurF9yXLohun1i2O+wKhcYGzXEaU1M1DWGMJMwW6sQWFK2AUv/PWo5
         GQBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:reply-to:to:references
         :in-reply-to:subject:date:mime-version:content-transfer-encoding
         :importance;
        bh=Qw8XOngMRwTLkVjjdtMRAj/st0YIoR4EAN8lkPp0eeQ=;
        b=j/f56dSoOulWfvmcblYzwHOGm8ItlB01VaRlfSnzh3Dg+ueZG8GISSd9Ogpxa6tuRB
         b67fpXb7p9RoJ8WDl9U2gWr8V0+TFFFcx+kbLD9P+eUeHE5reOzlprl6ATtqOPYYHkZ1
         OlREAVDtc2gG4KvzHnrD5aUJszu8nfwKFyhCJT2qSu+XinF/1JdqCjzEft+EfJZIJYWC
         rvjWNUMq4f5LlNNnzTlyPrHFuE0hmRcj7ShBcwzLRSJmBdFOq/Kd68IXsiKZUJL1BR3l
         Ji9ATZoZWtWCtnkzeNNQl6FltIJi+mM86+Sn4UbEA0H2uqa11kiHcSypJlpY9QmppBiC
         NvOg==
X-Gm-Message-State: AOAM530P5MWjzLcKRrbAcp6lAyq/V9C/yJNxItFl5kHyBbHCLJP/O+pl
        Yjo6JimWXjXJFpedCv6N1XAvXzEgjqM=
X-Google-Smtp-Source: ABdhPJyOJld1AwNCzqan3Br1lFCRiLOMJ6fDeyVahJJ9KSeOP1GdzhgJVfJZPDIsHSJTYgszaKIiLg==
X-Received: by 2002:a1c:6308:: with SMTP id x8mr6024204wmb.78.1612581554102;
        Fri, 05 Feb 2021 19:19:14 -0800 (PST)
Received: from Tosh10Pro (cpc92300-haye23-2-0-cust581.17-4.cable.virginm.net. [86.22.42.70])
        by smtp.gmail.com with ESMTPSA id s23sm10315623wmc.29.2021.02.05.19.19.13
        for <linux-raid@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Feb 2021 19:19:13 -0800 (PST)
From:   19 Devices linuxraid <19devices@gmail.com>
X-Google-Original-From: "19 Devices linuxraid" <19devices+linuxraid@gmail.com>
Message-ID: <03420E24CF73457CAAAEE93529BD8B6C@Tosh10Pro>
Reply-To: "19 Devices linuxraid" <19devices+linuxraid@gmail.com>
To:     <linux-raid@vger.kernel.org>
References: <CC93341E865248F8AB635929EF587792@Tosh10Pro>
In-Reply-To: <CC93341E865248F8AB635929EF587792@Tosh10Pro>
Subject: Repairing IMSM RAID array "active, FAILED, not started"
Date:   Sat, 6 Feb 2021 03:19:13 -0000
MIME-Version: 1.0
Content-Type: text/plain;
        format=flowed;
        charset="iso-8859-1";
        reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 16.4.3528.331
X-MimeOLE: Produced By Microsoft MimeOLE V16.4.3528.331
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi, I'm hoping you can help me repair this RAID array (md125 below).  It 
failed after a repeated series of power interruptions.  There are 4 x 1TB 
drives with 2 RAID 5 arrays spread across them.  One array is working 
(md126) as are all 4 drives.

The boot drive was on the failed array so the system is running from a 
Fedora 33 Live USB.  Details of the 3 arrays and 4 drives follow.

[root@localhost-live ~]# mdadm -D /dev/md125
/dev/md125:
         Container : /dev/md/imsm0, member 0
      Raid Devices : 4
     Total Devices : 3

             State : active, FAILED, Not Started
    Active Devices : 3
   Working Devices : 3
    Failed Devices : 0
     Spare Devices : 0

Consistency Policy : unknown


              UUID : 38c20294:230f3d70:a1a5c8bd:8add8ba5
    Number   Major   Minor   RaidDevice State
       -       0        0        0      removed
       -       0        0        1      removed
       -       0        0        2      removed
       -       0        0        3      removed

       -       8       32        0      sync   /dev/sdc
       -       8        0        1      sync   /dev/sda
       -       8       48        3      sync   /dev/sdd
[root@localhost-live ~]#

[root@localhost-live ~]# mdadm -D /dev/md126
/dev/md126:
         Container : /dev/md/imsm0, member 1
        Raid Level : raid5
        Array Size : 99116032 (94.52 GiB 101.49 GB)
     Used Dev Size : 33038976 (31.51 GiB 33.83 GB)
      Raid Devices : 4
     Total Devices : 4

             State : clean, degraded, recovering
    Active Devices : 3
   Working Devices : 4
    Failed Devices : 0
     Spare Devices : 1

            Layout : left-asymmetric
        Chunk Size : 128K

Consistency Policy : resync

    Rebuild Status : 35% complete


              UUID : 43d19777:6d66ecfa:3113d7a9:4feb07b4
    Number   Major   Minor   RaidDevice State
       3       8       32        0      active sync   /dev/sdc
       2       8        0        1      active sync   /dev/sda
       1       8       16        2      spare rebuilding   /dev/sdb
       0       8       48        3      active sync   /dev/sdd
[root@localhost-live ~]#

[root@localhost-live ~]# mdadm -D /dev/md127
/dev/md127:
           Version : imsm
        Raid Level : container
     Total Devices : 4

   Working Devices : 4


              UUID : bdb7f495:21b8c189:e4968216:6f2d6c4c
     Member Arrays : /dev/md125 /dev/md/md1_0

    Number   Major   Minor   RaidDevice

       -       8       32        -        /dev/sdc
       -       8        0        -        /dev/sda
       -       8       48        -        /dev/sdd
       -       8       16        -        /dev/sdb
[root@localhost-live ~]#


[root@localhost-live ~]# mdadm --examine /dev/sda
/dev/sda:
          Magic : Intel Raid ISM Cfg Sig.
        Version : 1.3.00
    Orig Family : ab386e31
         Family : 775b3841
     Generation : 00458337
     Attributes : All supported
           UUID : bdb7f495:21b8c189:e4968216:6f2d6c4c
       Checksum : f25e8e6d correct
    MPB Sectors : 2
          Disks : 5
   RAID Devices : 2

  Disk01 Serial : WD-WCC3F1681668
          State : active
             Id : 00000001
    Usable Size : 1953518848 (931.51 GiB 1000.20 GB)

[md0]:
           UUID : 38c20294:230f3d70:a1a5c8bd:8add8ba5
     RAID Level : 5
        Members : 4
          Slots : [UU_U]
    Failed disk : 2
      This Slot : 1
    Sector Size : 512
     Array Size : 5662310400 (2700.00 GiB 2899.10 GB)
   Per Dev Size : 1887436800 (900.00 GiB 966.37 GB)
  Sector Offset : 0
    Num Stripes : 7372800
     Chunk Size : 128 KiB
       Reserved : 0
  Migrate State : idle
      Map State : degraded
    Dirty State : dirty
     RWH Policy : off

[md1]:
           UUID : 43d19777:6d66ecfa:3113d7a9:4feb07b4
     RAID Level : 5
        Members : 4
          Slots : [UUUU]
    Failed disk : none
      This Slot : 1
    Sector Size : 512
     Array Size : 198232064 (94.52 GiB 101.49 GB)
   Per Dev Size : 66077952 (31.51 GiB 33.83 GB)
  Sector Offset : 1887440896
    Num Stripes : 258117
     Chunk Size : 128 KiB
       Reserved : 0
  Migrate State : idle
      Map State : normal
    Dirty State : clean
     RWH Policy : <unknown:128>

  Disk00 Serial : S13PJDWS608386
          State : active
             Id : 00000003
    Usable Size : 1953518848 (931.51 GiB 1000.20 GB)

  Disk02 Serial : D-WMC3F2148323:0
          State : active
             Id : ffffffff
    Usable Size : 1953518848 (931.51 GiB 1000.20 GB)

  Disk03 Serial : S13PJDWS608384
          State : active
             Id : 00000004
    Usable Size : 1953518848 (931.51 GiB 1000.20 GB)

  Disk04 Serial : WD-WMC3F2148323
          State : active
             Id : 00000002
    Usable Size : 1953518848 (931.51 GiB 1000.20 GB)
[root@localhost-live ~]#


[root@localhost-live ~]# mdadm --examine /dev/sdb
/dev/sdb:
          Magic : Intel Raid ISM Cfg Sig.
        Version : 1.3.00
    Orig Family : ab386e31
         Family : 775b3841
     Generation : 00458337
     Attributes : All supported
           UUID : bdb7f495:21b8c189:e4968216:6f2d6c4c
       Checksum : f25e8e6d correct
    MPB Sectors : 2
          Disks : 5
   RAID Devices : 2

  Disk04 Serial : WD-WMC3F2148323
          State : active
             Id : 00000002
    Usable Size : 1953518848 (931.51 GiB 1000.20 GB)

[md0]:
           UUID : 38c20294:230f3d70:a1a5c8bd:8add8ba5
     RAID Level : 5
        Members : 4
          Slots : [UU_U]
    Failed disk : 2
      This Slot : ?
    Sector Size : 512
     Array Size : 5662310400 (2700.00 GiB 2899.10 GB)
   Per Dev Size : 1887436800 (900.00 GiB 966.37 GB)
  Sector Offset : 0
    Num Stripes : 7372800
     Chunk Size : 128 KiB
       Reserved : 0
  Migrate State : idle
      Map State : degraded
    Dirty State : dirty
     RWH Policy : off

[md1]:
           UUID : 43d19777:6d66ecfa:3113d7a9:4feb07b4
     RAID Level : 5
        Members : 4
          Slots : [UUUU]
    Failed disk : none
      This Slot : 2
    Sector Size : 512
     Array Size : 198232064 (94.52 GiB 101.49 GB)
   Per Dev Size : 66077952 (31.51 GiB 33.83 GB)
  Sector Offset : 1887440896
    Num Stripes : 258117
     Chunk Size : 128 KiB
       Reserved : 0
  Migrate State : idle
      Map State : normal
    Dirty State : clean
     RWH Policy : <unknown:128>

  Disk00 Serial : S13PJDWS608386
          State : active
             Id : 00000003
    Usable Size : 1953518848 (931.51 GiB 1000.20 GB)

  Disk01 Serial : WD-WCC3F1681668
          State : active
             Id : 00000001
    Usable Size : 1953518848 (931.51 GiB 1000.20 GB)

  Disk02 Serial : D-WMC3F2148323:0
          State : active
             Id : ffffffff
    Usable Size : 1953518848 (931.51 GiB 1000.20 GB)

  Disk03 Serial : S13PJDWS608384
          State : active
             Id : 00000004
    Usable Size : 1953518848 (931.51 GiB 1000.20 GB)
[root@localhost-live ~]#


[root@localhost-live ~]# mdadm --examine /dev/sdc
/dev/sdc:
          Magic : Intel Raid ISM Cfg Sig.
        Version : 1.3.00
    Orig Family : ab386e31
         Family : 775b3841
     Generation : 00458337
     Attributes : All supported
           UUID : bdb7f495:21b8c189:e4968216:6f2d6c4c
       Checksum : f25e8e6d correct
    MPB Sectors : 2
          Disks : 5
   RAID Devices : 2

  Disk00 Serial : S13PJDWS608386
          State : active
             Id : 00000003
    Usable Size : 1953518848 (931.51 GiB 1000.20 GB)

[md0]:
           UUID : 38c20294:230f3d70:a1a5c8bd:8add8ba5
     RAID Level : 5
        Members : 4
          Slots : [UU_U]
    Failed disk : 2
      This Slot : 0
    Sector Size : 512
     Array Size : 5662310400 (2700.00 GiB 2899.10 GB)
   Per Dev Size : 1887436800 (900.00 GiB 966.37 GB)
  Sector Offset : 0
    Num Stripes : 7372800
     Chunk Size : 128 KiB
       Reserved : 0
  Migrate State : idle
      Map State : degraded
    Dirty State : dirty
     RWH Policy : off

[md1]:
           UUID : 43d19777:6d66ecfa:3113d7a9:4feb07b4
     RAID Level : 5
        Members : 4
          Slots : [UUUU]
    Failed disk : none
      This Slot : 0
    Sector Size : 512
     Array Size : 198232064 (94.52 GiB 101.49 GB)
   Per Dev Size : 66077952 (31.51 GiB 33.83 GB)
  Sector Offset : 1887440896
    Num Stripes : 258117
     Chunk Size : 128 KiB
       Reserved : 0
  Migrate State : idle
      Map State : normal
    Dirty State : clean
     RWH Policy : <unknown:128>

  Disk01 Serial : WD-WCC3F1681668
          State : active
             Id : 00000001
    Usable Size : 1953518848 (931.51 GiB 1000.20 GB)

  Disk02 Serial : D-WMC3F2148323:0
          State : active
             Id : ffffffff
    Usable Size : 1953518848 (931.51 GiB 1000.20 GB)

  Disk03 Serial : S13PJDWS608384
          State : active
             Id : 00000004
    Usable Size : 1953518848 (931.51 GiB 1000.20 GB)

  Disk04 Serial : WD-WMC3F2148323
          State : active
             Id : 00000002
    Usable Size : 1953518848 (931.51 GiB 1000.20 GB)
[root@localhost-live ~]#


[root@localhost-live ~]# mdadm --examine /dev/sdd
/dev/sdd:
          Magic : Intel Raid ISM Cfg Sig.
        Version : 1.3.00
    Orig Family : ab386e31
         Family : 775b3841
     Generation : 00458337
     Attributes : All supported
           UUID : bdb7f495:21b8c189:e4968216:6f2d6c4c
       Checksum : f25e8e6d correct
    MPB Sectors : 2
          Disks : 5
   RAID Devices : 2

  Disk03 Serial : S13PJDWS608384
          State : active
             Id : 00000004
    Usable Size : 1953518848 (931.51 GiB 1000.20 GB)

[md0]:
           UUID : 38c20294:230f3d70:a1a5c8bd:8add8ba5
     RAID Level : 5
        Members : 4
          Slots : [UU_U]
    Failed disk : 2
      This Slot : 3
    Sector Size : 512
     Array Size : 5662310400 (2700.00 GiB 2899.10 GB)
   Per Dev Size : 1887436800 (900.00 GiB 966.37 GB)
  Sector Offset : 0
    Num Stripes : 7372800
     Chunk Size : 128 KiB
       Reserved : 0
  Migrate State : idle
      Map State : degraded
    Dirty State : dirty
     RWH Policy : off

[md1]:
           UUID : 43d19777:6d66ecfa:3113d7a9:4feb07b4
     RAID Level : 5
        Members : 4
          Slots : [UUUU]
    Failed disk : none
      This Slot : 3
    Sector Size : 512
     Array Size : 198232064 (94.52 GiB 101.49 GB)
   Per Dev Size : 66077952 (31.51 GiB 33.83 GB)
  Sector Offset : 1887440896
    Num Stripes : 258117
     Chunk Size : 128 KiB
       Reserved : 0
  Migrate State : idle
      Map State : normal
    Dirty State : clean
     RWH Policy : <unknown:128>

  Disk00 Serial : S13PJDWS608386
          State : active
             Id : 00000003
    Usable Size : 1953518848 (931.51 GiB 1000.20 GB)

  Disk01 Serial : WD-WCC3F1681668
          State : active
             Id : 00000001
    Usable Size : 1953518848 (931.51 GiB 1000.20 GB)

  Disk02 Serial : D-WMC3F2148323:0
          State : active
             Id : ffffffff
    Usable Size : 1953518848 (931.51 GiB 1000.20 GB)

  Disk04 Serial : WD-WMC3F2148323
          State : active
             Id : 00000002
    Usable Size : 1953518848 (931.51 GiB 1000.20 GB)
[root@localhost-live ~]#

Thanks

ps. Why was my Outlook.com email address rejected by this server? 

