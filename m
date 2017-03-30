From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: RAID6 rebuild oddity
Date: Thu, 30 Mar 2017 09:22:40 +0800
Message-ID: <a8ad0de2-5cec-1e70-0fff-1df911a02932@fnarfbargle.com>
References: <9eb215dd-437e-ac62-c4df-f3307d8fc4b4@fnarfbargle.com>
 <87zig467z3.fsf@notabene.neil.brown.name>
 <5584b8b1-b4f1-0d2e-cbf3-f14b4127d031@fnarfbargle.com>
 <87wpb7612w.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87wpb7612w.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Linux-RAID <linux-raid@vger.kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

> NeilBrown
>
> This works for simple tests but might not be correct.
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index c523fd69a7bc..2eb45d57226c 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -3618,8 +3618,9 @@ static int fetch_block(struct stripe_head *sh, struct stripe_head_state *s,
>   		BUG_ON(test_bit(R5_Wantread, &dev->flags));
>   		BUG_ON(sh->batch_head);
>   		if ((s->uptodate == disks - 1) &&
> +		    ((sh->qd_idx >= 0 && sh->pd_idx == disk_idx) ||
>   		    (s->failed && (disk_idx == s->failed_num[0] ||
> -				   disk_idx == s->failed_num[1]))) {
> +				   disk_idx == s->failed_num[1])))) {
>   			/* have disk failed, and we're requested to fetch it;
>   			 * do compute it
>   			 */

G'day Neil,

Thanks for the in-depth analysis. I managed to follow most of it and 
when I get some time I'll get my head into the code and see if I can 
*really* follow along.

As I'm not particularly fussed about the integrity of the system in its 
current state, I patched the kernel, re-booted and kicked off the resync 
again.


Before patch :

brad@test:~$ cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md0 : active raid6 sdb[8] sdj[7] sdi[9] sdg[5] sdf[4] sde[3] sdd[2] sdc[1]
       35162348160 blocks super 1.2 level 6, 64k chunk, algorithm 2 
[8/7] [UUUUUU_U]
       [==============>......]  recovery = 72.0% (4222847296/5860391360) 
finish=541.6min speed=50382K/sec


avg-cpu:  %user   %nice %system %iowait  %steal   %idle
            1.32    0.00    7.02    1.37    0.00   90.29

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s 
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0.00    19.00   10.20   22.40   114.40   139.00 
15.55     0.52   15.95   26.27   11.25   5.03  16.40
sdb           16514.60     0.00  141.00    0.00 67860.00     0.00 
962.55     2.64   18.91   18.91    0.00   3.21  45.20
sdc           16514.60     0.00  140.60    0.00 67655.20     0.00 
962.38     2.06   14.77   14.77    0.00   2.79  39.20
sdd           16514.60     0.00  140.60    0.00 67655.20     0.00 
962.38     2.64   18.92   18.92    0.00   3.04  42.80
sde           16514.60     0.00  140.60    0.00 67655.20     0.00 
962.38     2.49   17.85   17.85    0.00   3.14  44.20
sdf           16514.60     0.00  140.60    0.00 67655.20     0.00 
962.38     2.24   16.05   16.05    0.00   2.86  40.20
sdg           18459.80     0.00  269.40    0.00 74772.00     0.00 
555.10    84.84  327.45  327.45    0.00   3.71 100.00
sdh               0.00    19.00    1.80   22.40    24.80   139.00 
13.54     0.25   10.17   10.00   10.18   5.87  14.20
sdi               0.00 16390.20    0.00  136.60     0.00 66138.40 
968.35     1.19    8.74    0.00    8.74   3.38  46.20
sdj           16514.40     0.00  140.80    0.00 67654.40     0.00 
961.00     2.25   16.11   16.11    0.00   2.86  40.20
md1               0.00     0.00    0.00    4.80     0.00 4.60     
1.92     0.00    0.00    0.00    0.00   0.00   0.00
md2               0.00     0.00   12.00   32.60   139.20   131.20 
12.13     0.00    0.00    0.00    0.00   0.00   0.00
md0               0.00     0.00    0.00    0.00     0.00 0.00     
0.00     0.00    0.00    0.00    0.00   0.00   0.00
dm-0              0.00     0.00    0.00    0.00     0.00 0.00     
0.00     0.00    0.00    0.00    0.00   0.00   0.00

After Patch :

root@test:~# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md0 : active raid6 sdb[8] sdj[7] sdi[9] sdg[5] sdf[4] sde[3] sdd[2] sdc[1]
       35162348160 blocks super 1.2 level 6, 64k chunk, algorithm 2 
[8/7] [UUUUUU_U]
       [==============>......]  recovery = 73.3% (4297641980/5860391360) 
finish=284.7min speed=91465K/sec


avg-cpu:  %user   %nice %system %iowait  %steal   %idle
            0.08    0.00    6.96    0.00    0.00   92.97

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s 
avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0.00     0.00    0.00    0.20     0.00 0.20     
2.00     0.00    0.00    0.00    0.00   0.00   0.00
sdb           28232.80     0.00  237.40    0.00 114502.40     0.00 
964.64     8.53   36.05   36.05    0.00   4.15  98.60
sdc           28232.80     0.00  236.00    0.00 113875.20     0.00 
965.04     1.21    5.13    5.13    0.00   1.77  41.80
sdd           28232.80     0.00  236.00    0.00 113875.20     0.00 
965.04     1.28    5.42    5.42    0.00   1.85  43.60
sde           28232.80     0.00  236.80    0.00 114195.20     0.00 
964.49     2.74   11.65   11.65    0.00   2.77  65.60
sdf           28232.80     0.00  236.00    0.00 113875.20     0.00 
965.04     1.56    6.63    6.63    0.00   2.14  50.60
sdg           28232.80     0.00  234.80    0.00 113273.60     0.00 
964.85     3.06   12.86   12.86    0.00   2.82  66.20
sdh               0.00     0.00    0.00    0.20     0.00 0.20     
2.00     0.00    0.00    0.00    0.00   0.00   0.00
sdi               0.00 28175.00    0.00  245.80     0.00 113683.20 
925.01     0.96    3.91    0.00    3.91   2.89  71.00
sdj           28232.80     0.00  236.00    0.00 113875.20     0.00 
965.04     1.53    6.50    6.50    0.00   2.07  48.80
md1               0.00     0.00    0.00    0.00     0.00 0.00     
0.00     0.00    0.00    0.00    0.00   0.00   0.00
md2               0.00     0.00    0.00    0.00     0.00 0.00     
0.00     0.00    0.00    0.00    0.00   0.00   0.00
md0               0.00     0.00    0.00    0.00     0.00 0.00     
0.00     0.00    0.00    0.00    0.00   0.00   0.00
dm-0              0.00     0.00    0.00    0.00     0.00 0.00     
0.00     0.00    0.00    0.00    0.00   0.00   0.00

So that has significantly increased the rebuild speed, as you would expect.


Regards,
Brad
-- 
Dolphins are so intelligent that within a few weeks they can
train Americans to stand at the edge of the pool and throw them
fish.

