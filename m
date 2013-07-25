From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: MD array keeps resyncing after rebooting
Date: Thu, 25 Jul 2013 22:21:42 +0200
Message-ID: <CAC9WiBh=Fm9Wot6u0DBUd06adjXDDOTksoMmAVcaLm=O2Dsvpw@mail.gmail.com>
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

Thanks for looking at this,

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

I'll do that, but unfortunately I won't be able to do any testings
before next monday.

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

No. I did the rebuilding/syncing with the old mdadm/mdmon.

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

No. I did the rebuilding/syncing with the old mdadm/mdmon. Therefore
"Not Consistent and Fully Initialized" was the state of the array
before rebooting created by the old mdmon (3.2.3)

During the rebuild I installed the latest mdadm version so the next
reboot was using the new version of mdadm.

>
> Thinking about it - you did some coding of your own to start mdmon in
> the initrd, right?

Not really I simply reacreated initrd in order to be sure that it uses
the latest version of mdadm.

> Do you also make sure that mdadm -Ss is called after
> umounting the file systems, but before shutdown? If not, an inconsistent
> state might result.

Ah, I need to check how the unmounting is done by systemd.

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

Well during the next reboot, I can see this from the traces (shown in
my previous email):

[    3.983026] md/raid1:md126: not clean -- starting background reconstruction

so my guess is that the array was recreated here.

Thanks for your help.
-- 
Francis
