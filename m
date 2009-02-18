From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] md: 'size_limit' attribute
Date: Tue, 17 Feb 2009 17:06:33 -0700
Message-ID: <e9c3a7c20902171606g1ad719f6v812aecc06f20ac2@mail.gmail.com>
References: <1234549811.26769.7.camel@dwillia2-linux.ch.intel.com>
	 <18838.14442.891790.33471@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18838.14442.891790.33471@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, ed.ciechanowski@intel.com, jacek.danecki@intel.com
List-Id: linux-raid.ids

On Fri, Feb 13, 2009 at 8:20 PM, Neil Brown <neilb@suse.de> wrote:
> On Friday February 13, dan.j.williams@intel.com wrote:
>> Subject: md: 'size_limit' attribute
>> From: Dan Williams <dan.j.williams@intel.com>
>>
>> Provide a sysfs attribute to allow a raid array to be truncated to an
>> arbitrary size.  This functionality is needed to support imsm raid
>> arrays where the metadata format expects that the size of some arrays is
>> rounded down to the nearest 1MB boundary.
>
> Well it's not April 1st, so I assume you are serious.
>
> It really truncates the array, not the individual drives?
> So you could have e.g. a raid0 in which only some of the last stripe
> was used?

Unfortunately yes.  It will even record the "correct" value for
num_data_stripes based on the per device size, but the actual
array_size recorded in the metadata is this weird rounded down value.

> Can you give me a concrete example of an array where this will make a
> required difference?  I just want to be sure I understand.

1/ Array created in orom
2/ User assembles, partitions, and formats the array in Linux
3/ User reboots into Windows and sees data missing off the end of the volume

So, it is purely an interoperability issue with other imsm drivers.

> I guess you couldn't just add an 'array_size' attribute which gave
> direct access to mddev->array_size because that gets set when the
> array is started, and we want to be able to impose the limit before
> starting the array....
>
> How about a semantic where starting the array will only modify
> ->array_size if it's value is zero of if it would reduce the value.
>
>
> How might this interact with array resizing?  You add a drive to an
> array, reshape it, and then it doesn't get any bigger until the
> size_limit is updated?   I guess that could work but it might be
> confusing.... though presumably mdadm/mdmon would know to look after
> all the details.
>
>
> What would you think of renaming the attribute to 'array_size' with
> the semantic of "once user-space sets it, the kernel will never change
> it" ??

To be be sure I understand, the differences from the current patch:
1/ The kernel will set ->array_size at array start time unless
userspace has modified it from zero.  If userspace has modified it we
should probably refuse to run if ->array_size is > ->array_sectors?
Upon successfully starting the array we record that userspace owns
->array_size.
2/ At reshape time the kernel sets ->array_size = ->array_sectors
unless userspace owns ->array_size at which point we don't touch
->array_size.  I assume we must then block attempts to reshape the
array to a smaller than ->array_size size when userspace ->array_size
is in effect?
3/ While an array is active userspace can set ->array_size only if the
kernel has recorded that ->array_size is under userspace control, and
then it can only set a value that is <= ->array_sectors?

Thanks,
Dan
