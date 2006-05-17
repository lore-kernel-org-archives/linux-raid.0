From: dean gaudet <dean@arctic.org>
Subject: Re: raid5 hang on get_active_stripe
Date: Wed, 17 May 2006 11:41:28 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0605171137350.29929@twinlark.arctic.org>
References: <5d96567b0603060346r768a0ee1i8d8170cf9ba4bac1@mail.gmail.com>
 <Pine.LNX.4.56.0603061156140.26994@lion.drogon.net>
 <5d96567b0603060456h5f2c3cc8me790c86b74e1f854@mail.gmail.com>
 <4415F400.5030808@ucolick.org> <17429.64926.100005.904328@cse.unsw.edu.au>
 <Pine.LNX.4.64.0605110758100.25283@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0605110758100.25283@twinlark.arctic.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Patrik Jonsson <patrik@ucolick.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 11 May 2006, dean gaudet wrote:

> On Tue, 14 Mar 2006, Neil Brown wrote:
> 
> > On Monday March 13, patrik@ucolick.org wrote:
> > > I just experienced some kind of lockup accessing my 8-drive raid5
> > > (2.6.16-rc4-mm2). The system has been up for 16 days running fine, but
> > > now processes that try to read the md device hang. ps tells me they are
> > > all sleeping in get_active_stripe. There is nothing in the syslog, and I
> > > can read from the individual drives fine with dd. mdadm says the state
> > > is "active".
...
> 
> i seem to be running into this as well... it has happenned several times 
> in the past three weeks.  i attached the kernel log output...

it happenned again...  same system as before...


> > You could try increasing the size of the stripe cache
> >   echo 512 > /sys/block/mdX/md/stripe_cache_size
> > (choose and appropriate 'X').
> 
> yeah that got things going again -- it took a minute or so maybe, i
> wasn't paying attention as to how fast things cleared up.

i tried 768 this time and it wasn't enough... 1024 did it again...

> 
> > Maybe check the content of
> >          /sys/block/mdX/md/stripe_cache_active
> > as well.
> 
> next time i'll check this before i increase stripe_cache_size... it's
> 0 now, but the raid5 is working again...

here's a sequence of things i did... not sure if it helps:

# cat /sys/block/md4/md/stripe_cache_active
435
# cat /sys/block/md4/md/stripe_cache_size
512
# echo 768 >/sys/block/md4/md/stripe_cache_size
# cat /sys/block/md4/md/stripe_cache_active
752
# cat /sys/block/md4/md/stripe_cache_active
752
# cat /sys/block/md4/md/stripe_cache_active
752
# cat /sys/block/md4/md/stripe_cache_active
752
# cat /sys/block/md4/md/stripe_cache_active
752
# cat /sys/block/md4/md/stripe_cache_active
752
# cat /sys/block/md4/md/stripe_cache_active
752
# echo 1024 >/sys/block/md4/md/stripe_cache_size
# cat /sys/block/md4/md/stripe_cache_active
927
# cat /sys/block/md4/md/stripe_cache_active
151
# cat /sys/block/md4/md/stripe_cache_active
66
# cat /sys/block/md4/md/stripe_cache_active
2
# cat /sys/block/md4/md/stripe_cache_active
1
# cat /sys/block/md4/md/stripe_cache_active
0
# cat /sys/block/md4/md/stripe_cache_active
3

and it's OK again... except i'm going to lower the stripe_cache_size to
256 again because i'm not sure i want to keep having to double it each
freeze :)

let me know if you want the task dump output from this one too.

-dean
