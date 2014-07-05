From: "Justin Stephenson" <justin@evensteveninc.com>
Subject: Re[2]: RAID 6 crashes system when being accessed
Date: Sat, 05 Jul 2014 01:08:20 +0000
Message-ID: <em91a768be-540f-4252-a524-6a9013c0861b@littlez>
References: <53B701B9.7060702@hardwarefreak.com>
Reply-To: "Justin Stephenson" <justin@evensteveninc.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53B701B9.7060702@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Thanks for your reply.

I should clarify that the crashes continue to be an issue in the absence 
of any power outage so this issue is now independent of power. I 
mentioned the UPS only with the thought that my problems may have been 
caused by a sudden power-down.

Please let me know if there are any logs or status print outs I could 
pull to help troubleshoot this.

Thanks Again,

- J



------ Original Message ------
From: "Stan Hoeppner" <stan@hardwarefreak.com>
To: "Justin Stephenson" <justin@evensteveninc.com>; 
linux-raid@vger.kernel.org
Sent: 04/07/2014 3:34:17 PM
Subject: Re: RAID 6 crashes system when being accessed

>On 7/4/2014 9:11 AM, Justin Stephenson wrote:
>>  Hello,
>>
>>  I am experiencing some issues with my md raid. It is crashing my 
>>system
>>  when accessed with any "verve". The reboot initiates a resync of the
>>  raid. I have gone through the crash/reboot/resynced a number of times
>>  now and the crash happens within minutes of mounting the raid.
>>
>>  Here are some details:
>>
>>  - It is a raid 6 with 7 3TB devices.
>>  - Formatted as EXT4
>>  - mdadm v3.2.6 - 25th October 2012
>>  - centos 6.5 kernel 2.6.32-431.3.1.el6.x86_64
>>  - It has been running flawlessly for the previous 6 months.
>>  - I have a cron script running that resyncs monthly.
>>  - When the raid is unmounted, the system runs fine. (I have an
>>  additional "dumb" hardware raid 1 for dailies attached to an ESATA 
>>port.
>>  This runs perfectly).
>>  - I am in the process of re-syncing the raid 6 again right now.
>>  - I have run an fsck on the raid volume after it was fully synced and
>>  everything came up clean.
>>
>>  - there have been lots of power outages the last while with the hot
>>  summer in Toronto. My UPS shuts the system down for me, though I 
>>think I
>>  can correlate the issues with the power outages.
>
>This sounds like the UPS is cutting power to the system before the
>shutdown sequence completes, before the array is stopped. This assumes
>you are already using apcupsd or similar. If you are check the
>configuration to make sure the system has plenty of time to shutdown
>after the UPS sends notification to the system. If you are not, then
>this will always happen as the UPS is simply cutting power when the
>battery gets low.
>
>Note that if the UPS is undersized for this system and only yields a 
>few
>minutes of on-battery time, it may simply not have enough juice to keep
>the machine up throughout the shutdown process.
>
>In summary, either your shutdown software isn't configured properly, 
>you
>are not using it, or the UPS is too small. This isn't an md problem.
>
>
>Cheers,
>
>Stan

