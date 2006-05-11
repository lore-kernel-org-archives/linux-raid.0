From: Guido Moonen <guido.moonen@axon.tv>
Subject: Re: RAID5 - 4 disk reboot trouble.
Date: Thu, 11 May 2006 16:15:12 +0200
Message-ID: <446346F0.1080304@axon.tv>
References: <44632411.7020102@axon.tv> <17507.9569.225607.513520@cse.unsw.edu.au> <44632749.7010600@axon.tv>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44632749.7010600@axon.tv>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

After some more tests:

A running system with a correct raid system will not have any trouble 
rebooting and re-assembling.
but a system without one of the disks also crashes the raid in a reboot.

I know we should have a fully 4 disk synchronized raid system. But it 
seems to me it should still be able to assemble a raid system without 
the forth disk, multiple times. Is there something that I should change 
in my configuration or any things I can do to prevent this?

Guido.

Correct System print:
[root@localhost ~]# mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90.03
  Creation Time : Thu May 11 12:05:31 2006
     Raid Level : raid5
     Array Size : 732419136 (698.49 GiB 750.00 GB)
    Device Size : 244139712 (232.83 GiB 250.00 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Thu May 11 13:36:45 2006
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : 32c52389:27a260ee:ed154946:5e56f4ed
         Events : 0.4

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
       2       8       33        2      active sync   /dev/sdc1
       3       8       49        3      active sync   /dev/sdd1

Does not have this problem.

Missing a drive print:
/dev/md0:
        Version : 00.90.03
  Creation Time : Thu May 11 12:05:31 2006
     Raid Level : raid5
    Device Size : 244139712 (232.83 GiB 250.00 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Thu May 11 14:09:09 2006
          State : active, degraded
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : 32c52389:27a260ee:ed154946:5e56f4ed
         Events : 0.455

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
       2       8       33        2      active sync   /dev/sdc1
       3       0        0        3      removed

Guido Moonen wrote:

> Hi,
>
> Computers in the field will be able to complete the whole cycle of 
> recovering and having a redundent array. but this is a situation that 
> can happen, and we are not sure what is causing this problem. I will 
> let one complete the this recovery and try to reproduce this bug. But 
> when a customer will replace one the drives this process is started 
> again and there will be a period where the system is not full proof.
>
> System use:
> This system will record (24/7) a single channel and saves the recorded 
> data (MPEG) on a raid device. The system must be able to hold 90 days 
> of recorded material for compliance regulation. When the raid fails 
> users can lose upto 90 days of mpeg which is not acceptable for 
> compliance (They must be able to produce the recorded mpeg for 90 
> days). So we would like to know if this failure can be avoided, or if 
> there is another configuration which makes it possible to recover from 
> this state.
>
> Guido.
>
> Neil Brown wrote:
>
>> On Thursday May 11, guido.moonen@axon.tv wrote:
>>  
>>
>>> Hi,
>>>
>>> I'm running a raid5 system, and when I reboot my raid seems to be 
>>> failing. (One disk is set to spare and other disk seems to be oke in 
>>> the detials page but we get a INPUT/OUTPUT error when trying to 
>>> mount it)
>>>
>>> We cannot seem te find the problem in this setup.
>>>   
>>
>> ...
>>  
>>
>>>          State : clean, degraded, recovering
>>>   
>>
>>                                     ^^^^^^^^^^
>>
>> Do you ever let the recovery actually finish?  Until you do you don't
>> have real redundancy.
>>
>> NeilBrown
>>
>>  
>>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

