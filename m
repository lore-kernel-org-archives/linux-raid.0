From: Phil Turmel <philip@turmel.org>
Subject: Re: no good deed goes unpunished...
Date: Tue, 31 Mar 2015 17:54:34 -0400
Message-ID: <551B179A.6020008@turmel.org>
References: <20150327103301.16746hhb6t1sroel@webmail.uniserve.com> <CAAMCDef5ejTu4aoYxMRxaRPvV9kKO4qwzbo9jAuPnFDYDoHo0A@mail.gmail.com> <20150327173709.19022q59t5hxh4tx@webmail.uniserve.com> <5515FC86.7030402@fnarfbargle.com> <20150331144155.14405dy3bqxotw9v@webmail.uniserve.com> <551B1717.2090809@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <551B1717.2090809@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Dave Stevens <geek@uniserve.com>, Brad Campbell <brad@fnarfbargle.com>
Cc: Roger Heflin <rogerheflin@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 03/31/2015 05:52 PM, Phil Turmel wrote:
> On 03/31/2015 05:41 PM, Dave Stevens wrote:
>> Quoting Brad Campbell <brad@fnarfbargle.com>:
>>
>>> md12 has claimed sda2 and md10 has sdb&c. Try this
>>>
>>> mdadm --stop /dev/md12
>>> mdadm --stop /dev/md10
>>> mdadm --assemble --force /dev/md13 /dev/sd[abc]2
>>
>> I owe you a beer, Brad! Now I only have to mount the LVM partition,
>> retrieve the Xen domains and rejig the management tools so I can do a
>> meaningful backup and restore but this is the bit I couldn't get my head
>> around.
> 
> If you did this with those three disks, you are likely to have random
> data corruption from the older mirror.  If so, stop and re-assemble with
> just the last good disks.

Let me clarify: you only had *two* working disks for a month or so
before the array finally died.  Only assemble those two.

Phil

