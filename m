From: Neil Brown <neilb@suse.de>
Subject: Re: RFC - device names and mdadm with some reference to udev.
Date: Tue, 28 Oct 2008 10:36:32 +1100
Message-ID: <18694.20608.954160.346473@notabene.brown>
References: <18692.62860.863118.727187@notabene.brown>
	<20081027082257.GB1801@piper.oerlikon.madduck.net>
	<1225120416.4845.128.camel@firewall.xsintricity.com>
	<20081027161000.GG17300@skl-net.de>
	<ac3eb2510810270937i3acd7c94r2817b8f4c79babec@mail.gmail.com>
	<1225128270.4845.144.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Doug Ledford on Monday October 27
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Andre Noll <maan@systemlinux.org>, martin f krafft <madduck@debian.org>, linux-raid@vger.kernel.org, Michal Marek <mmarek@novell.com>
List-Id: linux-raid.ids

On Monday October 27, dledford@redhat.com wrote:
> 
> I've found the udev rules method of starting md devices to be
> problematic (at best).
> 
> Here's the issue (in Fedora at least).  Starting devices via udev means
> starting them as soon as they are capable and not waiting until all
> devices are up and running.  You have to do this in case the device is
> in a degraded state and you aren't going to get all the devices.
> However, we don't create a bitmap on devices by default in the installer
> (a user can add one themselves, but it isn't there by default).  Without
> the bitmap, if the device is written to before all devices are added, it
> triggers a full resync of the device.  As it turns out, for certain
> installations, this happens on *every* single reboot.  It's painful, to
> say the least.   So, I wanted to change the udev rule to work slightly
> differently.  I wanted the invocation of mdadm --incremental that
> happened to be the one that took the array from an unrunable state to a
> runable but degraded state to sleep for say 2 to 5 seconds, and then if
> the array is still not up and running due to subsequent udev rule
> invocations, it would start the array in a degraded state.  This,
> however, breaks udevsettle.  So, the current setup (for the upcoming
> fedora 10) is done such that the udev rule won't start any degraded
> arrays, and instead we have both a specific mdadm invocation in the
> initrd and another in rc.sysinit that will start any degraded arrays
> that are also listed in the mdadm.conf file.  This makes sure that known
> arrays are assembled and started if at all possible, but we only start
> unknown arrays if they are complete.
> 

This is using udev to start md devices, which is not quite the focus
of the previous discussion.  That was more about using udev to create
the entries in /dev when someone else started the arrays.

However this is still a real issue that I would like to handle as best
we can.

I would like to get the md code to always have at least an in-memory
bitmap to allow quite resync after a "re-add".

However even this isn't a perfect solution as there is a window when a
single device failure can kill an array.

Your solution sounds good, but I'd be happy to hear other thoughts on
the issue.

Thanks,
NeilBrown
