From: David Greaves <david@dgreaves.com>
Subject: occasional bitmap was Re: RFC - device names and mdadm with some
 reference to udev.
Date: Tue, 28 Oct 2008 09:42:37 +0000
Message-ID: <4906DE8D.5010006@dgreaves.com>
References: <18692.62860.863118.727187@notabene.brown>	 <20081027082257.GB1801@piper.oerlikon.madduck.net>	 <1225120416.4845.128.camel@firewall.xsintricity.com>	 <20081027161000.GG17300@skl-net.de>	 <ac3eb2510810270937i3acd7c94r2817b8f4c79babec@mail.gmail.com> <1225128270.4845.144.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1225128270.4845.144.camel@firewall.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Andre Noll <maan@systemlinux.org>, martin f krafft <madduck@debian.org>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, Michal Marek <mmarek@novell.com>
List-Id: linux-raid.ids

Doug Ledford wrote:
> Here's the issue (in Fedora at least).  Starting devices via udev means
> starting them as soon as they are capable and not waiting until all
> devices are up and running.  You have to do this in case the device is
> in a degraded state and you aren't going to get all the devices.

> However, we don't create a bitmap on devices by default in the installer
> (a user can add one themselves, but it isn't there by default).  Without
> the bitmap, if the device is written to before all devices are added, it
> triggers a full resync of the device.

What about creating a bitmap and only writing to it whilst the array is degraded?

That way you don't get the performance hit of a permanent bitmap (which I live
with) but you do get high speed incremental assembly.

The bitmap area may have to record the starting event count written added to it.
 Then as devices are added, if the starting event matches the bitmap is used, if
not then a full sync happens.

I don't think this needs anything special on shutdown.

David


-- 
"Don't worry, you'll be fine; I saw it work in a cartoon once..."
