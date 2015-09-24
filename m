From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: Bad raid0 bio too large problem
Date: Thu, 24 Sep 2015 08:59:56 -0400
Message-ID: <wrfjwpvgvupf.fsf@redhat.com>
References: <wrfjoagucvyq.fsf@redhat.com>
	<87k2rhyiqe.fsf@notabene.neil.brown.name>
	<wrfjvbb12xl8.fsf@redhat.com>
	<87io70wmst.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87io70wmst.fsf@notabene.neil.brown.name> (Neil Brown's message
	of "Thu, 24 Sep 2015 12:53:06 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Xiao Ni <xni@redhat.com>, linux-raid <linux-raid@vger.kernel.org>, yizhan@redhat.com
List-Id: linux-raid.ids

Neil Brown <neilb@suse.de> writes:
> Jes Sorensen <Jes.Sorensen@redhat.com> writes:
>
>> Neil Brown <neilb@suse.de> writes:
>>> Jes Sorensen <Jes.Sorensen@redhat.com> writes:
>>>
>>>> Hi Neil,
>>>>
>>>> I think we have some bad side effects with this patch:
>>>>
>>>> commit 199dc6ed5179251fa6158a461499c24bdd99c836
>>>> Author: NeilBrown <neilb@suse.com>
>>>> Date:   Mon Aug 3 13:11:47 2015 +1000
>>>>
>>>>     md/raid0: update queue parameter in a safer location.
>>>>     
>>>>     When a (e.g.) RAID5 array is reshaped to RAID0, the updating
>>>>     of queue parameters (e.g. max number of sectors per bio) is
>>>>     done in the wrong place.
>>>>     It should be part of ->run, but it is actually part of ->takeover.
>>>>     This means it happens before level_store() calls:
>>>>     
>>>>         blk_set_stacking_limits(&mddev->queue->limits);
>>>>     
>>>> Running the '03r0assem' test suite fills my kernel log with output like
>>>> below. Yi Zhang also had issues where writes failed too.
>>>>
>>>> robably something we need to resolve for 4.2-final or revert the
>>>> offending patch.
>>>>
>>>> Cheers,
>>>> Jes
>>>>
>>>> md: bind<loop0>
>>>> md: bind<loop1>
>>>> md: bind<loop2>
>>>> md/raid0:md2: md_size is 116736 sectors.
>>>> md: RAID0 configuration for md2 - 1 zone
>>>> md: zone0=[loop0/loop1/loop2]
>>>>       zone-offset=         0KB, device-offset=         0KB, size=     58368KB
>>>>
>>>> md2: detected capacity change from 0 to 59768832
>>>> bio too big device loop0 (296 > 255)
>>>> bio too big device loop0 (272 > 255)
>>>
>>> 1/ Why do you blame that particular patch?
>>>
>>> 2/ Where is that error message coming from?  I cannot find "bio too big"
>>>   in the kernel (except in a comment).
>>>   Commit: 54efd50bfd87 ("block: make generic_make_request handle
>>> arbitrarily sized bios")
>>>   removed the only instance of the error message that I know of.
>>>
>>> Which kernel exactly are you testing?
>>
>> I blame it because of bisect - I revert that patch and the issue goes
>> away.
>>
>> I checked out 199dc6ed5179251fa6158a461499c24bdd99c836 in Linus' tree,
>> see the bio too large. I revert it and it goes away.
>
> Well that's pretty convincing - thanks.
> And as you say - it is tagged for -stable so really needs to be fixed.
>
> Stares at the code again.  And again.
>
> Ahhh.  that patch moved the
>   blk_queue_max_hw_sectors(mddev->queue, mddev->chunk_sectors);
> to after
>  disk_stack_limits(...);
>
> That is wrong.
>
> Could you confirm that this fixes your test?

I refuse to do that! .... since Xiao beat me to it! Thanks!

I was half way bisecting my way through it last night. For some reason
the problem was reproducible in 4.2 if I applied the offending patch,
but not in 4.3-rc2.

Any chance you'll push these to your git tree in the near future?

Thanks!
Jes
