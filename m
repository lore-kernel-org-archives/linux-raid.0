From: Neil Brown <neilb@suse.de>
Subject: Re: raid5 hang on get_active_stripe
Date: Wed, 31 May 2006 11:38:15 +1000
Message-ID: <17532.62343.933852.982391@cse.unsw.edu.au>
References: <5d96567b0603060346r768a0ee1i8d8170cf9ba4bac1@mail.gmail.com>
	<Pine.LNX.4.56.0603061156140.26994@lion.drogon.net>
	<5d96567b0603060456h5f2c3cc8me790c86b74e1f854@mail.gmail.com>
	<4415F400.5030808@ucolick.org>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from dean gaudet on Tuesday May 30
Sender: linux-raid-owner@vger.kernel.org
To: dean gaudet <dean@arctic.org>
Cc: Patrik Jonsson <patrik@ucolick.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday May 30, dean@arctic.org wrote:
> 
> actually i think the rate is higher... i'm not sure why, but klogd doesn't 
> seem to keep up with it:
> 
> root@neemlark:~# grep -c kblockd_schedule_work /var/log/messages
> 31
> root@neemlark:~# dmesg | grep -c kblockd_schedule_work
> 8192

# grep 'last message repeated' /var/log/messages
??

Obviously even faster than I thought.  I guess workqueue threads must
take a while to get scheduled...
I'm beginning to wonder if I really have found the bug after all :-(

I'll look forward to the results either way.

Thanks,
NeilBrown
