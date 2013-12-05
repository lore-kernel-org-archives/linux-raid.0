From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: RAID-0/5/6 performances
Date: Thu, 5 Dec 2013 23:29:22 +0100
Message-ID: <20131205222922.GA8000@lazy.lzy>
References: <20131205192454.GA5695@lazy.lzy>
 <20131206085712.0dfe8b6e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131206085712.0dfe8b6e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Dec 06, 2013 at 08:57:12AM +1100, NeilBrown wrote:
> On Thu, 5 Dec 2013 20:24:54 +0100 Piergiorgio Sartor
> <piergiorgio.sartor@nexgo.de> wrote:
> 
> > Hi all,
> > 
> > I've a system, with an LSI 2308 SAS controller
> > and 5 2.5" HDD attached.
> > Each HDD can do around 100MB/sec read/write.
> > This was tested will all HDDs in parallel, to
> > make sure the controller can sustain them.
> > Single disk has same performance.
> > 
> > I was testing RAID 0/5/6 perfomances and I found
> > something I could not clearly understand.
> > 
> > The test was done with "dd", I wanted to know the
> > maximum possible performance.
> > Specifically, for reading:
> > 
> > dd if=/dev/md127 of=/dev/null bs=4k
> > 
> > For writing:
> > 
> > dd if=/dev/zero of=/dev/md127 bs=4k conv=fdatasync
> > 
> > Note than large block size did not change the
> > results. I guess the page size is quite optimal.
> > 
> > I tested each RAID with 4 and 5 HDDs, with chunk
> > size of 512k, 64k and 16k.
> > The "stripe_cache_size" was set to the max 32768.
> > 
> > The results were observed with "iostat -k 5",
> > taking care to consider variations and ramp up.
> > 
> > The table, with MB/sec, the number are the HDDs
> > the "r" is read, "w" is write:
> > 
> > chunk RAID 4r  4w  5r  5w
> > 512k   0   400 400 500 500
> > 512k   5   260 300 360 400
> > 512k   6    55 180 100 290
> > 
> >  64k   0   400 400 440 500
> >  64k   5   150 300 160 400
> >  64k   6   100 180 140 290
> > 
> >  16k   0   380 400 350 500
> >  16k   5   100 300 130 390
> >  16k   6    80 180 100 290
> > 
> > Now, RAID-0/5 seem to perform as expected,
> > depending on the number of HDDs. Expecially
> > with large chunk size.
> > Write performances are not a problem, even
> > if those are CPU intensive, with parity RAID.
> > RAID-0/5 do not react well with small chunk.
> > RAID-6, on the other hand, seems to have an
> > idea of its own.
> > First of all, it does not seem to respect
> > proportionality. I would think a 4 HDDs
> > RAID-6 should more or less read as fast as
> > 2 HDDs. I can understand some loss, due to
> > the parity skip, but not so much. In fact it
> > improves with smaller chunk.
> > With 5 HDDs, I would expect something better
> > than 100MB/sec.
> > 
> > Any idea on this? Am I doing something wrong?
> > Some suggestion on tuning something in order
> > to try to improve RAID-6?
> > 
> > Thanks,
> > 
> > bye,
> > 
> 
> Does look strange.
> First thing I would check is the read-ahead size.
> md sets it for you but might be messing up some how.
> Have a look at 
>    /sys/block/mdX/bdi/read_ahead_kb
> for each configuration and see if making it some uniform large number has any
> effect.

Hi Neil,

thanks for the hint, I knew I needed _the_ expert :-)

Using a chunk of 64k (best of the table above), with
5 HDDs RAID-6, the default read_ahead_kb is 384.
I tried to increase it, with following improvement:

read_ahead_kb 5r
1024    -->   200MB/sec
4096    -->   300MB/sec
8192    -->   310MB/sec
32768   -->   310MB/sec

So, it seems that between 4k and 8k the max is reached,
which is somehow what I would expect for a 5 HDDs RAID-6.

I'll try (tomorrow) with different chunk to see what changes.

In any case, 384 seems a bit too little. Maybe 5 HDDs are
not a real RAID-6 use case, I do not know.

Thanks again,

bye,

pg

-- 

piergiorgio
