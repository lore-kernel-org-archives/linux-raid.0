Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71C35C433DB
	for <linux-raid@archiver.kernel.org>; Fri, 15 Jan 2021 17:57:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3686D22262
	for <linux-raid@archiver.kernel.org>; Fri, 15 Jan 2021 17:57:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbhAOR5V (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 15 Jan 2021 12:57:21 -0500
Received: from smtp.hosts.co.uk ([85.233.160.19]:11029 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728310AbhAOR5U (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 15 Jan 2021 12:57:20 -0500
Received: from host86-157-192-59.range86-157.btcentralplus.com ([86.157.192.59] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1l0Rqr-000CAM-C5; Fri, 15 Jan 2021 16:21:30 +0000
Subject: Re: Self inflicted reshape catastrophe
To:     Nathan Brown <nbrown.us@gmail.com>, linux-raid@vger.kernel.org,
        Phil Turmel <philip@turmel.org>, NeilBrown <neilb@suse.com>
References: <CAHikZs7DaOj4QAw0VcbidmdrP11pWE-NTcxXDJS=KW9rf0TY7Q@mail.gmail.com>
From:   antlists <antlists@youngman.org.uk>
Message-ID: <89e96c60-1dbd-a039-96ea-4665e437a171@youngman.org.uk>
Date:   Fri, 15 Jan 2021 16:21:30 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <CAHikZs7DaOj4QAw0VcbidmdrP11pWE-NTcxXDJS=KW9rf0TY7Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 14/01/2021 22:57, Nathan Brown wrote:
> Scenario:
> 
> I had a 4 by 10TB raid 5 array and was adding 5 more disks and
> reshaping it to a raid6. This was working just fine until I got a
> little too aggressive with perf tuning and caused `mdadm` to
> completely hang. I froze the rebuild and rebooted the server to wipe
> away my tuning mess. The raid didn't automatically assemble so I did
> `mdadm --assemble` but really screwed up and put the 5 new disks in a
> different array. Not sure why the superblock on those disks didn't
> stop `mdadm` from putting them into service but the end result was the
> superblock on those 5 new drives got wiped. That array was missing a
> disk so 4 went into spare and 1 went into service, I let that rebuild
> complete as I figure I'd likely already lost any usable data there.

Okay. Trying to make sense of what you're saying ... you were trying to 
convert it to a 9-disk raid-6?

Can you remember what you did? The more you can tell us, in detail 
terms, the better, but if you've crashed in the middle of a reshape and 
lost the superblocks, then the omens are not good.

That said, I think we might have succeeded in reconstructing a few arrays...
> 
> I now have 4 disks with proper looking superblocks, 4 disks with
> garbage superblocks, and 1 disk sitting in an array that it shouldn't
> be in. My primary concern is on assembling the 10TB disk array.

Is this the original four disks?
> 
> What I've done so far:
> 
> All this is done with an overlay to avoid modifying the disks any further.
> 
> `mdadm --assemble` if I provide all disks, it will refuse to start as
> it hits the first of the new drives "superblock on ... doesn't match
> others", `--force` has no effect. `--update=revert-reshape` changes
> the `--examine` details but nothing happens since the other 5 drives
> are absent.
> 
> `mdadm --assemble` again with all disks but the new disks super blocks
> have been zero'd. Refuses once it hits the first of the new disks "No
> super block found on ...", `--force` has no effect.
> 
> `mdadm --assemble` using only the 4 original disks, the md dev shows
> up now but can't start. If I try to add any of the new disks I get
> "Cannot get array info for /dev/md#", `--force` and super block
> zeroing has no effect.
> 
> `mdadm --create` using all permutations of the new drives, I believe
> know the order of the old ones. A handful of the 120 different
> arrangements will allow me to see some of the files, but I do not know
> how to move the reshape along in this state. Please note that 1 disk
> position is using `missing`.
> 
> I believe my next best bet is to try and create an appropriate super
> block and write them to each of the new disks to see if it will
> assemble and continue the reshape. I wanted to get this lists
> suggestions before I went down that path.
> 
> Thank you for your time.
> 
> Details:
> 
> `mdadm --version`
> mdadm - v4.1 - 2018-10-01
> 
> `lsb_release -a`
> Distributor ID: Ubuntu
> Description: Ubuntu 20.04.1 LTS
> Release: 20.04
> Codename: focal
> 
> `uname -a`
> Linux nas2 5.4.0-60-generic #67-Ubuntu SMP Tue Jan 5 18:31:36 UTC 2021
> x86_64 x86_64 x86_64 GNU/Linux
> 
> `mdadm -E /dev/sdk1`
> /dev/sdk1:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x5
>       Array UUID : a6914f4a:14a64337:c3546c24:42930ff9
>             Name : any:0
>    Creation Time : Mon Dec 23 22:56:41 2019
>       Raid Level : raid6
>     Raid Devices : 9
>   Avail Dev Size : 19532605440 (9313.87 GiB 10000.69 GB)
>       Array Size : 68364119040 (65197.10 GiB 70004.86 GB)
>      Data Offset : 264192 sectors
>     Super Offset : 8 sectors
>     Unused Space : before=264112 sectors, after=0 sectors
>            State : clean
>      Device UUID : a247b8d7:6abdf354:8ca03a82:8681cf54
> Internal Bitmap : 8 sectors from superblock
>    Reshape pos'n : 1922360832 (1833.31 GiB 1968.50 GB)
>    Delta Devices : 4 (5->9)
>       New Layout : left-symmetric
>      Update Time : Thu Jan 14 02:02:24 2021
>    Bad Block Log : 512 entries available at offset 48 sectors
>         Checksum : 4229db98 - correct
>           Events : 146894
>           Layout : left-symmetric-6
>       Chunk Size : 512K
>     Device Role : Active device 0
>     Array State : AAAA..A.A ('A' == active, '.' == missing, 'R' == replacing)
> 
> mdadm -E /dev/sdj1
> `/dev/sdj1:`
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x5
>       Array UUID : a6914f4a:14a64337:c3546c24:42930ff9
>             Name : any:0
>    Creation Time : Mon Dec 23 22:56:41 2019
>       Raid Level : raid6
>     Raid Devices : 9
>   Avail Dev Size : 19532605440 (9313.87 GiB 10000.69 GB)
>       Array Size : 68364119040 (65197.10 GiB 70004.86 GB)
>      Data Offset : 264192 sectors
>     Super Offset : 8 sectors
>     Unused Space : before=264112 sectors, after=0 sectors
>            State : clean
>      Device UUID : 218773e0:f097e26a:10eb2032:8b0c5f2a
> Internal Bitmap : 8 sectors from superblock
>    Reshape pos'n : 1922360832 (1833.31 GiB 1968.50 GB)
>    Delta Devices : 4 (5->9)
>       New Layout : left-symmetric
>      Update Time : Thu Jan 14 02:02:24 2021
>    Bad Block Log : 512 entries available at offset 48 sectors
>         Checksum : e64ccb33 - correct
>           Events : 146894
>           Layout : left-symmetric-6
>       Chunk Size : 512K
>     Device Role : Active device 1
>     Array State : AAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
> 
> `mdadm -E /dev/sdh1`
> /dev/sdh1:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x5
>       Array UUID : a6914f4a:14a64337:c3546c24:42930ff9
>             Name : any:0
>    Creation Time : Mon Dec 23 22:56:41 2019
>       Raid Level : raid6
>     Raid Devices : 9
>   Avail Dev Size : 19532605440 (9313.87 GiB 10000.69 GB)
>       Array Size : 68364119040 (65197.10 GiB 70004.86 GB)
>      Data Offset : 264192 sectors
>     Super Offset : 8 sectors
>     Unused Space : before=264112 sectors, after=0 sectors
>            State : clean
>      Device UUID : e8062d92:654dc1e0:4e28b361:eb97ccc2
> Internal Bitmap : 8 sectors from superblock
>    Reshape pos'n : 1922360832 (1833.31 GiB 1968.50 GB)
>    Delta Devices : 4 (5->9)
>       New Layout : left-symmetric
>      Update Time : Thu Jan 14 02:02:24 2021
>    Bad Block Log : 512 entries available at offset 48 sectors
>         Checksum : d5e4c90f - correct
>           Events : 146894
>           Layout : left-symmetric-6
>       Chunk Size : 512K
>     Device Role : Active device 2
>     Array State : AAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
> 
> `mdadm -E /dev/sdi1`
> /dev/sdi1:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x5
>       Array UUID : a6914f4a:14a64337:c3546c24:42930ff9
>             Name : any:0
>    Creation Time : Mon Dec 23 22:56:41 2019
>       Raid Level : raid6
>     Raid Devices : 9
>   Avail Dev Size : 19532605440 (9313.87 GiB 10000.69 GB)
>       Array Size : 68364119040 (65197.10 GiB 70004.86 GB)
>      Data Offset : 264192 sectors
>     Super Offset : 8 sectors
>     Unused Space : before=264112 sectors, after=0 sectors
>            State : clean
>      Device UUID : f0612be8:dcf9d96b:1926ce52:484d9ab2
> Internal Bitmap : 8 sectors from superblock
>    Reshape pos'n : 1922360832 (1833.31 GiB 1968.50 GB)
>    Delta Devices : 4 (5->9)
>       New Layout : left-symmetric
>      Update Time : Thu Jan 14 02:02:24 2021
>    Bad Block Log : 512 entries available at offset 48 sectors
>         Checksum : 97e483b8 - correct
>           Events : 146894
>           Layout : left-symmetric-6
>       Chunk Size : 512K
>     Device Role : Active device 3
>     Array State : AAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
> 
> If assembled with only the 4 disks with appropriate super blocks I get
> `mdadm --detail /dev/md0`
> /dev/md0:
>             Version : 1.2
>          Raid Level : raid0
>       Total Devices : 4
>         Persistence : Superblock is persistent
>               State : inactive
>     Working Devices : 4
>       Delta Devices : 4, (-4->0)
>           New Level : raid6
>          New Layout : left-symmetric
>       New Chunksize : 512K
>                Name : any:0
>                UUID : a6914f4a:14a64337:c3546c24:42930ff9
>              Events : 146894
>      Number   Major   Minor   RaidDevice
>         -     253        7        -        /dev/dm-7
>         -     253        5        -        /dev/dm-5
>         -     253        6        -        /dev/dm-6
>         -     253        4        -        /dev/dm-4
> 
Have you looked at
https://raid.wiki.kernel.org/index.php/Linux_Raid#When_Things_Go_Wrogn

You've given us a pretty good problem report, but lsdrv (over all 9 
drives) would be a help, and can you give us a brief smartctl report 
over the drives? That probably won't tell us anything, but you never know...

I've added Phil and Neil to the "to" line because I'm out of my depth 
here. They know a lot more than I do so hopefully they'll step in and help.

Cheers,
Wol
