From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: "cannot start dirty degraded array"
Date: Mon, 15 Jun 2009 11:54:22 -0400
Message-ID: <4A366EAE.9010706@tmr.com>
References: <20090610200310.GF18313@lairds.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090610200310.GF18313@lairds.com>
Sender: linux-raid-owner@vger.kernel.org
To: Kyler Laird <kyler-keyword-linuxraid.6e1399@lairds.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Kyler Laird wrote:
> I'm in a bind.  I have three RAID6s on a Sun X4540.  A bunch of disks
> threw error all of a sudden.  Two arrays came back (degraded) on reboot
> but the third is having problems.  
>   

Just a thought, when multiple units have errors at the same time, I 
suspect a power issue. And if these are real SCSI drives, it's possible 
for a drive to fail in such a way that it glitches the SCSI bus and 
causes the controller to think that multiple drives doing concurrent 
seeks have failed. I saw this often enough to have a script to force the 
controller to mark drives good and then test them one at a time when I 
was running ISP servers.

-- 
Bill Davidsen <davidsen@tmr.com>
  Obscure bug of 2004: BASH BUFFER OVERFLOW - if bash is being run by a
normal user and is setuid root, with the "vi" line edit mode selected,
and the character set is "big5," an off-by-one error occurs during
wildcard (glob) expansion.

