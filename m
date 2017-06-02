From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: Grow set size issue
Date: Fri, 2 Jun 2017 13:48:55 -0400
Message-ID: <7964b1f5-5092-238b-403e-ed4fba584746@gmail.com>
References: <wrfjlgrodlbj.fsf@gmail.com>
 <87o9wju5r0.fsf@notabene.neil.brown.name>
 <89891c04-620c-0dc2-97af-719b480aa4e5@gmail.com>
 <20170602110110.GA29246@proton.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170602110110.GA29246@proton.igk.intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/02/2017 07:01 AM, Tomasz Majchrzak wrote:
> On Thu, Mar 30, 2017 at 10:10:32AM -0400, Jes Sorensen wrote:
>> On 03/29/2017 05:34 PM, NeilBrown wrote:
>>> On Thu, Mar 30 2017, jes.sorensen@gmail.com wrote:
>>>
>>>> Hi Neil,
>>>>
>>>> In the below patch you changed the error handling, to make the kernel
>>>> not setting the size of the device being an error. However we still have
>>>> the code in place to handle the error, except it never triggers.
>>>
>>> So we do.  I should have removed all of that.
>>> I should have just reverted
>>> Commit: 65a9798b58b4 ("FIX: Detect error and rollback metadata")
>>>
>>>
>>>>
>>>> Question is do you remember the reason for this change? Old kernels not
>>>> allowing it, are there any legitimate reasons for the kernel to refuse
>>>> the size change?
>>>
>>> I needed to go further back to remind myself why we do these size change
>>> at all.
>>> The command being run here is "mdadm --grow /dev/mdX --size=foo"
>>> which has a primary purpose of changing the component_size of the array.
>>> What can happen is that someone makes all the components bigger
>>> (E.g. with LVM) and then uses this command to set --size=max, and it
>>> doesn't work.  That is because md doesn't know the devices are bigger.
>>>
>>> You can tell md that devices have changes size by writing to the "size"
>>> attribute.
>>> mdadm doesn't have an option for doing that per-device - you need to
>>> poke into sysfs.
>>>
>>> To make it a bit easier, when you use "--grow --size=foo", mdadm will
>>> always write "foo" to the "size" attribute of each device, just incase
>>> that will be helpful. In the case where the device is now bigger, it
>>> will.
>>>
>>> In the case where the size of the array is being reduced, it is not
>>> permitted to change the "size" of each device until the "component_size"
>>> of the array has changed, so these attempts to change "size" will fail.
>>> But that isn't a problem.
>>>
>>> In short, the attempt to change "size" here is a convenience, and
>>> optimization.  It doesn't matter if it fails.
>>>
>>> So please just revert all bits of the above commit that are still
>>> present.
>>
>> Hi Neil,
>>
>> Thanks for the explanation, I'll take the big hammer to the
>> leftovers and get rid of them.
>>
>> Jes
> 
> Hi,
> 
> The commit 758b327cf5a ("Grow: Remove unnecessary optimization") breaks grow
> operation for external metadata.
> 
> mdadm --create /dev/md/imsm0 --metadata=imsm --raid-devices=4 /dev/nvme[0-3]n1 --run
> mdadm --create /dev/md/r5 --level=5 --chunk 64 --size=1G --raid-devices=3 /dev/nvme[0-2]n1 --run --assume-clean
> 
> MDADM_EXPERIMENTAL=1 mdadm --grow /dev/md/r5 --size=2G
> mdadm: Cannot set device size for /dev/md/r5: No space left on device
> 
>  From update_size in MD driver:
> 
> 	if (avail < num_sectors)
> 		-ENOSPC;
> 
> In the above case 'avail' is set to old value (1GiB) and new size requested
> ('num_sectors') is 2GiB.
> 
> Shall we revert the recent change then?

Rather than just reverting, track down whats wrong and fix it.

Jes

