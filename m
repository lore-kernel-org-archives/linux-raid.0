From: Vincent Schut <schut@sarvision.nl>
Subject: Re: looking for advice on raid drives upgrade
Date: Wed, 30 Mar 2011 13:22:42 +0200
Message-ID: <imv3q2$h48$1@dough.gmane.org>
References: <imuu5b$gaf$1@dough.gmane.org> <alpine.DEB.2.00.1103301309100.1942@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1103301309100.1942@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/30/2011 01:10 PM, Mikael Abrahamsson wrote:
> On Wed, 30 Mar 2011, Vincent Schut wrote:
>
>> - offline the raid, dd(rescue) each 1TB drive onto a new 2TB one,
>> replace drives, put raid online again
>
> This works if you have a superblock version that stores its superblock
> in the beginning, not the end (or if you use a partition). This is the
> safest.

Thanks. That is something I would not have thought about myself.

according to mdadm --detail, my superblock version is 1.1:

  mdadm --detail /dev/md0
/dev/md0:
         Version : 1.1
   Creation Time : Fri Apr  2 11:59:08 2010
      Raid Level : raid5
      Array Size : 2930287104 (2794.54 GiB 3000.61 GB)
   Used Dev Size : 976762368 (931.51 GiB 1000.20 GB)
    Raid Devices : 4
   Total Devices : 4
     Persistence : Superblock is persistent

     Update Time : Wed Mar 30 13:17:09 2011
           State : clean
  Active Devices : 4
Working Devices : 4
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 512K

            Name : fransje:0  (local to host fransje)
            UUID : 0b2e8a3c:a84a6f4e:31ed60f8:d33de960
          Events : 319880

     Number   Major   Minor   RaidDevice State
        0       8       32        0      active sync   /dev/sdc
        1       8       16        1      active sync   /dev/sdb
        3       8        0        2      active sync   /dev/sda
        4       8       48        3      active sync   /dev/sdd

Version 1.1 stores the superblock at the beginning of the device, right? 
So that would allow me to use the dd method?

>
>> or:
>> - manually replace one drive at a time, and let the raid recover and
>> thus write the data onto the new drive?
>
> If you have a bad block anywhere on the degraded drives, you're going to
> lose data.
>
Exactly. A risk I'd like to avoid, of course.

Thanks for the info!
Vincent.

