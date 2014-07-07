From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: Re[6]: RAID 6 crashes system when being accessed
Date: Sun, 6 Jul 2014 20:56:13 -0500
Message-ID: <CAAMCDeejuiqM0tA1983=fSvhVx7rgaWPwOGQ_O54vPNaW2mLoQ@mail.gmail.com>
References: <CAAMCDefHmBE94KeE_GcMbHn2FEYUFK3AfysLTkMSk81sPu-RsQ@mail.gmail.com>
 <embe822e04-a5f1-42d4-9d14-a34ae3714154@littlez>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <embe822e04-a5f1-42d4-9d14-a34ae3714154@littlez>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Stephenson <justin@evensteveninc.com>
Cc: stan <stan@hardwarefreak.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

You are watching for the machine to crash and/or produce messages in
/var/log/messages.


On Sun, Jul 6, 2014 at 7:54 PM, Justin Stephenson
<justin@evensteveninc.com> wrote:
> Thanks again, Roger. Your input was super helpful and also helped me
> understand a little more about the relationship between md and my file
> system.
>
> in the full tests you mentioned "find /<dir> -type f -ls" and "...exec cksum
> {} \;"
>
> what would I be looking for? I executed the first one and I got a colossal
> list of files. The server stores a lot of media resources for my design
> practice and there are probably hundreds of thousands of files on there.
>
> Please let me know,
>
> J
> --------
> Justin Stephenson
> Creative Director/Motion Designer
> 416-900-6069
> http://justinstephenson.com
>
>
>
>
> ------ Original Message ------
> From: "Roger Heflin" <rogerheflin@gmail.com>
> To: "Justin Stephenson" <justin@evensteveninc.com>
> Cc: "stan" <stan@hardwarefreak.com>; "Linux RAID"
> <linux-raid@vger.kernel.org>
> Sent: 05/07/2014 4:42:04 PM
> Subject: Re: Re[4]: RAID 6 crashes system when being accessed
>
>> The MD volume itself would not be unstable. The filesystem,
>> directory and file structures could have been corrupted, likely it did
>> fix something that was not important enough to report. When you hit
>> the specific directory entry and/or file data that would be when it
>> would crash. I have no idea how many times I have fixed this sort of
>> issue, it is pretty common on an unexpected crash, maybe 1 in 10-50
>> crashes will produce this sort of error, the risk rises if files were
>> being created when it happens.
>>
>> If you want to do a full test this will list out all dirs "find
>> /<dirname> -type f -ls" and this will actual read all files fairly
>> quickly. If you want to check to see if all files and extents make
>> sense you can run the next commnad but it will take a long time
>> depending on how much data you have "find /<dirname> -type f -ls -exec
>> cksum {} \;"
>>
>> On Sat, Jul 5, 2014 at 2:22 PM, Justin Stephenson
>> <justin@evensteveninc.com> wrote:
>>>
>>>  Hello Roger,
>>>
>>>  Thank-you for your email and for laying out some trouble shooting steps
>>> for
>>>  me. I will take these to heart and keep them on file for the future.
>>>
>>>  I can report that there was a screen of rapid scrolling text during the
>>>  crashes and some kind of memory contents dump that had a progress
>>> indicator.
>>>  From what I could see, there was some kind of kernel panic and a message
>>>  about ATA-9. Nothing in the /var/log/messages file as far as I could
>>> see.
>>>
>>>  I had tried unmounting and running fsck before but not with your
>>> specified
>>>  -f -y flags.
>>>
>>>  Here are the steps I took based on your input.
>>>
>>>  - ran system overnight with md raid unmounted.
>>>  - fully completed resync
>>>  - performed fsck -f -y. It took approx 6 minutes (on a 12TB volume). No
>>>  errors reported in the printout.
>>>  - reboot
>>>  - locally initiated and completed a 22 gb copy from and to the md raid
>>> and a
>>>  local esata external drive.
>>>
>>>  ---
>>>
>>>  - from a workstation, opened SMB share to the MD raid
>>>  - workstation initiated copy to and from the CentOS box (and MD drive)
>>> of
>>>  the same 22gb folder over SMB.
>>>  - opened vnc client to the centOS box from a workstation.
>>>
>>>  Up until the fsck -f -y any of these three operations would cause a
>>> crash.
>>>
>>>
>>>  In summary, it would seem that the issue has been resolved by the fsck
>>> -f
>>>  -y. Up until running fsck - f -y, the system was completely
>>> unpredictable
>>>  when the MD drive was mounted - either during a sync or after it was
>>>  completed. I find this surprising, but perhaps I should not?
>>>
>>>  Based on Stan's email, I checked my UPS power settings, and I am certain
>>> I
>>>  was ending up with a hard powerdown when the battery ran out. I have
>>>  remedied this.
>>>
>>>  Could this have caused the MD volume to become unstable?
>>>
>>>  In any event, everything is up and running. I will report back with a
>>> log
>>>  entry if anything else appears.
>>>
>>>  Thanks again,
>>>
>>>  - Justin
>>>
>>>
>>>
>>>
>>>  ------ Original Message ------
>>>  From: "Roger Heflin" <rogerheflin@gmail.com>
>>>  To: "Justin Stephenson" <justin@evensteveninc.com>
>>>  Cc: stan@hardwarefreak.com; "Linux RAID" <linux-raid@vger.kernel.org>
>>>  Sent: 05/07/2014 12:17:45 AM
>>>  Subject: Re: Re[2]: RAID 6 crashes system when being accessed
>>>
>>>>  Some questions.
>>>>
>>>>  Do you get any messages on the screen when it crashes and/or is there
>>>>  anything in /var/log/messages from the crashes?
>>>>
>>>>  Is a sync running when it crashes? If so what kind of SATA
>>>>  controllers/setup are you using? I have had 2 previous setups that
>>>>  would run fairly stably so long as a sync was not running, but if a
>>>>  sync was running then the machine became unstable.
>>>>
>>>>  Did you umount it and run a "fsck -f -y" that took a while (at least
>>>>  30 seconds) or just umount it and ran fsck and it finished quickly and
>>>>  indicated clean? Generally if you nicely umount it the fs thinks it
>>>>  is clean even when it is not because of some previous event.
>>>>
>>>>  On Fri, Jul 4, 2014 at 8:08 PM, Justin Stephenson
>>>>  <justin@evensteveninc.com> wrote:
>>>>>
>>>>>
>>>>>   Hi,
>>>>>
>>>>>   Thanks for your reply.
>>>>>
>>>>>   I should clarify that the crashes continue to be an issue in the
>>>>> absence
>>>>>  of
>>>>>   any power outage so this issue is now independent of power. I
>>>>> mentioned
>>>>>  the
>>>>>   UPS only with the thought that my problems may have been caused by a
>>>>>  sudden
>>>>>   power-down.
>>>>>
>>>>>   Please let me know if there are any logs or status print outs I could
>>>>>  pull
>>>>>   to help troubleshoot this.
>>>>>
>>>>>   Thanks Again,
>>>>>
>>>>>   - J
>>>>>
>>>>>
>>>>>
>>>>>
>>>>>   ------ Original Message ------
>>>>>   From: "Stan Hoeppner" <stan@hardwarefreak.com>
>>>>>   To: "Justin Stephenson" <justin@evensteveninc.com>;
>>>>>   linux-raid@vger.kernel.org
>>>>>   Sent: 04/07/2014 3:34:17 PM
>>>>>   Subject: Re: RAID 6 crashes system when being accessed
>>>>>
>>>>>>   On 7/4/2014 9:11 AM, Justin Stephenson wrote:
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>>    Hello,
>>>>>>>
>>>>>>>    I am experiencing some issues with my md raid. It is crashing my
>>>>>>>  system
>>>>>>>    when accessed with any "verve". The reboot initiates a resync of
>>>>>>> the
>>>>>>>    raid. I have gone through the crash/reboot/resynced a number of
>>>>>>> times
>>>>>>>    now and the crash happens within minutes of mounting the raid.
>>>>>>>
>>>>>>>    Here are some details:
>>>>>>>
>>>>>>>    - It is a raid 6 with 7 3TB devices.
>>>>>>>    - Formatted as EXT4
>>>>>>>    - mdadm v3.2.6 - 25th October 2012
>>>>>>>    - centos 6.5 kernel 2.6.32-431.3.1.el6.x86_64
>>>>>>>    - It has been running flawlessly for the previous 6 months.
>>>>>>>    - I have a cron script running that resyncs monthly.
>>>>>>>    - When the raid is unmounted, the system runs fine. (I have an
>>>>>>>    additional "dumb" hardware raid 1 for dailies attached to an ESATA
>>>>>>>  port.
>>>>>>>    This runs perfectly).
>>>>>>>    - I am in the process of re-syncing the raid 6 again right now.
>>>>>>>    - I have run an fsck on the raid volume after it was fully synced
>>>>>>> and
>>>>>>>    everything came up clean.
>>>>>>>
>>>>>>>    - there have been lots of power outages the last while with the
>>>>>>> hot
>>>>>>>    summer in Toronto. My UPS shuts the system down for me, though I
>>>>>>>  think I
>>>>>>>    can correlate the issues with the power outages.
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>>   This sounds like the UPS is cutting power to the system before the
>>>>>>   shutdown sequence completes, before the array is stopped. This
>>>>>> assumes
>>>>>>   you are already using apcupsd or similar. If you are check the
>>>>>>   configuration to make sure the system has plenty of time to shutdown
>>>>>>   after the UPS sends notification to the system. If you are not, then
>>>>>>   this will always happen as the UPS is simply cutting power when the
>>>>>>   battery gets low.
>>>>>>
>>>>>>   Note that if the UPS is undersized for this system and only yields a
>>>>>>  few
>>>>>>   minutes of on-battery time, it may simply not have enough juice to
>>>>>> keep
>>>>>>   the machine up throughout the shutdown process.
>>>>>>
>>>>>>   In summary, either your shutdown software isn't configured properly,
>>>>>>  you
>>>>>>   are not using it, or the UPS is too small. This isn't an md problem.
>>>>>>
>>>>>>
>>>>>>   Cheers,
>>>>>>
>>>>>>   Stan
>>>>>
>>>>>
>>>>>
>>>>>
>>>>>   --
>>>>>   To unsubscribe from this list: send the line "unsubscribe linux-raid"
>>>>> in
>>>>>   the body of a message to majordomo@vger.kernel.org
>>>>>   More majordomo info at http://vger.kernel.org/majordomo-info.html
>>>
>>>
>>>
>
