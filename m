From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: Weirdness with DDF arrays (mdadm 3.3)
Date: Mon, 16 Sep 2013 21:31:36 +0200
Message-ID: <CAC9WiBjDFiNZdeoeaABZ6+2EoD8Mtpj11Jq+vFF9bqLuO8XEpQ@mail.gmail.com>
References: <CAC9WiBgJX4VH7-cNMVcqPL-9UpsH03Z7cRKvLUOSUogkiQpx7Q@mail.gmail.com>
	<52346FB1.2020205@arcor.de>
	<CAC9WiBiD4b9gKoEBCvWEOSbBtq72hZ-QFpbGpsEOinDWSatffw@mail.gmail.com>
	<5234C300.1050206@arcor.de>
	<CAC9WiBg+HQBzP_GpUosQrVgvv8znh+pOwtDVGseB2t5yxB6pbA@mail.gmail.com>
	<52360E9B.5050606@arcor.de>
	<CAC9WiBiFs8V+_iWx9sRW6WEPLAKR85zxBpHb3SsWa0k6J7z7Fg@mail.gmail.com>
	<523739A3.60507@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <523739A3.60507@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Sep 16, 2013 at 7:02 PM, Martin Wilck <mwilck@arcor.de> wrote:
> On 09/16/2013 03:47 PM, Francis Moreau wrote:
> [...]
>
>>>>> Wrt loop1[2], I think you interpret the [2] wrongly. It seems to be the
>>>>> kernel index of the device somehow. The mdstat parsing code of mdadm
>>>>> doesn't look at this number. If you look at
>>>>> /sys/class/block/md124/md/dev-loop*/slot, the number should be correct -
>>>>> I tried it here.
>>>>
>>>> Well I think I interpreted the numbers the way it's described here :
>>>>
>>>> https://raid.wiki.kernel.org/index.php/Mdstat#md_device_line
>>>
>>> That description is not quite correct. The number in brackets [2] means
>>> the index of the disk in the meta data (for DDF, that's the index in the
>>> "physical disks" table of the container). That number isn't very
>>> meaningful except for the meta data itself.
>>>
>>> The logical disk index is represented by the "slot" attribute in sysfs.
>>>
>>> See e.g.
>>> http://lxr.missinglinkelectronics.com/linux+*/drivers/md/md.h#L79
>>>
>>> The number displayed in /proc/mdstat is "desc_nr", while the number that
>>> actually matters is "raid_disk".
>>
>> Maybe the description in the wiki is correct but there's a bun in the
>> kernel which displays the wrong number ?
>>
>> If "desc_nr" isn't meaningful, I don't see the point to show it in
>> /proc/mdstat.
>
> Well, we could propose to change the value displayed by the kernel. The
> question is whether the kernel maintainers would allow that, because it
> would change the kernel-userspace API. mdadm itself doesn't look at this
> number, but other tools might, so there is some small but non-zero risk
> of breaking something somewhere.

Well I was assuming that the API was described by:
https://raid.wiki.kernel.org/index.php/Mdstat#md_device_line rather
than looking at the source code. I haven't found other documentation
for a description of /proc/mdstat BTW.

Plus the fact that "desc_nr" isn't really meaningful.

>
> Let's wait what others have to say.
>

Agreed.

Thanks.
-- 
Francis
