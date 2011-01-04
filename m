From: NeilBrown <neilb@suse.de>
Subject: Re: filesystem corruption
Date: Tue, 4 Jan 2011 16:33:24 +1100
Message-ID: <20110104163324.70baff54@notabene.brown>
References: <4D212D4A.3040003@feystorm.net>
	<20110103141603.632fdf3e@notabene.brown>
	<4D214B5C.3010103@feystorm.net>
	<20110103155630.565341d0@notabene.brown>
	<4D215902.9010308@feystorm.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D215902.9010308@feystorm.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Patrick H." <linux-raid@feystorm.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 02 Jan 2011 22:05:06 -0700 "Patrick H." <linux-raid@feystorm.net>
wrote:

> Ok, thanks for the info.
> I think I'll solve it by creating 2 dedicated hosts for running the 
> array, but not actually export any disks themselves. This way if a 
> master dies, all the raid disks are still there and can be picked up by 
> the other master.
> 

That sounds like it should work OK.

NeilBrown

