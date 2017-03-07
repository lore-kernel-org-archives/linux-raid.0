From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/2] md: add bad block flag to disk state
Date: Tue, 7 Mar 2017 07:54:26 +0100
Message-ID: <1430d533-495c-8f98-fb11-26543a9d7f9c@suse.de>
References: <1485259419-2308-1-git-send-email-tomasz.majchrzak@intel.com>
 <1485259419-2308-2-git-send-email-tomasz.majchrzak@intel.com>
 <20170130233341.l5eiars5lbgowrht@kernel.org>
 <20170201095352.GA24920@proton.igk.intel.com>
 <20170201181215.4d5nfyxmpsmgenks@kernel.org> <wrfjlgsim9xv.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjlgsim9xv.fsf@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com, Shaohua Li <shli@kernel.org>
Cc: Tomasz Majchrzak <tomasz.majchrzak@intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/06/2017 09:23 PM, jes.sorensen@gmail.com wrote:
> Shaohua Li <shli@kernel.org> writes:
>> On Wed, Feb 01, 2017 at 10:53:52AM +0100, Tomasz Majchrzak wrote:
>>> On Mon, Jan 30, 2017 at 03:33:41PM -0800, Shaohua Li wrote:
>>>> On Tue, Jan 24, 2017 at 01:03:38PM +0100, Tomasz Majchrzak wrote:
>>>>> Add a new flag to report that bad blocks are present on a disk. It will
>>>>> allow userspace to notify the user of the problem.
>>>>>
>>>>> Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
>>>>> ---
>>>>>  drivers/md/md.c                | 2 ++
>>>>>  include/uapi/linux/raid/md_p.h | 1 +
>>>>>  2 files changed, 3 insertions(+)
>>>>>
>>>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>>>> index 0abb147..1a807ec 100644
>>>>> --- a/drivers/md/md.c
>>>>> +++ b/drivers/md/md.c
>>>>> @@ -6034,6 +6034,8 @@ static int get_disk_info(struct mddev *mddev, void __user * arg)
>>>>>  			info.state |= (1<<MD_DISK_WRITEMOSTLY);
>>>>>  		if (test_bit(FailFast, &rdev->flags))
>>>>>  			info.state |= (1<<MD_DISK_FAILFAST);
>>>>> +		if (rdev->badblocks.count)
>>>>> +			info.state |= (1<<MD_DISK_BB_PRESENT);
>>>>
>>>> Userspace can find if a disk has badblocks by reading the bad_blocks sysfs
>>>> file. Why adds another interface?
>>>>
>>>> Thanks,
>>>> Shaohua
>>>
>>> Yes, indeed, it can. I have chosen to do it this way to keep it consistent
>>> with mdadm which uses GET_DISK_INFO ioctl to get disk information. All data
>>> provided in this ioctl is also available in sysfs file (rdev state), however
>>> ioctl is still used (legacy). The same applies for details subcommand of
>>> mdadm. To answer your question - yes, I could avoid new flag but it would
>>> make mdadm side of my improvement much more complicated.
>>
>> I intended to avoid adding new user interface if possible. Not sure about this
>> case though. How complicated in the mdadm side if we use the bad_block sysfs
>> file?
>>
>> Jes, how do you think from the mdadm side?
> 
> Hi,
> 
> Sorry for being so late getting back on this, I am just getting back to
> this now.
> 
> I am really split on this - if we have spare flags available, I guess
> it's not the end of the World. On the other hand there is something to
> be said for not adding any more using the old interface.
> 
> Right now mdadm relies heavily on the ioctl interfaces. In order to
> migrate away from that, we need to spend a fair amount of time to
> rewriting the general interface first. Something I think we should
> invest some time into doing, but having to handle both in parallel seems
> a bad idea to me.
> 
Personally I would positively _love_ a consistent interface.
ATM we have about 3 (or was it 4?) different interfaces, all of which
providing _different_ information.
(Not to mention the odd stall when reading that information...)

Coalescing all of that into _one_ set, or, better still, make sure that
one interface (sysfs?) provides all information would be a massive bonus.
And would finally enable us to provide an API for library usage.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
