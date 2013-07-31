From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: MD array keeps resyncing after rebooting
Date: Wed, 31 Jul 2013 21:36:06 +0200
Message-ID: <CAC9WiBhgF_-Ya7GW8DW0DcOQ-UhpN503hr=6_=46W5nbK04FTQ@mail.gmail.com>
References: <CAC9WiBjm5-RJ=CfpXMG7CCBp7StzWDuhp5XyFs4hAW3sxX7Gfw@mail.gmail.com>
	<CAC9WiBjs4DQqt1G911OBALzSqn=o_=L1S4_K_MvUWhAu-rhtUw@mail.gmail.com>
	<51EED0DA.3020901@arcor.de>
	<51EED102.4020503@arcor.de>
	<CAC9WiBgN1-HBEgqwo7CWor=nihCYUcOrYKhGxYTgbC-d4a7_-g@mail.gmail.com>
	<51EEF3D3.7020305@arcor.de>
	<CAC9WiBgrjrPRcHa5kh8TUfqN0rBBFC4M0_8iDkU3O0SOFgFW5g@mail.gmail.com>
	<CAC9WiBjQz6MJxBuw+cLWFZ-vOsdbYYSKdE575emH_AG5EmnGdw@mail.gmail.com>
	<51F1754B.5000905@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51F1754B.5000905@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Martin,

I finally managed to get more information.

After the resync finished I have the following state:

partial content of /sys/block/md126/md:
--------------------------------------
array_size           default
array_state          active
chunk_size           65536
component_size       975585280
degraded             0
layout               0
level                raid1
max_read_errors      20
metadata_version     external:/md127/0
mismatch_cnt         0
raid_disks           2
reshape_position     none
resync_start         none
safe_mode_delay      0.000
suspend_hi           0
suspend_lo           0
sync_action          idle
sync_completed       none

# cat /proc/mdstat
Personalities : [raid1]
md126 : active raid1 sdb[1] sda[0]
      975585280 blocks super external:/md127/0 [2/2] [UU]

md127 : inactive sdb[1](S) sda[0](S)
      2354608 blocks super external:ddf

unused devices: <none>

# mdadm -E /dev/sda | egrep "GUID|state"
Controller GUID : 4C534920:20202020:FFFFFFFF:FFFFFFFF:FFFFFFFF:FFFFFFFF
 Container GUID : 4C534920:20202020:80861D6B:10140432:3F14FDAD:5271FC67
      VD GUID[0] : 4C534920:20202020:80861D60:00000000:3F2A56A7:00001450
        state[0] : Optimal, Not Consistent
   init state[0] : Fully Initialised

Same for /dev/sdb

As you noticed the state is "Not Consistent". In my understanding it
becomes "Consistent" when  the array is stopped.

I checked during the shudown process that the array is correctly
stopped since at that point I got:

# mdadm -E /dev/sda | egrep "state"
        state[0] : Optimal, Consistent
   init state[0] : Fully Initialised

After rebooting, it appears that the BIOS changed a part of VD
GUID[0]. I'm not sure if that can confuse the kernel and if it's the
reason why the kernel shows:

    [  832.944623] md/raid1:md126: not clean -- starting background
reconstruction

but this is obviously where a resync is triggered during each reboot
whatever the initial state of the array. The kernel message is
actually issued by drivers/md/raid1.c, in particular:

        if (mddev->recovery_cp != MaxSector)
                printk(KERN_NOTICE "md/raid1:%s: not clean"
                       " -- starting background reconstruction\n",
                       mdname(mddev));

I don't understand the condition and how a resync can be triggered there.

Oh, this is with kernel 3.4.54.

Can you (or anyone else) spot something wrong with these information ?

Thanks

On Thu, Jul 25, 2013 at 8:58 PM, Martin Wilck <mwilck@arcor.de> wrote:
> On 07/24/2013 03:50 PM, Francis Moreau wrote:
>
>> I regenerated the initramfs in order to use the new binaries when
>> booting and now I can see some new warnings:
>>
>>   $ dracut -f
>>   mdmon: Failed to load secondary DDF header on /dev/block/8:0
>>   mdmon: Failed to load secondary DDF header on /dev/block/8:16
>>   ...
>>
>> I ignored them for now.
>
> The message is non-fatal. But is certainly strange, given that you have
> a LSI BIOS. It looks as if something was wrong with your secondary
> header. You may try the attached patch to understand the problem better.
>
>> Now the latest version of mdadm is used :
>>
>>   $ cat /proc/mdstat
>>   Personalities : [raid1]
>>   md126 : active raid1 sdb[1] sda[0]
>>         975585280 blocks super external:/md127/0 [2/2] [UU]
>>
>>   md127 : inactive sdb[1](S) sda[0](S)
>>         2354608 blocks super external:ddf
>
> So you did another rebuild of the array with the updated mdadm?
>
>> I run mdadm -E /dev/sdX for all RAID disks before and after reboot.
>> I'm still having this warning:
>>
>>    mdmon: Failed to load secondary DDF header on /dev/sda
>>
>> You can find the differences below:
>>
>> diff -Nurp before/sda.txt after/sda.txt
>> --- before/sda.txt      2013-07-24 15:15:33.304015379 +0200
>> +++ after/sda.txt       2013-07-24 15:49:09.520132838 +0200
>> @@ -9,11 +9,11 @@ Controller GUID : 4C534920:20202020:FFFF
>>    Redundant hdr : yes
>>    Virtual Disks : 1
>>
>> -      VD GUID[0] : 4C534920:20202020:80861D60:00000000:3F2103E0:00001450
>> -                  (LSI      07/24/13 12:18:08)
>> +      VD GUID[0] : 4C534920:20202020:80861D60:00000000:3F213401:00001450
>> +                  (LSI      07/24/13 15:43:29)
>
> This is weird. it looks as if the array had been recreated by the BIOS.
> Normally the GUID should stay constant over reboots.
>
>>           unit[0] : 0
>>          state[0] : Optimal, Not Consistent
>> -   init state[0] : Fully Initialised
>
> Not Consistent and Fully Initialized - This looks as if the array didn't
> close down cleanly. Is this the result of rebuilding the array with
> mdmon 3.3-rc1?
>
> Thinking about it - you did some coding of your own to start mdmon in
> the initrd, right? Do you also make sure that mdadm -Ss is called after
> umounting the file systems, but before shutdown? If not, an inconsistent
> state might result.
>
>> +   init state[0] : Not Initialised
>>         access[0] : Read/Write
>>           Name[0] : array0
>>   Raid Devices[0] : 2 (0 1)
>> diff -Nurp before/sdb.txt after/sdb.txt
>> --- before/sdb.txt      2013-07-24 15:17:50.300581049 +0200
>> +++ after/sdb.txt       2013-07-24 15:49:15.159997204 +0200
>> @@ -9,11 +9,11 @@ Controller GUID : 4C534920:20202020:FFFF
>>    Redundant hdr : yes
>>    Virtual Disks : 1
>>
>> -      VD GUID[0] : 4C534920:20202020:80861D60:00000000:3F2103E0:00001450
>> -                  (LSI      07/24/13 12:18:08)
>> +      VD GUID[0] : 4C534920:20202020:80861D60:00000000:3F213401:00001450
>> +                  (LSI      07/24/13 15:43:29)
>
> Again, new GUID. Did you recreate the array?
>
> Regards
> Martin
>



-- 
Francis
