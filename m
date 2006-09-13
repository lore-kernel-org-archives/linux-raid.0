From: Ric Wheeler <ric@emc.com>
Subject: Re: libata hotplug and md raid?
Date: Wed, 13 Sep 2006 06:51:21 -0400
Message-ID: <4507E2A9.7070306@emc.com>
References: <c384c5ea0609130311t4005e5aam153251fc6bbbdfb8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c384c5ea0609130311t4005e5aam153251fc6bbbdfb8@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leon Woestenberg <leon.woestenberg@gmail.com>
Cc: linux-raid@vger.kernel.org, Tejun Heo <htejun@gmail.com>, Greg KH <gregkh@suse.de>
List-Id: linux-raid.ids

(Adding Tejun & Greg KH to this thread)

Leon Woestenberg wrote:

> Hello all,
>
> I am testing the (work-in-progress / upcoming) libata SATA hotplug.
> Hotplugging alone seems to work, but not well in combination with md
> RAID.
>
> Here is my report and a question about intended behaviour. Mainstream
> 2.6.17.11 kernel patched with libata-tj-2.6.17.4-20060710.tar.bz2 from
> http://home-tj.org/files/libata-tj-stable/.
>
> Supermicro P8SCT motherboard with Intel ICH6R, using AHCI libata driver.
>
> In short, I use ext3 over /dev/md0 over 4 SATA drives /dev/sd[a-d]
> each driven by libata ahci. I unplug then replug the drive that is
> rebuilding in RAID-5.
>
> When I unplug a drive, /dev/sda is removed, hotplug seems to work to
> the point where proc/mdstat shows the drive failed, but not removed.
>
> Every other notion of the drive (in kernel and udev /dev namespace)
> seems to be gone after unplugging. I cannot manually removed the drive
> using mdadm, because it tells me the drive does not exist.
>
> Replugging the drive brings it back as /dev/sde, md0 will not pick it up.

I have a similar setup, AHCI + 4 drives but using a RAID-1 group.  The 
thing that you are looking for is "persistent device naming" and should 
work properly if you can tweak udev/hotplug correctly.

I have verified that a drive pull/drive reinsert on a mainline kernel 
with a SLES10 base does provide this (first insertion gives me sdb, pull 
followed by reinsert still is sdb), but have not tested interaction with 
RAID since I am focused on the bad block handling at the moment.  I will 
add this to my list ;-)

>
> The expected behaviour (from me) is that the drive re-appears as 
> /dev/sda.
>
> What is the intended behaviour of md in this case?
>
> Should some user-space application fail-remove a drive as a pre-action
> of the unplug event from udev, or should md fully remove the drive
> within kernel space??
>
> See kernel/udev/userspace messages in chronological order,
> with my actions marked between >>> <<<, at this web
> page:
>
> http://pastebin.ca/168798
>
> Thanks,
> -- 
> Leon
>
>
