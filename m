From: Gilad Arnold <arnold@cs.berkeley.edu>
Subject: Re: migrating from RAID5 to RAID10
Date: Thu, 10 Jun 2010 15:26:26 -0700
Message-ID: <20100610222625.GA14165@libra.CS.Berkeley.EDU>
References: <20100609151132.GA10082@libra.CS.Berkeley.EDU>
 <20100611005231.401529c0@natsu>
 <20100610195851.GA8408@libra.CS.Berkeley.EDU>
 <AANLkTim3vrtAfgzY87IAmP6mY9PNiYiQZ1LyuqWHisiD@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTim3vrtAfgzY87IAmP6mY9PNiYiQZ1LyuqWHisiD@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Drew <drew.kay@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jun 10, 2010 at 03:11:43PM -0700, Drew wrote:
> Actually No. If it is RAID-5 as you claim, then currently it is
> effectively a RAID-0.
> 
> RAID-5 is Striping with Distributed Parity and requires a *minimum* of
> 3 disks. Two disks, regardless of how you got there, is considered
> a degraded state.

Sounds to me that you can still stripe and distribute parity with two
drives, only that parity will amount to mirroring, and it can still
tolerate a single drive failure. I got there in the usual way, creating
a RAID5 with --raid-devices=2.


--8<------8<------8<------8<------8<------8<------8<------8<------8<----

$ mdadm --detail /dev/md4
/dev/md4:
        Version : 0.90
  Creation Time : Thu Nov 27 15:48:58 2008
     Raid Level : raid5
     Array Size : 484391808 (461.95 GiB 496.02 GB)
  Used Dev Size : 484391808 (461.95 GiB 496.02 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 4
    Persistence : Superblock is persistent

    Update Time : Thu Jun 10 15:16:45 2010
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : 1da37f10:3c14071d:40784aba:8675d418
         Events : 0.94324

    Number   Major   Minor   RaidDevice State
       0       8        4        0      active sync   /dev/sda4
       1       8       20        1      active sync   /dev/sdb4

--8<------8<------8<------8<------8<------8<------8<------8<------8<----


Gilad
