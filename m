From: Tony Coffman <tony@emitony.com>
Subject: Re: Device naming and raid1
Date: Wed, 27 Aug 2008 10:48:27 -0400
Message-ID: <48B5693B.9030504@emitony.com>
References: <48B42226.3020702@emitony.com>	 <A20315AE59B5C34585629E258D76A97C01A506E3@34093-C3-EVS3.exchange.rackspace.com>	 <48B554CA.4010804@emitony.com>	 <921ca19c0808270631r784b5cx36d4636d63692e97@mail.gmail.com> <921ca19c0808270708v5d0b9854ved991f13a2c3b35d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <921ca19c0808270708v5d0b9854ved991f13a2c3b35d@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sujit Karataparambil wrote:
> http://www.gagme.com/greg/linux/raid-lvm.php
>
> you can try this with the spare drives you have.
>
> basically what you have to do is to check whether the drive
> now linked to another device name, is the reason for this
> problem.
>
> once it shows unplugged or failed you can, use your new
> replacement drive and reboot.
>
> Kindly read the comments to this article, Which is very
> usefull.
>
> On 8/27/08, Sujit Karataparambil <sjt.kar@gmail.com> wrote:
>   
>>> Thanks much for the reply.  For the purposes of this discussion you can
>>> assume that I've already re-established confidence in the drive, the
>>> cable, and the controller and that the data on the drives is worthless
>>> and I just want to get maximum uptime without causing a raid assemble
>>> problem on the next reboot.
>>>       
>> Good.
>>
>>     
>>> Any idea on my original question?  If I re-add the drive using the
>>> /dev/sdc name will I have problems on the next boot when the drive is
>>> named /dev/sda?
>>>       
>> Since this seems to be block device it really does not matter.
>>
>>     
>>> Based on my experience with Linux and other software raid
>>> implementations, I'm strongly inclined to think that the device naming
>>> doesn't matter - the system will scan the drives at boot looking for
>>>       
>> Kindly read some decent kernel documentation before you jump up and
>> say this. Kindly surf the net and read some decent article's before you
>> do any precious upgrades for now.
>>
>> Sujit
>>
>> --
>> --linux(2.4/2.6),bsd(4.5.x+),solaris(2.5+)
>>
>>     
>
>   

Sujit,
Thanks for the replies and the link.  I appreciate them.

I spent several hours this week reading the kernel documentation
(md.txt), the mdadm man pages, the linux-raid wiki, and reading articles
on the net before posting to the list.

I highly recommend this wiki page from IBM for anybody who has an issue
similar to mine (temporary failure that knocks a drive offline who wants
to bring it back online without a reboot).  This really helped me
understand the processes for running a highly available raid-1 set on
the linux kernel.  The hardware is different but the same principles work.

http://www-941.ibm.com/collaboration/wiki/pages/viewpage.action?pageId=3625

For anybody who is interested, I grabbed a test system this morning to
simulate my situation (temporary drive failure).  You can, in fact,
bring the failed drive back online with a different device name,
remirror it, and reboot with no issues on Centos5.  The key, as Steve
Fairbairn pointed out, is that the mdadm.conf file is setup to use the
RAID UUID.  I moved the drives into a different scan order with a the
same test and that works also.  My situation is slightly complicated by
the fact that I'm booting off these same drives so I had to mirror the
MBR on the second drive but since I had already done this previously on
the wonky system this was easily achieved.

see here
http://www.dirigo.net/tuxTips/avoidingProblems/GrubMdMbr.php

I'm running a couple of more tests today to see what happens if I rescan
the device to bring it back online with the same device name - I'll post
the result in case anybody is interested.  I expect that I'll have to
initiate the rebuild but don't expect any other problems.

Regards,
--Tony

