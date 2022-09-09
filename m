Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4419ECAAD3
	for <linux-raid@archiver.kernel.org>; Fri,  9 Sep 2022 21:49:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbiIIVtB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 9 Sep 2022 17:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231709AbiIIVtA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 9 Sep 2022 17:49:00 -0400
Received: from hermes.turmel.org (hermes.turmel.org [IPv6:2604:180:f1::1e9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F786125B13
        for <linux-raid@vger.kernel.org>; Fri,  9 Sep 2022 14:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=turmel.org;
         s=a; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:References:Cc
        :To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=g2DIIBZ8f2uq6I0+f0po71RCRnTk7wqU9x5Y9fmt9g0=; b=PPBF2UjITFZ/CbfEVZj2fXDQwW
        LhvxKOvayUreysqHBLWUFBt+Oy7SHALK/0dJNhZ8QIZSVPQhw2KlE3EYVVPdntyLCcxIHRQZ8FZN+
        MVokIN3Q2lzS8YnP1x2QYBGYspCoE+qM3sZljZQU+nhKhyTcHqZaQzvklpQIyfKfVcadpXt/7azdD
        uD8NN+TT0PrkvYjLBmYeSmwcVz2nohPaXW2a/eoIjk+q9XtUzrqmTY/r25cDaZ3Hc80cReutvfyir
        c+iXYmB0kFkaDAXwMH9QKW/Hdk9YpmO1yhRlvSnA+xoRvXEr31CjCs/1/SEyKhdrqQXODYqMAYZRH
        V5ZOJKHQ==;
Received: from c-98-192-104-236.hsd1.ga.comcast.net ([98.192.104.236] helo=[192.168.19.197])
        by hermes.turmel.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <philip@turmel.org>)
        id 1oWlrt-0004Wz-HI; Fri, 09 Sep 2022 21:48:57 +0000
Message-ID: <df503250-7c8e-d6f7-21fd-2fe4f1cae961@turmel.org>
Date:   Fri, 9 Sep 2022 17:48:56 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: RAID5 failure and consequent ext4 problems
Content-Language: en-US
To:     Luigi Fabio <luigi.fabio@gmail.com>
Cc:     linux-raid@vger.kernel.org
References: <CAJJqR20U=OcMq_8wBMQ5xmWmcBcYoKN5+Fe9sPHYPkZ_yHurQQ@mail.gmail.com>
 <e8b44f4a-b6ae-6912-1b26-f900a24204af@turmel.org>
 <CAJJqR209OzydScj2jScKvKBR=B6d5JErfaFg=4qcSuC7aEvHEg@mail.gmail.com>
 <CAJJqR22EWec7gMwtVZCxxWc4-w9fEp8jaHWmtENwsLYSi7G5PQ@mail.gmail.com>
From:   Phil Turmel <philip@turmel.org>
In-Reply-To: <CAJJqR22EWec7gMwtVZCxxWc4-w9fEp8jaHWmtENwsLYSi7G5PQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Reasonably likely, but not certain.

Devices can be re-ordered by different kernels.  That's why lsdrv prints 
serial numbers in its tree.

You haven't mentioned whether your --create operations specified 
--assume-clean.

Also, be aware that shell expansion of something like /dev/sd[dcbaefgh] 
is sorted to /dev/sd[abcdefgh].  Use curly brace expansion with commas 
if you are taking shortcuts.

On 9/9/22 17:01, Luigi Fabio wrote:
> Another helpful datapoint, this is the boot *before* sdc got
> --replaced with sdo:
> 
> [   13.528395] md/raid:md123: device sdd1 operational as raid disk 5
> [   13.528396] md/raid:md123: device sde1 operational as raid disk 9
> [   13.528397] md/raid:md123: device sdg1 operational as raid disk 2
> [   13.528398] md/raid:md123: device sdf1 operational as raid disk 1
> [   13.528398] md/raid:md123: device sdh1 operational as raid disk 4
> [   13.528399] md/raid:md123: device sdk1 operational as raid disk 3
> [   13.528400] md/raid:md123: device sdj1 operational as raid disk 7
> [   13.528401] md/raid:md123: device sdn1 operational as raid disk 10
> [   13.528402] md/raid:md123: device sdi1 operational as raid disk 8
> [   13.528402] md/raid:md123: device sdl1 operational as raid disk 6
> [   13.528403] md/raid:md123: device sdm1 operational as raid disk 11
> [   13.528403] md/raid:md123: device sdc1 operational as raid disk 0
> [   13.531613] md/raid:md123: raid level 5 active with 12 out of 12
> devices, algorithm 2
> [   13.531644] md123: detected capacity change from 0 to 42945088192512
> 
> This gives us, correct me if I am wrong of course, an exact
> representation of what the array 'used to look like', with sdc1 then
> replaced by sdo1 (8/225).
> 
> Just some confirmation that the order should (?) be the one above.
> 
> LF
> 
> On Fri, Sep 9, 2022 at 4:32 PM Luigi Fabio <luigi.fabio@gmail.com> wrote:
>>
>> Thanks for reaching out, first of all. Apologies for the late reply,
>> the brilliant (...) spam filter strikes again...
>>
>> On Thu, Sep 8, 2022 at 1:23 PM Phil Turmel <philip@turmel.org> wrote:
>>> No, the moment of stupid was that you re-created the array.
>>> Simultaneous multi-drive failures that stop an array are easily fixed
>>> with --assemble --force.  Too late for that now.
>> Noted for the future, thanks.
>>
>>> It is absurdly easy to screw up device order when re-creating, and if
>>> you didn't specify every allocation and layout detail, the changes in
>>> defaults over the years would also screw up your data.  And finally,
>>> omitting --assume-clean would cause all of your parity to be
>>> recalculated immediately, with catastrophic results if any order or
>>> allocation attributes are wrong.
>> Of course. Which is why I specified everything and why I checked the
>> details with --examine and --detail and they match exactly, minus the
>> metadata version because, well, I wasn't actually the one typing (it's
>> a slightly complicated story.. I was reassembling by proxy on the
>> phone) and I made an incorrect assumption about the person typing.
>> There aren't, in the end, THAT many things to specify: RAID level,
>> number of drives, order thereof, chunk size, 'layout' and metadata
>> version. 0.90 doesn't allow before/after gaps so that should be it, I
>> believe.
>> Am I missing anything?
>>
>>> No, you just got lucky in the past.  Probably by using mdadm versions
>>> that hadn't been updated.
>> That's not quite it: I keep records of how arrays are built and match
>> them, though it is true that I tend to update things as little as
>> possible on production machines.
>> One of the differences, this time, is that this was NOT a production
>> machine. The other was that I was driving, dictating on the phone and
>> was under a lot of pressure to get the thing back up ASAP.
>> Nonetheless, I have an --examine of at least two drives from the
>> previous setup so there should be enough information there to rebuild
>> a matching array, I think?
>>
>>> You'll need to show us every command you tried from your history, and
>>> full details of all drives/partitions involved.
>>>
>>> But I'll be brutally honest:  your data is likely toast.
>> Well, let's hope it isn't. All mdadm commands were -o and
>> --assume-clean, so in theory the only thing which HAS been written are
>> the md blocks, unless I am mistaken and/or I read the docs
>> incorrectly?
>>
>> That does, of course, leave the problem of the blocks overwritten by
>> the 1.2 metadata, but as I read the docs that should be a very small
>> number - let's say one 4096byte block (a portion thereof, to be
>> pedantic, but ext4 doesn't really care?) per drive, correct?
>>
>> Background:
>> Separate 2x SSD RAID 1 root (/dev/sda. /dev/sdb) on the MB (Supemicro
>> X10 series)'s chipset SATA ports.
>> All filesystems are ext4, data=journal, nodelalloc, the 'data' RAIDs
>> have journals on another SSD RAID1 (one per FS, obviously).
>> Data drives:
>> 12 x 4'TB' Seagate drives, NC000n variety, on 2x LSI 2308 controllers,
>> each with two four-drive ports (and one of these went DELIGHTFULLY
>> missing)
>>
>> This is the layout of each drive:
>> ---
>> GPT fdisk (gdisk) version 1.0.6
>> ...
>> Found valid GPT with protective MBR; using GPT.
>> Disk /dev/sdc: 7814037168 sectors, 3.6 TiB
>> Model: ST4000NC001-1FS1
>> Sector size (logical/physical): 512/4096 bytes
>> ...
>> Total free space is 99949 sectors (48.8 MiB)
>>
>> Number  Start (sector)    End (sector)  Size       Code  Name
>>     1            2048      7625195519   3.5 TiB     8300  Linux RAID volume
>>     2      7625195520      7813939199   90.0 GiB    8300  Linux RAID backup
>> ---
>>
>> So there were two RAID arrays. Both RAID5 - a main RAID called
>> 'archive' which had the 12 x 3.5ish partitions sdx1 and a second array
>> called backup which had 12 x 90 GB.
>>
>> A little further backstory: right before the event, one drive had been
>> pulled because it had started failing. What I did was shut down the
>> machine, put the failing drive on a MB port and put a new drive on the
>> LSI controllers. I then brought the machine back online, did the
>> --replace --with thing and this worked fine.
>> At that point the faulty drive (/dev/sdc, MB drives come before the
>> LSI drives in the count) got deleted via /sys/block.... and physically
>> disconnected from the system, which was then happily running with
>> /dev/sda and /dev/sdb as the root RAID SSDs and drives sdd -> sdo as
>> the 'archive' drives.
>> It went 96 hours or so like that under moderate load. Then the failure
>> happened, the machine was rebooted thus the previous sdd -> sdo drives
>> became sdc -> sdn drives.
>> However, the relative order was, to the best of my knowledge,
>> conserved - AND I still have the 'faulty' drive, so I could very
>> easily put it back in to have everything match.
>> Most importantly, this drive has on it, without a doubt, the details
>> of the array BEFORE everything happened - by definition untouched
>> because the drive was stopped and pulled before the event.
>> I also have a cat of the --examine of two of the faulty drives BEFORE
>> anything was written to them - thus, unless I am mistaken, these
>> contained the md block details from 'before the event'.
>>
>> Here is one of them, taken after the reboot and therefore when the MB
>> /dev/sdc was no longer there:
>> ---
>> /dev/sdc1:
>>            Magic : a92b4efc
>>          Version : 0.90.00
>>             UUID : 2457b506:85728e9d:c44c77eb:7ee19756
>>    Creation Time : Sat Mar 30 18:18:00 2019
>>       Raid Level : raid5
>>    Used Dev Size : -482370688 (3635.98 GiB 3904.10 GB)
>>       Array Size : 41938562688 (39995.73 GiB 42945.09 GB)
>>     Raid Devices : 12
>>    Total Devices : 12
>> Preferred Minor : 123
>>
>>      Update Time : Tue Sep  6 11:37:53 2022
>>            State : clean
>>   Active Devices : 12
>> Working Devices : 12
>>   Failed Devices : 0
>>    Spare Devices : 0
>>         Checksum : 391e325d - correct
>>           Events : 52177
>>
>>           Layout : left-symmetric
>>       Chunk Size : 128K
>>
>>        Number   Major   Minor   RaidDevice State
>> this     5       8       49        5      active sync   /dev/sdd1
>>
>>     0     0       8      225        0      active sync
>>     1     1       8       81        1      active sync   /dev/sdf1
>>     2     2       8       97        2      active sync   /dev/sdg1
>>     3     3       8      161        3      active sync   /dev/sdk1
>>     4     4       8      113        4      active sync   /dev/sdh1
>>     5     5       8       49        5      active sync   /dev/sdd1
>>     6     6       8      177        6      active sync   /dev/sdl1
>>     7     7       8      145        7      active sync   /dev/sdj1
>>     8     8       8      129        8      active sync   /dev/sdi1
>>     9     9       8       65        9      active sync   /dev/sde1
>>    10    10       8      209       10      active sync   /dev/sdn1
>>    11    11       8      193       11      active sync   /dev/sdm1
>> ---
>> Note that the drives are 'moved' because the old /dev/sdc isn't there
>> any more but the relative position should be the same, correct me if I
>> am wrong. If you prefer, what you need to do to get the 'new' drive
>> letter is to take 16 out of the minor of each of the drives.
>>
>> This is the 'new' --create
>> ---
>> /dev/sdc1:
>>            Magic : a92b4efc
>>          Version : 0.90.00
>>             UUID : 79990944:0bb9420b:97d5a417:7d4e9ef8 (local to host beehive)
>>    Creation Time : Tue Sep  6 15:15:03 2022
>>       Raid Level : raid5
>>    Used Dev Size : -482370688 (3635.98 GiB 3904.10 GB)
>>       Array Size : 41938562688 (39995.73 GiB 42945.09 GB)
>>     Raid Devices : 12
>>    Total Devices : 12
>> Preferred Minor : 123
>>
>>      Update Time : Tue Sep  6 15:15:03 2022
>>            State : clean
>>   Active Devices : 12
>> Working Devices : 12
>>   Failed Devices : 0
>>    Spare Devices : 0
>>         Checksum : ed12b96a - correct
>>           Events : 1
>>
>>           Layout : left-symmetric
>>       Chunk Size : 128K
>>
>>        Number   Major   Minor   RaidDevice State
>> this     5       8       33        5      active sync   /dev/sdc1
>>
>>     0     0       8      209        0      active sync   /dev/sdn1
>>     1     1       8       65        1      active sync   /dev/sde1
>>     2     2       8       81        2      active sync   /dev/sdf1
>>     3     3       8      145        3      active sync   /dev/sdj1
>>     4     4       8       97        4      active sync   /dev/sdg1
>>     5     5       8       33        5      active sync   /dev/sdc1
>>     6     6       8      161        6      active sync   /dev/sdk1
>>     7     7       8      129        7      active sync   /dev/sdi1
>>     8     8       8      113        8      active sync   /dev/sdh1
>>     9     9       8       49        9      active sync   /dev/sdd1
>>    10    10       8      193       10      active sync   /dev/sdm1
>>    11    11       8      177       11      active sync   /dev/sdl1
>> ---
>>
>> If you put the layout lines side by side, it would seem to me that
>> they match, modulo the '16' difference.
>>
>> This is the list of --create and --assemble commands from the 6th
>> which involve the sdx1 partitions, those we care about right now -
>> there were others involving /dev/md124 and the /dev/sdx2 which however
>> are not relevant - the data there :
>> --
>>   9813  mdadm --assemble /dev/md123 missing
>>   9814  mdadm --assemble /dev/md123 missing /dev/sdf1 /dev/sdg1
>> /dev/sdk1 /dev/sdh1 /dev/sdd1 /dev/sdl1 /dev/sdj1 /dev/sdi1 /dev/sde1
>> /dev/sdn1 /dev/sdm1
>>   9815  mdadm --assemble /dev/md123 /dev/sdf1 /dev/sdg1 /dev/sdk1
>> /dev/sdh1 /dev/sdd1 /dev/sdl1 /dev/sdj1 /dev/sdi1 /dev/sde1 /dev/sdn1
>> /dev/sdm1
>>   9823  mdadm --create -o -n 12 -l 5 /dev/md124 missing /dev/sde1
>> /dev/sdf1 /dev/sdj1 /dev/sdg1 /dev/sdc1 /dev/sdk1 /dev/sdi1 /dev/sdd1
>> /dev/sdm1 /dev/sdl1
>>   9824  mdadm --create -o -n 12 -l 5 /dev/md124 missing /dev/sde1
>> /dev/sdf1 /dev/sdj1 /dev/sdg1 /dev/sdc1 /dev/sdk1 /dev/sdi1 /dev/sdh1
>> /dev/sdd1 /dev/sdm1 /dev/sdl1
>> ^^^^ note that these were the WRONG ARRAY - this was an unfortunate
>> miscommunication which caused potential damage.
>>   9852  mdadm --create -o --assume-clean -n 12 -l 5 --metadata=0.90
>> --chunk=128 /dev/md123 /dev/sdn1 /dev/sdd1 /dev/sdf1 /dev/sde1
>> /dev/sdg1 /dev/sdj1 /dev/sdi1 /dev/sdm1 /dev/sdh1 /dev/sdk1 /dev/sdl1
>>   9863  mdadm --create -o --assume-clean -n 12 -l 5 --metadata=0.90
>> --chunk=128 /dev/md123 /dev/sdn1 /dev/sdc1 /dev/sdd1 /dev/sdf1
>> /dev/sde1 /dev/sdg1 /dev/sdj1 /dev/sdi1 /dev/sdm1 /dev/sdh1 /dev/sdk1
>> /dev/sdl1
>>   9879  mdadm --create -o --assume-clean -n 12 -l 5 --metadata=0.90
>> --chunk=128 --bitmap=none /dev/md123 /dev/sdn1 /dev/sdc1 /dev/sdd1
>> /dev/sdf1 /dev/sde1 /dev/sdg1 /dev/sdj1 /dev/sdi1 /dev/sdm1 /dev/sdh1
>> /dev/sdk1 /dev/sdl1
>>   9889  mdadm --create -o --assume-clean -n 12 -l 5 --metadata=0.90
>> --chunk=128 --bitmap=none /dev/md123 /dev/sdn1 /dev/sde1 /dev/sdf1
>> /dev/sdl1 /dev/sdg1 /dev/sdc1 /dev/sdk1 /dev/sdi1 /dev/sdh1 /dev/sdd1
>> /dev/sdm1 /dev/sdl1
>>   9892  mdadm --create -o --assume-clean -n 12 -l 5 --metadata=0.90
>> --chunk=128 --bitmap=none /dev/md123 /dev/sdn1 /dev/sde1 /dev/sdf1
>> /dev/sdl1 /dev/sdg1 /dev/sdc1 /dev/sdk1 /dev/sdi1 /dev/sdh1 /dev/sdd1
>> /dev/sdm1 /dev/sdl1
>>   9895  mdadm --create -o --assume-clean -n 12 -l 5 --metadata=0.90
>> --chunk=128 --bitmap=none /dev/md123 /dev/sdn1 /dev/sde1 /dev/sdf1
>> /dev/sdj1 /dev/sdg1 /dev/sdc1 /dev/sdk1 /dev/sdi1 /dev/sdh1 /dev/sdd1
>> /dev/sdm1 /dev/sdl1
>>   9901  mdadm --assemble /dev/md123 /dev/sdn1 /dev/sde1 /dev/sdf1
>> /dev/sdl1 /dev/sdg1 /dev/sdc1 /dev/sdk1 /dev/sdi1 /dev/sdh1 /dev/sdd1
>> /dev/sdm1 /dev/sdl1
>>   9903  mdadm --create -o --assume-clean -n 12 -l 5 --metadata=0.90
>> --chunk=128 --bitmap=none /dev/md123 /dev/sdn1 /dev/sde1 /dev/sdf1
>> /dev/sdj1 /dev/sdg1 / dev/sdc1 /dev/sdk1 /dev/sdi1 /dev/sdh1 /dev/sdd1
>> /dev/sdm1 /dev/sdl1
>> ---
>>
>> Note that they all were -o, therefore if I am not mistaken no parity
>> data was written anywhere. Note further the fact that the first two
>> were the 'mistake' ones, which did NOT have --assume-clean (but with
>> -o this shouldn't make a difference AFAIK) and most importantly the
>> metadata was the 1.2 default AND they were the wrong array in the
>> first place.
>> Note also that the 'final' --create commands also had --bitmap=none to
>> match the original array, though according to the docs the bitmap
>> space in 0.90 (and 1.2?) is in a space which does not affect the data
>> in the first place.
>>
>> Now, first of all a question: if I get the 'old' sdc, the one that was
>> taken out prior to this whole mess, onto a different system in order
>> to examine it, the modern mdraid auto discovery shoud NOT overwrite
>> the md data, correct? Thus I should be able to double-check the drive
>> order on that as well?
>>
>> Any other pointers, insults etc are of course welcome.

