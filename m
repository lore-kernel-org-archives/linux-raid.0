Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10D37C433DB
	for <linux-raid@archiver.kernel.org>; Tue, 16 Mar 2021 08:16:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D00FB64FD1
	for <linux-raid@archiver.kernel.org>; Tue, 16 Mar 2021 08:16:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234243AbhCPIPn (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 16 Mar 2021 04:15:43 -0400
Received: from mga03.intel.com ([134.134.136.65]:36713 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234239AbhCPIPM (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 16 Mar 2021 04:15:12 -0400
IronPort-SDR: +mOxap/p8kIaFy5sWom9aYbdBkjzXg5UvRv1Ht4mts173IGLE802/QpD+qD8bzBh0Zy6/w6TOl
 OW/smM975cuA==
X-IronPort-AV: E=McAfee;i="6000,8403,9924"; a="189270232"
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="189270232"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2021 01:15:10 -0700
IronPort-SDR: MBcNBniFpCI8d8z2tDK0OIxyIROReIDwbZem0eGEPKI9uE2xpCYYoeTFhSedgjBBz3oUSK9BeO
 1zNtniS6uV7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="371903962"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga003.jf.intel.com with ESMTP; 16 Mar 2021 01:15:09 -0700
Received: from [10.249.154.67] (mtkaczyk-MOBL1.ger.corp.intel.com [10.249.154.67])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 91D1E580808;
        Tue, 16 Mar 2021 01:15:07 -0700 (PDT)
Subject: Re: Cannot add replacement hard drive to mdadm RAID5 array
To:     Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Devon Beets <devon@sigmalabsinc.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc:     Glenn Wikle <gwikle@sigmalabsinc.com>
References: <CY4PR1301MB215210F6808E6C0BA5D751ABCA6F9@CY4PR1301MB2152.namprd13.prod.outlook.com>
 <027a7faa-8858-2488-2771-0d412ef73866@intel.com>
From:   "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Message-ID: <45914472-b918-8a34-e531-fa145ec670fc@linux.intel.com>
Date:   Tue, 16 Mar 2021 09:15:05 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <027a7faa-8858-2488-2771-0d412ef73866@intel.com>
Content-Type: text/plain; charset=koi8-r; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 15.03.2021 15:38, Artur Paszkiewicz wrote:
> On 3/12/21 11:55 PM, Devon Beets wrote:
>> Hello,
>>
>> My colleague and I have been trying to replace a failed hard drive in a four-drive RAID5 array (/dev/sda to /dev/sdd). The failed drive is sdb. We have physically removed the hard drive and replaced it with a new drive that has identical specifications. We did not first use mdadm to set the failed hard drive with --fail.
>>
>> Upon booting the system with the new /dev/sdb drive installed, we see that instead of the usual two md entries (/dev/md127 which is an IMSM container and /dev/md126 which is the actual array) there are now three entries: md125 to md127. md127 is the IMSM container for sda, sdc, and sdd. md125 is a new container for sdb that we do not want. md126 is the actual array and only contains sda, sdc, and sdd. We tried to use --stop and --remove to get rid of md125, then add sdb to md127, and assemble to see if it adds to md126. It does not.
>>
>> Below is the output of some commands for additional diagnostic information. Please let me know if you need more.
>>
>> Note: The output of these commands is after a fresh reboot, without/before all the other commands we tried to fix it. It gets reset to this state after every reboot we tried so far.
>>
>> uname -a
>> Linux aerospace-pr3d-app 4.4.0-194-generic #226-Ubuntu SMP Wed Oct 21 10:19:36 UTC 2020 x86_64 x86_64 x86_64 GNU/Linux
>>
>> sudo mdadm --version
>> mdadm - v4.1-126-gbdbe7f8 - 2021-03-09
>>
>> sudo smartctl -H -i -l scterc /dev/sda
>> smartctl 6.5 2016-01-24 r4214 [x86_64-linux-4.4.0-194-generic] (local build)
>> Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org
>>
>> === START OF INFORMATION SECTION ===
>> Device Model:     ST2000NX0253
>> Serial Number:    W461SCHM
>> LU WWN Device Id: 5 000c50 0b426d2d0
>> Firmware Version: SN05
>> User Capacity:    2,000,398,934,016 bytes [2.00 TB]
>> Sector Sizes:     512 bytes logical, 4096 bytes physical
>> Rotation Rate:    7200 rpm
>> Form Factor:      2.5 inches
>> Device is:        Not in smartctl database [for details use: -P showall]
>> ATA Version is:   ACS-3 (minor revision not indicated)
>> SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)
>> Local Time is:    Thu Mar 11 15:07:30 2021 MST
>> SMART support is: Available - device has SMART capability.
>> SMART support is: Enabled
>>
>> === START OF READ SMART DATA SECTION ===
>> SMART overall-health self-assessment test result: PASSED
>>
>> SCT Error Recovery Control:
>>             Read:    100 (10.0 seconds)
>>            Write:    100 (10.0 seconds)
>>   
>>
>> sudo smartctl -H -i -l scterc /dev/sdb
>> smartctl 6.5 2016-01-24 r4214 [x86_64-linux-4.4.0-194-generic] (local build)
>> Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org
>>
>> === START OF INFORMATION SECTION ===
>> Device Model:     ST2000NX0253
>> Serial Number:    W462MZ0R
>> LU WWN Device Id: 5 000c50 0c569b51c
>> Firmware Version: SN05
>> User Capacity:    2,000,398,934,016 bytes [2.00 TB]
>> Sector Sizes:     512 bytes logical, 4096 bytes physical
>> Rotation Rate:    7200 rpm
>> Form Factor:      2.5 inches
>> Device is:        Not in smartctl database [for details use: -P showall]
>> ATA Version is:   ACS-3 (minor revision not indicated)
>> SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)
>> Local Time is:    Thu Mar 11 15:09:34 2021 MST
>> SMART support is: Available - device has SMART capability.
>> SMART support is: Enabled
>>
>> === START OF READ SMART DATA SECTION ===
>> SMART overall-health self-assessment test result: PASSED
>>
>> SCT Error Recovery Control:
>>             Read:    100 (10.0 seconds)
>>            Write:    100 (10.0 seconds)
>>   
>> sudo smartctl -H -i -l scterc /dev/sdc
>> smartctl 6.5 2016-01-24 r4214 [x86_64-linux-4.4.0-194-generic] (local build)
>> Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org
>>
>> === START OF INFORMATION SECTION ===
>> Device Model:     ST2000NX0253
>> Serial Number:    W461NLPM
>> LU WWN Device Id: 5 000c50 0b426f335
>> Firmware Version: SN05
>> User Capacity:    2,000,398,934,016 bytes [2.00 TB]
>> Sector Sizes:     512 bytes logical, 4096 bytes physical
>> Rotation Rate:    7200 rpm
>> Form Factor:      2.5 inches
>> Device is:        Not in smartctl database [for details use: -P showall]
>> ATA Version is:   ACS-3 (minor revision not indicated)
>> SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)
>> Local Time is:    Thu Mar 11 15:14:38 2021 MST
>> SMART support is: Available - device has SMART capability.
>> SMART support is: Enabled
>>
>> === START OF READ SMART DATA SECTION ===
>> SMART overall-health self-assessment test result: PASSED
>>
>> SCT Error Recovery Control:
>>             Read:    100 (10.0 seconds)
>>            Write:    100 (10.0 seconds)
>>
>> sudo smartctl -H -i -l scterc /dev/sdd
>> smartctl 6.5 2016-01-24 r4214 [x86_64-linux-4.4.0-194-generic] (local build)
>> Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org
>>
>> === START OF INFORMATION SECTION ===
>> Device Model:     ST2000NX0253
>> Serial Number:    W461NHAB
>> LU WWN Device Id: 5 000c50 0b426f8a4
>> Firmware Version: SN05
>> User Capacity:    2,000,398,934,016 bytes [2.00 TB]
>> Sector Sizes:     512 bytes logical, 4096 bytes physical
>> Rotation Rate:    7200 rpm
>> Form Factor:      2.5 inches
>> Device is:        Not in smartctl database [for details use: -P showall]
>> ATA Version is:   ACS-3 (minor revision not indicated)
>> SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)
>> Local Time is:    Thu Mar 11 15:16:24 2021 MST
>> SMART support is: Available - device has SMART capability.
>> SMART support is: Enabled
>>
>> === START OF READ SMART DATA SECTION ===
>> SMART overall-health self-assessment test result: PASSED
>>
>> SCT Error Recovery Control:
>>             Read:    100 (10.0 seconds)
>>            Write:    100 (10.0 seconds)
>>   
>> sudo mdadm --examine /dev/sda
>> /dev/sda:
>>            Magic : Intel Raid ISM Cfg Sig.
>>          Version : 1.3.00
>>      Orig Family : 154b243e
>>           Family : 154b243e
>>       Generation : 000003aa
>>    Creation Time : Unknown
>>       Attributes : All supported
>>             UUID : 72360627:bb745f4c:aedafaab:e25d3123
>>         Checksum : 21ae5a2a correct
>>      MPB Sectors : 2
>>            Disks : 4
>>     RAID Devices : 1
>>
>>    Disk00 Serial : W461SCHM
>>            State : active
>>               Id : 00000000
>>      Usable Size : 3907018766 (1863.01 GiB 2000.39 GB)
>>
>> [Data]:
>>         Subarray : 0
>>             UUID : 764aa814:831953a1:06cf2a07:1ca42b2e
>>       RAID Level : 5 <-- 5
>>          Members : 4 <-- 4
>>            Slots : [U_UU] <-- [U_UU]
>>      Failed disk : 1
>>        This Slot : 0
>>      Sector Size : 512
>>       Array Size : 11135008768 (5.19 TiB 5.70 TB)
>>     Per Dev Size : 3711671808 (1769.86 GiB 1900.38 GB)
>>    Sector Offset : 0
>>      Num Stripes : 28997420
>>       Chunk Size : 64 KiB <-- 64 KiB
>>         Reserved : 0
>>    Migrate State : repair
>>        Map State : degraded <-- degraded
>>       Checkpoint : 462393 (512)
>>      Dirty State : dirty
>>       RWH Policy : off
>>        Volume ID : 1
>>
>>    Disk01 Serial : W461S13X:0
>>            State : active
>>               Id : ffffffff
>>      Usable Size : 3907018766 (1863.01 GiB 2000.39 GB)
>>
>>    Disk02 Serial : W461NLPM
>>            State : active
>>               Id : 00000002
>>      Usable Size : 3907018766 (1863.01 GiB 2000.39 GB)
>>
>>    Disk03 Serial : W461NHAB
>>            State : active
>>               Id : 00000003
>>      Usable Size : 3907018766 (1863.01 GiB 2000.39 GB)
>>
>> sudo mdadm --examine /dev/sdb
>> /dev/sdb:
>>            Magic : Intel Raid ISM Cfg Sig.
>>          Version : 1.0.00
>>      Orig Family : 00000000
>>           Family : e5cd8601
>>       Generation : 00000001
>>    Creation Time : Unknown
>>       Attributes : All supported
>>             UUID : 00000000:00000000:00000000:00000000
>>         Checksum : cb9b0c02 correct
>>      MPB Sectors : 1
>>            Disks : 1
>>     RAID Devices : 0
>>
>>    Disk00 Serial : W462MZ0R
>>            State : spare
>>               Id : 04000000
>>      Usable Size : 3907026958 (1863.02 GiB 2000.40 GB)
>>
>>      Disk Serial : W462MZ0R
>>            State : spare
>>               Id : 04000000
>>      Usable Size : 3907026958 (1863.02 GiB 2000.40 GB)
>>
>> sudo mdadm --examine /dev/sdc
>> /dev/sdc:
>>            Magic : Intel Raid ISM Cfg Sig.
>>          Version : 1.3.00
>>      Orig Family : 154b243e
>>           Family : 154b243e
>>       Generation : 000003aa
>>    Creation Time : Unknown
>>       Attributes : All supported
>>             UUID : 72360627:bb745f4c:aedafaab:e25d3123
>>         Checksum : 21ae5a2a correct
>>      MPB Sectors : 2
>>            Disks : 4
>>     RAID Devices : 1
>>
>>    Disk02 Serial : W461NLPM
>>            State : active
>>               Id : 00000002
>>      Usable Size : 3907018766 (1863.01 GiB 2000.39 GB)
>>
>> [Data]:
>>         Subarray : 0
>>             UUID : 764aa814:831953a1:06cf2a07:1ca42b2e
>>       RAID Level : 5 <-- 5
>>          Members : 4 <-- 4
>>            Slots : [U_UU] <-- [U_UU]
>>      Failed disk : 1
>>        This Slot : 2
>>      Sector Size : 512
>>       Array Size : 11135008768 (5.19 TiB 5.70 TB)
>>     Per Dev Size : 3711671808 (1769.86 GiB 1900.38 GB)
>>    Sector Offset : 0
>>      Num Stripes : 28997420
>>       Chunk Size : 64 KiB <-- 64 KiB
>>         Reserved : 0
>>    Migrate State : repair
>>        Map State : degraded <-- degraded
>>       Checkpoint : 462393 (512)
>>      Dirty State : dirty
>>       RWH Policy : off
>>        Volume ID : 1
>>
>>    Disk00 Serial : W461SCHM
>>            State : active
>>               Id : 00000000
>>      Usable Size : 3907018766 (1863.01 GiB 2000.39 GB)
>>
>>    Disk01 Serial : W461S13X:0
>>            State : active
>>               Id : ffffffff
>>      Usable Size : 3907018766 (1863.01 GiB 2000.39 GB)
>>
>>    Disk03 Serial : W461NHAB
>>            State : active
>>               Id : 00000003
>>      Usable Size : 3907018766 (1863.01 GiB 2000.39 GB)
>>
>> sudo mdadm --examine /dev/sdd
>> /dev/sdd:
>>            Magic : Intel Raid ISM Cfg Sig.
>>          Version : 1.3.00
>>      Orig Family : 154b243e
>>           Family : 154b243e
>>       Generation : 000003aa
>>    Creation Time : Unknown
>>       Attributes : All supported
>>             UUID : 72360627:bb745f4c:aedafaab:e25d3123
>>         Checksum : 21ae5a2a correct
>>      MPB Sectors : 2
>>            Disks : 4
>>     RAID Devices : 1
>>
>>    Disk03 Serial : W461NHAB
>>            State : active
>>               Id : 00000003
>>      Usable Size : 3907018766 (1863.01 GiB 2000.39 GB)
>>
>> [Data]:
>>         Subarray : 0
>>             UUID : 764aa814:831953a1:06cf2a07:1ca42b2e
>>       RAID Level : 5 <-- 5
>>          Members : 4 <-- 4
>>            Slots : [U_UU] <-- [U_UU]
>>      Failed disk : 1
>>        This Slot : 3
>>      Sector Size : 512
>>       Array Size : 11135008768 (5.19 TiB 5.70 TB)
>>     Per Dev Size : 3711671808 (1769.86 GiB 1900.38 GB)
>>    Sector Offset : 0
>>      Num Stripes : 28997420
>>       Chunk Size : 64 KiB <-- 64 KiB
>>         Reserved : 0
>>    Migrate State : repair
>>        Map State : degraded <-- degraded
>>       Checkpoint : 462393 (512)
>>      Dirty State : dirty
>>       RWH Policy : off
>>        Volume ID : 1
>>
>>    Disk00 Serial : W461SCHM
>>            State : active
>>               Id : 00000000
>>      Usable Size : 3907018766 (1863.01 GiB 2000.39 GB)
>>
>>    Disk01 Serial : W461S13X:0
>>            State : active
>>               Id : ffffffff
>>      Usable Size : 3907018766 (1863.01 GiB 2000.39 GB)
>>
>>    Disk02 Serial : W461NLPM
>>            State : active
>>               Id : 00000002
>>      Usable Size : 3907018766 (1863.01 GiB 2000.39 GB)
>> sudo mdadm --detail /dev/md125
>> /dev/md125:
>>             Version : imsm
>>          Raid Level : container
>>       Total Devices : 1
>>
>>     Working Devices : 1
>>
>>       Member Arrays :
>>
>>      Number   Major   Minor   RaidDevice
>>
>>         -       8       16        -        /dev/sdb
>>
>> sudo mdadm --detail /dev/md126
>> /dev/md126:
>>           Container : /dev/md/imsm0, member 0
>>          Raid Level : raid5
>>       Used Dev Size : 1855835904 (1769.86 GiB 1900.38 GB)
>>        Raid Devices : 4
>>       Total Devices : 3
>>
>>               State : active, FAILED, Not Started
>>      Active Devices : 3
>>     Working Devices : 3
>>      Failed Devices : 0
>>       Spare Devices : 0
>>
>>              Layout : left-asymmetric
>>          Chunk Size : 64K
>>
>> Consistency Policy : unknown
>>
>>
>>                UUID : 764aa814:831953a1:06cf2a07:1ca42b2e
>>      Number   Major   Minor   RaidDevice State
>>         -       0        0        0      removed
>>         -       0        0        1      removed
>>         -       0        0        2      removed
>>         -       0        0        3      removed
>>
>>         -       8        0        0      sync   /dev/sda
>>         -       8       32        2      sync   /dev/sdc
>>         -       8       48        3      sync   /dev/sdd
>>
>> sudo mdadm --detail /dev/md127
>> /dev/md127:
>>             Version : imsm
>>          Raid Level : container
>>       Total Devices : 3
>>
>>     Working Devices : 3
>>
>>
>>                UUID : 72360627:bb745f4c:aedafaab:e25d3123
>>       Member Arrays : /dev/md126
>>
>>      Number   Major   Minor   RaidDevice
>>
>>         -       8        0        -        /dev/sda
>>         -       8       32        -        /dev/sdc
>>         -       8       48        -        /dev/sdd
>>   
>> lsdrv
>> **Warning** The following utility(ies) failed to execute:
>>    sginfo
>> Some information may be missing.
>>
>> PCI [nvme] 04:00.0 Non-Volatile memory controller: Samsung Electronics Co Ltd NVMe SSD Controller SM981/PM981
>> „nvme nvme0 Samsung SSD 970 EVO Plus 500GB           {S4P2NF0M501223D}
>>   „nvme0n1 465.76g [259:0] Empty/Unknown
>>    †nvme0n1p1 512.00m [259:1] Empty/Unknown
>>    „Mounted as /dev/nvme0n1p1 @ /boot/efi
>>    †nvme0n1p2 732.00m [259:2] Empty/Unknown
>>    „Mounted as /dev/nvme0n1p2 @ /boot
>>    „nvme0n1p3 464.54g [259:3] Empty/Unknown
>>     †dm-0 463.59g [252:0] Empty/Unknown
>>     „Mounted as /dev/mapper/customer--pr3d--app--vg-root @ /
>>     „dm-1 980.00m [252:1] Empty/Unknown
>> PCI [ahci] 00:11.5 SATA controller: Intel Corporation C620 Series Chipset Family SSATA Controller [AHCI mode] (rev 09)
>> „scsi 0:x:x:x [Empty]
>> PCI [ahci] 00:17.0 RAID bus controller: Intel Corporation C600/X79 series chipset SATA RAID Controller (rev 09)
>> †scsi 2:0:0:0 ATA      ST2000NX0253
>> „sda 1.82t [8:0] Empty/Unknown
>>  †md126 0.00k [9:126] MD vexternal:/md127/0 raid5 (4) inactive, 64k Chunk, None (None) None {None}
>>                      Empty/Unknown
>>  „md127 0.00k [9:127] MD vexternal:imsm  () inactive, None (None) None {None}
>>                       Empty/Unknown
>> †scsi 3:0:0:0 ATA      ST2000NX0253
>> „sdb 1.82t [8:16] Empty/Unknown
>>  „md125 0.00k [9:125] MD vexternal:imsm  () inactive, None (None) None {None}
>>                       Empty/Unknown
>> †scsi 4:0:0:0 ATA      ST2000NX0253
>> „sdc 1.82t [8:32] Empty/Unknown
>>  †md126 0.00k [9:126] MD vexternal:/md127/0 raid5 (4) inactive, 64k Chunk, None (None) None {None}
>>                      Empty/Unknown
>> †scsi 5:0:0:0 ATA      ST2000NX0253
>> „sdd 1.82t [8:48] Empty/Unknown
>>  †md126 0.00k [9:126] MD vexternal:/md127/0 raid5 (4) inactive, 64k Chunk, None (None) None {None}
>>                      Empty/Unknown
>> „scsi 6:0:0:0 Slimtype DVD A  DS8ACSH
>>   „sr0 1.00g [11:0] Empty/Unknown
>> Other Block Devices
>> †loop0 0.00k [7:0] Empty/Unknown
>> †loop1 0.00k [7:1] Empty/Unknown
>> †loop2 0.00k [7:2] Empty/Unknown
>> †loop3 0.00k [7:3] Empty/Unknown
>> †loop4 0.00k [7:4] Empty/Unknown
>> †loop5 0.00k [7:5] Empty/Unknown
>> †loop6 0.00k [7:6] Empty/Unknown
>> „loop7 0.00k [7:7] Empty/Unknown
>>
>> cat /proc/mdstat
>> Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0] [raid1] [raid10]
>> md125 : inactive sdb[0](S)
>>        1105 blocks super external:imsm
>>
>> md126 : inactive sda[2] sdc[1] sdd[0]
>>        5567507712 blocks super external:/md127/0
>>
>> md127 : inactive sdc[2](S) sdd[1](S) sda[0](S)
>>        9459 blocks super external:imsm
>>
>> unused devices: <none>
>>
>>
>> Thanks for the help!
>> Devon Beets
> 
> Hi Devon,
> 
> The array is in dirty degraded state. It does not start automatically because
> there is a risk of silent data corruption, i.e. RAID write hole. You can force
> it to start with:
> 
> # mdadm -R --force /dev/md126
> 
> You will need mdadm built with this commit for it to work:
> 
> https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/commit/?id=7b99edab2834d5d08ef774b4cff784caaa1a186f
> 
> It may be a good idea to copy the array contents with dd before you fsck or
> mount the filesystem in case the recovery goes wrong.
> 
> Then stop the second container and add the new drive to the array:
> 
> # mdadm -S /dev/md125
> # mdadm -a /dev/md127 /dev/sdb
> 
> Rebuild should begin at this point.
> 
> Regards,
> Artur
> 
>

Hello,
also see:
https://lore.kernel.org/linux-raid/ac370d79-95e8-d0a1-0991-
fb12b128818c@linux.intel.com/T/#t

Mariusz
