From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: RAID SB 1.x autodetection
Date: Thu, 31 May 2007 09:00:10 -0400
Message-ID: <465EC6DA.6020102@tmr.com>
References: <Pine.LNX.4.61.0705292036400.11140@yvahk01.tjqt.qr> <877iqqul7a.fsf@hades.wkstn.nix> <465DE009.7060202@tmr.com> <Pine.LNX.4.61.0705302254210.11140@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0705302254210.11140@yvahk01.tjqt.qr>
Sender: linux-raid-owner@vger.kernel.org
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Nix <nix@esperi.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jan Engelhardt wrote:
> On May 30 2007 16:35, Bill Davidsen wrote:
>   
>>> On 29 May 2007, Jan Engelhardt uttered the following:
>>>       
>>>> from your post at
>>>> http://www.mail-archive.com/linux-raid@vger.kernel.org/msg07384.html I
>>>> read that autodetecting arrays with a 1.x superblock is currently
>>>> impossible. Does it at least work to force the kernel to always assume
>>>> a 1.x sb? There are some 'broken' distros out there that still don't
>>>> use mdadm in initramfs, and recreating the initramfs each time is a
>>>> bit cumbersome...
>>>>         
>>> The kernel build system should be able to do that for you, shouldn't it?
>>>
>>>       
>> That would be an improvement, yes.
>>     
>
> Hardly, with all the Fedora specific cruft. Anyway, there was a
> simple patch posted in RH bugzilla, so I've gone with that.
>   
I'm not sure what Fedora has to do with it, it is generally useful to 
all distributions. What I had in mind was a make target, so that instead 
of "install" as target, you could have "install_mdadm" in the Makefile. 
Or "mdadm_install" to be consistent with "modules_install" perhaps.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

