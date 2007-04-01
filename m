From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: raid5 write performance
Date: Sun, 1 Apr 2007 16:08:12 -0700
Message-ID: <e9c3a7c20704011608lb1fcb55j628a7d1172812869@mail.gmail.com>
References: <5d96567b0607020702p25d66490i79445bac606e5210@mail.gmail.com>
	 <17576.18978.563672.656847@cse.unsw.edu.au>
	 <5d96567b0608130619w60d8d883q4ffbfefcf650ee82@mail.gmail.com>
	 <17650.29175.778076.964022@cse.unsw.edu.au>
	 <5d96567b0703301444j9b416c2nbc5ce27487eef5bc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5d96567b0703301444j9b416c2nbc5ce27487eef5bc@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Cc: Neil Brown <neilb@suse.de>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 3/30/07, Raz Ben-Jehuda(caro) <raziebe@gmail.com> wrote:
> Please see bellow.
>
> On 8/28/06, Neil Brown <neilb@suse.de> wrote:
> > On Sunday August 13, raziebe@gmail.com wrote:
> > > well ... me again
> > >
> > > Following your advice....
> > >
> > > I added a deadline for every WRITE stripe head when it is created.
> > > in raid5_activate_delayed i checked if deadline is expired and if not i am
> > > setting the sh to prereadactive mode as .
> > >
> > > This small fix ( and in few other places in the code) reduced the
> > > amount of reads
> > > to zero with dd but with no improvement to throghput. But with random access to
> > > the raid  ( buffers are aligned by the stripe width and with the size
> > > of stripe width )
> > > there is an improvement of at least 20 % .
> > >
> > > Problem is that a user must know what he is doing else there would be
> > > a reduction
> > > in performance if deadline line it too long (say 100 ms).
> >
> > So if I understand you correctly, you are delaying write requests to
> > partial stripes slightly (your 'deadline') and this is sometimes
> > giving you a 20% improvement ?
> >
> > I'm not surprised that you could get some improvement.  20% is quite
> > surprising.  It would be worth following through with this to make
> > that improvement generally available.
> >
> > As you say, picking a time in milliseconds is very error prone.  We
> > really need to come up with something more natural.
> > I had hopped that the 'unplug' infrastructure would provide the right
> > thing, but apparently not.  Maybe unplug is just being called too
> > often.
> >
> > I'll see if I can duplicate this myself and find out what is really
> > going on.
> >
> > Thanks for the report.
> >
> > NeilBrown
> >
>
> Neil Hello. I am sorry for this interval , I was assigned abruptly to
> a different project.
>
> 1.
>   I'd taken a look at the raid5 delay patch I have written a while
> ago. I ported it to 2.6.17 and tested it. it makes sounds of working
> and when used correctly it eliminates the reads penalty.
>
> 2. Benchmarks .
>     configuration:
>      I am testing a raid5 x 3 disks with 1MB chunk size.  IOs are
> synchronous and non-buffered(o_direct) , 2 MB in size and always
> aligned to the beginning of a stripe. kernel is 2.6.17. The
> stripe_delay was set to 10ms.
>
>  Attached is the simple_write code.
>
>          command :
>                simple_write /dev/md1 2048 0 1000
>                        simple_write raw writes (O_DIRECT) sequentially
> starting from offset zero 2048 kilobytes 1000 times.
>
> Benchmark Before patch
>
> sda            1848.00      8384.00     50992.00       8384      50992
> sdb            1995.00     12424.00     51008.00      12424      51008
> sdc            1698.00      8160.00     51000.00       8160      51000
> sdd               0.00         0.00         0.00          0          0
> md0               0.00         0.00         0.00          0          0
> md1             450.00         0.00    102400.00          0     102400
>
>
> Benchmark After patch
>
> sda             389.11         0.00    128530.69          0     129816
> sdb             381.19         0.00    129354.46          0     130648
> sdc             383.17         0.00    128530.69          0     129816
> sdd               0.00         0.00         0.00          0          0
> md0               0.00         0.00         0.00          0          0
> md1            1140.59         0.00    259548.51          0     262144
>
> As one can see , no additional reads were done. One can actually
> calculate  the raid's utilization: n-1/n * ( single disk throughput
> with 1M writes ) .
>
>
>       3.  The patch code.
>           Kernel tested above was 2.6.17. The patch is of 2.6.20.2
> because I have noticed a big code differences between 17 to 20.x .
> This patch was not tested on 2.6.20.2 but it is essentialy the same. I
> have not tested (yet) degraded mode or any other non-common pathes.
>
This is along the same lines of what I am working on, new cache
policies for raid5/6, so I want to give it a try as well.
Unfortunately gmail has mangled your patch.  Can you resend as an
attachment?

patch: **** malformed patch at line 10:
(&((conf)->stripe_hashtbl[((sect) >> STRIPE_SHIFT) & HASH_MASK]))

Thanks,
Dan
