From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID 6 crashes system when being accessed
Date: Fri, 04 Jul 2014 14:34:17 -0500
Message-ID: <53B701B9.7060702@hardwarefreak.com>
References: <emb6d3f02d-046d-4466-87c3-f86175b9b08a@littlez>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <emb6d3f02d-046d-4466-87c3-f86175b9b08a@littlez>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Stephenson <justin@evensteveninc.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 7/4/2014 9:11 AM, Justin Stephenson wrote:
> Hello,
> 
> I am experiencing some issues with my md raid. It is crashing my system
> when accessed with any "verve". The reboot initiates a resync of the
> raid. I have gone through the crash/reboot/resynced a number of times
> now and the crash happens within minutes of mounting the raid.
> 
> Here are some details:
> 
> - It is a raid 6 with 7 3TB devices.
> - Formatted as EXT4
> - mdadm v3.2.6 - 25th October 2012
> - centos 6.5 kernel 2.6.32-431.3.1.el6.x86_64
> - It has been running flawlessly for the previous 6 months.
> - I have a cron script running that resyncs monthly.
> - When the raid is unmounted, the system runs fine. (I have an
> additional "dumb" hardware raid 1 for dailies attached to an ESATA port.
> This runs perfectly).
> - I am in the process of re-syncing the raid 6 again right now.
> - I have run an fsck on the raid volume after it was fully synced and
> everything came up clean.
> 
> - there have been lots of power outages the last while with the hot
> summer in Toronto. My UPS shuts the system down for me, though I think I
> can correlate the issues with the power outages.

This sounds like the UPS is cutting power to the system before the
shutdown sequence completes, before the array is stopped.  This assumes
you are already using apcupsd or similar.  If you are check the
configuration to make sure the system has plenty of time to shutdown
after the UPS sends notification to the system.  If you are not, then
this will always happen as the UPS is simply cutting power when the
battery gets low.

Note that if the UPS is undersized for this system and only yields a few
minutes of on-battery time, it may simply not have enough juice to keep
the machine up throughout the shutdown process.

In summary, either your shutdown software isn't configured properly, you
are not using it, or the UPS is too small.  This isn't an md problem.


Cheers,

Stan
