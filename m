From: David Brown <david.brown@hesbynett.no>
Subject: Re: make filesystem failed while the capacity of raid5 is big than
 16TB
Date: Thu, 13 Sep 2012 09:06:52 +0200
Message-ID: <5051860C.9060902@hesbynett.no>
References: <505033fe.8aec440a.5d52.ffffe37b@mx.google.com> <50504094.2040302@hesbynett.no> <CACY-59cLmV2SRY+FrvhHxseDD1+r-B-3bOKPGzJdGttW+9U2mw@mail.gmail.com> <505059DD.8000108@hesbynett.no> <50509881.60607@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50509881.60607@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: GuoZhong Han <hanguozhong@meganovo.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/09/2012 16:13, Stan Hoeppner wrote:
> On 9/12/2012 4:46 AM, David Brown wrote:
>
>>>               The requirement of my application is :
>>>               1.There are 16 2T disks in the system, the app must be able
>>> to identify these disks.
>>>               2.The users can create a raid0,raid10 or raid5 use the
>>> disks they designated.
>>>               3.Performance for writes of the array will reach at least
>>> 100MB per second.
>>
>> This does not make sense as a set of requirements unless you are making
>> a disk tester.  1 and 2 are a list of possible solutions, not a
>> description of the application and requirements.
>
> It makes perfect sense if the OP is designing a storage appliance
> product and a management front end for it.  Based on the information
> given, this seems to be the case.
>

If he had said "up to 16 disks" of "up to 2TB", and a more general 
performance description, then I would have agreed.  I read the 
requirements as being /exactly/ 16 2TB disks, which I thought odd.  But 
the OP has replied with more information anyway.

mvh.,

David

