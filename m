From: Neil Brown <neilb@suse.de>
Subject: Re: Raid5 reads and cpu
Date: Mon, 4 Sep 2006 16:08:37 +1000
Message-ID: <17659.49893.62949.263198@cse.unsw.edu.au>
References: <1436.68.254.47.18.1156790025.squirrel@bymeinc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Rob Bray on Monday August 28
Sender: linux-raid-owner@vger.kernel.org
To: Rob Bray <raid@bymeinc.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday August 28, raid@bymeinc.com wrote:
> This might be a dumb question, but what causes md to use a large amount of
> cpu resources when reading a large amount of data from a raid1 array?

I assume you meant raid5 there.

md/raid5 shouldn't use that much CPU when reading.
It does use more than raid0 as it reads data in the stripe-cache and
then copies the data from the stripe cache into the read-buffer.  But
I wouldn't expect that to come anywhere near 50%.

Are you really seeing 'raid5d' using 50% of CPU in 'top' or similar?

NeilBrown


> Examples are on a 2.4GHz AMD64, 2GB, 2.6.15.1 (I realize there are md
> enhancements to later versions; I had some other unrelated issues and
> rolled back to one I've run on for several months).
> 
> A given 7-disk raid0 array can read 450MB/s (using cat > null) and use
> virtually no CPU resources. (Although cat and kswapd use quite a bit [60%]
> munching on the data)
> 
> A raid5 array on the same drive set pulls in at 250MB/s, but md uses
> roughly 50% of the CPU (the other 50% is spent dealing with the data,
> saturating the processor).
> 
> A consistency check on the raid5 array uses roughly 3% of the cpu. It is
> otherwise ~97% idle.
> md11 : active raid5 sdi2[5] sdh2[4] sdf2[3] sde2[2] sdd2[1] sdc2[6] sdb2[0]
>       248974848 blocks level 5, 256k chunk, algorithm 2 [7/7] [UUUUUUU]
>       [==============>......]  resync = 72.2% (29976960/41495808)
> finish=3.7min speed=51460K/sec
> (~350MB/s aggregate throughput, 50MB/s on each device)
> 
> Just a friendly question as to why CPU utilization is significantly
> different between a check and a real-world read on raid5? I feel like if
> there was vm overhead getting the data into userland, the slowdown would
> be present in raid0 as well. I assume parity calculations aren't done on a
> read of the array, which leaves me at my question.
> 
> Thanks,
> Rob
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
VGER BF report: U 0.5
