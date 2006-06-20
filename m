From: Niccolo Rigacci <niccolo@rigacci.org>
Subject: Re: IBM xSeries stop responding during RAID1 reconstruction
Date: Tue, 20 Jun 2006 17:45:24 +0200
Message-ID: <20060620154524.GA19463@rigacci.org>
References: <20060614085354.GA18106@rigacci.org> <44902F41.8030300@rcn.com> <20060619150556.GQ11429@boogie.lpds.sztaki.hu> <20060620130859.GA15394@rigacci.org> <20060620132753.GI22404@boogie.lpds.sztaki.hu> <Pine.LNX.4.64.0606200757300.30567@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0606200757300.30567@filesrv1.baby-dragons.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> 	At least one can do a ls of the /sys/block area & then do an 
> 	automated
> 	echo cfq down the tree .  Does anyone know of a method to set a 
> 	default
> 	scheduler ?

My be I didn't understand the question...

You decide what schedulers are available at kernel compile time, 
also at kernel compile time you decide which is the default i/o 
scheduler.

-- 
Niccolo Rigacci
Firenze - Italy

Iraq, missione di pace: 38475 morti - www.iraqbodycount.net
