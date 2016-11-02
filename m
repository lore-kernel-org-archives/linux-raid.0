From: Doug Dumitru <doug@easyco.com>
Subject: Re: RAID boot documentation
Date: Wed, 2 Nov 2016 09:51:19 -0700
Message-ID: <CAFx4rwTjDFS-uob=GpCGtOq2dfLWzKCWciA7RxWdORWkh2qn=g@mail.gmail.com>
References: <CAFx4rwS4xWDcRbWpnq__zTw5FqXA1SUNW1bJgWpxWotJiRKzdA@mail.gmail.com>
 <87funaqtsf.fsf@notabene.neil.brown.name>
Reply-To: doug@easyco.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87funaqtsf.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil,

Thank you very much.  If I chose to write up some documentation on
this, where/who might want it?  udev documentation in general seems
quite weak.

Doug


On Tue, Nov 1, 2016 at 11:29 PM, NeilBrown <neilb@suse.com> wrote:
> On Wed, Nov 02 2016, Doug Dumitru wrote:
>
>> Does anyone have any documentation on when a non-root RAID device
>> mounts and how this is triggered?
>>
>> I have dug around looking for calls to 'mdadm' and or references to
>> mdadm.conf to read the array details, but am not finding the obvious
>> things.  Then again, the new boot services still confuses me.
>>
>
> This depends on what the distro you are using chooses to implement.
>
> If your distro that uses systemd and uses the udev rules and unit files
> that are distrubuted with upstream mdadm, then:
>
> When a device is discovered that contains raid metadata, udev will run
>   mdadm --incremental --export /dev/whatever
> (or similar)
>
> See /usr/lib/udev/rules.d/64-md-raid-assembly.rules for details.
>
> Once this has happened for all devices in an array, the array will be
> started by mdadm.
>
> If mdadm notices that the array *could* be started if needed, but that
> it still expects more devices to appear, it reports
>     MD_STARTED=*unsafe*
> and the udev rules file uses this to trigger a message to systemd to
> start "mdadm-last-resort@devicename.timer"
> This sets a timer.  When the timer fires, the array is started even
> though some devices might be missing.
> If the array gets started before that (because the missing devices
> appeared) the timer is canceled.
>
> When an md array (or any other device) appear, some other udev handling,
> possibly involving udisks, might cause the filesystem to be mounted.
> That is completely outside of the control of mdadm.  mdadm just
> assembles the device.
>
> Hope that helps.
>
> NeilBrown



-- 
Doug Dumitru
EasyCo LLC
