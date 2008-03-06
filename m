From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: [PATCH 001 of 9] md: Fix deadlock in md/raid1 and md/raid10
 when handling a read error.
Date: Thu, 6 Mar 2008 17:34:42 +0100
Message-ID: <20080306173442.4516645f@szpak>
References: <20080303111240.23302.patches@notabene>
	<1080303001705.23577@suse.de>
	<20080303155449.GA32242@skl-net.de>
	<18380.59250.90214.461186@notabene.brown>
	<20080304112945.GB32242@skl-net.de>
	<18383.25889.876350.431676@notabene.brown>
	<20080306105134.GC32242@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080306105134.GC32242@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andre Noll said:     (by the date of Thu, 6 Mar 2008 11:51:34 +0100)

> But is that enough to avoid the deadlock? I think the following
> scenario would be possible with the code in the original patch:
> 
> 	// suppose conf->pending_bio_list.head==NULL ATM
> 
> 	CPU0:
> 	int rv = 0;
> 	spin_lock_irq(&conf->device_lock);
> 	if (conf->pending_bio_list.head) // false
> 	spin_unlock_irq(&conf->device_lock);
> 
> 	CPU1:
> 	conf->pending_bio_list.head = something;
> 
> 	CPU0:
> 	return rv; // zero

Remember that it's impossible to predict when is executed what. This
scenario can be true also, will it work?

 	CPU0:
 	int rv = 0;

CPU1:
conf->

	CPU0:
	spin_lock_irq(&conf->device_lock);

CPU1:
->pending_bio_list.

	CPU0:
 	if (conf->pending_bio_list.head) // false

CPU1:
.head = 

	CPU0:
 	spin_unlock_irq(&conf->device_lock);
 	return rv; // zero

CPU1:
= something;


This is exaggerated of course. But if you want to think "concurrent
execution" you must think that way.

-- 
Janek Kozicki                                                         |
