From: Phil Turmel <philip@turmel.org>
Subject: Re: Recovering RAID5 with 2, actually 1, faulty disks.
Date: Wed, 25 Nov 2015 11:58:57 -0500
Message-ID: <5655E8D1.2050906@turmel.org>
References: <189791448292518@web28m.yandex.ru> <565359F6.3020201@turmel.org>
 <3822301448453563@web17m.yandex.ru> <5655B62F.2070806@turmel.org>
 <240681448462882@web25o.yandex.ru> <939171448463324@web17m.yandex.ru>
 <5655D75B.9020901@turmel.org> <166511448468944@web24o.yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <166511448468944@web24o.yandex.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Semyon Enskiy <semyon.enskiy@yandex.ru>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/25/2015 11:29 AM, Semyon Enskiy wrote:
>>>  Maybe assemble command should include sdj3 device too?
>>>  Like
>>>  # mdadm -v --assemble --update=revert-reshape /dev/md3 /dev/sd[a-j]3
>>>  not
>>>  # mdadm -v --assemble --update=revert-reshape /dev/md3 /dev/sd[a-i]3
>>
>> Yes, my mistake. :-( Try again, including 'sdj3'.
>>
>> Phil
> 
> # mdadm -v --assemble --update=revert-reshape /dev/md3 /dev/sd[a-j]3
> mdadm: looking for devices for /dev/md3
> mdadm: superblock on /dev/sdj3 doesn't match others - assembly aborted
> 
> # mdadm -v --assemble --update=revert-reshape --force /dev/md3 /dev/sd[a-j]3
> mdadm: looking for devices for /dev/md3
> mdadm: superblock on /dev/sdj3 doesn't match others - assembly aborted
> 
> Note, that --examine in previous message shows delta devices value "-1" for
> all members of array, excepting sdj3, which has value "1", without minus
> symbol.

Hmmm. That's interesting.  That means mdadm wrote the revert-reshape
before it finished assembly.  Try this:

mdadm --stop /dev/md3

mdadm --assemble --update=revert-reshape /dev/md3 /dev/sdj3

That should fail w/ not enough to start, but apply the revert to that
one drive.  Then --stop again, and try with [a-j].

Phil

