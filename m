From: Henrik Holst <henrik.holst@idgmail.se>
Subject: Re: And then there was Bryce...
Date: Thu, 08 Jun 2006 08:38:46 +0200
Message-ID: <4487C5F6.2080107@idgmail.se>
References: <44877242.2060803@zeniv.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44877242.2060803@zeniv.linux.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Bryce <bryce@zeniv.linux.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bryce wrote:
>
> Gosh, where to start,..
>
> Ok general setup
>
> I'm using  kernel version 2.6.17-rc5 and  Raid 5 over 5 500Gb SATA disks

You have just upgraded to udev havn't you? :-)

[snip!]

>
> Hum ho,.. I survived the horror but umm, well, I'll leave the above as
> a story to frighten young sysadmins with.

The same happened to me with eth0-2. I _could_ not for my life
understand why I didn't get internet connect to work. But then I
realized that eth0 and eth1 had been swapped after I upgraded to udev.
Please advice your distribution udev documentation how to "lock down"
scsi and network cards to specific kernel names.

Regards,
Henrik Holst
