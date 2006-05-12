From: Ken <Ken@4dcsi.com>
Subject: Re: hardware raid 5 and software raid 0 stripe broke.
Date: Fri, 12 May 2006 09:07:44 -0400
Message-ID: <446488A0.8050004@4dcsi.com>
References: <4463ECBD.8040506@4dcsi.com> <17507.62169.927233.886775@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17507.62169.927233.886775@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Thursday May 11, Ken@4dcsi.com wrote:
>   
>> We have a Linux box running redhat 7.2   We have two hardware 
>> controllers in it with about 500gig's each.   They're raid 5.   We were 
>> using a software raid to combine them all together.   1 hard drive went 
>> down so we replaced it and now the system won't boot.   We have used a 
>> Knoppix boot cd to get into a linux system.   We can see /dev/sda1 and 
>> /dev/sdb1.   However, /dev/md0 cannot be accessed.   Is there a safe way 
>> to create the software raid from the cd to see if maybe mdadm on the 
>> original system got corrupt?   any help would be greatly appreciated.
>>     
>
> What booted off knoppix, what does
>
>  mdadm -E /dev/sda1
>  mdadm -E /dev/sdb1
>
> produce?
>
> How about
>   mdadm -A /dev/md0 /dev/sda1 /dev/sdb1
>
> NeilBrown
>
>   
Thank you for your response Neil.   We got it up and running again.   I 
don't remember what we did though.   We've been going on no sleep all 
week trying to setup a new server and right before the old one crashed 
we were all ready to go home and take a little rest.

Thanks again.

--Ken
