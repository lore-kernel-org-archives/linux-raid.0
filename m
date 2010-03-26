From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Another take on replacing failed raid drives
Date: Fri, 26 Mar 2010 18:59:26 +0000
Message-ID: <4BAD040E.2010304@anonymous.org.uk>
References: <4BAA469B.3050001@tmr.com> <4BACCD8B.8040705@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BACCD8B.8040705@xs4all.nl>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 26/03/2010 15:06, John Hendrikx wrote:
> Bill Davidsen wrote:
>> I stumbled on this description of replacing a drive in a raid array. I 
>> share it because different takes on a subject are usesful, and because 
>> he had multiple arrays using partitions of the failed drive, rather 
>> than a partitioned array.
>>
>> http://blogs.techrepublic.com.com/opensource/?p=1368
>>
> I do that too (multiple arrays using partitions).  My reason for that is 
> to make future upgrades less painful as it is possible to just copy and 
> drop one array at a time.

I do that too, but my reason is that the arrays are different types. For 
example, first partitions make RAID-1 for /boot, second partitions 
RAID-1 or RAID-10 swap, third partitions RAID-5 or RAID-6 filesystem (or 
several over LVM).

Cheers,

John.

