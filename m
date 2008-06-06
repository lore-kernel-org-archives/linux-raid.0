From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: After partition resize, RAID5 array does not assemble on boot
Date: Fri, 06 Jun 2008 09:52:45 -0400
Message-ID: <4849412D.9030607@tmr.com>
References: <4844E994.8020808@jellybean.co.uk>    <4845B573.7090801@jellybean.co.uk> <48675.192.168.1.70.1212528422.squirrel@neil.brown.name> <484636B9.20700@jellybean.co.uk> <48464B3A.7070206@dgreaves.com> <4846529B.1000809@jellybean.co.uk> <484681AF.8030004@dgreaves.com> <48469523.4050601@jellybean.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <48469523.4050601@jellybean.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Jules Bean <jules@jellybean.co.uk>
Cc: David Greaves <david@dgreaves.com>, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jules Bean wrote:
> David Greaves wrote:
>>> I don't really see that it's "safer" though. I would have thought it 
>>> was
>>> quicker but potentially less safe.
>>
>> Avoiding a lot of time stress testing the disks in degraded mode 
>> isn't 'safer'?
>
> Stress testing the disks by an md rebuild is a feature! It increases 
> confidence that they work.
>
> ;)
>
> Seriously, I understand your point now. Yes, a rebuild-free partition 
> resize would be a nice feature. So would a "help, please find my 
> superblock by exhaustive scanning" utility ;)

Since this code must work when a partition is added on a totally new 
drive, and when the partition is grown DOWN from the low end, clearly 
the default must be a rebuild. And running "repair" before doing this 
stuff is a really good idea!

What is needed is to do something like assume-clean on the old data and 
a sync on the new chunks. I don't see that there is a remotely safe way 
to do that, currently, although if you were willing to be unsafe you 
could remove a partition, grow it at the "top" end, and reassemble with 
--assume-clean. Sprinkling with holy water first might be a good thing. 
I'm just thinking out loud here, there are probably good reasons why 
this wouldn't work.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


