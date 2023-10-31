Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 860FAC4332F
	for <linux-raid@archiver.kernel.org>; Tue, 31 Oct 2023 22:01:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232168AbjJaWBK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 31 Oct 2023 18:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbjJaWBJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 31 Oct 2023 18:01:09 -0400
Received: from lists.tip.net.au (pasta.tip.net.au [203.10.76.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DD3DF4
        for <linux-raid@vger.kernel.org>; Tue, 31 Oct 2023 15:01:06 -0700 (PDT)
Received: from lists.tip.net.au (pasta.tip.net.au [IPv6:2401:fc00:0:129::2])
        by mailhost.tip.net.au (Postfix) with ESMTP id 4SKkc05lvMz9RPD
        for <linux-raid@vger.kernel.org>; Wed,  1 Nov 2023 09:01:04 +1100 (AEDT)
Received: from [IPV6:2405:6e00:494:92f5:21b:21ff:fe3a:5672] (unknown [IPv6:2405:6e00:494:92f5:21b:21ff:fe3a:5672])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mailhost.tip.net.au (Postfix) with ESMTPSA id 4SKkc031h5z9Q5T
        for <linux-raid@vger.kernel.org>; Wed,  1 Nov 2023 09:01:04 +1100 (AEDT)
Message-ID: <86826b56-7e8e-44ff-90f2-4d19bbbcdc46@eyal.emu.id.au>
Date:   Wed, 1 Nov 2023 09:00:59 +1100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: problem with recovered array [more details]
Content-Language: en-US
To:     linux-raid@vger.kernel.org
References: <87273fc6-9531-4072-ae6c-06306e9a269d@eyal.emu.id.au>
 <a095b798-6bfc-4b41-9d1d-19b99a9279bf@eyal.emu.id.au>
From:   eyal@eyal.emu.id.au
In-Reply-To: <a095b798-6bfc-4b41-9d1d-19b99a9279bf@eyal.emu.id.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 01/11/2023 08.44, eyal@eyal.emu.id.au wrote:
> On 31/10/2023 00.35, eyal@eyal.emu.id.au wrote:
>> F38
>>
>> I know this is a bit long but I wanted to provide as much detail as I thought needed.

[trimmed]

Responding with the array details:

mdadm --query
=============
/dev/md127: 54.57TiB raid6 7 devices, 0 spares. Use mdadm --detail for more detail.

mdadm --detail
==============
/dev/md127:
            Version : 1.2
      Creation Time : Fri Oct 26 17:24:59 2018
         Raid Level : raid6
         Array Size : 58593761280 (54.57 TiB 60.00 TB)
      Used Dev Size : 11718752256 (10.91 TiB 12.00 TB)
       Raid Devices : 7
      Total Devices : 6
        Persistence : Superblock is persistent

      Intent Bitmap : Internal

        Update Time : Wed Nov  1 05:09:17 2023
              State : clean, degraded
     Active Devices : 6
    Working Devices : 6
     Failed Devices : 0
      Spare Devices : 0

             Layout : left-symmetric
         Chunk Size : 512K

Consistency Policy : bitmap

               Name : e4.eyal.emu.id.au:127
               UUID : 15d250cf:fe43eafb:5779f3d8:7e79affc
             Events : 4802229

     Number   Major   Minor   RaidDevice State
        -       0        0        0      removed
        8       8       17        1      active sync   /dev/sdb1
        9       8       33        2      active sync   /dev/sdc1
        7       8       49        3      active sync   /dev/sdd1
        4       8       65        4      active sync   /dev/sde1
        5       8       81        5      active sync   /dev/sdf1
        6       8       97        6      active sync   /dev/sdg1

mdadm --examine "/dev/sd?1
==========================
/dev/sdb1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : 15d250cf:fe43eafb:5779f3d8:7e79affc
            Name : e4.eyal.emu.id.au:127
   Creation Time : Fri Oct 26 17:24:59 2018
      Raid Level : raid6
    Raid Devices : 7

  Avail Dev Size : 23437504512 sectors (10.91 TiB 12.00 TB)
      Array Size : 58593761280 KiB (54.57 TiB 60.00 TB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262064 sectors, after=0 sectors
           State : clean
     Device UUID : 4bfcc6d6:165b6a78:b8fad560:51ff21de

Internal Bitmap : 8 sectors from superblock
     Update Time : Wed Nov  1 05:09:17 2023
   Bad Block Log : 512 entries available at offset 56 sectors
        Checksum : d90d6d62 - correct
          Events : 4802229

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 1
    Array State : .AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdc1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : 15d250cf:fe43eafb:5779f3d8:7e79affc
            Name : e4.eyal.emu.id.au:127
   Creation Time : Fri Oct 26 17:24:59 2018
      Raid Level : raid6
    Raid Devices : 7

  Avail Dev Size : 23437504512 sectors (10.91 TiB 12.00 TB)
      Array Size : 58593761280 KiB (54.57 TiB 60.00 TB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262064 sectors, after=0 sectors
           State : clean
     Device UUID : 7fb0b851:c3d0463b:6460ff66:170088b9

Internal Bitmap : 8 sectors from superblock
     Update Time : Wed Nov  1 05:09:17 2023
   Bad Block Log : 512 entries available at offset 56 sectors
        Checksum : f86afdb5 - correct
          Events : 4802229

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 2
    Array State : .AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdd1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : 15d250cf:fe43eafb:5779f3d8:7e79affc
            Name : e4.eyal.emu.id.au:127
   Creation Time : Fri Oct 26 17:24:59 2018
      Raid Level : raid6
    Raid Devices : 7

  Avail Dev Size : 23437504512 sectors (10.91 TiB 12.00 TB)
      Array Size : 58593761280 KiB (54.57 TiB 60.00 TB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262064 sectors, after=0 sectors
           State : clean
     Device UUID : ce5bd1bc:3e5c3054:658888dd:9038e09f

Internal Bitmap : 8 sectors from superblock
     Update Time : Wed Nov  1 05:09:17 2023
   Bad Block Log : 512 entries available at offset 56 sectors
        Checksum : d94e94f8 - correct
          Events : 4802229

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 3
    Array State : .AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sde1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : 15d250cf:fe43eafb:5779f3d8:7e79affc
            Name : e4.eyal.emu.id.au:127
   Creation Time : Fri Oct 26 17:24:59 2018
      Raid Level : raid6
    Raid Devices : 7

  Avail Dev Size : 23437504512 sectors (10.91 TiB 12.00 TB)
      Array Size : 58593761280 KiB (54.57 TiB 60.00 TB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262064 sectors, after=0 sectors
           State : clean
     Device UUID : 4706a5ab:e7cea085:9af96e3a:81ac89b1

Internal Bitmap : 8 sectors from superblock
     Update Time : Wed Nov  1 05:09:17 2023
   Bad Block Log : 512 entries available at offset 56 sectors
        Checksum : 6822973d - correct
          Events : 4802229

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 4
    Array State : .AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdf1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : 15d250cf:fe43eafb:5779f3d8:7e79affc
            Name : e4.eyal.emu.id.au:127
   Creation Time : Fri Oct 26 17:24:59 2018
      Raid Level : raid6
    Raid Devices : 7

  Avail Dev Size : 23437504512 sectors (10.91 TiB 12.00 TB)
      Array Size : 58593761280 KiB (54.57 TiB 60.00 TB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262064 sectors, after=0 sectors
           State : clean
     Device UUID : b1732c74:a34e121d:8347018e:c42b5085

Internal Bitmap : 8 sectors from superblock
     Update Time : Wed Nov  1 05:09:17 2023
   Bad Block Log : 512 entries available at offset 56 sectors
        Checksum : ef74518f - correct
          Events : 4802229

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 5
    Array State : .AAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdg1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : 15d250cf:fe43eafb:5779f3d8:7e79affc
            Name : e4.eyal.emu.id.au:127
   Creation Time : Fri Oct 26 17:24:59 2018
      Raid Level : raid6
    Raid Devices : 7

  Avail Dev Size : 23437504512 sectors (10.91 TiB 12.00 TB)
      Array Size : 58593761280 KiB (54.57 TiB 60.00 TB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262064 sectors, after=0 sectors
           State : clean
     Device UUID : b44b1807:ed20c6f9:ec0436d7:744d144a

Internal Bitmap : 8 sectors from superblock
     Update Time : Wed Nov  1 05:09:17 2023
   Bad Block Log : 512 entries available at offset 56 sectors
        Checksum : 6d0cdaf7 - correct
          Events : 4802229

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 6
    Array State : .AAAAAA ('A' == active, '.' == missing, 'R' == replacing)

HTH

-- 
Eyal at Home (eyal@eyal.emu.id.au)

