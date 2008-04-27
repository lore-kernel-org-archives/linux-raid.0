From: Mark Hahn <hahn@mcmaster.ca>
Subject: Re: Question: how to identify failing disk in a RAID1
Date: Sun, 27 Apr 2008 17:53:38 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0804271749200.29351@coffee.psychology.mcmaster.ca>
References: <48025B8D.2030803@harddata.com> <alpine.DEB.1.10.0804131529300.11311@p34.internal.lan>
 <4802AFEB.9020006@tmr.com> <480F7105.9030405@harddata.com>
 <alpine.DEB.1.10.0804231453390.4441@p34.internal.lan> <480F8830.6020207@harddata.com>
 <alpine.DEB.1.10.0804231525140.4441@p34.internal.lan>
 <alpine.LFD.1.10.0804271758360.18247@www.karsites.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0804271758360.18247@www.karsites.net>
Sender: linux-raid-owner@vger.kernel.org
To: Keith Roberts <keith@karsites.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Is there any way that the smartmontools code can be included in the md driver 
> code, to allow mdadm access to the SMART data on a RAID1 set of disks please?

eh?  smart monitors disks.  the disks that comprise your raids are still 
available as disks, and smart can monitor them just fine...
