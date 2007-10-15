From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: experiences with raid5: stripe_queue patches
Date: Mon, 15 Oct 2007 12:40:13 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0710151239570.382@p34.internal.lan>
References: <200710151703.10404.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200710151703.10404.bs@q-leap.de>
Sender: linux-raid-owner@vger.kernel.org
To: Bernd Schubert <bs@q-leap.de>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids



On Mon, 15 Oct 2007, Bernd Schubert wrote:

> Hi,
>
> in order to tune raid performance I did some benchmarks with and without the
> stripe queue patches. 2.6.22 is only for comparison to rule out other
> effects, e.g. the new scheduler, etc.
> It seems there is a regression with these patch regarding the re-write
> performance, as you can see its almost 50% of what it should be.
>
> write      re-write   read       re-read
> 480844.26  448723.48  707927.55  706075.02 (2.6.22 w/o SQ patches)
> 487069.47  232574.30  709038.28  707595.09 (2.6.23 with SQ patches)
> 469865.75  438649.88  711211.92  703229.00 (2.6.23 without SQ patches)
>
> Benchmark details:
>
> 3xraid5 over 4 partitions of the very same hardware raid (in the end thats
> raid65, raid6 in hardware and raid5 in software, we need to do that).
>
> chunk size: 8192
> stripe_cache_size: 8192 each
> readahead of the md*: 65535 (well actually it limits itself to 65528
> readahead of the underlying partitions: 16384
>
> filesystem: xfs
>
> Testsystem: 2 x Quadcore Xeon 1.86 GHz (E5320)
>
> An interesting effect to notice: Without these patches the pdflush daemons
> will take a lot of CPU time, with these patches, pdflush almost doesn't
> appear in the 'top' list.
>
> Actually we would prefer one single raid5 array, but then one single raid5
> thread will run with 100% CPU time leaving 7 CPUs idle state, the status of
> the hardware raid says its utilization is only at about 50% and we only see
> writes at about 200 MB/s.
> On the contrary, with 3 different software raid5 sets the i/o to the harware
> raid systems is the bottleneck.
>
> Is there any chance to parallize the raid5 code? I think almost everything is
> done in raid5.c make_request(), but the main loop there is spin_locked by
> prepare_to_wait(). Would it be possible not to lock this entire loop?
>
>
> Thanks,
> Bernd
>
> -- 
> Bernd Schubert
> Q-Leap Networks GmbH
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Excellent questions I look forward to reading this thread :)

Justin.
