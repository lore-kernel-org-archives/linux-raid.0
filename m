From: Daniel Pittman <daniel@rimspace.net>
Subject: Re: Raid-0 speed
Date: Wed, 25 Aug 2004 16:09:51 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <87k6vneok0.fsf@enki.rimspace.net>
References: <412C1E23.1070104@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 25 Aug 2004, Brad Campbell wrote:
> As you would see I have a problem with libata drivers and raid-0.
> In the process of debugging this I have been doing some speed/throughput
> 	tests.
>
> On my machine, running 2 instances of dd in 2 terminals
> dd if=/dev/sdk of=/dev/null &
> dd if=/dev/sdl of=/dev/null
>
> I see over 100MB/s read from VMSTAT.
> If I pass the dd via pipebench to /dev/null I see between 50-60MB/s read speed
> 	from each drive
> simultaneously.
>
> With the raid-0 running, doing a dd if=/dev/md1 of=/dev/null I get about
> 	55MB/s read speed.
>
> I can't quite figure out why the md is so slow. Given its using
> streaming reads with no seeking it should be over 100MB/s.

Your chunk size is way to low to give good streaming reads.  The kernel
needs to switch between devices every 128 kilobytes, while is rather
low.

Try slowly pushing the chunk size to 16384 and see when your performance
gets back up to your expected level.

     Daniel
-- 
The propagandist's purpose is to make one set of people forget
that certain other sets of people are human.
        -- Aldous Huxley

