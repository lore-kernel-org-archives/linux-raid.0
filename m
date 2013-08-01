From: Martin Wilck <mwilck@arcor.de>
Subject: Re: MD array keeps resyncing after rebooting
Date: Thu, 01 Aug 2013 20:15:31 +0200
Message-ID: <51FAA5C3.8030109@arcor.de>
References: <CAC9WiBjm5-RJ=CfpXMG7CCBp7StzWDuhp5XyFs4hAW3sxX7Gfw@mail.gmail.com>	<CAC9WiBjs4DQqt1G911OBALzSqn=o_=L1S4_K_MvUWhAu-rhtUw@mail.gmail.com>	<51EED0DA.3020901@arcor.de>	<51EED102.4020503@arcor.de>	<CAC9WiBgN1-HBEgqwo7CWor=nihCYUcOrYKhGxYTgbC-d4a7_-g@mail.gmail.com>	<51EEF3D3.7020305@arcor.de>	<CAC9WiBgrjrPRcHa5kh8TUfqN0rBBFC4M0_8iDkU3O0SOFgFW5g@mail.gmail.com>	<CAC9WiBjQz6MJxBuw+cLWFZ-vOsdbYYSKdE575emH_AG5EmnGdw@mail.gmail.com>	<51F1754B.5000905@arcor.de> <CAC9WiBhgF_-Ya7GW8DW0DcOQ-UhpN503hr=6_=46W5nbK04FTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC9WiBhgF_-Ya7GW8DW0DcOQ-UhpN503hr=6_=46W5nbK04FTQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Francis,
> 
> As you noticed the state is "Not Consistent". In my understanding it
> becomes "Consistent" when  the array is stopped.

Correct.

> I checked during the shudown process that the array is correctly
> stopped since at that point I got:
> 
> # mdadm -E /dev/sda | egrep "state"
>         state[0] : Optimal, Consistent
>    init state[0] : Fully Initialised

This looks as it should, actually. This looks as if md is doing what
it's supposed to.

> After rebooting, it appears that the BIOS changed a part of VD
> GUID[0]. I'm not sure if that can confuse the kernel and if it's the
> reason why the kernel shows:
> 
>     [  832.944623] md/raid1:md126: not clean -- starting background
> reconstruction

The BIOS obviously changes the meta data. The GUID itself shouldn't be
the problem as long as it's consistently changed everywhere, but it's
certainly strange to change it - it's meant to be constant and unique
for this array.

It would be important to see the state of the meta data after md
shutdown and immediately after boot (before md actually starts), so that
we can exactly see what the BIOS has done.

> but this is obviously where a resync is triggered during each reboot
> whatever the initial state of the array. The kernel message is
> actually issued by drivers/md/raid1.c, in particular:
> 
>         if (mddev->recovery_cp != MaxSector)
>                 printk(KERN_NOTICE "md/raid1:%s: not clean"
>                        " -- starting background reconstruction\n",
>                        mdname(mddev));
> 
> I don't understand the condition and how a resync can be triggered there.

The kernel is just reacting to something it has been told by
mdadm/mdmon. mdadm, in turn, just reads the meta data. It is highly
likely that the meta data indicated that the array was not, or only
partially, initialized. In this case mdadm will always start a full
reconstruction.

> Oh, this is with kernel 3.4.54.
> 
> Can you (or anyone else) spot something wrong with these information ?

Well, obviously the BIOS made a change to the meta data. Why so? We can
only guess; perhaps something that mdadm wrote to the meta data didn't
please the BIOS code, and it "thought" it needed to do something
differently.

mdadm -E may not be enough here. We need to inspect the raw meta data
1. after BIOS created the array and before mdadm started
2. after mdadm shutdown
3. after BIOS reboot, before mdadm started.
4. (if you have a windows driver, it might be interesting to see how the
meta data looks after windows has shut down after step 1.)

You can dump the metadata with mdadm --dump, but the result is difficult
to handle because it's a sparse image the size of your disk.
Unless all your tools handle sparse files well, you will get stuck.

Here is a slightly more type-intensive but safer method:

Use "sg_readcap /dev/sda" to print the LBA of the last block.
Using this number, run

 dd if=/dev/sda of=/tmp/sda bs=1b skip=$LBA

then do hexdump -C /tmp/sda. You see your "DDF anchor" structure. At
offsets 0x0060 and 0x0068, you find the LBAs of the primary and
secondary header, in big endian. Use the smaller number of the two
(usually the secondary header at 0x0068). In may case the hexdump line reads

