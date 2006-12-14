From: David Greaves <david@dgreaves.com>
Subject: Re: Frequent SATA errors / port timeouts in 2.6.18.3?
Date: Thu, 14 Dec 2006 08:40:00 +0000
Message-ID: <45810DE0.9060608@dgreaves.com>
References: <4578F5D4.8080205@moniker.net> <458081D4.9060704@ucolick.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <458081D4.9060704@ucolick.org>
Sender: linux-raid-owner@vger.kernel.org
To: Patrik Jonsson <patrik@ucolick.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Patrik Jonsson wrote:
> Hi all,
> this may not be the best list for this question, but I figure that the
> number of disks connected to users here should be pretty big...
> 
> I upgraded from 2.6.17-rc4 to 2.6.18.3 about a week ago, and I've since
> had 3 drives kicked out of my 10-drive RAID5 array. Previously, I had no
> kicks over almost a year. The kernel message is:
> 
> ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> ata7.00: (BMDMA stat 0x20)
> ata7.00: tag 0 cmd 0xc8 Emask 0x1 stat 0x41 err 0x4 (device error)
> ata7: EH complete

> Any ideas or thought would be appreciated,
SMART?

Read the manpage and then try running:
smartctl -data -S on /dev/...
and
smartctl -data -s on /dev/...

Then look at your smartd timing and see if it's related; possibly just do a
manual smartd poll.

I've had smart/libata problems (well, no, glitches) for about 2 years now but as
the irq handler occasionally says "no one cared" ;)

It may well not be your problem but...

David
