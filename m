From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Raid corruption problems.
Date: Tue, 19 Dec 2006 16:39:54 -0500
Message-ID: <45885C2A.40602@tmr.com>
References: <4582FD12.90806@advocap.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4582FD12.90806@advocap.org>
Sender: linux-raid-owner@vger.kernel.org
To: John McMonagle <johnm@advocap.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

John McMonagle wrote:
> Have a raid1  backup server that seems to get corrupted.
> This is the 3rd time in about a year.
> Have 2 other backup servers that were cloned from this one that have 
> no problems.
>
> Done a couple kernel upgrades recently.
> Now has 2.6.18-2 kernel.
> It's based on Debian sarge.
>
> It's a low end Intel server motherboard using ata_piix sata driver.
> Have another mother board just like doing raid1 with sata drives that 
> has had no problems but it has a much lighter disk load.
> smartctl has never shown any problems.
> In /sys/block/md2 did
> echo check > syncaction
> No error messages but mismatch_cnt  is 1152.
> rc0/errors and rc1/errors are both 0.
>
> I'm guessing a hardware problem.
> Any suggestions? 

Since memory is the easiest to test, I'd try memtest86+ for at least 12 
hr. If this were PATA I'd suggest replugging the cables, but it's lower 
probability with SATA. Still, probably worth trying.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

