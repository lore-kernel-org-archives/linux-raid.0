From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: RAID6 data-check took almost 2 hours, clicking sounds, system
 unresponsive
Date: Wed, 13 Apr 2011 12:58:10 +0100
Message-ID: <4DA58FD2.8040900@anonymous.org.uk>
References: <323937.22450.qm@web65109.mail.ac2.yahoo.com>	<4DA58194.4070403@anonymous.org.uk> <20110413211310.53f6026f@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110413211310.53f6026f@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Gavin Flower <gavinflower@yahoo.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 13/04/2011 12:13, NeilBrown wrote:
> On Wed, 13 Apr 2011 11:57:24 +0100 John Robinson
> <john.robinson@anonymous.org.uk>  wrote:
>> On 12/04/2011 22:30, Gavin Flower wrote:
[...]
>>> md0 : active raid6 sda3[0] sdb3[4] sdd3[3] sdc3[5](F) sde3[1]
>>>         10751808 blocks level 6, 64k chunk, algorithm 2 [5/4] [UU_UU]
>>
>> This one I don't get:
>> md0 : active raid6 sda3[0] sde3[1] sdd3[3] sdb3[4] sdc3[5](F)
>> which ought to be UUUU_ again...
>>
>> Perhaps `mdadm -D /dev/md[0-2]` would make things clearer...
>
> This is actually more horrible than you imagine.

It isn't really, I was asking for the mdadm -D output precisely to get 
the list of role and slot numbers, having noticed there was no slot 2 in 
Gavin's setup...

[...]
> As the current number is pretty much useless, I should probably change it to
> the slot number, or an arbitrarily assigned larger number for spares.
> This would be an incompatible change, but I very much doubt anyone uses the
> numbers for what they actually are, so I doubt that would really matter.
>
> It has just never really got high on my list of priorities....
>
> Lesson:  Ignore the number in [] - it doesn't mean anything useful.

It's not useless, it reflects the order in which devices were added to 
the array.

Suggestion: Don't change the number in /proc/mdstat, just sort the 
devices by role (i.e. the same order as the UUUU_) instead of device 
node, and show spares at the end (as per your arbitrarily-assigned 
larger number, which this way you never have to display).

Cheers,

John.
