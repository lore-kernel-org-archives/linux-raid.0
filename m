From: David Greaves <david@dgreaves.com>
Subject: Re: Preparation advice?
Date: Sun, 28 Nov 2004 11:04:51 +0000
Message-ID: <41A9B0D3.4070701@dgreaves.com>
References: <6d5bedd8041126205255c0fe7d@mail.gmail.com>	 <Pine.LNX.4.56.0411270837340.5805@lion.drogon.net>	 <6d5bedd8041127082528ce68ec@mail.gmail.com>	 <41A8C57A.1060803@dgreaves.com>	 <6d5bedd8041127123945b8db48@mail.gmail.com>	 <41A8EA54.6090708@dgreaves.com>	 <6d5bedd8041127135230b95202@mail.gmail.com>	 <41A91263.1010909@dgreaves.com> <6d5bedd804112716277c31207c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6d5bedd804112716277c31207c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ewan Grantham <ewan.grantham@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Well, there's nothing wrong with /etc/fstab etc but you do have an odd 
report from mdadm.
Back to the list... :)

Ewan's running 2.4.27 and may have an inconsistency with mdadm counting 
the number of raid devices.



Ewan Grantham wrote:

> also send me the output from:
>  mdadm --detail /dev/md0

/dev/md0:
        Version : 00.90.00
  Creation Time : Sat Nov 27 07:32:34 2004
     Raid Level : raid5
     Array Size : 735334656 (701.27 GiB 752.98 GB)
    Device Size : 245111552 (233.76 GiB 250.99 GB)
   Raid Devices : 4
  Total Devices : 5
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Sat Nov 27 14:14:24 2004
          State : dirty
 Active Devices : 4
Working Devices : 4
 Failed Devices : 1
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 128K

           UUID : 525b6c6e:836b8598:b3778337:0be081e8
         Events : 0.2

    Number   Major   Minor   RaidDevice State
       0       8       33        0      active sync   /dev/sdc1
       1       8       49        1      active sync   /dev/sdd1
       2       3       65        2      active sync   /dev/hdb1
       3      22       65        3      active sync   /dev/hdd1



>>I wonder if you have an older version of mdadm?
>>mdadm -V
>>can you upgrade to 1.7 ?
>>    
>>
>
>mdadm - v1.7.0 - 11 August 2004
>
>  
>
>>What command did you use to create the array?
>>    
>>
>
>mdadm --create --verbose /dev/md0 --level=5 -c128 
>        --raid-devices=4  /dev/sdc1 /dev/sdd1 /dev/hdb1 /dev/hdd1
>
>  
>
>>What kernel version are you running?
>>    
>>
>
>2.4.27
>
>  
>
>>Have you put data on the array yet? (if not we may blat and rebuild it)
>>    
>>
>
>Yes, but nothing I can't live without at this point. More a matter of
>the time it takes - about 6 hours. But would rather take another 6
>hours than be likely to lose what I have on there...
>
>Let me know if there's something else I should look at/do...
>  
>
what does
 cat /proc/mdstat
say?


David
