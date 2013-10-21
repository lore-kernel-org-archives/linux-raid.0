From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: failed raid5
Date: Mon, 21 Oct 2013 10:24:26 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1310211022280.26825@uplift.swm.pp.se>
References: <06B0F993133B448E8F5CC115FB559300@DoenerMobil>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <06B0F993133B448E8F5CC115FB559300@DoenerMobil>
Sender: linux-raid-owner@vger.kernel.org
To: i.mikic@freenet.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 20 Oct 2013, i.mikic@freenet.de wrote:

> as far as i can see, 2 of the Memberdisks were switched from active to spare.

Check "dmesg" output and see what you find, there should be reason stated 
there.

> waht are the chances the data on the drives is still intact, how can i 
> get the raid running again and how risky is the process (is it neccesary 
> to get additional drives for cloning)?

Stop the array, then do mdadm --assemble --force with all the member 
drives. Since your event count is identical on all drives, this should be 
safe.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
