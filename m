From: Neil Brown <neilb@suse.de>
Subject: Re: raid5 hang on get_active_stripe
Date: Sat, 27 May 2006 09:55:54 +1000
Message-ID: <17527.38282.35857.117651@cse.unsw.edu.au>
References: <5d96567b0603060346r768a0ee1i8d8170cf9ba4bac1@mail.gmail.com>
	<Pine.LNX.4.56.0603061156140.26994@lion.drogon.net>
	<5d96567b0603060456h5f2c3cc8me790c86b74e1f854@mail.gmail.com>
	<4415F400.5030808@ucolick.org>
	<17429.64926.100005.904328@cse.unsw.edu.au>
	<Pine.LNX.4.64.0605110758100.25283@twinlark.arctic.org>
	<Pine.LNX.4.64.0605171137350.29929@twinlark.arctic.org>
	<17522.29813.189944.397154@cse.unsw.edu.au>
	<Pine.LNX.4.64.0605260903270.7952@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from dean gaudet on Friday May 26
Sender: linux-raid-owner@vger.kernel.org
To: dean gaudet <dean@arctic.org>
Cc: Patrik Jonsson <patrik@ucolick.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday May 26, dean@arctic.org wrote:
> On Tue, 23 May 2006, Neil Brown wrote:
> 
> i applied them against 2.6.16.18 and two days later i got my first hang... 
> below is the stripe_cache foo.
> 
> thanks
> -dean
> 
> neemlark:~# cd /sys/block/md4/md/
> neemlark:/sys/block/md4/md# cat stripe_cache_active 
> 255
> 0 preread
> bitlist=0 delaylist=255
> neemlark:/sys/block/md4/md# cat stripe_cache_active 
> 255
> 0 preread
> bitlist=0 delaylist=255
> neemlark:/sys/block/md4/md# cat stripe_cache_active 
> 255
> 0 preread
> bitlist=0 delaylist=255

Thanks.  This narrows it down quite a bit... too much infact:  I can
now say for sure that this cannot possible happen :-)

Two things that might be helpful:
  1/ Do you have any other patches on 2.6.16.18 other than the 3 I
    sent you?  If you do I'd like to see them, just in case.
  2/ The message.gz you sent earlier with the
          echo t > /proc/sysrq-trigger
     trace in it didn't contain information about md4_raid5 - the 
     controlling thread for that array.  It must have missed out
     due to a buffer overflowing.  Next time it happens, could you
     to get this trace again and see if you can find out what
     what md4_raid5 is going.  Maybe do the 'echo t' several times.
     I think that you need a kernel recompile to make the dmesg
     buffer larger.

Thanks for your patience - this must be very frustrating for you.

NeilBrown
