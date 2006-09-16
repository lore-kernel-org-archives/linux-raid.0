From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Correct way to create multiple RAID volumes with hot-spare?
Date: Sat, 16 Sep 2006 10:44:34 -0400
Message-ID: <450C0DD2.2030506@tmr.com>
References: <000001c6d6ba$50819ad0$0e00a8c0@sherlock> <4509849B.3020006@maine.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4509849B.3020006@maine.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Steve Cousins <steve.cousins@maine.edu>
Cc: 'Neil Brown' <neilb@suse.de>, 'Linux RAID Mailing List' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Steve Cousins wrote:

>
>
> Ruth Ivimey-Cook wrote:
>
>> Steve,
>>
>>> The recent "Messed up creating new array..." thread has someone who 
>>> started by using the whole drives but she now wants to use 
>>> partitions because the array is not starting automatically on boot 
>>> (I think that was the symptom).  I'm guessing this is because there 
>>> is no partigion ID of "fd" since there isn't even a partition.
>>
>>
>>
>> Yes, that's right.
>
>
> Thanks Ruth.
>
>
> Neil (or others), what is the recommended way to have the array start 
> up if you use whole drives instead of partitions?  Do you put mdadm -A 
> etc. in rc.local? 


I think you want it earlier than that, unless you want to do the whole 
mounting process by hand. It's distribution dependent, but doing it 
early allows the array to be handled like any other block device.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

