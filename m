From: Sasa Ostrouska <sasa.ostrouska@volja.net>
Subject: Re: kernel 2.6.8.1 & HPT370 RAID 1 array
Date: Thu, 07 Oct 2004 15:02:25 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1097154145.4268.17.camel@localhost>
References: <1097136709.4268.11.camel@localhost>
	 <1097153908.7962.867.camel@ws102.darkcore.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1097153908.7962.867.camel@ws102.darkcore.net>
To: John Lange <john.lange@bighostbox.com>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 2004-10-07 at 07:58 -0500, John Lange wrote:
> I'm not certain but your problem could very well be that the device
> names for SATA devices are different under 2.4.x kernels making your
> fstab invalid.
> 
This is exactly what I was thinking when I check the fstab. But who 
knows. I have tried to find some docs in the kernel source for 
RAID but have not been succesfull.  

> My understanding is 2.4 uses different code for SATA support than 2.6
> does and they assign different device names. 2.6 uses libata and 2.4
> uses ... ? The matter is futher complicated by the fact that libata has
> been recently backported to 2.4.27.
> 
> I have recently been trying to get some clarity on this issue myself so
> hopefully others on this list can shed some light on it.
> 
> John
Yes I hope somebody can help me with that. 

Rgds
-- 
Sasa Ostrouska <sasa.ostrouska@volja.net>

