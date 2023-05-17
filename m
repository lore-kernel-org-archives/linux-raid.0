Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50EC8C77B75
	for <linux-raid@archiver.kernel.org>; Wed, 17 May 2023 23:46:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbjEQXp7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 17 May 2023 19:45:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjEQXp6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 17 May 2023 19:45:58 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A685A49E8
        for <linux-raid@vger.kernel.org>; Wed, 17 May 2023 16:45:55 -0700 (PDT)
Received: from host86-157-72-252.range86-157.btcentralplus.com ([86.157.72.252] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1pzQq8-0007XA-5T;
        Thu, 18 May 2023 00:45:53 +0100
Message-ID: <96524acc-504d-6a07-85a0-0b56a9e2f2d7@youngman.org.uk>
Date:   Thu, 18 May 2023 00:45:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: RAID5 Phantom Drive Appeared while Reshaping Four Drive Array
 (HARDLOCK)
To:     raid@electrons.cloud, linux-raid@vger.kernel.org
References: <60563747e11acd6757b20ba19006fcdcff5df519.camel@electrons.cloud>
Content-Language: en-GB
From:   Wol <antlists@youngman.org.uk>
Cc:     Yu Kuai <yukuai1@huaweicloud.com>, Phil Turmel <philip@turmel.org>,
        NeilBrown <neilb@suse.com>
In-Reply-To: <60563747e11acd6757b20ba19006fcdcff5df519.camel@electrons.cloud>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hmmm. Firstly, what command did you give to grow the array?

Secondly, take a look at the thread "Raid5 to raid6 grow interrupted, 
mdadm hangs on assemble command". There's a problem there with rebuilds 
locking up, which is not fatal, and will be fixed, but might not have 
rippled through yet ...

That raid0 thing is almost certainly nothing to be worried about - it 
seems to be normal for any array that doesn't assemble completely.

The only things that bother me slightly are I believe mdadm 4.2 has been 
released? Don't quote me on that. And scterc is disabled by default? Weird.

I've cc'd a few people who I hope can help further ...

Cheers,
Wol

On 17/05/2023 14:26, raid wrote:
> RAID5 Phantom Drive Appeared while Reshaping Four Drive Array
> (HARDLOCK)
> 
> I've been struggling with this for about two weeks now, realizing that
> I need some expert help.
> 
> My original 18 month old RAID5 consists of three newer TOSHIBA drives.
> /dev/sdc :: TOSHIBA MG08ACA16TE (4303) :: 16 TB (16,000,900,661,248
> bytes)
> /dev/sdd :: TOSHIBA MG08ACA16TE (4303) :: 16 TB (16,000,900,661,248
> bytes)
> /dev/sde :: TOSHIBA MG08ACA16TE (4002) :: 16 TB (16,000,900,661,248
> bytes)
> 
> Recently added...
> /dev/sdf :: TOSHIBA MG08ACA16TE (4303) :: 16 TB (16,000,900,661,248
> bytes)
> 
> In a nutshell, I've added a fourth drive to my RAID5 and executed --
> grow & mdadm estimated completion in 3-5 days.
> At about 30-50% of reshaping, the computer hard locked. Pushing the
> reset button was the agonizing requirement.
> 
> After first reboot mdadm assembled & continued. But it displayed a
> fifth physical disk.
> The phantom FIFTH drive appeared as failed, while the other four
> continued reshaping, temporarily.
> The reshaping speed dropped to 0 after another day or so. It was near
> 80%, I think.
> So, I used mdadm -S then mdadm --assemble --scan it couldn't start
> (because phantom drive?) not enough
> drives to start the array. The Array State on each member shows the
> fifth drive with varying status.
> 
> File system (ext4) appears damaged and won't mount. Unrecognized
> filesystem.
> 20TB are backed up, there are, however, about 7000 newly scanned
> documents that aren't.
> I've done a cursory examination of data using R-Linux. Abit of in depth
> peeking using Active Disk Editor.
> 
> Life goes on. I've researched and read way more than I ever thought I
> would about mdadm RAID.
> Not any closer on how to proceed. I'm a hardware technician with some
> software skills. I'm stumped.
> Also trying to be cautious not to damage whats left of the RAID. ANY
> help with what commands
> I can attempt to at least get the RAID to assemble WITHOUT the phantom
> fifth drive would be
> immensely appreciated.
> 
> All four drives now appear as spares.
> 
> ---
> watch -c -d -n 1 cat /proc/mdstat
> md480 : inactive sdc1[0](S) sdd1[1](S) sdf1[4](S) sde1[3](S)
>        62502985709 blocks super 1.2
> ---
> uname -a
> Linux OAK2023 4.19.0-24-amd64 #1 SMP Debian 4.19.282-1 (2023-04-29)
> x86_64 GNU/Linux
> ---
> mdadm --version
> mdadm - v4.1 - 2018-10-01
> ---
> mdadm -E /dev/sd[c-f]1
> /dev/sdc1:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x45
>       Array UUID : 20211025:02005a7a:5a7abeef:cafebabe
>             Name : GRANDSLAM:480
>    Creation Time : Tue Oct 26 14:06:53 2021
>       Raid Level : raid5
>     Raid Devices : 5
> 
>   Avail Dev Size : 31251492831 (14901.87 GiB 16000.76 GB)
>       Array Size : 62502983680 (59607.49 GiB 64003.06 GB)
>    Used Dev Size : 31251491840 (14901.87 GiB 16000.76 GB)
>      Data Offset : 264192 sectors
>       New Offset : 261120 sectors
>     Super Offset : 8 sectors
>            State : clean
>      Device UUID : 8f0835db:3ea24540:2ab4232d:6203d1b7
> 
> Internal Bitmap : 8 sectors from superblock
>    Reshape pos'n : 51850891264 (49448.86 GiB 53095.31 GB)
>    Delta Devices : 1 (4->5)
> 
>      Update Time : Thu May  4 14:39:03 2023
>    Bad Block Log : 512 entries available at offset 72 sectors
>         Checksum : 37ac3c04 - correct
>           Events : 78714
> 
>           Layout : left-symmetric
>       Chunk Size : 512K
> 
>     Device Role : Active device 0
>     Array State : AA.A. ('A' == active, '.' == missing, 'R' ==
> replacing)
> /dev/sdd1:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x45
>       Array UUID : 20211025:02005a7a:5a7abeef:cafebabe
>             Name : GRANDSLAM:480
>    Creation Time : Tue Oct 26 14:06:53 2021
>       Raid Level : raid5
>     Raid Devices : 5
> 
>   Avail Dev Size : 31251492831 (14901.87 GiB 16000.76 GB)
>       Array Size : 62502983680 (59607.49 GiB 64003.06 GB)
>    Used Dev Size : 31251491840 (14901.87 GiB 16000.76 GB)
>      Data Offset : 264192 sectors
>       New Offset : 261120 sectors
>     Super Offset : 8 sectors
>            State : clean
>      Device UUID : b4660f49:867b9f1e:ecad0ace:c7119c37
> 
> Internal Bitmap : 8 sectors from superblock
>    Reshape pos'n : 51850891264 (49448.86 GiB 53095.31 GB)
>    Delta Devices : 1 (4->5)
> 
>      Update Time : Thu May  4 14:39:03 2023
>    Bad Block Log : 512 entries available at offset 72 sectors
>         Checksum : a4927b98 - correct
>           Events : 78714
> 
>           Layout : left-symmetric
>       Chunk Size : 512K
> 
>     Device Role : Active device 1
>     Array State : AA.A. ('A' == active, '.' == missing, 'R' ==
> replacing)
> /dev/sde1:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x45
>       Array UUID : 20211025:02005a7a:5a7abeef:cafebabe
>             Name : GRANDSLAM:480
>    Creation Time : Tue Oct 26 14:06:53 2021
>       Raid Level : raid5
>     Raid Devices : 5
> 
>   Avail Dev Size : 31251492831 (14901.87 GiB 16000.76 GB)
>       Array Size : 62502983680 (59607.49 GiB 64003.06 GB)
>    Used Dev Size : 31251491840 (14901.87 GiB 16000.76 GB)
>      Data Offset : 264192 sectors
>       New Offset : 261120 sectors
>     Super Offset : 8 sectors
>            State : clean
>      Device UUID : 79a3dff4:c53f9071:f9c1c262:403fbc10
> 
> Internal Bitmap : 8 sectors from superblock
>    Reshape pos'n : 51850891264 (49448.86 GiB 53095.31 GB)
>    Delta Devices : 1 (4->5)
> 
>      Update Time : Thu May  4 14:38:38 2023
>    Bad Block Log : 512 entries available at offset 72 sectors
>         Checksum : 112fbe09 - correct
>           Events : 78712
> 
>           Layout : left-symmetric
>       Chunk Size : 512K
> 
>     Device Role : Active device 2
>     Array State : AAAA. ('A' == active, '.' == missing, 'R' ==
> replacing)
> /dev/sdf1:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x45
>       Array UUID : 20211025:02005a7a:5a7abeef:cafebabe
>             Name : GRANDSLAM:480
>    Creation Time : Tue Oct 26 14:06:53 2021
>       Raid Level : raid5
>     Raid Devices : 5
> 
>   Avail Dev Size : 31251492926 (14901.87 GiB 16000.76 GB)
>       Array Size : 62502983680 (59607.49 GiB 64003.06 GB)
>    Used Dev Size : 31251491840 (14901.87 GiB 16000.76 GB)
>      Data Offset : 264192 sectors
>       New Offset : 261120 sectors
>     Super Offset : 8 sectors
>            State : clean
>      Device UUID : 9d9c1c0d:030844a7:f365ace6:5e568930
> 
> Internal Bitmap : 8 sectors from superblock
>    Reshape pos'n : 51850891264 (49448.86 GiB 53095.31 GB)
>    Delta Devices : 1 (4->5)
> 
>      Update Time : Thu May  4 14:39:03 2023
>    Bad Block Log : 512 entries available at offset 72 sectors
>         Checksum : 2d33aff - correct
>           Events : 78714
> 
>           Layout : left-symmetric
>       Chunk Size : 512K
> 
>     Device Role : Active device 3
>     Array State : AA.A. ('A' == active, '.' == missing, 'R' ==
> replacing)
> ---
> mdadm -E /dev/sd[c-f]1 | grep -E '^/dev/sd|Update'
> /dev/sdc1:
>      Update Time : Thu May  4 14:39:03 2023
> /dev/sdd1:
>      Update Time : Thu May  4 14:39:03 2023
> /dev/sde1:
>      Update Time : Thu May  4 14:38:38 2023
> /dev/sdf1:
>      Update Time : Thu May  4 14:39:03 2023
> ---
> mdadm --assemble --scan
> mdadm: /dev/md/GRANDSLAM:480 assembled from 3 drives - not enough to
> start the array.
> ---
> /etc/mdadm/mdadm.conf
> # This configuration was auto-generated on Tue, 26 Oct 2021 12:52:33
> -0500 by mkconf
> ARRAY /dev/md480 metadata=1.2 name=GRANDSLAM:480
> UUID=20211025:02005a7a:5a7abeef:cafebabe
> ---
> 
> NOTE: Raid Level is now shown below to be raid0. This is a RAID5.
>        Delta Devices are munged?
> 
> NOW;mdadm -D /dev/md480
>   2023.05.17 02:44:06 AM
> /dev/md480:
>             Version : 1.2
>          Raid Level : raid0
>       Total Devices : 4
>         Persistence : Superblock is persistent
> 
>               State : inactive
>     Working Devices : 4
> 
>       Delta Devices : 1, (-1->0)
>           New Level : raid5
>          New Layout : left-symmetric
>       New Chunksize : 512K
> 
>                Name : GRANDSLAM:480
>                UUID : 20211025:02005a7a:5a7abeef:cafebabe
>              Events : 78714
> 
>      Number   Major   Minor   RaidDevice
> 
>         -       8       81        -        /dev/sdf1
>         -       8       65        -        /dev/sde1
>         -       8       49        -        /dev/sdd1
>         -       8       33        -        /dev/sdc1
> ---
> 
> NOTE: The HITACHI MG08ACA16TE drives default to DISABLED
>        I've since enabled the setting if this helps.
> 
> smartctl -l scterc /dev/sdc; smartctl -l scterc /dev/sdd; smartctl -l
> scterc /dev/sde; smartctl -l scterc /dev/sdf
> 
> smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.19.0-24-amd64] (local
> build)
> Copyright (C) 2002-17, Bruce Allen, Christian Franke,
> www.smartmontools.org
> 
> SCT Error Recovery Control:
>             Read:     70 (7.0 seconds)
>            Write:     70 (7.0 seconds)
> 
> smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.19.0-24-amd64] (local
> build)
> Copyright (C) 2002-17, Bruce Allen, Christian Franke,
> www.smartmontools.org
> 
> SCT Error Recovery Control:
>             Read:     70 (7.0 seconds)
>            Write:     70 (7.0 seconds)
> 
> smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.19.0-24-amd64] (local
> build)
> Copyright (C) 2002-17, Bruce Allen, Christian Franke,
> www.smartmontools.org
> 
> SCT Error Recovery Control:
>             Read:     70 (7.0 seconds)
>            Write:     70 (7.0 seconds)
> 
> smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.19.0-24-amd64] (local
> build)
> Copyright (C) 2002-17, Bruce Allen, Christian Franke,
> www.smartmontools.org
> 
> SCT Error Recovery Control:
>             Read:     70 (7.0 seconds)
>            Write:     70 (7.0 seconds)
> 
> ---
> 
> Exhausted and maybe I'm just looking for someone to suggest running the
> command that I really don't want to run yet.
> 
> Enabling Loss Of Confusion flag hasn't worked either.
> 
