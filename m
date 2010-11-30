From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 14/53] FIX: Cannot exit monitor after takeover
Date: Wed, 1 Dec 2010 09:06:50 +1100
Message-ID: <20101201090650.46481f95@notabene.brown>
References: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
	<20101126080537.5221.28837.stgit@gklab-170-024.igk.intel.com>
	<20101129103829.0964debb@notabene.brown>
	<905EDD02F158D948B186911EB64DB3D174C8AB57@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D174C8AB57@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

On Tue, 30 Nov 2010 16:03:16 +0000 "Kwolek, Adam" <adam.kwolek@intel.com>
wrote:

> The problem is that, when raid0 array is about unfreezing and this is single/last array in container,
> Ping to this container causes to mdmon not to exit.
> In such condition managemon receives message and in handle_message() for ping case, calls wakeup_monitor()
> and then goes in to loop for monitor_loop_cnt update 
> 1. this occurs after timeout 
> 2. when this happens managemon stops on pselect() and as there is nothing to monitor in never wakeups.
> 3. monitor waits to be allowed to exit on open handlers.
> 
> How can this be resolved:
> 1. do not ping for last raid0 array during unfreezing (I've reworked patch to meet this condition)
> 2. guard waiting for monitor_loop_cnt change in handle_message() with:
> 	if (container->arrays)
> 
> 3. change in manage member condition:
> 	if (sigterm)
> 		Wakeup_monitor();
> 
> To
> 	if (sigterm || (container->arrays == NULL))
> 		Wakeup_monitor();
> 
> This causes additional monitor wakeup.
> 
> Any of method causes mdmon to exit as expected. 
> In cases 2 and 3 it takes a while (we are waiting on communication timeouts).
> Method 1 is fast and we are not blocking mdmon exit by communication.

Thanks for the explanation!
I definitely want to fix the managemon/monitor interaction so that it doesn't
hang as you describe.  I might end up with something a lot more heavy-weight
that the changes you suggest.

It might still be OK to include your option '1' as well - I decide when you
post the patch.

thanks,
NeilBrown

