From: Eric Valette <eric.valette@free.fr>
Subject: Re: Problem with array raid10 array resync on 4.4.0 (keeps reyncing
 each reboot)
Date: Wed, 27 Jan 2016 08:24:29 +0100
Message-ID: <56A870AD.4070400@free.fr>
References: <56A78786.10103@Free.fr> <20160126233133.GB12721@kernel.org>
Reply-To: eric.valette@free.fr
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160126233133.GB12721@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 27/01/2016 00:31, Shaohua Li wrote:
> On Tue, Jan 26, 2016 at 03:49:42PM +0100, Eric Valette wrote:
>> Hi,
>>
>> My raid 10 array (5 disk with one spare) was doing a  resync after an
>> upgrade to 4.4.0 from 4.1.15. The resync progress was steady and at the end
>> the /proc/mdstat was apparently complete but when rebooting, it started
>> resycing over and over. I noticed my dmesg was totally filled with raid10
>> conf printout message so it was impossible to trace anything else.
>>
>> Did a resync test with 3.14.58 (because I knew it had worked for resync
>> before and was still available as a boot option)  and the array was
>> correctly rebuild.
>> Runs fine with 4.1.16 now.
>>
>> Please CC me as I'm not subscribed.
>
> Could you please provide more info, like mdadm -D /dev/md0 in v4.4? If you run
> a stop/reassemble, does the resync start?

I'm not going to retry kernel 4.4.0 on this device as I'm no more 
confident about raid10 support with this 4.4 version.

So on 4.1.16 :

mdadm -D /dev/md0
/dev/md0:
         Version : 1.2
   Creation Time : Wed Jun 20 23:56:59 2012
      Raid Level : raid10
      Array Size : 5860268032 (5588.79 GiB 6000.91 GB)
   Used Dev Size : 2930134016 (2794.39 GiB 3000.46 GB)
    Raid Devices : 4
   Total Devices : 5
     Persistence : Superblock is persistent

     Update Time : Sun Jan 24 17:15:58 2016
           State : clean
  Active Devices : 4
Working Devices : 5
  Failed Devices : 0
   Spare Devices : 1

          Layout : near=2
      Chunk Size : 512K

            Name : nas2:0  (local to host nas2)
            UUID : 6abe1f20:90c629de:fadd8dc0:ca14c928
          Events : 480
 
 

     Number   Major   Minor   RaidDevice State 
 

        0       8       17        0      active sync set-A   /dev/sdb1 
 

        1       8       33        1      active sync set-B   /dev/sdc1 
 

        2       8       49        2      active sync set-A   /dev/sdd1 
 

        3       8       65        3      active sync set-B   /dev/sde1 
 

 
 

        4       8       81        -      spare   /dev/sdf1

uname -a
Linux nas2 4.1.16 #1 SMP Sat Jan 23 19:29:59 CET 2016 x86_64 GNU/Linux

And if I stop the array manually and reboot, its no more resynced with 
this 4.1.16 kernel.



