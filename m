From: Jeff Woods <kazrak+kernel@cesmail.net>
Subject: Re: RAID1 VS RAID5
Date: Mon, 27 Oct 2003 04:03:59 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <5.2.1.1.0.20031027034847.01b25630@no.incoming.mail>
References: <200310270927.32751.dusty@strike.wu-wien.ac.at>
 <1067179519.1222.107.camel@cala>
 <200310261716.17030.maarten@vbvb.nl>
 <200310270927.32751.dusty@strike.wu-wien.ac.at> <200310271208.04442.maarten@vbvb.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200310271208.04442.maarten@vbvb.nl>
References: <200310270927.32751.dusty@strike.wu-wien.ac.at>
 <1067179519.1222.107.camel@cala>
 <200310261716.17030.maarten@vbvb.nl>
 <200310270927.32751.dusty@strike.wu-wien.ac.at>
To: maarten van den Berg <maarten@vbvb.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

maarten van den Berg wrote (in part):
>The way it works now, AFAIK, is that concurrent read commands are issued 
>to all the drives in Raid1.  Because of seek times and the amount of 
>rotation needed to get the right sector underneath the head(s), one of the 
>disks will be first to transfer the data. This can be 'sooner' by a large 
>amount.
>
>If you instead want to interleave reads you lose the possibility to gain 
>speed from this mechanism described above. It would be a trade-off and I'm 
>not sure interleaving would come out as the winner here.

IIUC, neither duplicate reads nor interleaved reads closely matches how 
(Linux software) RAID1 works.  I'm not sure what the local protocol is (and 
if I'm stepping way out of line here, someone please correct me offlist), 
but I'm going to quote another post sent via this listserver last month:

>>From: "Bailey, Scott" <scott.bailey@eds.com>
>>To: "'Andrew Herdman'" <andrew@whine.com>
>>Cc: linux-raid@vger.kernel.org
>>Subject: RE: RAID1: Disks alternating on reads
>>Date: Tue, 23 Sep 2003 11:12:29 -0400
>>
>>>Pardon me if my assumption was incorrect, but I was under the belief 
>>>that when using software RAID1, that when reads occurred on the RAID 
>>>device that it would read from both drives in a striped fashion similar 
>>>to how RAID0 works to improve the speed of the md devices.   I am 
>>>actually seeing this, but it appears that the reads on each drive are 
>>>continuing for 10 to 20 seconds before moving onto the next drive and 
>>>then another 10-20 seconds and back again.  This is not allowing for any 
>>>performance increase, it just lets the drives rest alternately.
>>
>>My impression from crawling through the code a few months back was that 
>>this behavior was a design feature. On a read request, the request is 
>>sent to the device with heads "closest" to the target sector, EXCEPT that 
>>for sequential reads, the device gets reused on the assumption that the 
>>disk can be kept streaming, EXCEPT that after some maximum number of 
>>reads, another drive gets chosen to give the previous device a rest.
>>
>>I speculate your files are contiguous (or nearly so) with the result that 
>>the initially closest drive gets hammered until its 'work quota' gets 
>>exceeded, and then the next drive will get pounded. And so on. To test 
>>this, I think you could reduce MAX_WORK_PER_DISK in raid1.c from the 
>>default 128 (in 2.4.21) to something smaller (perhaps 8 sectors for a 
>>filesystem with 4K block size?) and see if the load evens out.
>>
>>Good luck,
>>
>>         Scott Bailey
>>         scott.bailey at eds.com

I believe the method Scott says the present code uses to be near optimal 
and am skeptical that arbitrary changes to it would be improvements.  Of 
course, someone actually making such changes and then multiple people 
benchmarking it in a variety of different, well-designed, controlled tests 
is the only way to really tell.

--
Jeff Woods <kazrak+kernel@cesmail.net>  


