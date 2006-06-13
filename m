From: Neil Brown <neilb@suse.de>
Subject: Re: raid5 hang on get_active_stripe
Date: Wed, 14 Jun 2006 09:13:17 +1000
Message-ID: <17551.18061.160356.35034@cse.unsw.edu.au>
References: <5d96567b0603060346r768a0ee1i8d8170cf9ba4bac1@mail.gmail.com>
	<17429.64926.100005.904328@cse.unsw.edu.au>
	<Pine.LNX.4.64.0605110758100.25283@twinlark.arctic.org>
	<Pine.LNX.4.64.0605171137350.29929@twinlark.arctic.org>
	<17522.29813.189944.397154@cse.unsw.edu.au>
	<Pine.LNX.4.64.0605260903270.7952@twinlark.arctic.org>
	<17527.38282.35857.117651@cse.unsw.edu.au>
	<Pine.LNX.4.64.0605270834240.30550@twinlark.arctic.org>
	<17529.37347.782285.77442@cse.unsw.edu.au>
	<Pine.LNX.4.64.0605291354260.30134@twinlark.arctic.org>
	<17531.35050.632471.433333@cse.unsw.edu.au>
	<Pine.LNX.4.64.0605301713480.11178@twinlark.arctic.org>
	<17532.59212.364233.765155@cse.unsw.edu.au>
	<Pine.LNX.4.64.0605301758380.21977@twinlark.arctic.org>
	<17532.62343.933852.982391@cse.unsw.edu.au>
	<Pine.LNX.4.64.0605301844180.21977@twinlark.arctic.org>
	<17534.22056.981033.686846@cse.unsw.edu.au>
	<Pine.LNX.4.64.0606020009560.10016@twinlark.arctic.org>
	<17535.59496.431182.785563@cse.unsw.edu.au>
	<448F0994.6050704@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bill Davidsen on Tuesday June 13
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: dean gaudet <dean@arctic.org>, Patrik Jonsson <patrik@ucolick.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday June 13, davidsen@tmr.com wrote:
> 
> Will that fix be in 2.6.17?
> 

Probably not.  We have had the last 'rc' twice and I so I don't think
it is appropriate to submit the patch at this stage.
I probably will submit it for an early 2.6.17.x. and for 2.6.16.y.

NeilBrown
