From: "Nigel J. Terry" <nigel@nigelterry.net>
Subject: Re: Raid 5 Problem
Date: Sun, 14 Dec 2008 16:08:21 -0500
Message-ID: <494575C5.4070007@nigelterry.net>
References: <49450D04.8060703@nigelterry.net> <4945276E.1010405@ziu.info> <49456F94.8020100@nigelterry.net> <alpine.DEB.1.10.0812141552380.27065@p34.internal.lan> <4945735A.6030909@nigelterry.net> <alpine.DEB.1.10.0812141600430.27065@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0812141600430.27065@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
Cc: Michal Soltys <soltys@ziu.info>
List-Id: linux-raid.ids

Justin Piszcz wrote:
>
>
> On Sun, 14 Dec 2008, nterry wrote:
>
>> Justin Piszcz wrote:
>>>
>>>
>>> On Sun, 14 Dec 2008, nterry wrote:
>>>
>>>> Michal Soltys wrote:
>>>>> nterry wrote:
>>>>>> Hi.  I hope someone can tell me what I have done wrong.  I have a 
>>>>>> 4 disk Raid 5 array running on Fedora9.  I've run this array for 
>>>>>> 2.5 years with no issues.  I recently rebooted after upgrading to 
>>>>>> Kernel 2.6.27.7.
>
>> [root@homepc ~]# mdadm --examine --scan
>> ARRAY /dev/md0 level=raid5 num-devices=2 
>> UUID=c57d50aa:1b3bcabd:ab04d342:6049b3f1
>>  spares=1
>> ARRAY /dev/md0 level=raid5 num-devices=4 
>> UUID=50e3173e:b5d2bdb6:7db3576b:644409bb
>>  spares=1
>> ARRAY /dev/md0 level=raid5 num-devices=4 
>> UUID=50e3173e:b5d2bdb6:7db3576b:644409bb
>>  spares=1
>> [root@homepc ~]#
>
> I saw Debian do something like this to one of my raids once and it was 
> because
> /etc/mdadm/mdadm.conf had been changed through an upgrade or some such 
> to use
> md0_X, I changed it back to /dev/md0 and the problem went away.
>
> You have another issue here though, it looks like your "few" attempts 
> have
> lead to multiple RAID superblocks.  I have always wondered how one can 
> clean
> this up without dd if=/dev/zero of=/dev/dsk & (for each disk, wipe it) 
> to get
> rid of them all, you should only have [1] /dev/md0 for your raid 5, 
> not 3.
>
> Neil?
>
> Justin.
>
The difference in my case is that I don't have /dev/md_d0 in 
/etc/mdadm.conf and have never had that.  It seems that something is 
automatically creating it at boot and that has changed in the last few days.

Wait for Neil I guess...
