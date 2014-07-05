From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: Re[2]: RAID 6 crashes system when being accessed
Date: Fri, 4 Jul 2014 23:17:45 -0500
Message-ID: <CAAMCDefrCAQNLgPc54uUQZVW8TGDPzR-JRpmJo+raRj3uZd4eQ@mail.gmail.com>
References: <53B701B9.7060702@hardwarefreak.com> <em91a768be-540f-4252-a524-6a9013c0861b@littlez>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <em91a768be-540f-4252-a524-6a9013c0861b@littlez>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Stephenson <justin@evensteveninc.com>
Cc: stan@hardwarefreak.com, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Some questions.

Do you get any messages on the screen when it crashes and/or is there
anything in /var/log/messages from the crashes?

Is a sync running when it crashes?   If so what kind of SATA
controllers/setup are you using?  I have had 2 previous setups that
would run fairly stably so long as a sync was not running, but if a
sync was running then the machine became unstable.

Did you umount it and run a "fsck -f -y" that took a while (at least
30 seconds) or just umount it and ran fsck and it finished quickly and
indicated clean?    Generally if you nicely umount it the fs thinks it
is clean even when it is not because of some previous event.

On Fri, Jul 4, 2014 at 8:08 PM, Justin Stephenson
<justin@evensteveninc.com> wrote:
> Hi,
>
> Thanks for your reply.
>
> I should clarify that the crashes continue to be an issue in the absence of
> any power outage so this issue is now independent of power. I mentioned the
> UPS only with the thought that my problems may have been caused by a sudden
> power-down.
>
> Please let me know if there are any logs or status print outs I could pull
> to help troubleshoot this.
>
> Thanks Again,
>
> - J
>
>
>
>
> ------ Original Message ------
> From: "Stan Hoeppner" <stan@hardwarefreak.com>
> To: "Justin Stephenson" <justin@evensteveninc.com>;
> linux-raid@vger.kernel.org
> Sent: 04/07/2014 3:34:17 PM
> Subject: Re: RAID 6 crashes system when being accessed
>
>> On 7/4/2014 9:11 AM, Justin Stephenson wrote:
>>>
>>>  Hello,
>>>
>>>  I am experiencing some issues with my md raid. It is crashing my system
>>>  when accessed with any "verve". The reboot initiates a resync of the
>>>  raid. I have gone through the crash/reboot/resynced a number of times
>>>  now and the crash happens within minutes of mounting the raid.
>>>
>>>  Here are some details:
>>>
>>>  - It is a raid 6 with 7 3TB devices.
>>>  - Formatted as EXT4
>>>  - mdadm v3.2.6 - 25th October 2012
>>>  - centos 6.5 kernel 2.6.32-431.3.1.el6.x86_64
>>>  - It has been running flawlessly for the previous 6 months.
>>>  - I have a cron script running that resyncs monthly.
>>>  - When the raid is unmounted, the system runs fine. (I have an
>>>  additional "dumb" hardware raid 1 for dailies attached to an ESATA port.
>>>  This runs perfectly).
>>>  - I am in the process of re-syncing the raid 6 again right now.
>>>  - I have run an fsck on the raid volume after it was fully synced and
>>>  everything came up clean.
>>>
>>>  - there have been lots of power outages the last while with the hot
>>>  summer in Toronto. My UPS shuts the system down for me, though I think I
>>>  can correlate the issues with the power outages.
>>
>>
>> This sounds like the UPS is cutting power to the system before the
>> shutdown sequence completes, before the array is stopped. This assumes
>> you are already using apcupsd or similar. If you are check the
>> configuration to make sure the system has plenty of time to shutdown
>> after the UPS sends notification to the system. If you are not, then
>> this will always happen as the UPS is simply cutting power when the
>> battery gets low.
>>
>> Note that if the UPS is undersized for this system and only yields a few
>> minutes of on-battery time, it may simply not have enough juice to keep
>> the machine up throughout the shutdown process.
>>
>> In summary, either your shutdown software isn't configured properly, you
>> are not using it, or the UPS is too small. This isn't an md problem.
>>
>>
>> Cheers,
>>
>> Stan
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
