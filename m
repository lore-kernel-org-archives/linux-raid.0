From: dean gaudet <dean@arctic.org>
Subject: Re: raid5 hang on get_active_stripe
Date: Fri, 26 May 2006 09:07:52 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0605260903270.7952@twinlark.arctic.org>
References: <5d96567b0603060346r768a0ee1i8d8170cf9ba4bac1@mail.gmail.com>
 <Pine.LNX.4.56.0603061156140.26994@lion.drogon.net>
 <5d96567b0603060456h5f2c3cc8me790c86b74e1f854@mail.gmail.com>
 <4415F400.5030808@ucolick.org> <17429.64926.100005.904328@cse.unsw.edu.au>
 <Pine.LNX.4.64.0605110758100.25283@twinlark.arctic.org>
 <Pine.LNX.4.64.0605171137350.29929@twinlark.arctic.org>
 <17522.29813.189944.397154@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17522.29813.189944.397154@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Patrik Jonsson <patrik@ucolick.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 23 May 2006, Neil Brown wrote:

> I've spent all morning looking at this and while I cannot see what is
> happening I did find a couple of small bugs, so that is good...
> 
> I've attached three patches.  The first fix two small bugs (I think).
> The last adds some extra information to
>   /sys/block/mdX/md/stripe_cache_active
> 
> They are against 2.6.16.11.
> 
> If you could apply them and if the problem recurs, report the content
> of stripe_cache_active several times before and after changing it,
> just like you did last time, that might help throw some light on the
> situation.

i applied them against 2.6.16.18 and two days later i got my first hang... 
below is the stripe_cache foo.

thanks
-dean

neemlark:~# cd /sys/block/md4/md/
neemlark:/sys/block/md4/md# cat stripe_cache_active 
255
0 preread
bitlist=0 delaylist=255
neemlark:/sys/block/md4/md# cat stripe_cache_active 
255
0 preread
bitlist=0 delaylist=255
neemlark:/sys/block/md4/md# cat stripe_cache_active 
255
0 preread
bitlist=0 delaylist=255
neemlark:/sys/block/md4/md# cat stripe_cache_active 
255
0 preread
bitlist=0 delaylist=255
neemlark:/sys/block/md4/md# cat stripe_cache_active 
255
0 preread
bitlist=0 delaylist=255
neemlark:/sys/block/md4/md# cat stripe_cache_size 
256
neemlark:/sys/block/md4/md# echo 512 >stripe_cache_size
neemlark:/sys/block/md4/md# cat stripe_cache_active
474
187 preread
bitlist=0 delaylist=222
neemlark:/sys/block/md4/md# cat stripe_cache_active
438
222 preread
bitlist=0 delaylist=72
neemlark:/sys/block/md4/md# cat stripe_cache_active
438
222 preread
bitlist=0 delaylist=72
neemlark:/sys/block/md4/md# cat stripe_cache_active
469
222 preread
bitlist=0 delaylist=72
neemlark:/sys/block/md4/md# cat stripe_cache_active
512
72 preread
bitlist=160 delaylist=103
neemlark:/sys/block/md4/md# cat stripe_cache_active
1
0 preread
bitlist=0 delaylist=0
neemlark:/sys/block/md4/md# cat stripe_cache_active
2
0 preread
bitlist=0 delaylist=0
neemlark:/sys/block/md4/md# cat stripe_cache_active
0
0 preread
bitlist=0 delaylist=0
neemlark:/sys/block/md4/md# cat stripe_cache_active
2
0 preread
bitlist=0 delaylist=0
neemlark:/sys/block/md4/md# 

md4 : active raid5 sdd1[0] sde1[5](S) sdh1[4] sdg1[3] sdf1[2] sdc1[1]
      1562834944 blocks level 5, 128k chunk, algorithm 2 [5/5] [UUUUU]
      bitmap: 10/187 pages [40KB], 1024KB chunk
