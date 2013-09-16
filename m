From: Martin Wilck <mwilck@arcor.de>
Subject: Re: Weirdness with DDF arrays (mdadm 3.3)
Date: Mon, 16 Sep 2013 19:02:27 +0200
Message-ID: <523739A3.60507@arcor.de>
References: <CAC9WiBgJX4VH7-cNMVcqPL-9UpsH03Z7cRKvLUOSUogkiQpx7Q@mail.gmail.com>	<52346FB1.2020205@arcor.de>	<CAC9WiBiD4b9gKoEBCvWEOSbBtq72hZ-QFpbGpsEOinDWSatffw@mail.gmail.com>	<5234C300.1050206@arcor.de>	<CAC9WiBg+HQBzP_GpUosQrVgvv8znh+pOwtDVGseB2t5yxB6pbA@mail.gmail.com>	<52360E9B.5050606@arcor.de> <CAC9WiBiFs8V+_iWx9sRW6WEPLAKR85zxBpHb3SsWa0k6J7z7Fg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC9WiBiFs8V+_iWx9sRW6WEPLAKR85zxBpHb3SsWa0k6J7z7Fg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 09/16/2013 03:47 PM, Francis Moreau wrote:
[...]

>>>> Wrt loop1[2], I think you interpret the [2] wrongly. It seems to be the
>>>> kernel index of the device somehow. The mdstat parsing code of mdadm
>>>> doesn't look at this number. If you look at
>>>> /sys/class/block/md124/md/dev-loop*/slot, the number should be correct -
>>>> I tried it here.
>>>
>>> Well I think I interpreted the numbers the way it's described here :
>>>
>>> https://raid.wiki.kernel.org/index.php/Mdstat#md_device_line
>>
>> That description is not quite correct. The number in brackets [2] means
>> the index of the disk in the meta data (for DDF, that's the index in the
>> "physical disks" table of the container). That number isn't very
>> meaningful except for the meta data itself.
>>
>> The logical disk index is represented by the "slot" attribute in sysfs.
>>
>> See e.g.
>> http://lxr.missinglinkelectronics.com/linux+*/drivers/md/md.h#L79
>>
>> The number displayed in /proc/mdstat is "desc_nr", while the number that
>> actually matters is "raid_disk".
> 
> Maybe the description in the wiki is correct but there's a bun in the
> kernel which displays the wrong number ?
>
> If "desc_nr" isn't meaningful, I don't see the point to show it in
> /proc/mdstat.

Well, we could propose to change the value displayed by the kernel. The
question is whether the kernel maintainers would allow that, because it
would change the kernel-userspace API. mdadm itself doesn't look at this
number, but other tools might, so there is some small but non-zero risk
of breaking something somewhere.

Let's wait what others have to say.

Martin
