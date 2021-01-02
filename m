Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8ED7C433DB
	for <linux-raid@archiver.kernel.org>; Sat,  2 Jan 2021 20:04:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 891D320796
	for <linux-raid@archiver.kernel.org>; Sat,  2 Jan 2021 20:04:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726662AbhABUEg (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 2 Jan 2021 15:04:36 -0500
Received: from smtp.hosts.co.uk ([85.233.160.19]:12189 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726648AbhABUEe (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sat, 2 Jan 2021 15:04:34 -0500
Received: from host86-158-105-41.range86-158.btcentralplus.com ([86.158.105.41] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1kvmdm-0000rX-EL; Sat, 02 Jan 2021 19:32:43 +0000
Subject: Re: Raid working but stuck at 99.9%
To:     Teejay <teejay@gizzy.co.uk>, linux-raid@vger.kernel.org
References: <11a6cdb6-ab69-ec4d-8ffb-b92d80d5b03f@gizzy.co.uk>
From:   antlists <antlists@youngman.org.uk>
Message-ID: <0d41bab4-e051-cccb-3a63-e77c258ef78f@youngman.org.uk>
Date:   Sat, 2 Jan 2021 19:32:43 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <11a6cdb6-ab69-ec4d-8ffb-b92d80d5b03f@gizzy.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 02/01/2021 12:37, Teejay wrote:
> Hi,
> 
> Firstly I should say I am very new to RAID and this is my first post, so 
> please forgive naive questions and woolly thinking!
> 
> I have been running a RAID 0 array on three 4TB drives for some time 
> with no issue. However, I have always been a little concerned that I had 
> no redundancy so I purchased another two drives, same type and size, 
> with the plan of growing the array from 12TB to 16TB and introducing 
> RAID5. What seemed like a good idea turned out to be a bit of a nightmare!

Raid 0? Not that good an idea ... bear in mind in this case 
probabilities add up - you've just TREBLED your chances of losing your 
data to a disk failure ...
> 
> To upgrade the array I used the following command:
> 
> sudo mdadm --grow /dev/md0 --level=5 --raid-devices=5 --add /dev/sde 
> /dev/sdf --backup-file=/tmp/grow_md0.bak
> 
> To my surprise it returned almost instantly with no errors. So I had a 
> look at the status:
> 
> less /proc/mdstat
> 
> and it came back as being a raid 5 array and stated that it was reshape 
> = 0.01% and would take several million minutes to complete! Somewhat 
> concerned, I left it for half an hour and tried again only to find that 
> the number of complete blocks was the same and the time had grown to an 
> even more crazy number. It was clear the process had stalled.

uname -a ?
mdadm --version ?

This sounds similar to a problem we've regularly seen with raid-5. And 
it's noticeable with older Ubuntus.
> 
> I tried to stop the array and the command just hang. After some time I 
> forced a power down and rebooted (could not figure what else to do!)
> 
> When the machine came back up, it did not assemble (as I had not updated 
> the mdadm.conf

This *shouldn't* make any difference ...

> so I ran the following:
> 
> lounge@lounge:~$ sudo blkid
> [sudo] password for lounge:
> /dev/sda1: UUID="314a0be6-e180-4dc3-8439-b5a84ee7f4a5" TYPE="ext4" 
> PARTUUID="e01c24f7-01"
> /dev/loop0: TYPE="squashfs"
> /dev/loop1: TYPE="squashfs"
> /dev/loop2: TYPE="squashfs"
> /dev/loop3: TYPE="squashfs"
> /dev/loop4: TYPE="squashfs"
> /dev/loop5: TYPE="squashfs"
> /dev/loop6: TYPE="squashfs"
> /dev/loop7: TYPE="squashfs"
> /dev/sdc: UUID="5e89b9c4-dbdd-62a9-6bcc-20e02f58cdd2" 
> UUID_SUB="7b17180b-6db1-675b-d208-84d43a3eb154" LABEL="lounge:0" 
> TYPE="linux_raid_member"
> /dev/sdb: UUID="5e89b9c4-dbdd-62a9-6bcc-20e02f58cdd2" 
> UUID_SUB="c36a1dcd-e199-0ca5-3a89-7e6b298c9240" LABEL="lounge:0" 
> TYPE="linux_raid_member"
> /dev/sdd: UUID="5e89b9c4-dbdd-62a9-6bcc-20e02f58cdd2" 
> UUID_SUB="2dc33f33-e2de-4c7d-d5e2-6006640b4e38" LABEL="lounge:0" 
> TYPE="linux_raid_member"
> /dev/sde: UUID="5e89b9c4-dbdd-62a9-6bcc-20e02f58cdd2" 
> UUID_SUB="a41557e2-f35b-8acb-0203-281cafd5c18e" LABEL="lounge:0" 
> TYPE="linux_raid_member"
> /dev/sdf: UUID="5e89b9c4-dbdd-62a9-6bcc-20e02f58cdd2" 
> UUID_SUB="7951f3fc-d111-65ef-dc28-11befcdc4769" LABEL="lounge:0" 
> TYPE="linux_raid_member"
> 
> I then modified my config file as follows:
> 
> ARRAY /dev/md/0  level=raid5 metadata=1.2 num-devices=5: 
> UUID=5e89b9c4:dbdd62a9:6bcc20e0:2f58cdd2 name=lounge:0
>     devices=/dev/sdb,/dev/sdc,/dev/sdd,/dev/sde,/dev/sdf
> MAILADDR root
> 
> and the ran the assemble command
> 
> sudo mdadm --assemble --verbose /dev/md0
> 
> It assembled fine, but the same thing happened, the reshape hang, so I 
> hit google. Anyway to cut a long story short (post a lot of googling) I 
> have determined that the drives that I am using are the dreaded SMR and 
> that is probably why it all locked up (I wish I had found the wiki 
> first!!!)

Ahhhhh ... you MAY be able to RMA them. What are they? If they're WD 
Reds I'd RMA them as a matter of course as "unfit for purpose". If 
they're BarraCudas, well, tough luck but you might get away with it.
> 
> so I figured I needed to abort the reshape and following some advice 
> posted on some forum I tried:
> 
> sudo mdadm --assemble --update=revert-reshape /dev/md0
> 
> It told me it had done it but needed a backup file name so I tried:
> 
> sudo mdadm --assemble --verbose --backup-file=/tmp/reshape.backup /dev/md0

DON'T use a backup file unless it tells you it needs it. Usually it 
doesn't, now, if you're adding space I believe it dumps the backup in 
the new space that will become available.
> 
> The situation I am now is the array will assemble, but with one drive 
> missing (not sure why) and the reshape is stuck at 99.9%
> 
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] 
> [raid4] [raid10]
> md0 : active raid5 sdf[4] sdb[2] sdd[1] sdc[0]
>        11720658432 blocks super 1.2 level 5, 512k chunk, algorithm 2 
> [4/3] [UUU_]
>        [===================>.]  reshape = 99.9% (3906632192/3906886144) 
> finish=1480857.6min speed=0K/sec
> 
> unused devices: <none>

So we have a four-drive raid 5. Not bad. Does that include one of the 
SMR drives?!?
> 
> The good news is that if I mount the array (read only) it seems to be 
> intact, I tried watching a movie and it seems good. Also fsck reports 
> that the filesystem is clean. I have not had the courage to force a full 
> check as I do not wish to write anything to it while it is in this state.
> 
> This is the output of  sudo mdadm -D /dev/md0
> /dev/md0:
>             Version : 1.2
>       Creation Time : Sun Aug 16 16:43:19 2020
>          Raid Level : raid5
>          Array Size : 11720658432 (11177.69 GiB 12001.95 GB)
>       Used Dev Size : 3906886144 (3725.90 GiB 4000.65 GB)
>        Raid Devices : 4
>       Total Devices : 4
>         Persistence : Superblock is persistent
> 
>         Update Time : Sat Jan  2 11:48:45 2021
>               State : clean, degraded, reshaping
>      Active Devices : 4
>     Working Devices : 4
>      Failed Devices : 0
>       Spare Devices : 0
> 
>              Layout : left-symmetric
>          Chunk Size : 512K
> 
> Consistency Policy : resync
> 
>      Reshape Status : 99% complete
>       Delta Devices : -1, (5->4)
>          New Layout : parity-last
> 
>                Name : lounge:0  (local to host lounge)
>                UUID : 5e89b9c4:dbdd62a9:6bcc20e0:2f58cdd2
>              Events : 876
> 
>      Number   Major   Minor   RaidDevice State
>         0       8       32        0      active sync /dev/sdc
>         1       8       48        1      active sync /dev/sdd
>         2       8       16        2      active sync /dev/sdb
>         -       0        0        3      removed
> 
>         4       8       80        4      active sync /dev/sdf
> 
> 
> so it looks like it attempting to become a RAID 4 array (parity-last?) 
> and had got stuck. It is not hung just in this state of limbo.
> 
> I am not sure what I can do. It would seem my drives are not any good 
> for RAID, although everything seemed fine while at level 0 since the 
> offset (Maybe I got lucky).

Okay. What are those drives? I'm *guessing* your original three drives 
were WD Reds. What is the type number? If they're Reds this ends in EFAX 
or EFRX, if I remember correctly. I think EFAX are good and EFRX are 
bad. It could be the other way round ...

> I need to somehow get back to a useful 
> state. If I could get back to level 0 with three drives that would be 
> great. I could then delete some junk and then backup the data the other 
> two drives using rsync or something.
> 
> So I guess my questions are
> 
> 1 - Can I safely get back to a three drive level 0 RAID thereby freeing 
> the two drives I added to allow me to make a backup of the data?

I'll let others comment.

> 2 - Even if I can revert, should I move my data and no longer even use 
> RAID 0 until I can get some decent hard drives?

Don't mess with it yet.

> 3 - Any other cunning ideas, at the moment I think my only option, if I 
> can't revert, which is to buy many TB's of storage to back up the read 
> only file system, which I can ill afford to do!

What I personally would do is - if the old drives are okay and you can 
RMA the two new ones - RMA one of them and swap it for a BarraCuda 12TB. 
I think a 4TB Red is about £100 and a 12TB BarraCuda is about £200. Yes 
I know BarraCudas are SMR, but this is a backup drive, so it doesn't 
really matter. RMA the other and swap it for a 4TB IronWolf.

Timing here is the problem - one drive you want to RMA is currently in 
the array, and you don't want to return it until you've got both new 
drives. Get the BarraCuda and back up the array first. Then ADD the 
IronWolf using "mdadm --replace /dev/smr --with /dev/ironwolf". The 
other possibility is, IFF it was a shop and you can go in person, they 
might be able to copy the data from one drive to the other - "dd -if 
/dev/Red -of /dev/IronWolf". That will at least keep your data safe AND 
REDUNDANT.

(Oh, and if you're returning £200 of drives and swapping it for £300, 
they might decide to be kind ... :-)
> 
> Any advice would be great. Where I am now, I think my data is safe-ish 
> (baring a drive failure!). I just need to make it safer the best way 
> possible, while not valuable, it will take many hundreds of hours to 
> rebuild from scratch. I also need to end up with a system I can write 
> too and trust.
> 
That should stream all the data off the SMR drive on to the IronWolf and 
you should end up with a properly working array ... (although if the 
shop copied it, this will be irrelevant.)

(I'd put LVM on the BarraCuda, so you can then use an "inplace rsync" to 
take incremental backups - remember RAID IS NOT A BACKUP.)

NB - if you found the wiki, why didn't you follow its advice ...
https://raid.wiki.kernel.org/index.php/Linux_Raid#When_Things_Go_Wrogn
There's a reason we ask for all that information ;-) which is why I've 
asked you for a lot of the information you should have supplied already 
:-) Yes it's a lot we ask for, but I'm guessing a lot here, and guesses 
aren't a good idea for your data ...

Cheers,
Wol
