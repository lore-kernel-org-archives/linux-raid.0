From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: IBM xSeries stop responding during RAID1 reconstruction
Date: Tue, 20 Jun 2006 08:00:13 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0606200757300.30567@filesrv1.baby-dragons.com>
References: <20060614085354.GA18106@rigacci.org> <44902F41.8030300@rcn.com>
 <20060619150556.GQ11429@boogie.lpds.sztaki.hu> <20060620130859.GA15394@rigacci.org>
 <20060620132753.GI22404@boogie.lpds.sztaki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060620132753.GI22404@boogie.lpds.sztaki.hu>
Sender: linux-raid-owner@vger.kernel.org
To: Gabor Gombas <gombasg@sztaki.hu>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

 	Hello Gabor ,

On Tue, 20 Jun 2006, Gabor Gombas wrote:
> On Tue, Jun 20, 2006 at 03:08:59PM +0200, Niccolo Rigacci wrote:
>> Do you know if it is possible to switch the scheduler at runtime?
> echo cfq > /sys/block/<disk>/queue/scheduler

 	At least one can do a ls of the /sys/block area & then do an automated
 	echo cfq down the tree .  Does anyone know of a method to set a default
 	scheduler ?  Scanning down a list or manually maintaining a list seems
 	to be a bug in the waiting .  Tia ,  JimL
-- 
+----------------------------------------------------------------------+
| James   W.   Laferriere |   System    Techniques   | Give me VMS     |
| Network        Engineer | 3600 14th Ave SE #20-103 |  Give me Linux  |
| babydr@baby-dragons.com |  Olympia ,  WA.   98501  |   only  on  AXP |
+----------------------------------------------------------------------+