00000060  00 00 00 00 3a 37 c0 40  00 00 00 00 3a 37 20 50

The primary LBA is 0x3a37c040, the secondary 3a372050, which is less.
Next, using the smaller number, run

dd if=/dev/sda bs=1b skip=$((0x3a372050)) | gzip -c /tmp/sda-ddf.gz

Put the results somewhere where I can pick them up.

Martin

> 
> Thanks
> 
> On Thu, Jul 25, 2013 at 8:58 PM, Martin Wilck <mwilck@arcor.de> wrote:
>> On 07/24/2013 03:50 PM, Francis Moreau wrote:
>>
>>> I regenerated the initramfs in order to use the new binaries when
>>> booting and now I can see some new warnings:
>>>
>>>   $ dracut -f
>>>   mdmon: Failed to load secondary DDF header on /dev/block/8:0
>>>   mdmon: Failed to load secondary DDF header on /dev/block/8:16
>>>   ...
>>>
>>> I ignored them for now.
>>
>> The message is non-fatal. But is certainly strange, given that you have
>> a LSI BIOS. It looks as if something was wrong with your secondary
>> header. You may try the attached patch to understand the problem better.
>>
>>> Now the latest version of mdadm is used :
>>>
>>>   $ cat /proc/mdstat
>>>   Personalities : [raid1]
>>>   md126 : active raid1 sdb[1] sda[0]
>>>         975585280 blocks super external:/md127/0 [2/2] [UU]
>>>
>>>   md127 : inactive sdb[1](S) sda[0](S)
>>>         2354608 blocks super external:ddf
>>
>> So you did another rebuild of the array with the updated mdadm?
>>
>>> I run mdadm -E /dev/sdX for all RAID disks before and after reboot.
>>> I'm still having this warning:
>>>
>>>    mdmon: Failed to load secondary DDF header on /dev/sda
>>>
>>> You can find the differences below:
>>>
>>> diff -Nurp before/sda.txt after/sda.txt
>>> --- before/sda.txt      2013-07-24 15:15:33.304015379 +0200
>>> +++ after/sda.txt       2013-07-24 15:49:09.520132838 +0200
>>> @@ -9,11 +9,11 @@ Controller GUID : 4C534920:20202020:FFFF
>>>    Redundant hdr : yes
>>>    Virtual Disks : 1
>>>
>>> -      VD GUID[0] : 4C534920:20202020:80861D60:00000000:3F2103E0:00001450
>>> -                  (LSI      07/24/13 12:18:08)
>>> +      VD GUID[0] : 4C534920:20202020:80861D60:00000000:3F213401:00001450
>>> +                  (LSI      07/24/13 15:43:29)
>>
>> This is weird. it looks as if the array had been recreated by the BIOS.
>> Normally the GUID should stay constant over reboots.
>>
>>>           unit[0] : 0
>>>          state[0] : Optimal, Not Consistent
>>> -   init state[0] : Fully Initialised
>>
>> Not Consistent and Fully Initialized - This looks as if the array didn't
>> close down cleanly. Is this the result of rebuilding the array with
>> mdmon 3.3-rc1?
>>
>> Thinking about it - you did some coding of your own to start mdmon in
>> the initrd, right? Do you also make sure that mdadm -Ss is called after
>> umounting the file systems, but before shutdown? If not, an inconsistent
>> state might result.
>>
>>> +   init state[0] : Not Initialised
>>>         access[0] : Read/Write
>>>           Name[0] : array0
>>>   Raid Devices[0] : 2 (0 1)
>>> diff -Nurp before/sdb.txt after/sdb.txt
>>> --- before/sdb.txt      2013-07-24 15:17:50.300581049 +0200
>>> +++ after/sdb.txt       2013-07-24 15:49:15.159997204 +0200
>>> @@ -9,11 +9,11 @@ Controller GUID : 4C534920:20202020:FFFF
>>>    Redundant hdr : yes
>>>    Virtual Disks : 1
>>>
>>> -      VD GUID[0] : 4C534920:20202020:80861D60:00000000:3F2103E0:00001450
>>> -                  (LSI      07/24/13 12:18:08)
>>> +      VD GUID[0] : 4C534920:20202020:80861D60:00000000:3F213401:00001450
>>> +                  (LSI      07/24/13 15:43:29)
>>
>> Again, new GUID. Did you recreate the array?
>>
>> Regards
>> Martin
>>
> 
> 
> 

