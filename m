From: Andrew Clayton <andrew@digital-domain.net>
Subject: Re: RAID 5 performance issue.
Date: Fri, 5 Oct 2007 20:42:07 +0100
Message-ID: <20071005204207.2d338375@alpha.digital-domain.net>
References: <20071003105321.06943824@zeus.pccl.info>
	<Pine.LNX.4.64.0710031243080.8612@p34.internal.lan>
	<20071003211910.439ded54@alpha.digital-domain.net>
	<72dbd3150710031336s331782c3yd0ac7ceda4e81774@mail.gmail.com>
	<20071004150831.6edbf926@zeus.pccl.info>
	<Pine.LNX.4.64.0710041009150.8275@p34.internal.lan>
	<Pine.LNX.4.64.0710041009530.8275@p34.internal.lan>
	<20071004154441.31addcfe@zeus.pccl.info>
	<18182.35390.419883.646409@stoffel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18182.35390.419883.646409@stoffel.org>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, David Rees <drees76@gmail.com>, Andrew Clayton <andrew@pccl.info>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 5 Oct 2007 15:02:22 -0400, John Stoffel wrote:

> 
> How much memory does this system have?  Have you checked the output of

2GB

> /proc/mtrr at all?  There' have been reports of systems with a bad

$ cat /proc/mtrr 
reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1

> BIOS that gets the memory map wrong, causing access to memory to slow
> down drastically.

BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007fff0000 (usable)
 BIOS-e820: 000000007fff0000 - 000000007ffff000 (ACPI data)
 BIOS-e820: 000000007ffff000 - 0000000080000000 (ACPI NVS)
 BIOS-e820: 00000000ff780000 - 0000000100000000 (reserved)


full dmesg (from 2.6.21-rc8-git2) at
http://digital-domain.net/kernel/sw-raid5-issue/dmesg

> So if you have 2gb of RAM, try booting with mem=1900m or something

Worth a shot.

> like that and seeing if things are better for you.
> 
> Make sure your BIOS is upto the latest level as well.

Hmm, I'll see whats involved in that.
 
> John


Cheers,

Andrew
