From: "John Stoffel" <john@stoffel.org>
Subject: Re: RAID 5 performance issue.
Date: Fri, 5 Oct 2007 16:56:03 -0400
Message-ID: <18182.42211.405326.261727@stoffel.org>
References: <20071003105321.06943824@zeus.pccl.info>
	<Pine.LNX.4.64.0710031243080.8612@p34.internal.lan>
	<20071003211910.439ded54@alpha.digital-domain.net>
	<72dbd3150710031336s331782c3yd0ac7ceda4e81774@mail.gmail.com>
	<20071004150831.6edbf926@zeus.pccl.info>
	<Pine.LNX.4.64.0710041009150.8275@p34.internal.lan>
	<Pine.LNX.4.64.0710041009530.8275@p34.internal.lan>
	<20071004154441.31addcfe@zeus.pccl.info>
	<18182.35390.419883.646409@stoffel.org>
	<20071005204207.2d338375@alpha.digital-domain.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071005204207.2d338375@alpha.digital-domain.net>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Clayton <andrew@digital-domain.net>
Cc: John Stoffel <john@stoffel.org>, Justin Piszcz <jpiszcz@lucidpixels.com>, David Rees <drees76@gmail.com>, Andrew Clayton <andrew@pccl.info>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Andrew> On Fri, 5 Oct 2007 15:02:22 -0400, John Stoffel wrote:
>> 
>> How much memory does this system have?  Have you checked the output of

Andrew> 2GB

>> /proc/mtrr at all?  There' have been reports of systems with a bad

Andrew> $ cat /proc/mtrr 
Andrew> reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1

That looks to be good, all the memory is there all in the same
region.  Oh well... it was a thought. 

>> BIOS that gets the memory map wrong, causing access to memory to slow
>> down drastically.

Andrew> BIOS-provided physical RAM map:
Andrew>  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
Andrew>  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
Andrew>  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
Andrew>  BIOS-e820: 0000000000100000 - 000000007fff0000 (usable)
Andrew>  BIOS-e820: 000000007fff0000 - 000000007ffff000 (ACPI data)
Andrew>  BIOS-e820: 000000007ffff000 - 0000000080000000 (ACPI NVS)
Andrew>  BIOS-e820: 00000000ff780000 - 0000000100000000 (reserved)

I dunno about this part.  

Andrew> full dmesg (from 2.6.21-rc8-git2) at
Andrew> http://digital-domain.net/kernel/sw-raid5-issue/dmesg

>> So if you have 2gb of RAM, try booting with mem=1900m or something

Andrew> Worth a shot.

It might make a difference, might not.  Do you have any kernel
debugging options turned on?  That might also be an issue.  Check your
.config, there are a couple of options which drastically slow down the
system. 

>> like that and seeing if things are better for you.
>> 
>> Make sure your BIOS is upto the latest level as well.

Andrew> Hmm, I'll see whats involved in that.
 
At this point, I don't suspect the BIOS any more.  

Can you start a 'vmstat 1' in one window, then start whatever you do
to get crappy performance.  That would be interesting to see.

John
