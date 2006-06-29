From: Tim <irule@irule.net>
Subject: Re: Cutting power without breaking RAID
Date: Wed, 28 Jun 2006 18:03:01 -0700
Message-ID: <44A326C5.70205@irule.net>
References: <20060628214350.GA23970@rigacci.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060628214350.GA23970@rigacci.org>
Sender: linux-raid-owner@vger.kernel.org
To: Niccolo Rigacci <niccolo@rigacci.org>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Your UPS won't accept a timer value to wait before actually cutting
power? That would probably be ideal, issue the power off command with
something like a 30 second timeout, which would give the system time to
power off cleanly first.

-Tim

Niccolo Rigacci wrote:
> Hello,
>
> I'm facing this problem:
>
> when my Linux box detects a POWER FAIL event from the UPS, it 
> starts a normal shutdown. Just before the normal kernel poweroff, 
> it sends to the UPS a signal on the serial line which says 
> "cut-off the power to the server and switch-off the UPS".
>
> This is required to reboot the server as soon as the power is 
> restored.
>
> The problem is that the root partition is on top of a RAID-1 
> filesystem which is still mounted when the program that kills the 
> power is run, so the system goes down with a non clean RAID 
> volume.
>
> What can be the proper action to do before killing the power to 
> ensure that RAID will remain clean? It seems that remounting 
> the partition read-only is not sufficient.
>
>   

