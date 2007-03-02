From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: RAID0 to RAID5 upgrade
Date: Fri, 02 Mar 2007 15:31:35 -0500
Message-ID: <45E889A7.5000408@tmr.com>
References: <45E75DE0.6060900@tmr.com> <20070301233905.GA13126@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070301233905.GA13126@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit@rabbit.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter Rabbitson wrote:
> On Thu, Mar 01, 2007 at 06:12:32PM -0500, Bill Davidsen wrote:
>   
>> I have three drives, with some various partitions, currently set up like 
>> this.
>>
>>  drive0    drive1    drive2
>>
>>   hdb1      hdi1      hdk1
>>   \_________RAID1________/
>>
>>   hdb2      hdi2      hdk2
>>  unused     \___RAID0____/
>>   200GB       100GB x 2
>>
>>             hdi3      hdk3
>>             \___unused___/
>>                100GB x 2
>>
>> What I want to have is 3 x 200 = 400GB RAID5.
>>
>> I would like to avoid copying 200GB of data to another machine and back 
>>     
>
> Can't you do the following:
>
> * copy the data from raid0 to hdb2 ( raid0 <= hdb2 you can even do a dd)
> * degrade raid1 to only contain drive0
> * since you have all your data on drive0, wipe drive1 and drive2 clean, 
> create a degraded raid5
> * copy stuff from drive0 to the new array (enw fs as well I presume)
> * resync the raid5 with drive0

The RAID1 is "most critical" data, and would never voluntarily be 
degraded. And since I only want to combine hd[ij][23] I would have no 
reason to do that. Other than that, it seems possible, assuming that 
mdadm will actually create the degraded RAID5 array with enough room for 
the data.

I'm testing that now.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

