From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: stripe cache question
Date: Sun, 27 Feb 2011 12:37:11 +0100
Message-ID: <20110227113710.GA16286@lazy.lzy>
References: <20110224210642.GA20306@lazy.lzy>
 <20110225145125.69dd4b9d@notabene.brown>
 <20110226102128.GA15074@lazy.lzy>
 <20110227154350.4448d731@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110227154350.4448d731@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > > Ideally the cache should be automatically sized based on demand and memory
> > > size - with maybe just a tunable to select between "use a much memory as you
> > > need - within reason" verse "use a little memory as you can manage with".
> > > 
> > > But that requires thought and design and code and .... it just never seemed
> > > like a priority.
> > 
> > You're a bit contraddicting your philosopy of
> > "let's do the smart things in user space"... :-)
> > 
> > IMHO, if really necessary, it could be enough to
> > have this "upper limit" avaialable in sysfs.
> > 
> > Then user space can decide what to do with it.
> > 
> > For example, at boot the amount of memory is checked
> > and the upper limit set.
> > I see a duplication here, maybe better just remove
> > the upper limit and let user space to deal with that.
> 
> 
> Maybe....  I still feel I want some sort of built-in protection...

As I wrote, I think a second sysfs entry, with the upper
limit, could be enough.
It allows flexibility and somehow protection.
It would be required two _coordinated_ access to sysfs in order
to break the limit, which is unlikely to happen by random.
That is, at boot /sys/block/mdX/md/stripe_cache_limit will
be 32768 and the "cache_size" will be 256.
If someone wants to play with the cache size, will be able
to top it to 32768. Otherwise, the first entry has to be
changed to higher values (min value should be the cache_size).

This is, of course, a duplication, but it enforce a certain
process (two accesses) giving then some degree of protection.

I guess, but you're the expert, this should be easier than
other solutions.

> Maybe if I did all the allocations with "__GFP_WAIT" clear so that it would
> only allocate memory that is easily available.  It wouldn't be a hard
> guarantee against running out, but it might help..

Again, I think you're over-designing it.

BTW, I hope that is unswappable memory, or?

> Maybe you could try removing the limit and see what actually happens when
> you set a ridiculously large size.??

Yes and no. The home PC has a RAID-10f2, the work PC has
a RAID-5, but I do not want to play with the kernel on it.
I guess using loop devices will not be meaningful.

As soon as I manage to build the RAID-6 NAS I could give it
a try, but this has no "schedule" right now.

bye,

-- 

piergiorgio
