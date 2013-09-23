From: Martin Wilck <mwilck@arcor.de>
Subject: Re: mdadm 3.3 fails to kick out non fresh disk
Date: Mon, 23 Sep 2013 22:02:42 +0200
Message-ID: <52409E62.3090105@arcor.de>
References: <CAC9WiBgGgKGHqcwrVo7J_peS8YiH-KBF8T1uGbwJrve_7aa3cw@mail.gmail.com>	<20130914064305.0baadc69@notabene.brown>	<CAC9WiBhbyV6Xpu=7HvKUK1hXNw1uC+QZcDOM0R9zUCMrR7WNtQ@mail.gmail.com>	<20130914203800.385466b2@notabene.brown>	<CAC9WiBh9EOFKx99fTH2yYN62A5CAg4_mqpNtxj6jZOZE+_Raww@mail.gmail.com>	<CAC9WiBja2N_Q8h6MSci+fgRWWpvvRpcMZp8FOZX3V_FK8pjhpA@mail.gmail.com>	<5234CA6A.3070305@arcor.de>	<CAC9WiBi8XyWS8AgjAE0cxiaa4uRbNS69=vfC+TKnoG_iFp2+Vg@mail.gmail.com>	<52373A19.7000105@arcor.de>	<CAC9WiBjnM5nwKf4f7UN6hQgsbYhVLLPnfAD6RATbF3C-NHRrXg@mail.gmail.com>	<523C8EF9.60809@arcor.de>	<CAC9WiBgnWHupc59z+ym2me3RcL4F6YqdE_3aXTvRN2zZZQ4jzQ@mail.gmail.com> <CAC9WiBgzfvQkLZXT+9WYuxBUCRJqWZAvbyVmK9-9EsiwNeRxhw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC9WiBgzfvQkLZXT+9WYuxBUCRJqWZAvbyVmK9-9EsiwNeRxhw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 09/21/2013 03:22 PM, Francis Moreau wrote:
> On Fri, Sep 20, 2013 at 11:08 PM, Francis Moreau <francis.moro@gmail.com> wrote:
>> Hello Martin,
>>
>> On Fri, Sep 20, 2013 at 8:07 PM, Martin Wilck <mwilck@arcor.de> wrote:
>>> On 09/20/2013 10:56 AM, Francis Moreau wrote:
>>>> Hello Martin,
>>>>
>>>> On Mon, Sep 16, 2013 at 7:04 PM, Martin Wilck <mwilck@arcor.de> wrote:
>>>>> On 09/16/2013 03:56 PM, Francis Moreau wrote:
>>>>>
>>>>>> I did give your patch "DDF: compare_super_ddf: fix sequence number
>>>>>> check" a try and now mdadm is able to detect a difference between the
>>>>>> 2 disks. Therefore it refuses to insert the second disk which is
>>>>>> better.
>>>>>>
>>>>>> However it's still not able to detect which version is the "fresher"
>>>>>> like mdadm does with soft RAID1 (metadata 1.2). Therefore mdadm is not
>>>>>> able to kick out the first disk if it's the outdated one.
>>>>>>
>>>>>> Is that expected ?
>>>>>
>>>>> At the moment, yes. This needs work.
>>>>>
>>>>
>>>> Actually this is worse than I thought: with your patch applied mdadm
>>>> refuses to add back a spare disk into a degraded DDF array.
>>>>
>>>> For example on a DDF array:
>>>>
>>>> # cat /proc/mdstat
>>>> Personalities : [raid1]
>>>> md126 : active raid1 sdb[1] sda[0]
>>>>       2064384 blocks super external:/md127/0 [2/2] [UU]
>>>>
>>>> md127 : inactive sdb[1](S) sda[0](S)
>>>>       65536 blocks super external:ddf
>>>>
>>>> unused devices: <none>
>>>>
>>>> # mdadm /dev/md126 --fail sdb
>>>> [   24.118434] md/raid1:md126: Disk failure on sdb, disabling device.
>>>> [   24.118437] md/raid1:md126: Operation continuing on 1 devices.
>>>> mdadm: set sdb faulty in /dev/md126
>>>>
>>>> # mdadm /dev/md127 --remove sdb
>>>> mdadm: hot removed sdb from /dev/md127
>>>>
>>>> # mdadm /dev/md127 --add /dev/sdb
>>>> mdadm: added /dev/sdb
>>>>
>>>> # cat /proc/mdstat
>>>> Personalities : [raid1]
>>>> md126 : active raid1 sda[0]
>>>>       2064384 blocks super external:/md127/0 [2/1] [U_]
>>>>
>>>> md127 : inactive sdb[1](S) sda[0](S)
>>>>       65536 blocks super external:ddf
>>>>
>>>> unused devices: <none>
>>>>
>>>>
>>>> As you can see the reinserted disk sdb sits as spare and isn't added
>>>> back to the array.
>>>
>>> That's correct. You marked that disk failed.
>>>
>>>> Is it possible to add this major feature work again and keep your improvement ?
>>>
>>> No. A failed disk can't be added again without rebuild. I am positive
>>> about that.
>>>
>>
>> Hmm that's not the case with soft linux RAID AFAICS: doing the same
>> thing with soft RAID and the reinserted disk is added to the raid
>> array and it's synchronised automatically. You can try it easily.
> 

Sorry, I didn't read your problem description carefully enough. You used
mdadm --add, and that should work and should trigger a rebuild, as you said.

> BTW, that's also the case for DDF if I don't apply your patch.

I don't understand this. My patch doesn't change the behavior of "mdadm
--add". AFAICS compare_super() isn't called in that code path.

I just posted two unit tests that cover this use (or better: failure)
case, please verify that they meet your scenario.

On my system, with my latest patch, these tests are successful.

I also tried a VM, as you suggested, and did exactly what you described,
successfully. After failing/removing one disk and rebooting, the system
comes up degraded; mdadm -I the old disk fails (that's correct), but I
can mdadm --add the old disk and recovery starts automatically. So all
is fine - the question is why it doesn't work on your system.

> Additionnal information: looking at sda shows that it doesn't seem to
> have metadata anymore after having added it to the container:
> 
> # mdadm -E /dev/sda
> /dev/sda:
>    MBR Magic : aa55
> Partition[0] :      3564382 sectors at         2048 (type 83)
> Partition[1] :       559062 sectors at      3569643 (type 05)

I wonder if this gives us a clue. It seems that something erased the
meta data. I can't imagine that mdadm did that. I wonder if that could
have been your BIOS. Pretty certainly it wasn't mdadm. However mdadm
--add should work, even if the BIOS had changed something on the disk. I
admit I'm clueless here.

In order to make progress, we'd need mdadm -E output of both disks
before and after the BIOS gets to write them, after boot, and after your
trying mdadm --add. The mdmon logs would also be highly appreciated, but
they'll probably hard for you to generate. You need to compile mdmon
with CXFLAGS="-DDEBUG=1 -g" and make sure mdmon's stderr os captured
somewhere.

Regards
Martin

