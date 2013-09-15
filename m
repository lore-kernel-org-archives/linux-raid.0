From: Martin Wilck <mwilck@arcor.de>
Subject: Re: Weirdness with DDF arrays (mdadm 3.3)
Date: Sun, 15 Sep 2013 21:46:35 +0200
Message-ID: <52360E9B.5050606@arcor.de>
References: <CAC9WiBgJX4VH7-cNMVcqPL-9UpsH03Z7cRKvLUOSUogkiQpx7Q@mail.gmail.com>	<52346FB1.2020205@arcor.de>	<CAC9WiBiD4b9gKoEBCvWEOSbBtq72hZ-QFpbGpsEOinDWSatffw@mail.gmail.com>	<5234C300.1050206@arcor.de> <CAC9WiBg+HQBzP_GpUosQrVgvv8znh+pOwtDVGseB2t5yxB6pbA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC9WiBg+HQBzP_GpUosQrVgvv8znh+pOwtDVGseB2t5yxB6pbA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 09/15/2013 02:52 PM, Francis Moreau wrote:
> Hello Martin,
> 
> On Sat, Sep 14, 2013 at 10:11 PM, Martin Wilck <mwilck@arcor.de> wrote:
>> On 09/14/2013 05:25 PM, Francis Moreau wrote:
> 
> [...]
> 
>>>>>
>>>>> which looks even weirder: "loop1[2]" indicates that the disk is a
>>>>> spare one whereas "[UU]" tells me the opposite.
>>>>>
>>>>> Could you tell me if I'm wrong in my interpretation or what's going wrong ?
>>>
>>> What about the loop1 in spare and [UU] indicating that loop1 is used ?
>>
>> After you added loop1, the array was in read-auto state. Rebuild doesn't
>> start in this state.
>>
>> When you created the partition table, the array went in active state and
>> was rebuilt. When you looked at mdstat again, the rebuild was already
>> finished. Therefore you got "[UU]" after that.
>>
>> Wrt loop1[2], I think you interpret the [2] wrongly. It seems to be the
>> kernel index of the device somehow. The mdstat parsing code of mdadm
>> doesn't look at this number. If you look at
>> /sys/class/block/md124/md/dev-loop*/slot, the number should be correct -
>> I tried it here.
> 
> Well I think I interpreted the numbers the way it's described here :
> 
> https://raid.wiki.kernel.org/index.php/Mdstat#md_device_line

That description is not quite correct. The number in brackets [2] means
the index of the disk in the meta data (for DDF, that's the index in the
"physical disks" table of the container). That number isn't very
meaningful except for the meta data itself.

The logical disk index is represented by the "slot" attribute in sysfs.

See e.g.
http://lxr.missinglinkelectronics.com/linux+*/drivers/md/md.h#L79

The number displayed in /proc/mdstat is "desc_nr", while the number that
actually matters is "raid_disk".

Regards
Martin

> Thanks

