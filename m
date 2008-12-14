From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Raid 5 Problem
Date: Sun, 14 Dec 2008 16:03:47 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0812141600430.27065@p34.internal.lan>
References: <49450D04.8060703@nigelterry.net> <4945276E.1010405@ziu.info> <49456F94.8020100@nigelterry.net> <alpine.DEB.1.10.0812141552380.27065@p34.internal.lan> <4945735A.6030909@nigelterry.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4945735A.6030909@nigelterry.net>
Sender: linux-raid-owner@vger.kernel.org
To: nterry <nigel@nigelterry.net>
Cc: linux-raid@vger.kernel.org, Michal Soltys <soltys@ziu.info>
List-Id: linux-raid.ids



On Sun, 14 Dec 2008, nterry wrote:

> Justin Piszcz wrote:
>> 
>> 
>> On Sun, 14 Dec 2008, nterry wrote:
>> 
>>> Michal Soltys wrote:
>>>> nterry wrote:
>>>>> Hi.  I hope someone can tell me what I have done wrong.  I have a 4 disk 
>>>>> Raid 5 array running on Fedora9.  I've run this array for 2.5 years with 
>>>>> no issues.  I recently rebooted after upgrading to Kernel 2.6.27.7.

> [root@homepc ~]# mdadm --examine --scan
> ARRAY /dev/md0 level=raid5 num-devices=2 
> UUID=c57d50aa:1b3bcabd:ab04d342:6049b3f1
>  spares=1
> ARRAY /dev/md0 level=raid5 num-devices=4 
> UUID=50e3173e:b5d2bdb6:7db3576b:644409bb
>  spares=1
> ARRAY /dev/md0 level=raid5 num-devices=4 
> UUID=50e3173e:b5d2bdb6:7db3576b:644409bb
>  spares=1
> [root@homepc ~]#

I saw Debian do something like this to one of my raids once and it was because
/etc/mdadm/mdadm.conf had been changed through an upgrade or some such to use
md0_X, I changed it back to /dev/md0 and the problem went away.

You have another issue here though, it looks like your "few" attempts have
lead to multiple RAID superblocks.  I have always wondered how one can clean
this up without dd if=/dev/zero of=/dev/dsk & (for each disk, wipe it) to get
rid of them all, you should only have [1] /dev/md0 for your raid 5, not 3.

Neil?

Justin.

