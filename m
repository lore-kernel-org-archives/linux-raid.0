From: Chris Birkinshaw <chris@postbox.org.uk>
Subject: Re: Dual disk RAID 5 failure!
Date: Thu, 25 Nov 2004 20:22:44 +0000
Message-ID: <C40728DE-3F1F-11D9-8034-000A959A30DC@postbox.org.uk>
References: <A6264114-3F0D-11D9-8034-000A959A30DC@postbox.org.uk> <41A63328.40907@dgreaves.com>
Mime-Version: 1.0 (Apple Message framework v619)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <evms-devel-admin@lists.sourceforge.net>
In-Reply-To: <41A63328.40907@dgreaves.com>
Sender: evms-devel-admin@lists.sourceforge.net
Errors-To: evms-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/evms-devel>,
	<mailto:evms-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:evms-devel@lists.sourceforge.net>
List-Help: <mailto:evms-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/evms-devel>,
	<mailto:evms-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=evms-devel>
To: David Greaves <david@dgreaves.com>
Cc: linux-raid@vger.kernel.org, evms-devel@lists.sourceforge.net
List-Id: linux-raid.ids

Thanks for the quick response!

mdadm --detail /dev/md0 gives:


/dev/md0:
         Version : 00.90.01
   Creation Time : Mon Aug 11 16:21:07 2003
      Raid Level : raid5
     Device Size : 58612992 (55.90 GiB 60.02 GB)
    Raid Devices : 7
   Total Devices : 5
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Thu Nov 25 17:03:19 2004
           State : dirty, degraded
  Active Devices : 5
Working Devices : 5
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-asymmetric
      Chunk Size : 128K

     Number   Major   Minor   RaidDevice State
        0       0        0       -1      removed
        1       0        0       -1      removed
        2     253       25        2      active sync   
/dev/evms/.nodes/hdg1
        3     253       26        3      active sync   
/dev/evms/.nodes/hdh1
        4     253       27        4      active sync   
/dev/evms/.nodes/hdi1
        5     253       24        5      active sync   
/dev/evms/.nodes/hde_bbr3
        6     253       22        6      active sync   
/dev/evms/.nodes/hdb1
            UUID : aee7cfe5:90afb264:d1f855a1:f7a6b30e
          Events : 0.10035809




On 25 Nov 2004, at 19:31, David Greaves wrote:

> certainly cc the guys on linux-raid - a *great* bunch :)
>
> you'll need more detail on your config though - have you got mdadm 
> installed?
>
> mdadm --detail /dev/md0
>
> any log output?
>
> David
>
> Chris Birkinshaw wrote:
>
>>
>>
>> Hi,
>>
>> Last night one of my drives got corrupted during a crash, but also 
>> corrupted the other drive on that controller (I know I should only 
>> have one drive per controller but you know how it is.... stable door 
>> and all that).
>>
>> So I now have 2 disks missing from my RAID 5 with corrupt 
>> superblocks. Is there any way to get back from this, there was around 
>> 400Gb of data on there....
>>
>> If anyone has any idea at all that may help I would be very happy to 
>> hear it,
>>
>> Many thanks,
>>
>> Chris
>>
>>



-------------------------------------------------------
SF email is sponsored by - The IT Product Guide
Read honest & candid reviews on hundreds of IT Products from real users.
Discover which products truly live up to the hype. Start reading now. 
http://productguide.itmanagersjournal.com/
_______________________________________________
Evms-devel mailing list
Evms-devel@lists.sourceforge.net
To subscribe/unsubscribe, please visit:
https://lists.sourceforge.net/lists/listinfo/evms-devel
