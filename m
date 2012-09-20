From: Chris Friesen <chris.friesen@genband.com>
Subject: Re: hung in raise_barrier() in raid1.c  -- any ideas?
Date: Thu, 20 Sep 2012 11:55:02 -0600
Message-ID: <505B5876.4040405@genband.com>
References: <505B49E2.8070109@genband.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <505B49E2.8070109@genband.com>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/20/2012 10:52 AM, Chris Friesen wrote:
>
> Hi,
>
> I've got a fairly beefy (32 cpus, 64GB ram, isci-based SAS disks, 
> etc.) embedded system running 2.6.27.
>
> We're seeing issues where disk operations suddenly seem to stall.  In 
> the most recent case we had the hung-task watchdog indicate that 
> md1_resync was stuck for more than 120sec in raise_barrier().
>
> There are a bunch of "normal" tasks also stuck in wait_barrier(), so 
> based on that I assume we're stuck in the second call to 
> wait_event_lock_irq().
>
> Has anyone seen anything like this?  Could commit 73d5c38 be related? 
> What about 1d9d524?

Could d6b42dc be related?

Chris
