From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: [PATCH 0/2] md: More block -> sector conversions.
Date: Mon, 26 Jan 2009 18:26:08 +0100
Message-ID: <497DF230.1080908@rabbit.us>
References: <1232982852-32747-1-git-send-email-maan@systemlinux.org> <497DD740.8080306@rabbit.us> <20090126160814.GD17185@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090126160814.GD17185@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Andre Noll wrote:
> On 16:31, Peter Rabbitson wrote:
> 
>> Is it possible that the following issue is related to your earlier
>> patches: http://marc.info/?l=linux-raid&m=123202024116493&w=2
> 
> I don't think this is possible because you are using Linux 2.6.24.7
> which does not contain any of the block -> sector conversion changes.
> 
> Moreover, those changes should be invisible to userspace. In
> particular, mdadm does not need to know whether the kernel uses blocks
> or sectors for its internal representations. In fact, no changes to
> mdadm were made wrt. the block -> sector conversions.
> 
> Can you reproduce the incorrect output for the used device size
> with the recent master branch of the mdadm git tree?
> 

Hi Andre,

Yes I can:

root@Thesaurus:/home/rabbit/src/git/mdadm# ./mdadm --version
mdadm - v2.6.8 - 28th November 2008


root@Thesaurus:/home/rabbit/src/git/mdadm# ./mdadm -E /dev/sda1
/dev/sda1:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x0
     Array UUID : 6b11b1ba:78985745:b320fc1a:1db68bcf
           Name : Thesaurus:Crypta  (local to host Thesaurus)
  Creation Time : Sat Mar  8 16:33:41 2008
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 578130828 (275.67 GiB 296.00 GB)
     Array Size : 1730162688 (825.01 GiB 885.84 GB)
  Used Dev Size : 576720896 (275.00 GiB 295.28 GB)
    Data Offset : 264 sectors
   Super Offset : 0 sectors
          State : active
    Device UUID : 85e0e62b:56129e5f:b0d82e78:2ace7d37

    Update Time : Mon Jan 26 18:24:19 2009
       Checksum : 61b214ff - correct
         Events : 772406

         Layout : left-symmetric
     Chunk Size : 2048K

    Array Slot : 5 (failed, failed, 2, 3, 0, 1)
   Array State : uUuu 2 failed


root@Thesaurus:/home/rabbit/src/git/mdadm# ./mdadm -D /dev/md5
/dev/md5:
        Version : 1.01
  Creation Time : Sat Mar  8 16:33:41 2008
     Raid Level : raid5
     Array Size : 865081344 (825.01 GiB 885.84 GB)
  Used Dev Size : 576720896 (550.00 GiB 590.56 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 5
    Persistence : Superblock is persistent

    Update Time : Mon Jan 26 18:24:34 2009
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 2048K

           Name : Thesaurus:Crypta  (local to host Thesaurus)
           UUID : 6b11b1ba:78985745:b320fc1a:1db68bcf
         Events : 772406

    Number   Major   Minor   RaidDevice State
       4       8       67        0      active sync   /dev/sde3
       5       8        1        1      active sync   /dev/sda1
       2       8       19        2      active sync   /dev/sdb3
       3       8       35        3      active sync   /dev/sdc3
