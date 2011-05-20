From: Joe Landman <joe.landman@gmail.com>
Subject: Re: HBA Adaptor advice
Date: Fri, 20 May 2011 08:48:23 -0400
Message-ID: <4DD66317.70400@gmail.com>
References: <4DD50C89.8060006@wildgooses.com>	<20110520020853.GC4759@bitfolk.com>	<4DD61948.8050302@wildgooses.com>	<4DD65C18.5090804@gmail.com> <20110520183413.64fe3ccc@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110520183413.64fe3ccc@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: Ed W <lists@wildgooses.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/20/2011 08:34 AM, Roman Mamedov wrote:
> On Fri, 20 May 2011 08:18:32 -0400
> Joe Landman<joe.landman@gmail.com>  wrote:
>
>> Second off, you can turn any of the expensive RAID cards into an 'JBOD'
>> by doing something like this:
>>
>> 1) have the unit configured in RAID mode
>>
>> 2) build virtual disks out of single drives, as RAID0.
>>
>> 3) iterate 2 until you exhaust your drives.
>>
>> 4) make sure you prevent these drives from messing with your boot drive
>> order ... some bioses "helpfully" reorganize new drives for you by
>> messing with this list.
>>
>> Once the drive is a 1 disk RAID0, you get the cache, and the BBU for the
>> cache.  Yeah, its a little weird.  But it does work (we've done this
>> with some LSI8888's).
>
> But can you then access SMART of the individual drives?

I don't view the loss of direct SMART access as a bad thing ... most of 
the RAID cards will give you CLI access to this data, if in a convoluted 
manner.  SMART's utility is generally pretty questionable (see the 
Google paper for a discussion on the profound lack of correlation of 
SMART parameters with actual failure rates).  But its there if you want it.

> Or will you see only some bogus block devices which do not accept SMART
> commands, do not return real drive identity, and present themselves as RAID0
> #1, RAID0 #2 etc. instead?

The RAID will provide you an abstraction (e.g. a layer you have to walk 
through) to your disks.  Seeing what composes the RAID is generally not 
hard, though you might need to write a quick and dirty parser for this.

The block devices are not bogus.  They are logical block devices.

-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics, Inc.
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
        http://scalableinformatics.com/sicluster
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615
