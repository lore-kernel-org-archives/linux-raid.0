From: Tobias Hofmann <tobias.hofmann@medien.uni-weimar.de>
Subject: Re: First RAID Setup
Date: Fri, 16 Dec 2005 09:08:10 +0100
Message-ID: <43A275EA.9020104@medien.uni-weimar.de>
References: <0481A62A3E95A044AC20A1A45899645C06B02F4B@glc-mail-1.tessco.com>	<43A1D642.2010301@wasp.net.au>	<43A1E0CE.7090805@medien.uni-weimar.de> <17314.7734.707554.88728@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17314.7734.707554.88728@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Brad Campbell <brad@wasp.net.au>, "Callahan, Tom" <CallahanT@tessco.com>, 'Andargor The Wise' <andargor@yahoo.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 16.12.2005 02:53, Neil Brown wrote:
> On Thursday December 15, tobias.hofmann@medien.uni-weimar.de wrote:
> 
>><delurk>
>>
>>On 15.12.2005 21:46, Brad Campbell wrote:
>>
>>>Callahan, Tom wrote:
>>>
>>>
>>>>It is always wise to build in a spare however, that being said about all
>>>>raid levels. In your configuration, if a disk fails in your RAID5, your
>>>>array will go down. RAID5 is usually 3+ disks, with a mirror. So you 
>>>>should
>>>>have 3 disks at minimum, and then a 4th as a spare.
>>>
>>>/me wonders in the days of reliable RAID-6 why we use RAID-5 + spare?
>>
>>Me too. ;) So, with holidays ahead, two questions (as I might tackle 
>>that soon and have not found it mentioned):
>>
>>- How would one "switch" from the latter to the former? Is there 
>>something like "grow_to_RAID_6"?
> 
> 
> No... at least not yet....

Hm. :) Around here, it is pretty much Christmas time, with all the 
"wishing" going on - hint, hint? ;)

>>- Does RAID6 have disadvantages wrt write speed?
> 
> Probably.  I haven't done any measurements myself, but from a
> theoretical standpoint, you would expect raid6 to impose more CPU load
> (though that may not be noticeable) and as raid6 need to see the whole
> stripe to update the P and Q blocks (it cannot do a subtract old, add
> new update) there could well be more IO happening, particularly on
> large arrays (>5 devices).

That,s about the line of thinking I was considering. I,ll see, if I 
tackle this over the holidays, to do some tests...

> Of course, whether this caused noticeable reduction in throughput and
> latency would be very workload-dependant.

My scenarios here @home will probably not be very relevant to what one 
would like to know in a production environment - whatever that is... :)

Thanks for the input, Neil,

greets, tobi... :)

