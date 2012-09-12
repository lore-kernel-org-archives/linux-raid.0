From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: make filesystem failed while the capacity of raid5 is big than
 16TB
Date: Wed, 12 Sep 2012 09:13:21 -0500
Message-ID: <50509881.60607@hardwarefreak.com>
References: <505033fe.8aec440a.5d52.ffffe37b@mx.google.com> <50504094.2040302@hesbynett.no> <CACY-59cLmV2SRY+FrvhHxseDD1+r-B-3bOKPGzJdGttW+9U2mw@mail.gmail.com> <505059DD.8000108@hesbynett.no>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <505059DD.8000108@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: GuoZhong Han <hanguozhong@meganovo.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 9/12/2012 4:46 AM, David Brown wrote:

>>              The requirement of my application is :
>>              1.There are 16 2T disks in the system, the app must be able
>> to identify these disks.
>>              2.The users can create a raid0,raid10 or raid5 use the
>> disks they designated.
>>              3.Performance for writes of the array will reach at least
>> 100MB per second.
> 
> This does not make sense as a set of requirements unless you are making
> a disk tester.  1 and 2 are a list of possible solutions, not a
> description of the application and requirements.

It makes perfect sense if the OP is designing a storage appliance
product and a management front end for it.  Based on the information
given, this seems to be the case.

-- 
Stan

