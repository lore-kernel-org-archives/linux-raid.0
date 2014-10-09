From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: /sys/block/md126 still exists even after stopping the array
Date: Thu, 09 Oct 2014 11:40:25 +0200
Message-ID: <54365809.90406@gmail.com>
References: <53A99B76.3020603@gmail.com>	<20140625110348.48ab2d7a@notabene.brown>	<54243ED7.6090904@gmail.com>	<20140926103348.5f5ea568@notabene.brown>	<54253E9F.4070505@gmail.com>	<20140926204445.1ec830b9@notabene.brown>	<54255A30.9010406@gmail.com>	<20140929143735.5fa54253@notabene.brown>	<54291C1D.7010005@gmail.com>	<20140930075643.34e864fa@notabene.brown>	<542A5F15.7030100@gmail.com>	<543390C7.2080104@gmail.com> <20141008105425.64cd0fed@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141008105425.64cd0fed@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, sebastian.riemer@profitbricks.com
List-Id: linux-raid.ids

On 10/08/2014 01:54 AM, NeilBrown wrote:
> On Tue, 07 Oct 2014 09:05:43 +0200 Francis Moreau <francis.moro@gmail.com>
> wrote:
> 
>> Hi Neil,
>>
>> On 09/30/2014 09:43 AM, Francis Moreau wrote:
>>> Hi Neil,
>>>
>>> On 09/29/2014 11:56 PM, NeilBrown wrote:
>>>> On Mon, 29 Sep 2014 10:45:17 +0200 Francis Moreau <francis.moro@gmail.com>
>>>> wrote:
>>>>
>>>>>> So what were pids 930 and 459?
>>>>>> One was presumably the "mdadm -Ss"  - probably 930.
>>>>>> Is 459 the "mdadm --monitor" ??  That might be useful hint.
>>>>>>
>>>>>
>>>>> yes.
>>>>>
>>>>> [456] is:  /sbin/mdadm --monitor --scan --daemonise --syslog
>>>>> --pid-file=/run/mdadm/mdadm.pid
>>>>>
>>>>> and [930] is 'mdamd -Ss'.
>>>>
>>>> Good.  Please try the patch below.
>>>>
>>>
>>> After applying your patch, this is what I'm getting in syslog:
>>>
>>> Sep 30 03:40:07 localhost kernel: md_open(): md125 opened by mdadm [970]
>>> Sep 30 03:40:07 localhost kernel: md_release(): md125 released by mdadm
>>> [970]
>>> Sep 30 03:40:07 localhost kernel: md_open(): md125 opened by mdadm [972]
>>> Sep 30 03:40:07 localhost kernel: md_open(): md125 opened by mdadm [970]
>>> Sep 30 03:40:07 localhost kernel: md_release(): md125 released by mdadm
>>> [972]
>>> Sep 30 03:40:07 localhost kernel: md_open(): md125 opened by
>>> systemd-udevd [971]
>>> Sep 30 03:40:07 localhost systemd[1]: Cannot add dependency job for unit
>>> mdmonitor-takeover.service, ignoring: Invalid argument
>>> Sep 30 03:40:07 localhost systemd[1]: Started Software RAID monitoring
>>> and management.
>>> Sep 30 03:40:07 localhost kernel: md_release(): md125 released by
>>> systemd-udevd [971]
>>> Sep 30 03:40:08 localhost mdadm[466]: DeviceDisappeared event detected
>>> on md device /dev/md125
>>> Sep 30 03:40:08 localhost mdadm[466]: DeviceDisappeared event detected
>>> on md device /dev/md126
>>> Sep 30 03:40:08 localhost mdadm[466]: DeviceDisappeared event detected
>>> on md device /dev/md127
>>> Sep 30 03:40:08 localhost kernel: md125: detected capacity change from
>>> 1863254016 to 0
>>> Sep 30 03:40:08 localhost kernel: md: md125 stopped.
>>> Sep 30 03:40:08 localhost kernel: md: unbind<vdc3>
>>> Sep 30 03:40:08 localhost kernel: md: export_rdev(vdc3)
>>> Sep 30 03:40:08 localhost kernel: md: unbind<vdb3>
>>> Sep 30 03:40:08 localhost kernel: md: export_rdev(vdb3)
>>> Sep 30 03:40:08 localhost kernel: md_release(): md125 released by mdadm
>>> [970]
>>> Sep 30 03:40:08 localhost kernel: md_open(): md127 opened by mdadm [466]
>>> Sep 30 03:40:08 localhost kernel: md_release(): md127 released by mdadm
>>> [466]
>>> Sep 30 03:40:08 localhost kernel: md_open(): md126 opened by mdadm [466]
>>> Sep 30 03:40:08 localhost kernel: md_release(): md126 released by mdadm
>>> [466]
>>> Sep 30 03:40:08 localhost kernel: md_open(): md126 opened by mdadm [970]
>>> Sep 30 03:40:08 localhost kernel: md_release(): md126 released by mdadm
>>> [970]
>>> Sep 30 03:40:08 localhost kernel: md_open(): md126 opened by mdadm [970]
>>> Sep 30 03:40:08 localhost kernel: md126: detected capacity change from
>>> 67043328 to 0
>>> Sep 30 03:40:08 localhost kernel: md: md126 stopped.
>>> Sep 30 03:40:08 localhost kernel: md: unbind<vdc1>
>>> Sep 30 03:40:08 localhost kernel: md: export_rdev(vdc1)
>>> Sep 30 03:40:08 localhost kernel: md: unbind<vdb1>
>>> Sep 30 03:40:08 localhost kernel: md: export_rdev(vdb1)
>>> Sep 30 03:40:08 localhost kernel: md_open(): md127 opened by mdadm [466]
>>> Sep 30 03:40:08 localhost kernel: md_release(): md127 released by mdadm
>>> [466]
>>> Sep 30 03:40:08 localhost kernel: md_release(): md126 released by mdadm
>>> [970]
>>> Sep 30 03:40:08 localhost kernel: md_open(): md127 opened by mdadm [970]
>>> Sep 30 03:40:08 localhost kernel: md_release(): md127 released by mdadm
>>> [970]
>>> Sep 30 03:40:08 localhost kernel: md_open(): md127 opened by mdadm [970]
>>> Sep 30 03:40:08 localhost kernel: md127: detected capacity change from
>>> 214564864 to 0
>>> Sep 30 03:40:08 localhost kernel: md: md127 stopped.
>>> Sep 30 03:40:08 localhost kernel: md: unbind<vdc2>
>>> Sep 30 03:40:08 localhost kernel: md: export_rdev(vdc2)
>>> Sep 30 03:40:08 localhost kernel: md: unbind<vdb2>
>>> Sep 30 03:40:08 localhost kernel: md: export_rdev(vdb2)
>>> Sep 30 03:40:08 localhost kernel: md_release(): md127 released by mdadm
>>> [970]
>>>
>>> The ghost device is no more present so your patch seems to have fixed my
>>> issue. But I must admit I don't really understand what's going on :-/
>>>
>>
>> Since those 'ghost' devices are expected from the MD implementation
>> point of view, I'm wondering how am I supposed to detect them or maybe
>> how an application is supposed to recognized online arrays.
> 
> If your application is looking in /proc/mdstat, then the "ghost" devices will
> be either "inactive" or not present at all.
> If your application is looking in /sys/block/md*, then the "ghost" devices
> will have "clear" or "inactive" in /sys/block/mdXX/md/array_state.
> 
> If you use the new "CREATE names=yes" line in mdadm.conf (mdadm 3.3 or
> later), and use kernel 3.17 or later, and use names rather than numbers to
> identify your arrays (/dev/md/home, /dev/md_root), then the "ghost" problem
> will be gone, and names in /proc/mdstat will be e.g. "md_home", or "md_root"
> rather than "md4" or "md127".
> 
>>
>> My application uses udev to detect et to get information about new
>> devices. I don't think the information exported by udev is enough to
>> figure this out. Also please note that since I rely on udev, I can't
>> really read information on /sys since this information may be out of
>> sync with the one returned by udev.
> 
> If udev reports that an array exists, then it really did exist when udev got
> the message.  By the time your program gets run by udev, it might not exist
> any more. i.e. udev is always racy.

Yes, but reading sysfs is also racy. I was thinking that the advantage
of using udev is that it gives me a *consistent* (perhaps outdated)
snapshot of the device state.

Thanks
