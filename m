From: Neil Brown <neilb@suse.de>
Subject: Re: Proposal: make RAID6 code optional
Date: Sun, 19 Apr 2009 16:28:11 +1000
Message-ID: <18922.50299.133847.743973@notabene.brown>
References: <200904180946.27722.prakash@punnoor.de>
	<49E98AD2.8060601@msgid.tls.msk.ru>
	<200904181117.03418.prakash@punnoor.de>
	<alpine.LNX.2.00.0904181551320.16493@swampdragon.chaosbits.net>
	<20090418145850.GD28512@mea-ext.zmailer.org>
	<49EA8766.9070605@zytor.com>
	<2954ad7f6081b2a6da33f861b0654626.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from NeilBrown on Sunday April 19
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>, Matti Aarnio <matti.aarnio@zmailer.org>, Jesper Juhl <jj@chaosbits.net>, Prakash Punnoor <prakash@punnoor.de>, Michael Tokarev <mjt@tls.msk.>
List-Id: linux-raid.ids

On Sunday April 19, neilb@suse.de wrote:
> 
> In 2.6.30, the Q syndrome code has been moved into a separate module,
> so raid456.ko should be quite a bit smaller.

Of course that doesn't really help as there will be a dependency
between raid456.ko and pq.ko so you cannot avoid having pq.ko loaded
while using raid5.

It might make sense to create a raid6 module that just contains 
The call to register_md_personality(raid6_personality) and some
linkage so that the code in raid456.ko can get to the code in pq.ko.

This is probably worth trying one the raid6 async offload stuff
stabilises.

NeilBrown
