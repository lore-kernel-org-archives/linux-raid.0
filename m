From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: IBM xSeries stop responding during RAID1 reconstruction
Date: Mon, 26 Jun 2006 10:52:52 -0400
Message-ID: <449FF4C4.2050700@tmr.com>
References: <20060614085354.GA18106@rigacci.org> <44902F41.8030300@rcn.com> <20060619150556.GQ11429@boogie.lpds.sztaki.hu> <20060620130859.GA15394@rigacci.org> <20060620132753.GI22404@boogie.lpds.sztaki.hu> <Pine.LNX.4.64.0606200757300.30567@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0606200757300.30567@filesrv1.baby-dragons.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: Gabor Gombas <gombasg@sztaki.hu>, linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Mr. James W. Laferriere wrote:

>     Hello Gabor ,
>
> On Tue, 20 Jun 2006, Gabor Gombas wrote:
>
>> On Tue, Jun 20, 2006 at 03:08:59PM +0200, Niccolo Rigacci wrote:
>>
>>> Do you know if it is possible to switch the scheduler at runtime?
>>
>> echo cfq > /sys/block/<disk>/queue/scheduler
>
>
>     At least one can do a ls of the /sys/block area & then do an 
> automated
>     echo cfq down the tree .  Does anyone know of a method to set a 
> default
>     scheduler ?  Scanning down a list or manually maintaining a list 
> seems
>     to be a bug in the waiting .  Tia ,  JimL

Thought I posted this... it can be set in kernel build or on the bloot 
parameters from grub/lilo.

2nd thought: set it to cfq by default, then at the END of rc.local, if 
there are no arrays rebuilding, change to something else if you like.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

