Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 819EFC433E0
	for <linux-raid@archiver.kernel.org>; Mon,  8 Feb 2021 13:31:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36D3664DCC
	for <linux-raid@archiver.kernel.org>; Mon,  8 Feb 2021 13:31:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbhBHNbC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 8 Feb 2021 08:31:02 -0500
Received: from mga04.intel.com ([192.55.52.120]:59527 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229611AbhBHNay (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 8 Feb 2021 08:30:54 -0500
IronPort-SDR: RCvQcfq1z6IziNi3G8AfF3Qd1b8YLibmV1YwdFix4VaHPDzbA+OUcHn24a6SPB6T/JuAUaGjOH
 hFJZJMpszKDQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9888"; a="179148729"
X-IronPort-AV: E=Sophos;i="5.81,162,1610438400"; 
   d="scan'208";a="179148729"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 05:29:03 -0800
IronPort-SDR: ZybZu9iW/ekyTVZR6CEWrtX8Iw548D0mwybpkcZJxqJNfXrj8jdY/+jdpHeXJkKpx9s+nb2Jqf
 1/QbRRUhv+gQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,162,1610438400"; 
   d="scan'208";a="361420718"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga006.jf.intel.com with ESMTP; 08 Feb 2021 05:29:01 -0800
Received: from [10.249.152.46] (mtkaczyk-MOBL1.ger.corp.intel.com [10.249.152.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id DA0F7580428;
        Mon,  8 Feb 2021 05:28:59 -0800 (PST)
Subject: Re: Repairing IMSM RAID array "active, FAILED, not started"
To:     19 Devices linuxraid <19devices+linuxraid@gmail.com>
References: <CC93341E865248F8AB635929EF587792@Tosh10Pro>
 <03420E24CF73457CAAAEE93529BD8B6C@Tosh10Pro>
From:   "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Message-ID: <ac370d79-95e8-d0a1-0991-fb12b128818c@linux.intel.com>
Date:   Mon, 8 Feb 2021 14:28:57 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <03420E24CF73457CAAAEE93529BD8B6C@Tosh10Pro>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello,

You achieved dirty-degraded RAID5 scenario:
 >       Map State : degraded
 >     Dirty State : dirty

Support for assembling IMSM dirty degraded array has been
added recently to mdadm:
https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/commit/?id=7b99edab2834d5d08ef774b4cff784caaa1a186f

This array cannot be assembled automatically, Incremental mode doesn't
support it. To start it you need to do following steps:
1. Backup the data on the drives first.

2. Check that mdadm has this fix included. The simplest way is to
download source package and check %patches section in mdadm.spec file.
If no, then compile your mdadm or please find distribution with fix
included.

3. Stop this inactive array:
# mdadm -S /dev/md/md0

4. Call assemble on the container with force flag:
# mdadm -A /dev/md127 /dev/md/md0 --force


You will see prompt:
"%s array state forced to clean. It may cause data corruption."
That is true, some data may be invalid. There is no safe way to start
your array.

Regards,
Mariusz

On 06.02.2021 04:19, 19 Devices linuxraid wrote:
> Hi, I'm hoping you can help me repair this RAID array (md125 below).  It failed 
> after a repeated series of power interruptions.  There are 4 x 1TB drives with 2 
> RAID 5 arrays spread across them.  One array is working (md126) as are all 4 
> drives.
> 
> The boot drive was on the failed array so the system is running from a Fedora 33 
> Live USB.  Details of the 3 arrays and 4 drives follow.
> 
> [root@localhost-live ~]# mdadm -D /dev/md125
> /dev/md125:
>          Container : /dev/md/imsm0, member 0
>       Raid Devices : 4
>      Total Devices : 3
> 
>              State : active, FAILED, Not Started
>     Active Devices : 3
>    Working Devices : 3
>     Failed Devices : 0
>      Spare Devices : 0
> 
> Consistency Policy : unknown
> 
> 
>               UUID : 38c20294:230f3d70:a1a5c8bd:8add8ba5
>     Number   Major   Minor   RaidDevice State
>        -       0        0        0      removed
>        -       0        0        1      removed
>        -       0        0        2      removed
>        -       0        0        3      removed
> 
>        -       8       32        0      sync   /dev/sdc
>        -       8        0        1      sync   /dev/sda
>        -       8       48        3      sync   /dev/sdd
> [root@localhost-live ~]#
> 
> [root@localhost-live ~]# mdadm -D /dev/md126
> /dev/md126:
>          Container : /dev/md/imsm0, member 1
>         Raid Level : raid5
>         Array Size : 99116032 (94.52 GiB 101.49 GB)
>      Used Dev Size : 33038976 (31.51 GiB 33.83 GB)
>       Raid Devices : 4
>      Total Devices : 4
> 
>              State : clean, degraded, recovering
>     Active Devices : 3
>    Working Devices : 4
>     Failed Devices : 0
>      Spare Devices : 1
> 
>             Layout : left-asymmetric
>         Chunk Size : 128K
> 
> Consistency Policy : resync
> 
>     Rebuild Status : 35% complete
> 
> 
>               UUID : 43d19777:6d66ecfa:3113d7a9:4feb07b4
>     Number   Major   Minor   RaidDevice State
>        3       8       32        0      active sync   /dev/sdc
>        2       8        0        1      active sync   /dev/sda
>        1       8       16        2      spare rebuilding   /dev/sdb
>        0       8       48        3      active sync   /dev/sdd
> [root@localhost-live ~]#
> 
> [root@localhost-live ~]# mdadm -D /dev/md127
> /dev/md127:
>            Version : imsm
>         Raid Level : container
>      Total Devices : 4
> 
>    Working Devices : 4
> 
> 
>               UUID : bdb7f495:21b8c189:e4968216:6f2d6c4c
>      Member Arrays : /dev/md125 /dev/md/md1_0
> 
>     Number   Major   Minor   RaidDevice
> 
>        -       8       32        -        /dev/sdc
>        -       8        0        -        /dev/sda
>        -       8       48        -        /dev/sdd
>        -       8       16        -        /dev/sdb
> [root@localhost-live ~]#
> 
> 
> [root@localhost-live ~]# mdadm --examine /dev/sda
> /dev/sda:
>           Magic : Intel Raid ISM Cfg Sig.
>         Version : 1.3.00
>     Orig Family : ab386e31
>          Family : 775b3841
>      Generation : 00458337
>      Attributes : All supported
>            UUID : bdb7f495:21b8c189:e4968216:6f2d6c4c
>        Checksum : f25e8e6d correct
>     MPB Sectors : 2
>           Disks : 5
>    RAID Devices : 2
> 
>   Disk01 Serial : WD-WCC3F1681668
>           State : active
>              Id : 00000001
>     Usable Size : 1953518848 (931.51 GiB 1000.20 GB)
> 
> [md0]:
>            UUID : 38c20294:230f3d70:a1a5c8bd:8add8ba5
>      RAID Level : 5
>         Members : 4
>           Slots : [UU_U]
>     Failed disk : 2
>       This Slot : 1
>     Sector Size : 512
>      Array Size : 5662310400 (2700.00 GiB 2899.10 GB)
>    Per Dev Size : 1887436800 (900.00 GiB 966.37 GB)
>   Sector Offset : 0
>     Num Stripes : 7372800
>      Chunk Size : 128 KiB
>        Reserved : 0
>   Migrate State : idle
>       Map State : degraded
>     Dirty State : dirty
>      RWH Policy : off
> 
> [md1]:
>            UUID : 43d19777:6d66ecfa:3113d7a9:4feb07b4
>      RAID Level : 5
>         Members : 4
>           Slots : [UUUU]
>     Failed disk : none
>       This Slot : 1
>     Sector Size : 512
>      Array Size : 198232064 (94.52 GiB 101.49 GB)
>    Per Dev Size : 66077952 (31.51 GiB 33.83 GB)
>   Sector Offset : 1887440896
>     Num Stripes : 258117
>      Chunk Size : 128 KiB
>        Reserved : 0
>   Migrate State : idle
>       Map State : normal
>     Dirty State : clean
>      RWH Policy : <unknown:128>
> 
>   Disk00 Serial : S13PJDWS608386
>           State : active
>              Id : 00000003
>     Usable Size : 1953518848 (931.51 GiB 1000.20 GB)
> 
>   Disk02 Serial : D-WMC3F2148323:0
>           State : active
>              Id : ffffffff
>     Usable Size : 1953518848 (931.51 GiB 1000.20 GB)
> 
>   Disk03 Serial : S13PJDWS608384
>           State : active
>              Id : 00000004
>     Usable Size : 1953518848 (931.51 GiB 1000.20 GB)
> 
>   Disk04 Serial : WD-WMC3F2148323
>           State : active
>              Id : 00000002
>     Usable Size : 1953518848 (931.51 GiB 1000.20 GB)
> [root@localhost-live ~]#
> 
> 
> [root@localhost-live ~]# mdadm --examine /dev/sdb
> /dev/sdb:
>           Magic : Intel Raid ISM Cfg Sig.
>         Version : 1.3.00
>     Orig Family : ab386e31
>          Family : 775b3841
>      Generation : 00458337
>      Attributes : All supported
>            UUID : bdb7f495:21b8c189:e4968216:6f2d6c4c
>        Checksum : f25e8e6d correct
>     MPB Sectors : 2
>           Disks : 5
>    RAID Devices : 2
> 
>   Disk04 Serial : WD-WMC3F2148323
>           State : active
>              Id : 00000002
>     Usable Size : 1953518848 (931.51 GiB 1000.20 GB)
> 
> [md0]:
>            UUID : 38c20294:230f3d70:a1a5c8bd:8add8ba5
>      RAID Level : 5
>         Members : 4
>           Slots : [UU_U]
>     Failed disk : 2
>       This Slot : ?
>     Sector Size : 512
>      Array Size : 5662310400 (2700.00 GiB 2899.10 GB)
>    Per Dev Size : 1887436800 (900.00 GiB 966.37 GB)
>   Sector Offset : 0
>     Num Stripes : 7372800
>      Chunk Size : 128 KiB
>        Reserved : 0
>   Migrate State : idle
>       Map State : degraded
>     Dirty State : dirty
>      RWH Policy : off
> 
> [md1]:
>            UUID : 43d19777:6d66ecfa:3113d7a9:4feb07b4
>      RAID Level : 5
>         Members : 4
>           Slots : [UUUU]
>     Failed disk : none
>       This Slot : 2
>     Sector Size : 512
>      Array Size : 198232064 (94.52 GiB 101.49 GB)
>    Per Dev Size : 66077952 (31.51 GiB 33.83 GB)
>   Sector Offset : 1887440896
>     Num Stripes : 258117
>      Chunk Size : 128 KiB
>        Reserved : 0
>   Migrate State : idle
>       Map State : normal
>     Dirty State : clean
>      RWH Policy : <unknown:128>
> 
>   Disk00 Serial : S13PJDWS608386
>           State : active
>              Id : 00000003
>     Usable Size : 1953518848 (931.51 GiB 1000.20 GB)
> 
>   Disk01 Serial : WD-WCC3F1681668
>           State : active
>              Id : 00000001
>     Usable Size : 1953518848 (931.51 GiB 1000.20 GB)
> 
>   Disk02 Serial : D-WMC3F2148323:0
>           State : active
>              Id : ffffffff
>     Usable Size : 1953518848 (931.51 GiB 1000.20 GB)
> 
>   Disk03 Serial : S13PJDWS608384
>           State : active
>              Id : 00000004
>     Usable Size : 1953518848 (931.51 GiB 1000.20 GB)
> [root@localhost-live ~]#
> 
> 
> [root@localhost-live ~]# mdadm --examine /dev/sdc
> /dev/sdc:
>           Magic : Intel Raid ISM Cfg Sig.
>         Version : 1.3.00
>     Orig Family : ab386e31
>          Family : 775b3841
>      Generation : 00458337
>      Attributes : All supported
>            UUID : bdb7f495:21b8c189:e4968216:6f2d6c4c
>        Checksum : f25e8e6d correct
>     MPB Sectors : 2
>           Disks : 5
>    RAID Devices : 2
> 
>   Disk00 Serial : S13PJDWS608386
>           State : active
>              Id : 00000003
>     Usable Size : 1953518848 (931.51 GiB 1000.20 GB)
> 
> [md0]:
>            UUID : 38c20294:230f3d70:a1a5c8bd:8add8ba5
>      RAID Level : 5
>         Members : 4
>           Slots : [UU_U]
>     Failed disk : 2
>       This Slot : 0
>     Sector Size : 512
>      Array Size : 5662310400 (2700.00 GiB 2899.10 GB)
>    Per Dev Size : 1887436800 (900.00 GiB 966.37 GB)
>   Sector Offset : 0
>     Num Stripes : 7372800
>      Chunk Size : 128 KiB
>        Reserved : 0
>   Migrate State : idle
>       Map State : degraded
>     Dirty State : dirty
>      RWH Policy : off
> 
> [md1]:
>            UUID : 43d19777:6d66ecfa:3113d7a9:4feb07b4
>      RAID Level : 5
>         Members : 4
>           Slots : [UUUU]
>     Failed disk : none
>       This Slot : 0
>     Sector Size : 512
>      Array Size : 198232064 (94.52 GiB 101.49 GB)
>    Per Dev Size : 66077952 (31.51 GiB 33.83 GB)
>   Sector Offset : 1887440896
>     Num Stripes : 258117
>      Chunk Size : 128 KiB
>        Reserved : 0
>   Migrate State : idle
>       Map State : normal
>     Dirty State : clean
>      RWH Policy : <unknown:128>
> 
>   Disk01 Serial : WD-WCC3F1681668
>           State : active
>              Id : 00000001
>     Usable Size : 1953518848 (931.51 GiB 1000.20 GB)
> 
>   Disk02 Serial : D-WMC3F2148323:0
>           State : active
>              Id : ffffffff
>     Usable Size : 1953518848 (931.51 GiB 1000.20 GB)
> 
>   Disk03 Serial : S13PJDWS608384
>           State : active
>              Id : 00000004
>     Usable Size : 1953518848 (931.51 GiB 1000.20 GB)
> 
>   Disk04 Serial : WD-WMC3F2148323
>           State : active
>              Id : 00000002
>     Usable Size : 1953518848 (931.51 GiB 1000.20 GB)
> [root@localhost-live ~]#
> 
> 
> [root@localhost-live ~]# mdadm --examine /dev/sdd
> /dev/sdd:
>           Magic : Intel Raid ISM Cfg Sig.
>         Version : 1.3.00
>     Orig Family : ab386e31
>          Family : 775b3841
>      Generation : 00458337
>      Attributes : All supported
>            UUID : bdb7f495:21b8c189:e4968216:6f2d6c4c
>        Checksum : f25e8e6d correct
>     MPB Sectors : 2
>           Disks : 5
>    RAID Devices : 2
> 
>   Disk03 Serial : S13PJDWS608384
>           State : active
>              Id : 00000004
>     Usable Size : 1953518848 (931.51 GiB 1000.20 GB)
> 
> [md0]:
>            UUID : 38c20294:230f3d70:a1a5c8bd:8add8ba5
>      RAID Level : 5
>         Members : 4
>           Slots : [UU_U]
>     Failed disk : 2
>       This Slot : 3
>     Sector Size : 512
>      Array Size : 5662310400 (2700.00 GiB 2899.10 GB)
>    Per Dev Size : 1887436800 (900.00 GiB 966.37 GB)
>   Sector Offset : 0
>     Num Stripes : 7372800
>      Chunk Size : 128 KiB
>        Reserved : 0
>   Migrate State : idle
>       Map State : degraded
>     Dirty State : dirty
>      RWH Policy : off
> 
> [md1]:
>            UUID : 43d19777:6d66ecfa:3113d7a9:4feb07b4
>      RAID Level : 5
>         Members : 4
>           Slots : [UUUU]
>     Failed disk : none
>       This Slot : 3
>     Sector Size : 512
>      Array Size : 198232064 (94.52 GiB 101.49 GB)
>    Per Dev Size : 66077952 (31.51 GiB 33.83 GB)
>   Sector Offset : 1887440896
>     Num Stripes : 258117
>      Chunk Size : 128 KiB
>        Reserved : 0
>   Migrate State : idle
>       Map State : normal
>     Dirty State : clean
>      RWH Policy : <unknown:128>
> 
>   Disk00 Serial : S13PJDWS608386
>           State : active
>              Id : 00000003
>     Usable Size : 1953518848 (931.51 GiB 1000.20 GB)
> 
>   Disk01 Serial : WD-WCC3F1681668
>           State : active
>              Id : 00000001
>     Usable Size : 1953518848 (931.51 GiB 1000.20 GB)
> 
>   Disk02 Serial : D-WMC3F2148323:0
>           State : active
>              Id : ffffffff
>     Usable Size : 1953518848 (931.51 GiB 1000.20 GB)
> 
>   Disk04 Serial : WD-WMC3F2148323
>           State : active
>              Id : 00000002
>     Usable Size : 1953518848 (931.51 GiB 1000.20 GB)
> [root@localhost-live ~]#
> 
> Thanks
> 
> ps. Why was my Outlook.com email address rejected by this server?
> 
> 

