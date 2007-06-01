From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: RAID SB 1.x autodetection
Date: Fri, 01 Jun 2007 12:16:07 -0400
Message-ID: <46604647.2040703@tmr.com>
References: <Pine.LNX.4.61.0705292036400.11140@yvahk01.tjqt.qr> <877iqqul7a.fsf@hades.wkstn.nix> <465DE009.7060202@tmr.com> <Pine.LNX.4.61.0705302254210.11140@yvahk01.tjqt.qr> <465EC6DA.6020102@tmr.com> <Pine.LNX.4.61.0705312105430.11140@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0705312105430.11140@yvahk01.tjqt.qr>
Sender: linux-raid-owner@vger.kernel.org
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Nix <nix@esperi.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jan Engelhardt wrote:
> On May 31 2007 09:00, Bill Davidsen wrote:
>   
>>> Hardly, with all the Fedora specific cruft. Anyway, there was a
>>> simple patch posted in RH bugzilla, so I've gone with that.
>>>
>>>       
>> I'm not sure what Fedora has to do with it,
>>     
>
> I like highly modularized systems. And that requires an initramfs
> to load all the required modules.
>
>   

And do you find the Fedora is the only distribution which is modular? 
I'm simply calling attention to the problem being general, not something 
which works on everything but Fedora. I generally have to diddle the 
initram a bit to get mdadm in, nbd module, and the video and framebuffer 
modules for the system. I'd like to have a "add these" file the make can 
read, but I can cope with scripts to do it after the install.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

