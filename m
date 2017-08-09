From: David R <david@unsolicited.net>
Subject: Re: [MD] Crash with 4.12+ kernel and high disk load -- bisected to
 4ad23a976413: MD: use per-cpu counter for writes_pending
Date: Wed, 09 Aug 2017 06:28:37 +0000
Message-ID: <20170809062837.Horde.FGhyXH8bqUtevHY6m-LHp8x@vinovium.com>
References: <ee7921d2-d3ff-2381-1f05-2c07b8001d08@unsolicited.net>
 <c2df7906-67b2-b33f-0e82-49e6ef53f5f1@unsolicited.net>
 <20170807112025.GA3094@light.dominikbrodowski.net>
 <87k22esfuf.fsf@notabene.neil.brown.name>
 <20170808073614.GA21316@light.dominikbrodowski.net>
 <20170808090600.GA28583@isilmar-4.linta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170808090600.GA28583@isilmar-4.linta.de>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: NeilBrown <neilb@suse.com>, Shaohua Li <shli@fb.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, tj@kernel.org
List-Id: linux-raid.ids

My raid check also ran through cleanly, so feel free to add my Tested-By:

Cheers
David

Quoting Dominik Brodowski <linux@dominikbrodowski.net>:

> On Tue, Aug 08, 2017 at 09:36:14AM +0200, Dominik Brodowski wrote:
>> On Tue, Aug 08, 2017 at 05:01:28PM +1000, NeilBrown wrote:
>> > On Mon, Aug 07 2017, Dominik Brodowski wrote:
>> >
>> > > Neil, Shaohua,
>> > >
>> > > following up on David R's bug message: I have observed something similar
>> > > on v4.12.[345] and v4.13-rc4, but not on v4.11. This is a RAID1 (on bare
>> > > metal partitions, /dev/sdaX and /dev/sdbY linked together). In case it
>> > > matters: Further upwards are cryptsetup, a DM volume group, then logical
>> > > volumes, and then filesystems (ext4, but also happened with xfs).
>> > >
>> > > In a tedious bisect (the bug wasn't as quickly reproducible as  
>> I would like,
>> > > but happened when I repeatedly created large lvs and filled  
>> them with some
>> > > content, while compiling kernels in parallel), I was able to track this
>> > > down to:
>> > >
>> > >
>> > > commit 4ad23a976413aa57fe5ba7a25953dc35ccca5b71
>> > > Author: NeilBrown <neilb@suse.com>
>> > > Date:   Wed Mar 15 14:05:14 2017 +1100
>> > >
>> > >     MD: use per-cpu counter for writes_pending
>> > >
>> > >     The 'writes_pending' counter is used to determine when the
>> > >     array is stable so that it can be marked in the superblock
>> > >     as "Clean".  Consequently it needs to be updated frequently
>> > >     but only checked for zero occasionally.  Recent changes to
>> > >     raid5 cause the count to be updated even more often - once
>> > >     per 4K rather than once per bio.  This provided
>> > >     justification for making the updates more efficient.
>> > >
>> > >     ...
>> >
>> > Thanks for the report... and for bisecting and for re-sending...
>> >
>> > I believe I have found the problem, and have sent a patch separately.
>> >
>> > If mddev->safemode == 1 and mddev->in_sync != 0, md_check_recovery()
>> > causes the thread that calls it to spin.
>> > Prior to the patch you found, that couldn't happen.  Now it can,
>> > so it needs to be handled more carefully.
>> >
>> > While I was examining the code, I found another bug - so that is a win!
>> >
>> > Thanks,
>> > NeilBrown
>>
>>
>> Nice catch. Thanks! Will give it (both patches at once) a try on the test
>> system immediately.
>
> More than 2 hours of stress-testing shows no issues any more. Very nice.
> Thanks!
>
> 	Dominik
