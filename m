From: Neil Brown <neilb@suse.de>
Subject: Re: increasing stripe_cache_size decreases RAID-6 read throughput
Date: Wed, 28 Apr 2010 07:24:19 +1000
Message-ID: <20100428072419.22779335@notabene.brown>
References: <h2y11f0870e1004241636z1f3e302g913be494ec0aefa5@mail.gmail.com>
	<20100427164126.2765f9e0@notabene.brown>
	<n2x11f0870e1004271018t742e933tba7e0d37428271f2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <n2x11f0870e1004271018t742e933tba7e0d37428271f2@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Williams <jwilliams315@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 27 Apr 2010 10:18:36 -0700
Joe Williams <jwilliams315@gmail.com> wrote:

> On Mon, Apr 26, 2010 at 11:41 PM, Neil Brown <neilb@suse.de> wrote:
> > On Sat, 24 Apr 2010 16:36:20 -0700 Joe Williams <jwilliams315@gmail.com> wrote:
> >
> > The whole 'queue' directory really shouldn't appear for md devices but for
> > some very boring reasons it does.
> 
> But read_ahead for md0 is in the queue directory:
> 
> /sys/block/md0/queue/read_ahead_kb

True - but it shouldn't be.  read_ahead has nothing to do with 
the queue.  
   /sys/block/md0/bdi/read_ahead_kb
is (in my mind) the more natural way to access that information.
Actually it should be

   /sys/class/block/md0/bdi/read_ahead_kb

but that is a little off-topic.

> 
> I know you said read_ahead is irrelevant for the individual disk
> devices like sdb, but I thought it was implied the read_ahead for md0
> is significant.
> 

NeilBrown
