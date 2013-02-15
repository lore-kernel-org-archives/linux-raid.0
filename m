From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID performance
Date: Fri, 15 Feb 2013 15:01:42 +1100
Message-ID: <511DB326.1090406@websitemanagers.com.au>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <5113A2D6.20104@websitemanagers.com.au> <CAKHEz2YgiQiknBXju9a=PR3zV1Hb7ux8yBZWywiTi=BXFm20GA@mail.gmail.com> <51150475.2020803@websitemanagers.com.au> <51157141.90205@hardwarefreak.com> <9ABA2459-DB04-40CA-996E-D02FEE43291B@colorremedies.com> <511D8AEF.8040202@websitemanagers.com.au> <80A5C958-6E76-49BD-9CDC-3E8705B401C5@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <80A5C958-6E76-49BD-9CDC-3E8705B401C5@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: "linux-raid@vger.kernel.org list" <linux-raid@vger.kernel.org>, "stan@hardwarefreak.com Hoeppner" <stan@hardwarefreak.com>
List-Id: linux-raid.ids

On 15/02/13 12:40, Chris Murphy wrote:
> 
> On Feb 14, 2013, at 6:10 PM, Adam Goryachev
> <mailinglists@websitemanagers.com.au> wrote:
>> 
>> So assuming I don't mind wasting a few MB per disk (I was leaving
>> empty space at the end of the partition anyway), what would I need
>> to instruct fdisk and/or md to do to get the alignment right?
>> 
>> Current partition/disk is as follows: /dev/sdc1              63
>> 931769999   465884968   fd  Lnx RAID auto
> 
> Yeah the old fdisk starts at LBA 63 which is not good because it's
> neither 4K nor 8K aligned. For a long time now fdisk starts new ones
> at 2048 which is 1MB aligned (and is of course also 8KB and 4KB
> aligned, among others so it's just easier to do that.) But for 4K and
> 8K alignment, start LBA 48, 64, 80, etc are also valid.

Probably a stupid question, but how do I force fdisk to start at 64 ? or
even 2048?

Would it be a sequence like this:
fdisk /dev/sdb
d <- delete the existing partition
u <- change units
n <- new partition
p <- primary
1 <- partition 1
64 <- start sector 64
xxx <- end size of partition

Will that make it right?

I'm planning on doing:
mdadm --manage /dev/md0 --fail /dev/sdb1
mdadm --manage /dev/md0 --remove /dev/sdb1
fdisk (delete and re-create partition, same size, different start/end)
mdadm --manage /dev/md0 --add /dev/sdb1
Wait for resync to complete, and repeat with the next disk.

I was thinking to also use smartctl to instruct the disk to do a format
before creating the new partition. Would that help to "trim" the disk,
or not make any difference at all (since md will re-write the whole disk
in the resync phase anyway).

Thanks,
Adam

-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au
