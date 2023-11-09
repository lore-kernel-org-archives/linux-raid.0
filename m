Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA886C4332F
	for <linux-raid@archiver.kernel.org>; Thu,  9 Nov 2023 02:59:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbjKIC7Z (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 8 Nov 2023 21:59:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjKIC7Y (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 8 Nov 2023 21:59:24 -0500
Received: from lists.tip.net.au (pasta.tip.net.au [203.10.76.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A3B72590
        for <linux-raid@vger.kernel.org>; Wed,  8 Nov 2023 18:59:21 -0800 (PST)
Received: from lists.tip.net.au (pasta.tip.net.au [203.10.76.2])
        by mailhost.tip.net.au (Postfix) with ESMTP id 4SQmrP0nz9z8shf
        for <linux-raid@vger.kernel.org>; Thu,  9 Nov 2023 13:59:17 +1100 (AEDT)
Received: from [IPV6:2405:6e00:4ed:cdf7:21b:21ff:fe3a:5672] (unknown [IPv6:2405:6e00:4ed:cdf7:21b:21ff:fe3a:5672])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mailhost.tip.net.au (Postfix) with ESMTPSA id 4SQmrN2CxCz9R8b
        for <linux-raid@vger.kernel.org>; Thu,  9 Nov 2023 13:59:16 +1100 (AEDT)
Message-ID: <e25d99ef-89e2-4cba-92ae-4bbe1506a1e4@eyal.emu.id.au>
Date:   Thu, 9 Nov 2023 13:59:04 +1100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: extremely slow writes to array [now not degraded]
To:     linux-raid@vger.kernel.org
References: <eb9a7323-f955-4b1c-b1c4-7f0723078c42@eyal.emu.id.au>
Content-Language: en-US
From:   eyal@eyal.emu.id.au
In-Reply-To: <eb9a7323-f955-4b1c-b1c4-7f0723078c42@eyal.emu.id.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Now the missing disk was added and recovered so we have a fully redundant raid6. System was restarted now.

I copied the same tree as before and the system has so far spent 2 hour slowly writing the dirty blocks.

Can I have someone (an expert) suggest why w_await is so high (seconds)?

13:56:08 Device            r/s     rkB/s   rrqm/s  %rrqm r_await rareq-sz     w/s     wkB/s   wrqm/s  %wrqm w_await wareq-sz     d/s     dkB/s   drqm/s  %drqm d_await dareq-sz     f/s f_await  aqu-sz  %util
13:56:08 md127            0.00      0.00     0.00   0.00    0.00     0.00    2.40     17.60     0.00   0.00 1473.96     7.33    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00    3.54   3.97
13:56:08 sdb              0.00      0.00     0.00   0.00    0.00     0.00    1.40     15.80     3.10  68.89    2.00    11.29    0.00      0.00     0.00   0.00    0.00     0.00    1.20    1.92    0.01   0.39
13:56:08 sdc              0.00      0.00     0.00   0.00    0.00     0.00    1.40     15.80     3.10  68.89    2.57    11.29    0.00      0.00     0.00   0.00    0.00     0.00    1.20    2.50    0.01   0.47
13:56:08 sdd              0.00      0.00     0.00   0.00    0.00     0.00    1.20      2.60     0.00   0.00    2.75     2.17    0.00      0.00     0.00   0.00    0.00     0.00    1.20    2.42    0.01   0.43
13:56:08 sde              0.20      2.00     0.30  60.00    0.50    10.00    1.60      7.00     0.70  30.43   14.38     4.38    0.00      0.00     0.00   0.00    0.00     0.00    1.20    2.83    0.03   2.22
13:56:08 sdf              0.20      2.00     0.30  60.00    0.00    10.00    1.60      7.00     0.70  30.43   14.06     4.38    0.00      0.00     0.00   0.00    0.00     0.00    1.20    3.08    0.03   2.19
13:56:08 sdg              0.40     15.20     3.40  89.47    4.50    38.00    1.60     17.80     3.40  68.00   15.94    11.12    0.00      0.00     0.00   0.00    0.00     0.00    1.20    3.17    0.03   2.19
13:56:08 sdh              0.20      2.40     0.40  66.67    0.00    12.00    1.40      5.00     0.40  22.22   14.07     3.57    0.00      0.00     0.00   0.00    0.00     0.00    1.20    1.67    0.02   1.94
13:56:18 md127            0.00      0.00     0.00   0.00    0.00     0.00    0.60      2.40     0.00   0.00   19.67     4.00    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00    0.01  10.29
13:56:18 sdb              0.00      0.00     0.00   0.00    0.00     0.00    0.20      0.40     0.00   0.00    0.00     2.00    0.00      0.00     0.00   0.00    0.00     0.00    0.20    0.00    0.00   0.03
13:56:18 sdc              0.00      0.00     0.00   0.00    0.00     0.00    0.20      0.40     0.00   0.00    0.50     2.00    0.00      0.00     0.00   0.00    0.00     0.00    0.20    0.50    0.00   0.03
13:56:18 sdd              0.00      0.00     0.00   0.00    0.00     0.00    0.20      0.40     0.00   0.00    0.50     2.00    0.00      0.00     0.00   0.00    0.00     0.00    0.20    0.50    0.00   0.03
13:56:18 sde              0.00      0.00     0.00   0.00    0.00     0.00    0.40      2.80     0.40  50.00    9.25     7.00    0.00      0.00     0.00   0.00    0.00     0.00    0.20    9.00    0.01   0.39
13:56:18 sdf              0.00      0.00     0.00   0.00    0.00     0.00    0.40      2.80     0.40  50.00   13.00     7.00    0.00      0.00     0.00   0.00    0.00     0.00    0.20    9.50    0.01   0.54
13:56:18 sdg              0.00      0.00     0.00   0.00    0.00     0.00    0.20      0.40     0.00   0.00    9.00     2.00    0.00      0.00     0.00   0.00    0.00     0.00    0.20    0.50    0.00   0.20
13:56:18 sdh              0.20      2.40     0.40  66.67   11.50    12.00    0.40      2.80     0.40  50.00    9.25     7.00    0.00      0.00     0.00   0.00    0.00     0.00    0.20    4.50    0.01   0.62
13:56:28 md127            0.00      0.00     0.00   0.00    0.00     0.00    2.90     22.40     0.00   0.00 2791.14     7.72    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00    8.09  12.99
13:56:28 sdb              0.00      0.00     0.00   0.00    0.00     0.00    1.50     20.20     4.10  73.21    4.20    13.47    0.00      0.00     0.00   0.00    0.00     0.00    1.10    5.27    0.01   0.71
13:56:28 sdc              0.00      0.00     0.00   0.00    0.00     0.00    1.50     20.20     4.10  73.21    5.00    13.47    0.00      0.00     0.00   0.00    0.00     0.00    1.10    6.00    0.01   0.64
13:56:28 sdd              0.00      0.00     0.00   0.00    0.00     0.00    1.10      2.20     0.00   0.00    0.73     2.00    0.00      0.00     0.00   0.00    0.00     0.00    1.10    0.55    0.00   0.18
13:56:28 sde              0.00      0.00     0.00   0.00    0.00     0.00    1.50      6.60     0.70  31.82   16.20     4.40    0.00      0.00     0.00   0.00    0.00     0.00    1.10    2.55    0.03   2.56
13:56:28 sdf              0.00      0.00     0.00   0.00    0.00     0.00    1.50      6.60     0.70  31.82   14.00     4.40    0.00      0.00     0.00   0.00    0.00     0.00    1.10    5.09    0.03   2.19
13:56:28 sdg              0.10      0.40     0.00   0.00    0.00     4.00    1.20      2.60     0.00   0.00   15.50     2.17    0.00      0.00     0.00   0.00    0.00     0.00    1.10    2.27    0.02   1.95
13:56:28 sdh              0.70     22.00     4.80  87.27    2.43    31.43    1.80     24.20     4.80  72.73   12.28    13.44    0.00      0.00     0.00   0.00    0.00     0.00    1.10    5.36    0.03   2.19

TIA

On 06/11/2023 10.06, eyal@eyal.emu.id.au wrote:
> 
> This is a more organized summary of a number of recent threads I posted about this problem.
> The last one is titled "problem with recovered array".
> 
> 
> The environment
> ===============
> 
> Fedora 28
> 
> $ uname -a
> Linux e7.eyal.emu.id.au 6.5.8-200.fc38.x86_64 #1 SMP PREEMPT_DYNAMIC Fri Oct 20 15:53:48 UTC 2023 x86_64 GNU/Linux
> 
> 7 disks raid6 array(*1). boot, root and swap on a separate SSD.
> 
> $ cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md127 : active raid6 sde1[4] sdc1[9] sdf1[5] sdb1[8] sdd1[7] sdg1[6]
>        58593761280 blocks super 1.2 level 6, 512k chunk, algorithm 2 [7/6] [_UUUUUU]
>        bitmap: 88/88 pages [352KB], 65536KB chunk
> 
> One disk was removed recently and sent for replacement. The system felt OK but a few days later I noticed an issue...
> 
> The problem
> ===========
> 
> I wanted to copy data from a SATA drive (/data2) into the array (/data1):
> 
> I started copying the full dataset (260GB 8,911k files). rsync soon stopped with 100%CPU. It was killed.
> 4GB (system limit) dirty blocks were created, which took 12h to clear.
> 
> I later used a smaller, partial dataset.
> 
> $ sudo find /data2/no-backup/old-backups/tapes/01/file.14.data | wc -l
> 5380
> 
> $ sudo du -sm /data2/no-backup/old-backups/tapes/01/file.14.data
> 93      /data2/no-backup/old-backups/tapes/01/file.14.data
> 
> $ sudo rsync -aHSK --stats --progress --checksum-choice=none --no-compress -W /data2/no-backup/old-backups/tapes/01/file.14.data /data1/no-backup/old-backups/
>      In this small test rsync completed quickly.
> 
> The copy completed fast but the kthread took about 1.5 hours at 100%CPU  to clear the dirty blocks.
> - When copying more files (3-5GB) the rsync was consuming 100%CPU and started pausing every few files (then killed).
> - The same copy to a plain (non array) disk completes quickly, no issues.
> - A 'dd if=/dev/zero of=/data1/no-backup/old-backups/100GB' completed quickly, no issues.
> - during a test a mythtv recording was going which DID NOT add to the dirty blocks but wrote to disk quickly.
> 
> I observed a kthread flush thread running at 100%CPU
> 
>      PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
>   944760 root      20   0       0      0      0 R 100.0   0.0 164:00.85 kworker/u16:3+flush-9:127
> 
> rsync was killed but the kthread remained. Copying less data had rsync complete but the kthread still stayed up for over an hour.
> 
> The system became sluggish, even typing into vi had pauses.
> See also (*7) for a side issue.
> 
> While the dirty blocks are slowly clearing, at some point it resolves in a burst.
> Another test started with 1.6GB dirty blocks and resolved 12h later at 116MB.
> In a controlled (short) test it started with 260MB and resolved 80m later at 40MB.
> Then another (short) test started with 2.4GB and resolved in 90m at around 1GB.
> 
> I cannot see the pattern but clearly the array CAN sustain a high rate of writing, and maybe it is not the array
> that is holding back the flush kthread?
> 
> I ran iostat which showed very few writes to the array(*2).
> 
> I also ran iostat on the member devices (*3), same low rate.
> 
> You can see how the %util of the array is often high (13.86) while the members are in the low single digits. One example:
> 
>           Device            r/s     rkB/s   rrqm/s  %rrqm r_await rareq-sz     w/s     wkB/s   wrqm/s  %wrqm w_await wareq-sz     d/s     dkB/s   drqm/s  %drqm d_await dareq-sz     f/s f_await  aqu-sz  %util
> 15:35:52 md127            0.80      3.20     0.00   0.00   13.75     4.00   43.60   1419.60     0.00   0.00   99.34    32.56    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00    4.34  13.86
> 15:35:52 sdb              0.60     85.20    20.70  97.18   14.33   142.00    2.70    470.15   115.20  97.71    2.07   174.13    0.00      0.00     0.00   0.00    0.00     0.00    0.80    4.25    0.02   1.25
> 15:35:52 sdc              1.20     97.20    23.10  95.06   10.50    81.00    2.20    371.75    91.10  97.64    2.59   168.98    0.00      0.00     0.00   0.00    0.00     0.00    0.80    2.12    0.02   1.13
> 15:35:52 sdd              2.10    305.60    74.30  97.25   14.62   145.52    1.70    234.95    57.40  97.12    7.71   138.21    0.00      0.00     0.00   0.00    0.00     0.00    0.80    1.12    0.04   2.43
> 15:35:52 sde              1.50    288.40    70.60  97.92   17.47   192.27    1.90    278.95    68.20  97.29    9.74   146.82    0.00      0.00     0.00   0.00    0.00     0.00    0.80    0.38    0.05   2.60
> 15:35:52 sdf              1.30    334.00    82.20  98.44   26.31   256.92    2.30    351.35    85.90  97.39    7.74   152.76    0.00      0.00     0.00   0.00    0.00     0.00    0.80    2.00    0.05   2.34
> 15:35:52 sdg              0.80    215.20    53.00  98.51   18.38   269.00    2.90    510.55   125.10  97.73    7.03   176.05    0.00      0.00     0.00   0.00    0.00     0.00    0.80    3.75    0.04   2.53
> 
> Advice from the list suggested I follow some meminfo numbers (Dirty, Buffers, MemFree)(*4).
> 
> I was also asked to run 'perf top' (*5).
> 
> Also a few sysrq 'w' and 'l' were used to try to see if anything is visible(6).
> I ran sysrq 't' (twice) and kept the huge log.
> 
> [BTW, I have the full logs saved in case they are needed].
> 
> If necessary, I can trigger the problem easily, if more data is required.
> 
> The opinion I received suggests that there may be a kernel problem. another poster has the same issue.
> 
> TIA
> 
> (*1)
> $ sudo mdadm -D /dev/md127
> /dev/md127:
>             Version : 1.2
>       Creation Time : Fri Oct 26 17:24:59 2018
>          Raid Level : raid6
>          Array Size : 58593761280 (54.57 TiB 60.00 TB)
>       Used Dev Size : 11718752256 (10.91 TiB 12.00 TB)
>        Raid Devices : 7
>       Total Devices : 6
>         Persistence : Superblock is persistent
> 
>       Intent Bitmap : Internal
> 
>         Update Time : Sun Nov  5 18:15:07 2023
>               State : clean, degraded
>      Active Devices : 6
>     Working Devices : 6
>      Failed Devices : 0
>       Spare Devices : 0
> 
>              Layout : left-symmetric
>          Chunk Size : 512K
> 
> Consistency Policy : bitmap
> 
>                Name : e4.eyal.emu.id.au:127
>                UUID : 15d250cf:fe43eafb:5779f3d8:7e79affc
>              Events : 5017887
> 
>      Number   Major   Minor   RaidDevice State
>         -       0        0        0      removed
>         8       8       17        1      active sync   /dev/sdb1
>         9       8       33        2      active sync   /dev/sdc1
>         7       8       49        3      active sync   /dev/sdd1
>         4       8       65        4      active sync   /dev/sde1
>         5       8       81        5      active sync   /dev/sdf1
>         6       8       97        6      active sync   /dev/sdg1
> 
> $ sudo mdadm -E /dev/sd{b,c,d,e,f,g}1
> 
> /dev/sdb1:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x1
>       Array UUID : 15d250cf:fe43eafb:5779f3d8:7e79affc
>             Name : e4.eyal.emu.id.au:127
>    Creation Time : Fri Oct 26 17:24:59 2018
>       Raid Level : raid6
>     Raid Devices : 7
> 
>   Avail Dev Size : 23437504512 sectors (10.91 TiB 12.00 TB)
>       Array Size : 58593761280 KiB (54.57 TiB 60.00 TB)
>      Data Offset : 262144 sectors
>     Super Offset : 8 sectors
>     Unused Space : before=262064 sectors, after=0 sectors
>            State : clean
>      Device UUID : 4bfcc6d6:165b6a78:b8fad560:51ff21de
> 
> Internal Bitmap : 8 sectors from superblock
>      Update Time : Sun Nov  5 05:09:23 2023
>    Bad Block Log : 512 entries available at offset 56 sectors
>         Checksum : d915eee6 - correct
>           Events : 5014067
> 
>           Layout : left-symmetric
>       Chunk Size : 512K
> 
>     Device Role : Active device 1
>     Array State : .AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
> 
> /dev/sdc1:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x1
>       Array UUID : 15d250cf:fe43eafb:5779f3d8:7e79affc
>             Name : e4.eyal.emu.id.au:127
>    Creation Time : Fri Oct 26 17:24:59 2018
>       Raid Level : raid6
>     Raid Devices : 7
> 
>   Avail Dev Size : 23437504512 sectors (10.91 TiB 12.00 TB)
>       Array Size : 58593761280 KiB (54.57 TiB 60.00 TB)
>      Data Offset : 262144 sectors
>     Super Offset : 8 sectors
>     Unused Space : before=262064 sectors, after=0 sectors
>            State : clean
>      Device UUID : 7fb0b851:c3d0463b:6460ff66:170088b9
> 
> Internal Bitmap : 8 sectors from superblock
>      Update Time : Sun Nov  5 05:09:23 2023
>    Bad Block Log : 512 entries available at offset 56 sectors
>         Checksum : f8737f39 - correct
>           Events : 5014067
> 
>           Layout : left-symmetric
>       Chunk Size : 512K
> 
>     Device Role : Active device 2
>     Array State : .AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
> 
> /dev/sdd1:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x1
>       Array UUID : 15d250cf:fe43eafb:5779f3d8:7e79affc
>             Name : e4.eyal.emu.id.au:127
>    Creation Time : Fri Oct 26 17:24:59 2018
>       Raid Level : raid6
>     Raid Devices : 7
> 
>   Avail Dev Size : 23437504512 sectors (10.91 TiB 12.00 TB)
>       Array Size : 58593761280 KiB (54.57 TiB 60.00 TB)
>      Data Offset : 262144 sectors
>     Super Offset : 8 sectors
>     Unused Space : before=262064 sectors, after=0 sectors
>            State : clean
>      Device UUID : ce5bd1bc:3e5c3054:658888dd:9038e09f
> 
> Internal Bitmap : 8 sectors from superblock
>      Update Time : Sun Nov  5 05:09:23 2023
>    Bad Block Log : 512 entries available at offset 56 sectors
>         Checksum : d957167c - correct
>           Events : 5014067
> 
>           Layout : left-symmetric
>       Chunk Size : 512K
> 
>     Device Role : Active device 3
>     Array State : .AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
> /dev/sde1:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x1
>       Array UUID : 15d250cf:fe43eafb:5779f3d8:7e79affc
>             Name : e4.eyal.emu.id.au:127
>    Creation Time : Fri Oct 26 17:24:59 2018
>       Raid Level : raid6
>     Raid Devices : 7
> 
>   Avail Dev Size : 23437504512 sectors (10.91 TiB 12.00 TB)
>       Array Size : 58593761280 KiB (54.57 TiB 60.00 TB)
>      Data Offset : 262144 sectors
>     Super Offset : 8 sectors
>     Unused Space : before=262064 sectors, after=0 sectors
>            State : clean
>      Device UUID : 4706a5ab:e7cea085:9af96e3a:81ac89b1
> 
> Internal Bitmap : 8 sectors from superblock
>      Update Time : Sun Nov  5 05:09:23 2023
>    Bad Block Log : 512 entries available at offset 56 sectors
>         Checksum : 682b18c1 - correct
>           Events : 5014067
> 
>           Layout : left-symmetric
>       Chunk Size : 512K
> 
>     Device Role : Active device 4
>     Array State : .AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
> 
> /dev/sdf1:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x1
>       Array UUID : 15d250cf:fe43eafb:5779f3d8:7e79affc
>             Name : e4.eyal.emu.id.au:127
>    Creation Time : Fri Oct 26 17:24:59 2018
>       Raid Level : raid6
>     Raid Devices : 7
> 
>   Avail Dev Size : 23437504512 sectors (10.91 TiB 12.00 TB)
>       Array Size : 58593761280 KiB (54.57 TiB 60.00 TB)
>      Data Offset : 262144 sectors
>     Super Offset : 8 sectors
>     Unused Space : before=262064 sectors, after=0 sectors
>            State : clean
>      Device UUID : b1732c74:a34e121d:8347018e:c42b5085
> 
> Internal Bitmap : 8 sectors from superblock
>      Update Time : Sun Nov  5 05:09:23 2023
>    Bad Block Log : 512 entries available at offset 56 sectors
>         Checksum : ef7cd313 - correct
>           Events : 5014067
> 
>           Layout : left-symmetric
>       Chunk Size : 512K
> 
>     Device Role : Active device 5
>     Array State : .AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
> 
> /dev/sdg1:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x1
>       Array UUID : 15d250cf:fe43eafb:5779f3d8:7e79affc
>             Name : e4.eyal.emu.id.au:127
>    Creation Time : Fri Oct 26 17:24:59 2018
>       Raid Level : raid6
>     Raid Devices : 7
> 
>   Avail Dev Size : 23437504512 sectors (10.91 TiB 12.00 TB)
>       Array Size : 58593761280 KiB (54.57 TiB 60.00 TB)
>      Data Offset : 262144 sectors
>     Super Offset : 8 sectors
>     Unused Space : before=262064 sectors, after=0 sectors
>            State : clean
>      Device UUID : b44b1807:ed20c6f9:ec0436d7:744d144a
> 
> Internal Bitmap : 8 sectors from superblock
>      Update Time : Sun Nov  5 05:09:23 2023
>    Bad Block Log : 512 entries available at offset 56 sectors
>         Checksum : 6d155c7b - correct
>           Events : 5014067
> 
>           Layout : left-symmetric
>       Chunk Size : 512K
> 
>     Device Role : Active device 6
>     Array State : .AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
> 
> (*2)
> # iostat
> 15:35:10 Device             tps    kB_read/s    kB_wrtn/s    kB_dscd/s    kB_read    kB_wrtn    kB_dscd
> 15:35:10 md127             0.40         0.00         1.60         0.00          0         16          0
> 15:35:20 md127            80.90        23.20       300.40         0.00        232       3004          0
> 15:35:30 md127             2.60         0.00        13.60         0.00          0        136          0
> 15:35:40 md127             1.20         0.00         5.20         0.00          0         52          0
> 15:35:50 md127            46.00         3.60      1455.60         0.00         36      14556          0
> 15:36:00 md127             7.50         0.00        43.20         0.00          0        432          0
> 15:36:10 md127             1.40         0.00        16.00         0.00          0        160          0
> 15:36:20 md127             2.70         0.00        16.00         0.00          0        160          0
> 15:36:30 md127             3.20         0.40        37.20         0.00          4        372          0
> 15:36:40 md127             1.30         0.00        11.60         0.00          0        116          0
> 15:36:50 md127             3.10         0.40        36.40         0.00          4        364          0
> 15:37:00 md127             3.00         0.00        98.80         0.00          0        988          0
> 15:37:10 md127             2.50         0.00        10.80         0.00          0        108          0
> 15:37:20 md127             1.30         0.00         8.40         0.00          0         84          0
> 15:37:30 md127             2.60         0.00        16.00         0.00          0        160          0
> 15:37:40 md127             9.30         0.40        62.80         0.00          4        628          0
> 15:37:50 md127             8.40         0.00        33.60         0.00          0        336          0
> 15:38:00 md127             8.80         0.00        42.80         0.00          0        428          0
> 15:38:00 2023-11-05
> 15:38:00 Device             tps    kB_read/s    kB_wrtn/s    kB_dscd/s    kB_read    kB_wrtn    kB_dscd
> 15:38:00 md127             5.65        76.85       953.30         0.00   30896031  383252160          0
> 15:38:10 md127             5.30         0.00        24.40         0.00          0        244          0
> 15:38:20 md127             1.30         0.00        12.40         0.00          0        124          0
> 15:38:30 md127             2.60         0.00        11.20         0.00          0        112          0
> 15:38:40 md127             2.60         0.00        16.40         0.00          0        164          0
> 15:38:50 md127             3.30         0.40        34.80         0.00          4        348          0
> 15:39:00 md127             1.30         0.00        11.60         0.00          0        116          0
> 15:39:10 md127             2.50         0.00        10.00         0.00          0        100          0
> 15:39:20 md127             2.30         0.00        17.60         0.00          0        176          0
> 15:39:30 md127             2.70         0.00        20.40         0.00          0        204          0
> 15:39:40 md127             4.90         1.20       132.80         0.00         12       1328          0
> 15:39:50 md127             2.70         0.00        11.20         0.00          0        112          0
> 15:40:00 md127             1.30         0.00        12.80         0.00          0        128          0
> 15:40:10 md127             2.60         0.00        16.00         0.00          0        160          0
> 15:40:20 md127             4.30         0.00        64.80         0.00          0        648          0
> 15:40:30 md127             3.50         0.00        28.80         0.00          0        288          0
> 15:40:40 md127             2.80         0.00        13.20         0.00          0        132          0
> 15:40:50 md127             5.00         0.00        23.60         0.00          0        236          0
> 15:41:00 md127             3.60         0.00        17.20         0.00          0        172          0
> 15:41:10 md127             2.20         1.60        87.20         0.00         16        872          0
> 15:41:20 md127             6.00         1.60       361.20         0.00         16       3612          0
> 
> (*3)
> # iostat -x
>           Device            r/s     rkB/s   rrqm/s  %rrqm r_await rareq-sz     w/s     wkB/s   wrqm/s  %wrqm w_await wareq-sz     d/s     dkB/s   drqm/s  %drqm d_await dareq-sz     f/s f_await  aqu-sz  %util
> 15:35:02 md127            0.00      0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00    0.00   0.00
> 15:35:02 sdb              0.00      0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00    0.00   0.00
> 15:35:02 sdc              0.00      0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00    0.00   0.00
> 15:35:02 sdd              0.00      0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00    0.00   0.00
> 15:35:02 sde              0.00      0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00    0.00   0.00
> 15:35:02 sdf              0.00      0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00    0.00   0.00
> 15:35:02 sdg              0.00      0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00    0.00   0.00
> 15:35:12 md127            5.80     23.20     0.00   0.00    1.60     4.00    0.40      1.60     0.00   0.00   13.25     4.00    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00    0.01   1.83
> 15:35:12 sdb              1.60      6.40     0.00   0.00    0.12     4.00    0.70      2.10     0.10  12.50    5.14     3.00    0.00      0.00     0.00   0.00    0.00     0.00    0.50    6.80    0.01   0.58
> 15:35:12 sdc              1.70      6.80     0.00   0.00    1.76     4.00    0.70      2.10     0.10  12.50    3.71     3.00    0.00      0.00     0.00   0.00    0.00     0.00    0.50    4.80    0.01   0.76
> 15:35:12 sdd              1.70      6.80     0.00   0.00    1.18     4.00    0.60      1.30     0.00   0.00   12.33     2.17    0.00      0.00     0.00   0.00    0.00     0.00    0.50    0.40    0.01   1.16
> 15:35:12 sde              0.20      0.80     0.00   0.00   10.50     4.00    0.50      0.90     0.00   0.00   14.60     1.80    0.00      0.00     0.00   0.00    0.00     0.00    0.50    0.40    0.01   0.96
> 15:35:12 sdf              0.00      0.00     0.00   0.00    0.00     0.00    0.60      1.30     0.00   0.00   15.67     2.17    0.00      0.00     0.00   0.00    0.00     0.00    0.50    4.40    0.01   0.97
> 15:35:12 sdg              0.80      3.60     0.10  11.11    4.50     4.50    0.80      2.50     0.10  11.11   13.12     3.12    0.00      0.00     0.00   0.00    0.00     0.00    0.50    3.80    0.02   1.51
> 15:35:22 md127            0.00      0.00     0.00   0.00    0.00     0.00   75.10    300.40     0.00   0.00   15.81     4.00    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00    1.19   6.22
> 15:35:22 sdb              0.00      0.00     0.00   0.00    0.00     0.00    1.20    104.15    25.20  95.45    4.00    86.79    0.00      0.00     0.00   0.00    0.00     0.00    0.70    5.57    0.01   0.52
> 15:35:22 sdc              0.00      0.00     0.00   0.00    0.00     0.00    1.10    103.75    25.20  95.82    5.73    94.32    0.00      0.00     0.00   0.00    0.00     0.00    0.70    7.71    0.01   0.65
> 15:35:22 sdd              0.00      0.00     0.00   0.00    0.00     0.00    1.00     53.75    12.80  92.75   13.80    53.75    0.00      0.00     0.00   0.00    0.00     0.00    0.70    4.29    0.02   1.45
> 15:35:22 sde              0.00      0.00     0.00   0.00    0.00     0.00    1.00     52.95    12.60  92.65    9.80    52.95    0.00      0.00     0.00   0.00    0.00     0.00    0.70    2.43    0.01   1.07
> 15:35:22 sdf              0.00      0.00     0.00   0.00    0.00     0.00    1.00     52.95    12.60  92.65   13.20    52.95    0.00      0.00     0.00   0.00    0.00     0.00    0.70    3.00    0.02   1.37
> 15:35:22 sdg              0.10     23.60     5.80  98.31   15.00   236.00    1.10     45.35    10.60  90.60   13.73    41.23    0.00      0.00     0.00   0.00    0.00     0.00    0.70    3.29    0.02   1.75
> 15:35:32 md127            0.00      0.00     0.00   0.00    0.00     0.00    2.60     13.60     0.00   0.00 1410.23     5.23    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00    3.67   8.41
> 15:35:32 sdb              0.00      0.00     0.00   0.00    0.00     0.00    1.40      6.60     0.80  36.36    4.43     4.71    0.00      0.00     0.00   0.00    0.00     0.00    1.00    5.70    0.01   0.73
> 15:35:32 sdc              0.00      0.00     0.00   0.00    0.00     0.00    1.00      1.80     0.00   0.00    2.80     1.80    0.00      0.00     0.00   0.00    0.00     0.00    1.00    2.60    0.01   0.38
> 15:35:32 sdd              0.00      0.00     0.00   0.00    0.00     0.00    1.20      9.80     1.80  60.00   12.75     8.17    0.00      0.00     0.00   0.00    0.00     0.00    1.00    2.90    0.02   1.63
> 15:35:32 sde              0.00      0.00     0.00   0.00    0.00     0.00    1.00      1.80     0.00   0.00   14.20     1.80    0.00      0.00     0.00   0.00    0.00     0.00    1.00    0.30    0.01   1.49
> 15:35:32 sdf              0.00      0.00     0.00   0.00    0.00     0.00    1.10      2.60     0.10   8.33   12.55     2.36    0.00      0.00     0.00   0.00    0.00     0.00    1.00    1.60    0.02   1.48
> 15:35:32 sdg              0.00      0.00     0.00   0.00    0.00     0.00    1.70     15.40     2.70  61.36   13.53     9.06    0.00      0.00     0.00   0.00    0.00     0.00    1.00    6.90    0.03   2.36
> 15:35:42 md127            0.10      0.40     0.00   0.00   20.00     4.00    2.70     41.20     0.00   0.00 1039.07    15.26    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00    2.81   8.88
> 15:35:42 sdb              0.40     28.80     6.80  94.44   14.25    72.00    1.50     32.55     7.10  82.56    4.47    21.70    0.00      0.00     0.00   0.00    0.00     0.00    0.90    6.78    0.02   0.95
> 15:35:42 sdc              0.40     32.80     7.80  95.12    2.25    82.00    1.10     27.75     6.30  85.14    1.09    25.23    0.00      0.00     0.00   0.00    0.00     0.00    0.90    0.78    0.00   0.28
> 15:35:42 sdd              0.20      6.80     1.50  88.24    9.00    34.00    1.00      2.15     0.00   0.00   14.80     2.15    0.00      0.00     0.00   0.00    0.00     0.00    0.90    3.78    0.02   1.58
> 15:35:42 sde              0.20      6.80     1.50  88.24    0.50    34.00    0.90      1.75     0.00   0.00   14.78     1.94    0.00      0.00     0.00   0.00    0.00     0.00    0.90    0.44    0.01   1.43
> 15:35:42 sdf              0.20     26.00     6.30  96.92   11.50   130.00    1.70     38.15     8.30  83.00    8.35    22.44    0.00      0.00     0.00   0.00    0.00     0.00    0.90    3.00    0.02   1.74
> 15:35:42 sdg              0.00      0.00     0.00   0.00    0.00     0.00    1.90     16.95     2.80  59.57   12.32     8.92    0.00      0.00     0.00   0.00    0.00     0.00    0.90    7.22    0.03   2.02
> 15:35:52 md127            0.80      3.20     0.00   0.00   13.75     4.00   43.60   1419.60     0.00   0.00   99.34    32.56    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00    4.34  13.86
> 15:35:52 sdb              0.60     85.20    20.70  97.18   14.33   142.00    2.70    470.15   115.20  97.71    2.07   174.13    0.00      0.00     0.00   0.00    0.00     0.00    0.80    4.25    0.02   1.25
> 15:35:52 sdc              1.20     97.20    23.10  95.06   10.50    81.00    2.20    371.75    91.10  97.64    2.59   168.98    0.00      0.00     0.00   0.00    0.00     0.00    0.80    2.12    0.02   1.13
> 15:35:52 sdd              2.10    305.60    74.30  97.25   14.62   145.52    1.70    234.95    57.40  97.12    7.71   138.21    0.00      0.00     0.00   0.00    0.00     0.00    0.80    1.12    0.04   2.43
> 15:35:52 sde              1.50    288.40    70.60  97.92   17.47   192.27    1.90    278.95    68.20  97.29    9.74   146.82    0.00      0.00     0.00   0.00    0.00     0.00    0.80    0.38    0.05   2.60
> 15:35:52 sdf              1.30    334.00    82.20  98.44   26.31   256.92    2.30    351.35    85.90  97.39    7.74   152.76    0.00      0.00     0.00   0.00    0.00     0.00    0.80    2.00    0.05   2.34
> 15:35:52 sdg              0.80    215.20    53.00  98.51   18.38   269.00    2.90    510.55   125.10  97.73    7.03   176.05    0.00      0.00     0.00   0.00    0.00     0.00    0.80    3.75    0.04   2.53
> 15:36:02 md127            0.00      0.00     0.00   0.00    0.00     0.00    7.50     43.20     0.00   0.00  500.76     5.76    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00    3.76   9.00
> 15:36:02 sdb              0.20     18.40     4.40  95.65   13.00    92.00    1.90     45.40    10.00  84.03    6.37    23.89    0.00      0.00     0.00   0.00    0.00     0.00    1.20    8.25    0.02   1.17
> 15:36:02 sdc              0.60     32.40     7.50  92.59    9.00    54.00    1.40     21.00     4.40  75.86    3.64    15.00    0.00      0.00     0.00   0.00    0.00     0.00    1.20    3.83    0.01   0.89
> 15:36:02 sdd              0.40     14.00     3.10  88.57    0.50    35.00    1.20      2.60     0.00   0.00   14.33     2.17    0.00      0.00     0.00   0.00    0.00     0.00    1.20    0.33    0.02   1.89
> 15:36:02 sde              0.40     14.00     3.10  88.57    2.50    35.00    1.20      2.60     0.00   0.00   14.17     2.17    0.00      0.00     0.00   0.00    0.00     0.00    1.20    0.33    0.02   1.97
> 15:36:02 sdf              0.60     32.40     7.50  92.59    6.67    54.00    1.50     21.40     4.40  74.58   12.73    14.27    0.00      0.00     0.00   0.00    0.00     0.00    1.20    2.50    0.03   2.19
> 15:36:02 sdg              0.00      0.00     0.00   0.00    0.00     0.00    1.80     27.40     5.60  75.68   13.44    15.22    0.00      0.00     0.00   0.00    0.00     0.00    1.20    3.67    0.03   2.52
> 15:36:12 md127            0.00      0.00     0.00   0.00    0.00     0.00    2.80     24.40     0.00   0.00 1312.57     8.71    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00    3.68   6.54
> 15:36:12 sdb              0.10     10.40     2.50  96.15    0.00   104.00    1.60     18.20     3.50  68.63    3.56    11.38    0.00      0.00     0.00   0.00    0.00     0.00    1.10    4.73    0.01   0.67
> 15:36:12 sdc              0.50     16.00     3.50  87.50    3.40    32.00    1.20     12.60     2.50  67.57    3.00    10.50    0.00      0.00     0.00   0.00    0.00     0.00    1.10    3.00    0.01   0.50
> 15:36:12 sdd              0.40      5.60     1.00  71.43    0.25    14.00    1.10      2.20     0.00   0.00   14.45     2.00    0.00      0.00     0.00   0.00    0.00     0.00    1.10    0.45    0.02   1.76
> 15:36:12 sde              0.40      5.60     1.00  71.43    0.25    14.00    1.10      2.20     0.00   0.00   14.73     2.00    0.00      0.00     0.00   0.00    0.00     0.00    1.10    0.36    0.02   1.74
> 15:36:12 sdf              0.50     16.00     3.50  87.50    3.20    32.00    1.40     21.00     4.40  75.86   13.57    15.00    0.00      0.00     0.00   0.00    0.00     0.00    1.10    2.91    0.02   1.99
> 15:36:12 sdg              0.00      0.00     0.00   0.00    0.00     0.00    1.70     16.20     2.90  63.04   13.53     9.53    0.00      0.00     0.00   0.00    0.00     0.00    1.10    4.64    0.03   2.41
> 15:36:22 md127            0.00      0.00     0.00   0.00    0.00     0.00    1.30      7.60     0.00   0.00 1415.46     5.85    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00    1.84  12.01
> 15:36:22 sdb              0.00      0.00     0.00   0.00    0.00     0.00    0.80      3.70     0.40  33.33    2.62     4.62    0.00      0.00     0.00   0.00    0.00     0.00    0.60    3.00    0.00   0.26
> 15:36:22 sdc              0.20      2.40     0.40  66.67    0.50    12.00    0.60      1.30     0.00   0.00    0.83     2.17    0.00      0.00     0.00   0.00    0.00     0.00    0.60    0.67    0.00   0.13
> 15:36:22 sdd              0.20      2.40     0.40  66.67    0.50    12.00    0.60      1.30     0.00   0.00   16.17     2.17    0.00      0.00     0.00   0.00    0.00     0.00    0.60    0.33    0.01   1.05
> 15:36:22 sde              0.20      2.40     0.40  66.67    0.50    12.00    0.60      1.30     0.00   0.00   14.00     2.17    0.00      0.00     0.00   0.00    0.00     0.00    0.60    0.33    0.01   0.91
> 15:36:22 sdf              0.20      2.40     0.40  66.67    0.50    12.00    0.70      6.50     1.20  63.16   14.71     9.29    0.00      0.00     0.00   0.00    0.00     0.00    0.60    3.17    0.01   1.12
> 15:36:22 sdg              0.00      0.00     0.00   0.00    0.00     0.00    0.90      8.90     1.60  64.00   14.89     9.89    0.00      0.00     0.00   0.00    0.00     0.00    0.60    4.50    0.02   1.39
> 
> (*4)
> 2023-11-05 15:34:42 Dirty:        60 kB  Buffers:   3990316 kB  MemFree:   1276448 kB
> 2023-11-05 15:34:52 Dirty:        88 kB  Buffers:   3990332 kB  MemFree:   1292280 kB
> 2023-11-05 15:35:02 Dirty:       544 kB  Buffers:   3990344 kB  MemFree:   1292780 kB
> 2023-11-05 15:35:12 Dirty:     94128 kB  Buffers:   3993288 kB  MemFree:   1189540 kB
> 2023-11-05 15:35:22 Dirty:     96756 kB  Buffers:   3993328 kB  MemFree:   1194372 kB
> 2023-11-05 15:35:32 Dirty:     96696 kB  Buffers:   3993364 kB  MemFree:   1189540 kB
> 2023-11-05 15:35:42 Dirty:     96176 kB  Buffers:   3993408 kB  MemFree:   1199604 kB
> 2023-11-05 15:35:52 Dirty:     81980 kB  Buffers:   3993468 kB  MemFree:   1137836 kB
> 2023-11-05 15:36:02 Dirty:     82180 kB  Buffers:   3993504 kB  MemFree:   1132644 kB
> 2023-11-05 15:36:12 Dirty:     81884 kB  Buffers:   3993532 kB  MemFree:   1164068 kB
> 2023-11-05 15:36:22 Dirty:     81956 kB  Buffers:   3993556 kB  MemFree:   1155296 kB
> 2023-11-05 15:36:32 Dirty:     81468 kB  Buffers:   3993600 kB  MemFree:   1148428 kB
> 2023-11-05 15:36:42 Dirty:     81184 kB  Buffers:   3993632 kB  MemFree:   1203772 kB
> 2023-11-05 15:36:52 Dirty:     80956 kB  Buffers:   3993652 kB  MemFree:   1168112 kB
> 2023-11-05 15:37:02 Dirty:     80360 kB  Buffers:   3993684 kB  MemFree:   1164228 kB
> 2023-11-05 15:37:12 Dirty:     80280 kB  Buffers:   3993720 kB  MemFree:   1200968 kB
> 2023-11-05 15:37:22 Dirty:     80052 kB  Buffers:   3993736 kB  MemFree:   1165204 kB
> 2023-11-05 15:37:32 Dirty:     79828 kB  Buffers:   3993768 kB  MemFree:   1144772 kB
> 2023-11-05 15:37:42 Dirty:     79488 kB  Buffers:   3993876 kB  MemFree:   1148376 kB
> 2023-11-05 15:37:52 Dirty:     79500 kB  Buffers:   3993964 kB  MemFree:   1144604 kB
> 2023-11-05 15:38:02 Dirty:     79652 kB  Buffers:   3994088 kB  MemFree:   1229132 kB
> 2023-11-05 15:38:12 Dirty:     79308 kB  Buffers:   3994136 kB  MemFree:   1222776 kB
> 2023-11-05 15:38:22 Dirty:     79132 kB  Buffers:   3994168 kB  MemFree:   1216236 kB
> 2023-11-05 15:38:32 Dirty:     79112 kB  Buffers:   3994196 kB  MemFree:   1205308 kB
> 2023-11-05 15:38:42 Dirty:     78980 kB  Buffers:   3994228 kB  MemFree:   1213188 kB
> 2023-11-05 15:38:52 Dirty:     79160 kB  Buffers:   3994268 kB  MemFree:   1199640 kB
> 2023-11-05 15:39:02 Dirty:     79304 kB  Buffers:   3994308 kB  MemFree:   1195604 kB
> 2023-11-05 15:39:12 Dirty:     78832 kB  Buffers:   3994340 kB  MemFree:   1215976 kB
> 2023-11-05 15:39:22 Dirty:     78872 kB  Buffers:   3994380 kB  MemFree:   1196416 kB
> 2023-11-05 15:39:32 Dirty:     78236 kB  Buffers:   3994420 kB  MemFree:   1198744 kB
> 2023-11-05 15:39:42 Dirty:     77188 kB  Buffers:   3994456 kB  MemFree:   1224896 kB
> 2023-11-05 15:39:52 Dirty:     77356 kB  Buffers:   3994488 kB  MemFree:   1219820 kB
> 2023-11-05 15:40:02 Dirty:     77520 kB  Buffers:   3994520 kB  MemFree:   1216344 kB
> 2023-11-05 15:40:12 Dirty:     77452 kB  Buffers:   3994548 kB  MemFree:   1197372 kB
> 2023-11-05 15:40:22 Dirty:     76652 kB  Buffers:   3994580 kB  MemFree:   1181344 kB
> 2023-11-05 15:40:32 Dirty:     76620 kB  Buffers:   3994604 kB  MemFree:   1188504 kB
> 2023-11-05 15:40:42 Dirty:     76516 kB  Buffers:   3994636 kB  MemFree:   1202256 kB
> 2023-11-05 15:40:52 Dirty:     76544 kB  Buffers:   3994708 kB  MemFree:   1181708 kB
> 2023-11-05 15:41:02 Dirty:     76716 kB  Buffers:   3994748 kB  MemFree:   1183688 kB
> 2023-11-05 15:41:12 Dirty:     74888 kB  Buffers:   3994796 kB  MemFree:   1168440 kB
> 2023-11-05 15:41:22 Dirty:     72064 kB  Buffers:   3994836 kB  MemFree:   1167124 kB
> 2023-11-05 15:41:32 Dirty:     71520 kB  Buffers:   3994860 kB  MemFree:   1160128 kB
> 2023-11-05 15:41:42 Dirty:     71464 kB  Buffers:   3994892 kB  MemFree:   1154912 kB
> 2023-11-05 15:41:52 Dirty:     71504 kB  Buffers:   3994932 kB  MemFree:   1160312 kB
> 2023-11-05 15:42:02 Dirty:     71404 kB  Buffers:   3994956 kB  MemFree:   1204212 kB
> 2023-11-05 15:42:12 Dirty:     70812 kB  Buffers:   3994988 kB  MemFree:   1163440 kB
> 2023-11-05 15:42:22 Dirty:     69880 kB  Buffers:   3995024 kB  MemFree:   1160820 kB
> 
> Then at some point all the dirty blocks are written quickly:
> 
> 2023-11-05 16:34:13 Dirty:      7876 kB  Buffers:   4042032 kB  MemFree:    628004 kB
> 2023-11-05 16:34:23 Dirty:      7836 kB  Buffers:   4042056 kB  MemFree:    626240 kB
> 2023-11-05 16:34:33 Dirty:      7628 kB  Buffers:   4042080 kB  MemFree:    624728 kB
> 2023-11-05 16:34:43 Dirty:      7540 kB  Buffers:   4042112 kB  MemFree:    622464 kB
> 2023-11-05 16:34:53 Dirty:      7496 kB  Buffers:   4042136 kB  MemFree:    620448 kB
> 2023-11-05 16:35:03 Dirty:      8224 kB  Buffers:   4042164 kB  MemFree:    635820 kB
> 2023-11-05 16:35:13 Dirty:      7544 kB  Buffers:   4042212 kB  MemFree:    631848 kB
> 2023-11-05 16:35:23 Dirty:      7524 kB  Buffers:   4042236 kB  MemFree:    631092 kB
> 2023-11-05 16:35:33 Dirty:      7472 kB  Buffers:   4042260 kB  MemFree:    630084 kB
> 2023-11-05 16:35:43 Dirty:      7320 kB  Buffers:   4042300 kB  MemFree:    625044 kB
> 2023-11-05 16:35:53 Dirty:      7244 kB  Buffers:   4042324 kB  MemFree:    623788 kB
> 2023-11-05 16:36:03 Dirty:      7516 kB  Buffers:   4042348 kB  MemFree:    631476 kB
> 2023-11-05 16:36:13 Dirty:      7216 kB  Buffers:   4042376 kB  MemFree:    636232 kB
> 2023-11-05 16:36:23 Dirty:      6368 kB  Buffers:   4042408 kB  MemFree:    633964 kB
> 2023-11-05 16:36:33 Dirty:      5564 kB  Buffers:   4042424 kB  MemFree:    632464 kB
> 2023-11-05 16:36:43 Dirty:      4452 kB  Buffers:   4042456 kB  MemFree:    630704 kB
> 2023-11-05 16:36:53 Dirty:      4344 kB  Buffers:   4042480 kB  MemFree:    628688 kB
> 2023-11-05 16:37:03 Dirty:       296 kB  Buffers:   4042524 kB  MemFree:    625196 kB
> 2023-11-05 16:37:13 Dirty:       312 kB  Buffers:   4042540 kB  MemFree:    623948 kB
> 2023-11-05 16:37:23 Dirty:       204 kB  Buffers:   4042548 kB  MemFree:    622216 kB
> 2023-11-05 16:37:33 Dirty:       240 kB  Buffers:   4042564 kB  MemFree:    620704 kB
> 2023-11-05 16:37:43 Dirty:        84 kB  Buffers:   4042580 kB  MemFree:    619192 kB
> 2023-11-05 16:37:53 Dirty:        84 kB  Buffers:   4042588 kB  MemFree:    617428 kB
> 
> I have a script that displays progress in this log:
> 
>                          Dirty               Buffers               MemFree
> 2023-11-05 15:34:42        60 kB    -7560   3990316 kB       24   1276448 kB   -43800
> 2023-11-05 15:34:52        88 kB       28   3990332 kB       16   1292280 kB    15832
> 2023-11-05 15:35:02       544 kB      456   3990344 kB       12   1292780 kB      500
> 2023-11-05 15:35:12     94128 kB    93584   3993288 kB     2944   1189540 kB  -103240
> 2023-11-05 15:35:22     96756 kB     2628   3993328 kB       40   1194372 kB     4832
> 2023-11-05 15:35:32     96696 kB      -60   3993364 kB       36   1189540 kB    -4832
> 2023-11-05 15:35:42     96176 kB     -520   3993408 kB       44   1199604 kB    10064
> 2023-11-05 15:35:52     81980 kB   -14196   3993468 kB       60   1137836 kB   -61768
> 2023-11-05 15:36:02     82180 kB      200   3993504 kB       36   1132644 kB    -5192
> 2023-11-05 15:36:12     81884 kB     -296   3993532 kB       28   1164068 kB    31424
> 2023-11-05 15:36:22     81956 kB       72   3993556 kB       24   1155296 kB    -8772
> 2023-11-05 15:36:32     81468 kB     -488   3993600 kB       44   1148428 kB    -6868
> 2023-11-05 15:36:42     81184 kB     -284   3993632 kB       32   1203772 kB    55344
> 2023-11-05 15:36:52     80956 kB     -228   3993652 kB       20   1168112 kB   -35660
> 2023-11-05 15:37:02     80360 kB     -596   3993684 kB       32   1164228 kB    -3884
> 2023-11-05 15:37:12     80280 kB      -80   3993720 kB       36   1200968 kB    36740
> 2023-11-05 15:37:22     80052 kB     -228   3993736 kB       16   1165204 kB   -35764
> 2023-11-05 15:37:32     79828 kB     -224   3993768 kB       32   1144772 kB   -20432
> 2023-11-05 15:37:42     79488 kB     -340   3993876 kB      108   1148376 kB     3604
> 2023-11-05 15:37:52     79500 kB       12   3993964 kB       88   1144604 kB    -3772
> 2023-11-05 15:38:02     79652 kB      152   3994088 kB      124   1229132 kB    84528
> 2023-11-05 15:38:12     79308 kB     -344   3994136 kB       48   1222776 kB    -6356
> 2023-11-05 15:38:22     79132 kB     -176   3994168 kB       32   1216236 kB    -6540
> 2023-11-05 15:38:32     79112 kB      -20   3994196 kB       28   1205308 kB   -10928
> 2023-11-05 15:38:42     78980 kB     -132   3994228 kB       32   1213188 kB     7880
> 2023-11-05 15:38:52     79160 kB      180   3994268 kB       40   1199640 kB   -13548
> 2023-11-05 15:39:02     79304 kB      144   3994308 kB       40   1195604 kB    -4036
> 2023-11-05 15:39:12     78832 kB     -472   3994340 kB       32   1215976 kB    20372
> 2023-11-05 15:39:22     78872 kB       40   3994380 kB       40   1196416 kB   -19560
> 2023-11-05 15:39:32     78236 kB     -636   3994420 kB       40   1198744 kB     2328
> 2023-11-05 15:39:42     77188 kB    -1048   3994456 kB       36   1224896 kB    26152
> 2023-11-05 15:39:52     77356 kB      168   3994488 kB       32   1219820 kB    -5076
> 2023-11-05 15:40:02     77520 kB      164   3994520 kB       32   1216344 kB    -3476
> 2023-11-05 15:40:12     77452 kB      -68   3994548 kB       28   1197372 kB   -18972
> 2023-11-05 15:40:22     76652 kB     -800   3994580 kB       32   1181344 kB   -16028
> 2023-11-05 15:40:32     76620 kB      -32   3994604 kB       24   1188504 kB     7160
> 2023-11-05 15:40:42     76516 kB     -104   3994636 kB       32   1202256 kB    13752
> 2023-11-05 15:40:52     76544 kB       28   3994708 kB       72   1181708 kB   -20548
> 2023-11-05 15:41:02     76716 kB      172   3994748 kB       40   1183688 kB     1980
> 2023-11-05 15:41:12     74888 kB    -1828   3994796 kB       48   1168440 kB   -15248
> 2023-11-05 15:41:22     72064 kB    -2824   3994836 kB       40   1167124 kB    -1316
> 2023-11-05 15:41:32     71520 kB     -544   3994860 kB       24   1160128 kB    -6996
> 2023-11-05 15:41:42     71464 kB      -56   3994892 kB       32   1154912 kB    -5216
> 2023-11-05 15:41:52     71504 kB       40   3994932 kB       40   1160312 kB     5400
> 2023-11-05 15:42:02     71404 kB     -100   3994956 kB       24   1204212 kB    43900
> 2023-11-05 15:42:12     70812 kB     -592   3994988 kB       32   1163440 kB   -40772
> 2023-11-05 15:42:22     69880 kB     -932   3995024 kB       36   1160820 kB    -2620
> 
> (*5)
> 
> $ sudo perf top --pid 4164147 -g
> Samples: 261K of event 'cycles:P', 4000 Hz, Event count (approx.): 70413169119 lost: 0/0 drop: 0/0
>    Children      Self  Shared O  Symbol
> +  100.00%     1.60%  [kernel]  [k] ext4_mb_regular_allocator
> +   67.08%     5.93%  [kernel]  [k] ext4_mb_find_good_group_avg_frag_lists
> +   62.47%    42.34%  [kernel]  [k] ext4_mb_good_group
> +   22.51%    11.36%  [kernel]  [k] ext4_get_group_info
> +   19.70%    10.80%  [kernel]  [k] ext4_mb_scan_aligned
> +   13.13%     0.00%  [kernel]  [k] ret_from_fork_asm
> +   13.13%     0.00%  [kernel]  [k] ret_from_fork
> +   13.13%     0.00%  [kernel]  [k] kthread
> +   13.13%     0.00%  [kernel]  [k] worker_thread
> +   13.13%     0.00%  [kernel]  [k] process_one_work
> +   13.13%     0.00%  [kernel]  [k] wb_workfn
> +   13.13%     0.00%  [kernel]  [k] wb_writeback
> +   13.13%     0.00%  [kernel]  [k] __writeback_inodes_wb
> +   13.13%     0.00%  [kernel]  [k] writeback_sb_inodes
> +   13.13%     0.00%  [kernel]  [k] __writeback_single_inode
> +   13.13%     0.00%  [kernel]  [k] do_writepages
> +   13.13%     0.00%  [kernel]  [k] ext4_writepages
> +   13.13%     0.00%  [kernel]  [k] ext4_do_writepages
> +   13.13%     0.00%  [kernel]  [k] ext4_map_blocks
> +   13.13%     0.00%  [kernel]  [k] ext4_ext_map_blocks
> +   13.13%     0.00%  [kernel]  [k] ext4_mb_new_blocks
> +    8.95%     1.80%  [kernel]  [k] mb_find_extent
> +    7.11%     1.41%  [kernel]  [k] ext4_mb_load_buddy_gfp
> +    6.94%     6.89%  [kernel]  [k] mb_find_order_for_block
> +    5.89%     5.79%  [kernel]  [k] __rcu_read_unlock
> +    5.43%     0.19%  [kernel]  [k] pagecache_get_page
> +    5.14%     0.47%  [kernel]  [k] __filemap_get_folio
> +    4.53%     1.61%  [kernel]  [k] filemap_get_entry
> +    3.81%     3.75%  [kernel]  [k] __rcu_read_lock
> +    2.75%     0.95%  [kernel]  [k] xas_load
> +    1.73%     1.53%  [kernel]  [k] xas_descend
> +    1.08%     1.08%  [kernel]  [k] ext4_mb_unload_buddy
> +    0.76%     0.53%  [kernel]  [k] _raw_read_unlock
> +    0.55%     0.55%  [kernel]  [k] _raw_spin_trylock
>       0.44%     0.43%  [kernel]  [k] _raw_read_lock
>       0.26%     0.24%  [kernel]  [k] xas_start
>       0.22%     0.18%  [kernel]  [k] mb_find_buddy
>       0.19%     0.14%  [kernel]  [k] folio_mark_accessed
>       0.15%     0.15%  [kernel]  [k] _raw_spin_unlock
>       0.13%     0.09%  [kernel]  [k] __cond_resched
>       0.09%     0.09%  [kernel]  [k] folio_test_hugetlb
>       0.09%     0.00%  [kernel]  [k] hrtimer_interrupt
>       0.07%     0.00%  [kernel]  [k] __hrtimer_run_queues
>       0.04%     0.00%  [kernel]  [k] scheduler_tick
>       0.03%     0.00%  [kernel]  [k] __sysvec_apic_timer_interrupt
>       0.01%     0.00%  [kernel]  [k] perf_adjust_freq_unthr_context
>       0.01%     0.00%  [kernel]  [k] clockevents_program_event
>       0.01%     0.00%  [kernel]  [k] arch_scale_freq_tick
>       0.01%     0.00%  [kernel]  [k] asm_sysvec_apic_timer_interrupt
>       0.01%     0.00%  [kernel]  [k] sysvec_apic_timer_interrupt
>       0.01%     0.01%  [kernel]  [k] native_write_msr
>       0.01%     0.00%  [kernel]  [k] sched_clock_cpu
>       0.01%     0.00%  [kernel]  [k] lapic_next_deadline
>       0.01%     0.01%  [kernel]  [k] native_irq_return_iret
>       0.01%     0.01%  [kernel]  [k] read_tsc
>       0.01%     0.00%  [kernel]  [k] timekeeping_advance
>       0.01%     0.01%  [kernel]  [k] native_read_msr
>       0.01%     0.00%  [kernel]  [k] ktime_get
>       0.01%     0.00%  [kernel]  [k] tick_sched_timer
>       0.01%     0.01%  [kernel]  [k] native_sched_clock
>       0.01%     0.01%  [kernel]  [k] trigger_load_balance
>       0.01%     0.00%  [kernel]  [k] update_rq_clock
>       0.00%     0.00%  [kernel]  [k] tick_sched_handle
>       0.00%     0.00%  [kernel]  [k] update_process_times
>       0.00%     0.00%  [kernel]  [k] irqtime_account_irq
>       0.00%     0.00%  [kernel]  [k] __irq_exit_rcu
>       0.00%     0.00%  [kernel]  [k] update_curr
>       0.00%     0.00%  [kernel]  [k] update_load_avg
>       0.00%     0.00%  [kernel]  [k] native_apic_msr_eoi_write
>       0.00%     0.00%  [kernel]  [k] wq_worker_tick
>       0.00%     0.00%  [kernel]  [k] psi_account_irqtime
>       0.00%     0.00%  [kernel]  [k] error_entry
>       0.00%     0.00%  [kernel]  [k] _raw_spin_lock_irqsave
>       0.00%     0.00%  [kernel]  [k] _raw_spin_lock
>       0.00%     0.00%  [kernel]  [k] hrtimer_active
>       0.00%     0.00%  [kernel]  [k] __update_load_avg_cfs_rq
>       0.00%     0.00%  [kernel]  [k] generic_exec_single
>       0.00%     0.00%  [kernel]  [k] perf_pmu_nop_void
>       0.00%     0.00%  [kernel]  [k] perf_event_task_tick
>       0.00%     0.00%  [kernel]  [k] __intel_pmu_enable_all.isra.0
>       0.00%     0.00%  [kernel]  [k] task_tick_fair
>       0.00%     0.00%  [kernel]  [k] timerqueue_del
>       0.00%     0.00%  [kernel]  [k] timekeeping_update
>       0.00%     0.00%  [kernel]  [k] rb_erase
>       0.00%     0.00%  [kernel]  [k] cpuacct_charge
>       0.00%     0.00%  [kernel]  [k] profile_tick
>       0.00%     0.00%  [kernel]  [k] hrtimer_forward
>       0.00%     0.00%  [kernel]  [k] irqtime_account_process_tick
>       0.00%     0.00%  [kernel]  [k] update_irq_load_avg
>       0.00%     0.00%  [kernel]  [k] raid5_get_active_stripe
>       0.00%     0.00%  [kernel]  [k] rcu_sched_clock_irq
>       0.00%     0.00%  [kernel]  [k] kthread_data
>       0.00%     0.00%  [kernel]  [k] rcu_segcblist_ready_cbs
>       0.00%     0.00%  [kernel]  [k] irqentry_enter
>       0.00%     0.00%  [kernel]  [k] hrtimer_run_queues
>       0.00%     0.00%  [kernel]  [k] perf_event_nmi_handler
>       0.00%     0.00%  [kernel]  [k] enqueue_hrtimer
>       0.00%     0.00%  [kernel]  [k] _raw_spin_unlock_irqrestore
>       0.00%     0.00%  [kernel]  [k] wbc_detach_inode
>       0.00%     0.00%  [kernel]  [k] update_vsyscall
>       0.00%     0.00%  [kernel]  [k] timerqueue_add
>       0.00%     0.00%  [kernel]  [k] _raw_spin_lock_irq
>       0.00%     0.00%  [kernel]  [k] llist_add_batch
>       0.00%     0.00%  [kernel]  [k] tick_do_update_jiffies64
>       0.00%     0.00%  [kernel]  [k] call_function_single_prep_ipi
>       0.00%     0.00%  [kernel]  [k] update_cfs_group
>       0.00%     0.00%  [kernel]  [k] __hrtimer_next_event_base
>       0.00%     0.00%  [kernel]  [k] notifier_call_chain
>       0.00%     0.00%  [kernel]  [k] bio_alloc_bioset
>       0.00%     0.00%  [kernel]  [k] __update_load_avg_se
>       0.00%     0.00%  [kernel]  [k] account_process_tick
>       0.00%     0.00%  [kernel]  [k] pvclock_gtod_notify
>       0.00%     0.00%  [kernel]  [k] kmem_cache_free
>       0.00%     0.00%  [kernel]  [k] ktime_get_update_offsets_now
>       0.00%     0.00%  [kernel]  [k] load_balance
>       0.00%     0.00%  [kernel]  [k] update_fast_timekeeper
>       0.00%     0.00%  [kernel]  [k] restore_regs_and_return_to_kernel
>       0.00%     0.00%  [kernel]  [k] find_get_stripe
>       0.00%     0.00%  [kernel]  [k] set_next_buddy
>       0.00%     0.00%  [kernel]  [k] ext4_sb_block_valid
>       0.00%     0.00%  [kernel]  [k] update_min_vruntime
>       0.00%     0.00%  [kernel]  [k] irq_work_tick
>       0.00%     0.00%  [kernel]  [k] md_account_bio
>       0.00%     0.00%  [kernel]  [k] run_posix_cpu_timers
>       0.00%     0.00%  [kernel]  [k] __accumulate_pelt_segments
>       0.00%     0.00%  [kernel]  [k] __es_remove_extent
>       0.00%     0.00%  [kernel]  [k] ntp_tick_length
>       0.00%     0.00%  [kernel]  [k] tick_program_event
>       0.00%     0.00%  [kernel]  [k] kmem_cache_alloc
>       0.00%     0.00%  [kernel]  [k] __sysvec_call_function_single
> 
> 
> (*6)
> 
> # echo w > /proc/sysrq-trigger
> Nov  5 15:39:42 e7 kernel: sysrq: Show Blocked State
> Nov  5 15:39:42 e7 kernel: task:md127_raid6     state:D stack:0     pid:909   ppid:2      flags:0x00004000
> Nov  5 15:39:42 e7 kernel: Call Trace:
> Nov  5 15:39:42 e7 kernel: <TASK>
> Nov  5 15:39:42 e7 kernel: ? __pfx_md_thread+0x10/0x10
> Nov  5 15:39:42 e7 kernel: __schedule+0x3ee/0x14c0
> Nov  5 15:39:42 e7 kernel: ? update_load_avg+0x7e/0x780
> Nov  5 15:39:42 e7 kernel: ? __pfx_md_thread+0x10/0x10
> Nov  5 15:39:42 e7 kernel: schedule+0x5e/0xd0
> Nov  5 15:39:42 e7 kernel: percpu_ref_switch_to_atomic_sync+0x9a/0xf0
> Nov  5 15:39:42 e7 kernel: ? __pfx_autoremove_wake_function+0x10/0x10
> Nov  5 15:39:42 e7 kernel: set_in_sync+0x5c/0xc0
> Nov  5 15:39:42 e7 kernel: md_check_recovery+0x356/0x5a0
> Nov  5 15:39:42 e7 kernel: raid5d+0x76/0x750 [raid456]
> Nov  5 15:39:42 e7 kernel: ? lock_timer_base+0x61/0x80
> Nov  5 15:39:42 e7 kernel: ? prepare_to_wait_event+0x60/0x180
> Nov  5 15:39:42 e7 kernel: ? __pfx_md_thread+0x10/0x10
> Nov  5 15:39:42 e7 kernel: md_thread+0xab/0x190
> Nov  5 15:39:42 e7 kernel: ? __pfx_autoremove_wake_function+0x10/0x10
> Nov  5 15:39:42 e7 kernel: kthread+0xe5/0x120
> Nov  5 15:39:42 e7 kernel: ? __pfx_kthread+0x10/0x10
> Nov  5 15:39:42 e7 kernel: ret_from_fork+0x31/0x50
> Nov  5 15:39:42 e7 kernel: ? __pfx_kthread+0x10/0x10
> Nov  5 15:39:42 e7 kernel: ret_from_fork_asm+0x1b/0x30
> Nov  5 15:39:42 e7 kernel: </TASK>
> 
> # echo l > /proc/sysrq-trigger
> Nov  5 15:42:41 e7 kernel: Sending NMI from CPU 3 to CPUs 0-2,4-7:
> Nov  5 15:42:41 e7 kernel: NMI backtrace for cpu 1
> Nov  5 15:42:41 e7 kernel: CPU: 1 PID: 4164147 Comm: kworker/u16:3 Not tainted 6.5.8-200.fc38.x86_64 #1
> Nov  5 15:42:41 e7 kernel: Hardware name: Gigabyte Technology Co., Ltd. Z390 UD/Z390 UD, BIOS F8 05/24/2019
> Nov  5 15:42:41 e7 kernel: Workqueue: writeback wb_workfn (flush-9:127)
> Nov  5 15:42:41 e7 kernel: RIP: 0010:ext4_mb_good_group+0x60/0xf0
> Nov  5 15:42:41 e7 kernel: Code: 48 8b 00 a8 04 75 2c 8b 46 14 85 c0 74 25 8b 4e 18 85 c9 74 1e 83 fb 03 74 3c 83 fb 04 74 23 83 eb 01 83 fb 01 77 38 99 f7 f9 <41> 3b 45 2c 0f 9d c2 eb 02 31 d2 5b 89 d0 5d 41 5c 41 5d c3 cc cc
> Nov  5 15:42:41 e7 kernel: RSP: 0018:ffffb7be054ef6a0 EFLAGS: 00000246
> Nov  5 15:42:41 e7 kernel: RAX: 0000000000000201 RBX: 0000000000000001 RCX: 000000000000000d
> Nov  5 15:42:41 e7 kernel: RDX: 0000000000000003 RSI: ffff892f46d37450 RDI: ffff893019445280
> Nov  5 15:42:41 e7 kernel: RBP: 0000000000001306 R08: ffff892f49711000 R09: 0000000000000280
> Nov  5 15:42:41 e7 kernel: R10: 0000000000000001 R11: 0000000000000100 R12: 0000000000000004
> Nov  5 15:42:41 e7 kernel: R13: ffff892f486d31c8 R14: 0000000000000002 R15: ffff892f46d37450
> Nov  5 15:42:41 e7 kernel: FS:  0000000000000000(0000) GS:ffff8936de440000(0000) knlGS:0000000000000000
> Nov  5 15:42:41 e7 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Nov  5 15:42:41 e7 kernel: CR2: 000055d6aaa70af8 CR3: 000000050f222003 CR4: 00000000003706e0
> Nov  5 15:42:41 e7 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> Nov  5 15:42:41 e7 kernel: DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Nov  5 15:42:41 e7 kernel: Call Trace:
> Nov  5 15:42:41 e7 kernel: <NMI>
> Nov  5 15:42:41 e7 kernel: ? nmi_cpu_backtrace+0x99/0x110
> Nov  5 15:42:41 e7 kernel: ? nmi_cpu_backtrace_handler+0x11/0x20
> Nov  5 15:42:41 e7 kernel: ? nmi_handle+0x5e/0x150
> Nov  5 15:42:41 e7 kernel: ? default_do_nmi+0x40/0x100
> Nov  5 15:42:41 e7 kernel: ? exc_nmi+0x139/0x1c0
> Nov  5 15:42:41 e7 kernel: ? end_repeat_nmi+0x16/0x67
> Nov  5 15:42:41 e7 kernel: ? ext4_mb_good_group+0x60/0xf0
> Nov  5 15:42:41 e7 kernel: ? ext4_mb_good_group+0x60/0xf0
> Nov  5 15:42:41 e7 kernel: ? ext4_mb_good_group+0x60/0xf0
> Nov  5 15:42:41 e7 kernel: </NMI>
> Nov  5 15:42:41 e7 kernel: <TASK>
> Nov  5 15:42:41 e7 kernel: ext4_mb_find_good_group_avg_frag_lists+0x8e/0xe0
> Nov  5 15:42:41 e7 kernel: ext4_mb_regular_allocator+0x473/0xe00
> Nov  5 15:42:41 e7 kernel: ext4_mb_new_blocks+0xa74/0x11e0
> Nov  5 15:42:41 e7 kernel: ? ext4_find_extent+0x3c6/0x420
> Nov  5 15:42:41 e7 kernel: ext4_ext_map_blocks+0x5f8/0x1930
> Nov  5 15:42:41 e7 kernel: ? release_pages+0x177/0x510
> Nov  5 15:42:41 e7 kernel: ? filemap_get_folios_tag+0x1d0/0x200
> Nov  5 15:42:41 e7 kernel: ? __folio_batch_release+0x1f/0x60
> Nov  5 15:42:41 e7 kernel: ? mpage_prepare_extent_to_map+0x494/0x4d0
> Nov  5 15:42:41 e7 kernel: ext4_map_blocks+0x1ba/0x5f0
> Nov  5 15:42:41 e7 kernel: ext4_do_writepages+0x76a/0xc90
> Nov  5 15:42:41 e7 kernel: ext4_writepages+0xad/0x180
> Nov  5 15:42:41 e7 kernel: do_writepages+0xcf/0x1e0
> Nov  5 15:42:41 e7 kernel: __writeback_single_inode+0x3d/0x360
> Nov  5 15:42:41 e7 kernel: ? wbc_detach_inode+0x101/0x220
> Nov  5 15:42:41 e7 kernel: writeback_sb_inodes+0x1ed/0x4b0
> Nov  5 15:42:41 e7 kernel: __writeback_inodes_wb+0x4c/0xf0
> Nov  5 15:42:41 e7 kernel: wb_writeback+0x298/0x310
> Nov  5 15:42:41 e7 kernel: wb_workfn+0x35b/0x510
> Nov  5 15:42:41 e7 kernel: ? __schedule+0x3f6/0x14c0
> Nov  5 15:42:41 e7 kernel: process_one_work+0x1de/0x3f0
> Nov  5 15:42:41 e7 kernel: worker_thread+0x51/0x390
> Nov  5 15:42:41 e7 kernel: ? __pfx_worker_thread+0x10/0x10
> Nov  5 15:42:41 e7 kernel: kthread+0xe5/0x120
> Nov  5 15:42:41 e7 kernel: ? __pfx_kthread+0x10/0x10
> Nov  5 15:42:41 e7 kernel: ret_from_fork+0x31/0x50
> Nov  5 15:42:41 e7 kernel: ? __pfx_kthread+0x10/0x10
> Nov  5 15:42:41 e7 kernel: ret_from_fork_asm+0x1b/0x30
> Nov  5 15:42:41 e7 kernel: </TASK>
> 
> # echo l > /proc/sysrq-trigger
> Nov  5 15:45:47 e7 kernel: sysrq: Show backtrace of all active CPUs
> Nov  5 15:45:47 e7 kernel: Sending NMI from CPU 3 to CPUs 0-2,4-7:
> Nov  5 15:45:47 e7 kernel: NMI backtrace for cpu 1
> Nov  5 15:45:47 e7 kernel: CPU: 1 PID: 4164147 Comm: kworker/u16:3 Not tainted 6.5.8-200.fc38.x86_64 #1
> Nov  5 15:45:47 e7 kernel: Hardware name: Gigabyte Technology Co., Ltd. Z390 UD/Z390 UD, BIOS F8 05/24/2019
> Nov  5 15:45:47 e7 kernel: Workqueue: writeback wb_workfn (flush-9:127)
> Nov  5 15:45:47 e7 kernel: RIP: 0010:ext4_get_group_info+0x47/0x70
> Nov  5 15:45:47 e7 kernel: Code: fd 53 8b 88 b0 00 00 00 89 f3 48 8b 40 38 41 d3 ec 48 83 e8 01 21 c3 e8 47 3c c9 ff 48 8b 85 80 03 00 00 48 8b 80 b8 02 00 00 <4a> 8b 2c e0 e8 b0 6a c9 ff 48 8b 44 dd 00 5b 5d 41 5c c3 cc cc cc
> Nov  5 15:45:47 e7 kernel: RSP: 0018:ffffb7be054ef680 EFLAGS: 00000202
> Nov  5 15:45:47 e7 kernel: RAX: ffff892f5cc30000 RBX: 0000000000000029 RCX: 0000000000000006
> Nov  5 15:45:47 e7 kernel: RDX: ffff893019445280 RSI: 00000000000012e9 RDI: ffff892f49711000
> Nov  5 15:45:47 e7 kernel: RBP: ffff892f49711000 R08: ffff892f49711000 R09: 0000000000000023
> Nov  5 15:45:47 e7 kernel: R10: 0000000000000000 R11: 0000000000000000 R12: 000000000000004b
> Nov  5 15:45:47 e7 kernel: R13: ffff892f486d31c8 R14: 0000000000000001 R15: ffff892f46d36730
> Nov  5 15:45:47 e7 kernel: FS:  0000000000000000(0000) GS:ffff8936de440000(0000) knlGS:0000000000000000
> Nov  5 15:45:47 e7 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Nov  5 15:45:47 e7 kernel: CR2: 000055d6aaa70af8 CR3: 000000050f222003 CR4: 00000000003706e0
> Nov  5 15:45:47 e7 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> Nov  5 15:45:47 e7 kernel: DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Nov  5 15:45:47 e7 kernel: Call Trace:
> Nov  5 15:45:47 e7 kernel: <NMI>
> Nov  5 15:45:47 e7 kernel: ? nmi_cpu_backtrace+0x99/0x110
> Nov  5 15:45:47 e7 kernel: ? nmi_cpu_backtrace_handler+0x11/0x20
> Nov  5 15:45:47 e7 kernel: ? nmi_handle+0x5e/0x150
> Nov  5 15:45:47 e7 kernel: ? default_do_nmi+0x40/0x100
> Nov  5 15:45:47 e7 kernel: ? exc_nmi+0x139/0x1c0
> Nov  5 15:45:47 e7 kernel: ? end_repeat_nmi+0x16/0x67
> Nov  5 15:45:47 e7 kernel: ? ext4_get_group_info+0x47/0x70
> Nov  5 15:45:47 e7 kernel: ? ext4_get_group_info+0x47/0x70
> Nov  5 15:45:47 e7 kernel: ? ext4_get_group_info+0x47/0x70
> Nov  5 15:45:47 e7 kernel: </NMI>
> Nov  5 15:45:47 e7 kernel: <TASK>
> Nov  5 15:45:47 e7 kernel: ext4_mb_good_group+0x29/0xf0
> Nov  5 15:45:47 e7 kernel: ext4_mb_find_good_group_avg_frag_lists+0x8e/0xe0
> Nov  5 15:45:47 e7 kernel: ext4_mb_regular_allocator+0xb74/0xe00
> Nov  5 15:45:47 e7 kernel: ext4_mb_new_blocks+0xa74/0x11e0
> Nov  5 15:45:47 e7 kernel: ? ext4_find_extent+0x3c6/0x420
> Nov  5 15:45:47 e7 kernel: ext4_ext_map_blocks+0x5f8/0x1930
> Nov  5 15:45:47 e7 kernel: ? release_pages+0x177/0x510
> Nov  5 15:45:47 e7 kernel: ? filemap_get_folios_tag+0x1d0/0x200
> Nov  5 15:45:47 e7 kernel: ? __folio_batch_release+0x1f/0x60
> Nov  5 15:45:47 e7 kernel: ? mpage_prepare_extent_to_map+0x494/0x4d0
> Nov  5 15:45:47 e7 kernel: ext4_map_blocks+0x1ba/0x5f0
> Nov  5 15:45:47 e7 kernel: ext4_do_writepages+0x76a/0xc90
> Nov  5 15:45:47 e7 kernel: ext4_writepages+0xad/0x180
> Nov  5 15:45:47 e7 kernel: do_writepages+0xcf/0x1e0
> Nov  5 15:45:47 e7 kernel: __writeback_single_inode+0x3d/0x360
> Nov  5 15:45:47 e7 kernel: ? wbc_detach_inode+0x101/0x220
> Nov  5 15:45:47 e7 kernel: writeback_sb_inodes+0x1ed/0x4b0
> Nov  5 15:45:47 e7 kernel: __writeback_inodes_wb+0x4c/0xf0
> Nov  5 15:45:47 e7 kernel: wb_writeback+0x298/0x310
> Nov  5 15:45:47 e7 kernel: wb_workfn+0x35b/0x510
> Nov  5 15:45:47 e7 kernel: ? __schedule+0x3f6/0x14c0
> Nov  5 15:45:47 e7 kernel: process_one_work+0x1de/0x3f0
> Nov  5 15:45:47 e7 kernel: worker_thread+0x51/0x390
> Nov  5 15:45:47 e7 kernel: ? __pfx_worker_thread+0x10/0x10
> Nov  5 15:45:47 e7 kernel: kthread+0xe5/0x120
> Nov  5 15:45:47 e7 kernel: ? __pfx_kthread+0x10/0x10
> Nov  5 15:45:47 e7 kernel: ret_from_fork+0x31/0x50
> Nov  5 15:45:47 e7 kernel: ? __pfx_kthread+0x10/0x10
> Nov  5 15:45:47 e7 kernel: ret_from_fork_asm+0x1b/0x30
> Nov  5 15:45:47 e7 kernel: </TASK>
> 
> (*7)
> When the rsync ran the first time I did not see the kthread but decided a restart will clear the issue (I blamed rsyn).
> The system could not shutdown and a syseq 'b' was required.
> On restart the array was all spares. It was reassembled with
>      mdadm --assemble --force /dev/md127 /dev/sd{b,c,d,e,f,g}1
> and then a boot looked OK.
> 
> Later, examining the logs I saw this message as the array was assembled:
>      2023-10-30T01:08:25+1100 kernel: md: requested-resync of RAID array md127
> I did not see a resync in mdstat after a restart.
> 
> All of the tests in this report were done after these events.
> 

-- 
Eyal at Home (eyal@eyal.emu.id.au)

