Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D795C7EE22
	for <linux-raid@archiver.kernel.org>; Sat,  6 May 2023 22:28:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbjEFW06 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 6 May 2023 18:26:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbjEFW04 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 6 May 2023 18:26:56 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5C9C1BD4
        for <linux-raid@vger.kernel.org>; Sat,  6 May 2023 15:26:54 -0700 (PDT)
Received: from host86-157-72-252.range86-157.btcentralplus.com ([86.157.72.252] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1pvQMe-0000m9-CG;
        Sat, 06 May 2023 23:26:53 +0100
Message-ID: <ab20e20d-40b4-98fb-8be8-7eba6ce9ee54@youngman.org.uk>
Date:   Sat, 6 May 2023 23:26:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: Second of 3 drives in RAID5 missing
Content-Language: en-GB
To:     Alex Elder <elder@ieee.org>, linux-raid@vger.kernel.org
References: <d11acbac-a31b-b38c-8e10-b664ec52a47b@ieee.org>
From:   Wol <antlists@youngman.org.uk>
In-Reply-To: <d11acbac-a31b-b38c-8e10-b664ec52a47b@ieee.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 06/05/2023 17:28, Alex Elder wrote:
> I have a 3-drive RAID5 that I set up more than 5 years ago.
> At some point, the "middle" drive failed (hardware failure).
> I bought a replacement and issued some commands to attempt
> to recover, and did *something* wrong.  I was too busy to
> spend time to fix this then, and one thing led to another,
> and now it's 2023 and I'd like to fire the array up again.
> 
> The current state is that /dev/md127 gets created automatically
> and it contains the two good disks (partitions).  I'm pretty
> sure this should be easy enough to recover if I issue the
> right commands to rebuild things.
> 
> The disks are 8TB Seagate Ironwolf drives. (ST8000VN0022-2EL)
> They are partitioned identically, with a GPT label.  The first
> partition starts at offset 2048 sectors and continues to the end.
> The RAID device was originally created with this command:
>    mdadm --create /dev/md/z --level=5 --raid-devices=3 /dev/sd{b,c,d}1
> 
> I'm going to provide the output of a few commands below, and
> will gladly provide whatever other information is required
> to get this fixed.
> 
> Thank you.
> 
>                      -Alex

https://raid.wiki.kernel.org/index.php/Linux_Raid
> 
> root@meat:/# mdadm --version
> mdadm - v4.2 - 2021-12-30 - Ubuntu 4.2-3ubuntu1
> root@meat:/#
> 
> root@meat:/# mdadm --detail --scan
> INACTIVE-ARRAY /dev/md127 metadata=1.2 name=meat:z 
> UUID=8a021a34:f19bbc01:7bcf6f8e:3bea43a9
> root@meat:/#
> 
> root@meat:/# mdadm --detail /dev/md127
> /dev/md127:
>             Version : 1.2
>          Raid Level : raid5
>       Total Devices : 2
>         Persistence : Superblock is persistent
> 
>               State : inactive
>     Working Devices : 2
> 
>                Name : meat:z  (local to host meat)
>                UUID : 8a021a34:f19bbc01:7bcf6f8e:3bea43a9
>              Events : 9534
> 
>      Number   Major   Minor   RaidDevice
> 
>         -       8       49        -        /dev/sdd1
>         -       8       17        -        /dev/sdb1
> root@meat:/#

So the raid array doesn't know about sdc.
> 
> root@meat:/# ls -l /dev/sd[bcd]1
> brw-rw---- 1 root disk 8, 17 May  6 11:20 /dev/sdb1
> brw-rw---- 1 root disk 8, 33 May  6 11:20 /dev/sdc1
> brw-rw---- 1 root disk 8, 49 May  6 11:20 /dev/sdd1
> root@meat:/#
> 
> =========== Here's the disk that got replaced
> root@meat:/# mdadm --examine /dev/sdc1
> mdadm: No md superblock detected on /dev/sdc1.
> root@meat:/#

Nor does sdc know about the array.
> 
> =========== Here are the other two  disks
> root@meat:/# mdadm --examine /dev/sd[bd]1
> /dev/sdb1:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x1
>       Array UUID : 8a021a34:f19bbc01:7bcf6f8e:3bea43a9
>             Name : meat:z  (local to host meat)
>    Creation Time : Sun Oct 22 21:19:23 2017
>       Raid Level : raid5
>     Raid Devices : 3
> 
>   Avail Dev Size : 15627786240 sectors (7.28 TiB 8.00 TB)
>       Array Size : 15627786240 KiB (14.55 TiB 16.00 TB)
>      Data Offset : 262144 sectors
>     Super Offset : 8 sectors
>     Unused Space : before=262064 sectors, after=0 sectors
>            State : clean
>      Device UUID : 4cd855b7:ecba9064:b74a2182:bbc8a994
> 
> Internal Bitmap : 8 sectors from superblock
>      Update Time : Sun Dec 13 16:51:21 2020
>    Bad Block Log : 512 entries available at offset 40 sectors
>         Checksum : be977447 - correct
>           Events : 9534
> 
>           Layout : left-symmetric
>       Chunk Size : 512K
> 
>     Device Role : Active device 0
>     Array State : AAA ('A' == active, '.' == missing, 'R' == replacing)

Odd ... although this is possibly because the array is inactive so the 
drive hasn't realised sdc has gone AWOL ...

> /dev/sdd1:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x1
>       Array UUID : 8a021a34:f19bbc01:7bcf6f8e:3bea43a9
>             Name : meat:z  (local to host meat)
>    Creation Time : Sun Oct 22 21:19:23 2017
>       Raid Level : raid5
>     Raid Devices : 3
> 
>   Avail Dev Size : 15627786240 sectors (7.28 TiB 8.00 TB)
>       Array Size : 15627786240 KiB (14.55 TiB 16.00 TB)
>      Data Offset : 262144 sectors
>     Super Offset : 8 sectors
>     Unused Space : before=262064 sectors, after=0 sectors
>            State : clean
>      Device UUID : 1d2ce616:943d0c86:fa9ef8ad:87e31be0
> 
> Internal Bitmap : 8 sectors from superblock
>      Update Time : Sun Dec 13 16:51:21 2020
>    Bad Block Log : 512 entries available at offset 40 sectors
>         Checksum : b6ece242 - correct
>           Events : 9534
> 
>           Layout : left-symmetric
>       Chunk Size : 512K
> 
>     Device Role : Active device 2
>     Array State : AAA ('A' == active, '.' == missing, 'R' == replacing)
> root@meat:/#
> 
Same again.

Okay, the first thing I would do is add sdc1 again. Does sdc1 actually 
exist? Possibly what you did wrong was forget to create it?

What I'm hoping is that this will then trigger a rebuild and everything 
will be hunky-dory.

What MIGHT happen, though, is that you end up with an inactive array 
with two active drives and a spare. At which point it should simply be a 
matter of activating the array (snag is, I'm not sure how). The fact the 
array was inactivated is a safety feature - whatever went wrong, md 
realised that something wasn't right and inactivated the array to 
protect it.

So to sum up, I'm expecting just re-adding sdc1 (because the add clearly 
failed last time) will trigger a rebuild, at which point the array will 
be clean and should just reactivate.

If that doesn't succeed, it won't do any damage, but will need someone 
with more knowledge than me for the final steps.

Cheers,
Wol
