From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: raid5 software vs hardware: parity calculations?
Date: Mon, 15 Jan 2007 12:37:15 -0500
Message-ID: <45ABBBCB.4050709@tmr.com>
References: <2A887D754684B6703B52E126@emerald.sei.cmu.edu>	 <Pine.LNX.4.64.0701120935000.18431@twinlark.arctic.org>	 <F4B05AD60951BBA089A81535@emerald.sei.cmu.edu> <e9c3a7c20701130120o246f5cf1i8d364777123c50d8@mail.gmail.com> <45A917B8.2060706@tmr.com> <eobpl9$df3$1@sea.gmane.org> <45AB9DC6.50509@tmr.com> <45ABAA43.2000902@robinbowes.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45ABAA43.2000902@robinbowes.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Bowes <robin-lists@robinbowes.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Robin Bowes wrote:
> Bill Davidsen wrote:
>   
>> Robin Bowes wrote:
>>     
>>> Bill Davidsen wrote:
>>>  
>>>       
>>>> There have been several recent threads on the list regarding software
>>>> RAID-5 performance. The reference might be updated to reflect the poor
>>>> write performance of RAID-5 until/unless significant tuning is done.
>>>> Read that as tuning obscure parameters and throwing a lot of memory into
>>>> stripe cache. The reasons for hardware RAID should include "performance
>>>> of RAID-5 writes is usually much better than software RAID-5 with
>>>> default tuning.
>>>>     
>>>>         
>>> Could you point me at a source of documentation describing how to
>>> perform such tuning?
>>>   
>>>       
>> No. There has been a lot of discussion of this topic on this list, and a
>> trip through the archives of the last 60 days or so will let you pull
>> out a number of tuning tips which allow very good performance. My
>> concern was writing large blocks of data, 1MB per write, to RAID-5, and
>> didn't involve the overhead of small blocks at all, that leads through
>> other code and behavior.
>>     
>
> Actually Bill, I'm running RAID6 (my mistake for not mentioning it
> explicitly before) - I found some material relating to RAID5 but nothing
> on RAID6.
>
> Are the concepts similar, or is RAID6 a different beast altogether?
>   
You mentioned that before, and I think the concepts covered in the 
RAID-5 discussion apply to RAID-6 as well. I don't have enough unused 
drives to really test anything beyond RAID-5, so I have no particular 
tuning information to share. Testing on system drives introduces too 
much jitter to trust the results.
>   
>>> Specifically, I have 8x500GB WD STAT drives on a Supermicro PCI-X 8-port
>>> SATA card configured as a single RAID6 array (~3TB available space)
>>>   
>>>       
>> No hot spare(s)?
>>     
>
> I'm running RAID6 instead of RAID5+1 - I've had a couple of instances
> where a drive has failed in a RAID5+1 array and a second has failed
> during the rebuild after the hot-spare had kicked in.
-- 

bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

