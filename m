Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DABAC433F5
	for <linux-raid@archiver.kernel.org>; Thu, 30 Sep 2021 20:54:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B1096124D
	for <linux-raid@archiver.kernel.org>; Thu, 30 Sep 2021 20:54:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348327AbhI3Uzq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 30 Sep 2021 16:55:46 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:34813 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346766AbhI3Uzq (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 30 Sep 2021 16:55:46 -0400
Received: (Authenticated sender: clemens@kiehas.at)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id 94A69100003;
        Thu, 30 Sep 2021 20:54:00 +0000 (UTC)
Message-ID: <39c820d8-f014-ccf4-3bd8-1359551dade1@kiehas.at>
Date:   Thu, 30 Sep 2021 22:53:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: Missing superblock on two disks in raid5
To:     Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
References: <d0350f88-304f-040d-6901-76f72932bbbf@kiehas.at>
 <a66ec5ed-eeba-6c86-24b7-b3fd061082b9@kiehas.at>
 <1241748e-5cfb-474d-3da1-a9f28ed691f2@youngman.org.uk>
From:   Clemens Kiehas <clemens@kiehas.at>
In-Reply-To: <1241748e-5cfb-474d-3da1-a9f28ed691f2@youngman.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Wol,

thank you.
I followed the overlay-procedure for all 7 disks and was able to start 
the array with:
mdadm --create --assume-clean --level=5 --raid-devices=7 /dev/md0 $OVERLAYS

# echo $OVERLAYS
/dev/mapper/sdd /dev/mapper/sdg /dev/mapper/sdh /dev/mapper/sdf1 
/dev/mapper/sde /dev/mapper/sdi /dev/mapper/sdc

# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] 
[raid4] [raid10]
md0 : active raid5 dm-5[6] dm-10[5] dm-8[4] dm-9[3] dm-11[2] dm-7[1] dm-6[0]
       23441316864 blocks super 1.2 level 5, 512k chunk, algorithm 2 
[7/7] [UUUUUUU]
       bitmap: 0/30 pages [0KB], 65536KB chunk

# mdadm --detail /dev/md0
/dev/md0:
            Version : 1.2
      Creation Time : Thu Sep 30 21:57:03 2021
         Raid Level : raid5
         Array Size : 23441316864 (22355.38 GiB 24003.91 GB)
      Used Dev Size : 3906886144 (3725.90 GiB 4000.65 GB)
       Raid Devices : 7
      Total Devices : 7
        Persistence : Superblock is persistent

      Intent Bitmap : Internal

        Update Time : Thu Sep 30 21:57:03 2021
              State : clean
     Active Devices : 7
    Working Devices : 7
     Failed Devices : 0
      Spare Devices : 0

             Layout : left-symmetric
         Chunk Size : 512K

Consistency Policy : bitmap

               Name : titan:0  (local to host titan)
               UUID : 45954f34:4559be76:61d18d85:f9e7ed80
             Events : 0

     Number   Major   Minor   RaidDevice State
        0     253        6        0      active sync   /dev/dm-6
        1     253        7        1      active sync   /dev/dm-7
        2     253       11        2      active sync   /dev/dm-11
        3     253        9        3      active sync   /dev/dm-9
        4     253        8        4      active sync   /dev/dm-8
        5     253       10        5      active sync   /dev/dm-10
        6     253        5        6      active sync   /dev/dm-5

I also examined all overlay-disks and they seem to have proper superblocks:
# mdadm -E /dev/mapper/sdc
/dev/mapper/sdc:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : 45954f34:4559be76:61d18d85:f9e7ed80
            Name : titan:0  (local to host titan)
   Creation Time : Thu Sep 30 21:57:03 2021
      Raid Level : raid5
    Raid Devices : 7

  Avail Dev Size : 7813772976 (3725.90 GiB 4000.65 GB)
      Array Size : 23441316864 (22355.38 GiB 24003.91 GB)
   Used Dev Size : 7813772288 (3725.90 GiB 4000.65 GB)
     Data Offset : 264192 sectors
    Super Offset : 8 sectors
    Unused Space : before=264112 sectors, after=688 sectors
           State : clean
     Device UUID : 10d49408:d28fe8ee:58ce698e:a2d66ac0

Internal Bitmap : 8 sectors from superblock
     Update Time : Thu Sep 30 21:57:03 2021
   Bad Block Log : 512 entries available at offset 24 sectors
        Checksum : 68e54840 - correct
          Events : 0

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 6
    Array State : AAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

But it looks like there is no data on it?
Initially I used LVM to create /dev/md0 as a physical volume, created a 
volume-group with it and a logical volume on it with all free space. 
Either the physical volume doesn't exist in this state, or I don't know 
to use it..
I tried pvs, pvscan, vgscan, dmsetup info, but it won't show up.
Do you think this is just a lvm problem now, or did I miss something?

Best regards,
Clemens

Am 30.09.2021 um 20:11 schrieb Wols Lists:
> On 30/09/2021 18:21, Clemens Kiehas wrote:
>> Hello,
>>
>> until recently I was using Unraid with 8 disks in an XFS array.
>> I installed Debian on a spare SSD on the same machine and started 
>> migrating disk by disk from the Unraid array to a raid5 array using a 
>> second server as temporay storage. So I switched between Debian and 
>> Unraid a lot to copy data and remove/add drives from/to arrays.
>>
>>  From the beginning I always had to assemble the array without 
>> /dev/sdd, add it afterwards and let it rebuild - since the array was 
>> working fine afterwards I didn't really think much of it.
>
> Not wise - as you've found out it was trashing your redundancy ...
>
>> Appearently Unraid always overwrote the superblock of that 1 (and 
>> later 2) disks (/dev/sdc and /dev/sdd) when I switched between the 
>> two OSs and now mdadm isn't recognizing those 2 disks and I can't 
>> assemble the array obviously.
>> At least that's what I think happened, since file tells me that the 
>> first 32k bytes are XFS:
>> # losetup -o 32768 -f /dev/sdd
>> # file -s /dev/loop0
>> /dev/loop0: SGI XFS filesystem data (blksz 4096, inosz 512, v2 dirs)
>
> That feels good, but I'm not sure how to proceed from here.
>>
>> Right now mdadm only assembles 5 (instead of 7) disks as spares into 
>> an inactive array at boot:
>> # cat /proc/mdstat
>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] 
>> [raid4] [raid10]
>> md0 : inactive sde[6](S) sdf1[5](S) sdg[1](S) sdh[3](S) sdi[8](S)
>>        21487980896 blocks super 1.2
>> unused devices: <none>
>>
>> My system:
>> Linux titan 5.10.0-8-amd64 #1 SMP Debian 5.10.46-4 (2021-08-03) 
>> x86_64 GNU/Linux
>> mdadm - v4.1 - 2018-10-01
>>
>> Maybe I could try to assemble it with assume-clean and read-only?
>> I found some pages in the wiki but I'm not 100% sure that they will 
>> solve my problem and I don't want to make things worse.
>> https://raid.wiki.kernel.org/index.php/Recovering_a_damaged_RAID
>> https://raid.wiki.kernel.org/index.php/RAID_Recovery
>>
> The first page talks about overlays. THEY WILL PROTECT YOUR DATA.
>
> Make sure every disk is overlayed, then try assembling the overlays 
> with your assume-clean. You won't need read-only but do it if you like 
> it then do.
>
> If you can then mount and run a fsck or whatever it is over the file 
> system and it says everything is clean, then you can redo it without 
> the overlays and recover the array properly. If it's messed up, just 
> tear down the overlays and you're back where you started.
>
> If it doesn't work, come back and tell us what happened (if it does 
> work, please let us know :-)
>
> Cheers,
> Wol

-- 
MatrNr: 11805432
Mobile: 06642573109
E-Mail: clemens@kiehas.at
Matrix: @clemens:matrix.spacebeard.tech

