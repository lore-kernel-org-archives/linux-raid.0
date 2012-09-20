From: Chris Friesen <chris.friesen@genband.com>
Subject: hung in raise_barrier() in raid1.c  -- any ideas?
Date: Thu, 20 Sep 2012 10:52:50 -0600
Message-ID: <505B49E2.8070109@genband.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi,

I've got a fairly beefy (32 cpus, 64GB ram, isci-based SAS disks, etc.) 
embedded system running 2.6.27.

We're seeing issues where disk operations suddenly seem to stall.  In 
the most recent case we had the hung-task watchdog indicate that 
md1_resync was stuck for more than 120sec in raise_barrier().

There are a bunch of "normal" tasks also stuck in wait_barrier(), so 
based on that I assume we're stuck in the second call to 
wait_event_lock_irq().

Has anyone seen anything like this?  Could commit 73d5c38 be related? 
What about 1d9d524?

Also, what's the meaning of RESYNC_DEPTH?

Thanks,
Chris

-- 

Chris Friesen
Software Designer

3500 Carling Avenue
Ottawa, Ontario K2H 8E9
www.genband.com
