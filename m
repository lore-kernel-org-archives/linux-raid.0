From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Sharing disks amoung multiple software RAIDs
Date: Fri, 02 May 2008 17:24:22 -0400
Message-ID: <481B8686.7070208@tmr.com>
References: <232402.74959.qm@web50210.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <232402.74959.qm@web50210.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: alex14641@yahoo.com
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Alex Davis wrote:
> --- On Thu, 5/1/08, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>
>   
>> From: Justin Piszcz <jpiszcz@lucidpixels.com>
>> Subject: Re: Sharing disks amoung multiple software RAIDs
>> To: "Alex Davis" <alex14641@yahoo.com>
>> Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
>> Date: Thursday, May 1, 2008, 8:50 AM
>> On Thu, 1 May 2008, Alex Davis wrote:
>>
>>     
>>> Is this a bad thing? I'm guessing that it is, but
>>>       
>> I want independent
>>     
>>> confirmation before I spoke to someone I know
>>>       
>> who's doing this.
>>     
>>> Thanks
>>>
>>>
>>>     
>>>       
>> What is the use case, why would you want to do that?
>> I have seen people on the list do it before, for example
>> are you going to be utilizing both raids at the same time? 
>>     
> Yes.
>
>   
>> If so, I would advise against it.
>>
>> What is the reasoning?
>>     
>
> No, I don't want to do this. I know someone who is, and I wanted to get
> more input before I advised them to get more disks. The RAIDs are running
> in degraded mode, so they'll need more disks anyway. Since they are (or
> hopefully soon will be) buying more disks, I'll advise them to get
> dedicated disks for each RAID.
>   

Depending on the use, dedicated disk may not be better, unless the 
budget is large. I ran an application which had a heavily read database 
and a large collection of files thich were read based on offsets read 
from the database. I have a limited number of drives available 
(rackspace limit, not $). I partitioned the drives with a small 
partition for the heavily read database, using three copies raid1, and 
raid5 for the more lightly used data, across the same disks.

I tried almost every layout possible with six drives, and spreading the 
required head motion to all drives was a big win on the heavily read 
database, while spreading the storage over all drives was required 
because of capacity. And split and shared the performance was optimized. 
And it did stay up with a drive fail, although "up" means "didn't lose 
data" rather than "usefully fast."



-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


