From: Coly Li <colyli@suse.de>
Subject: Re: [MD PATCH 1/1] Don't add nr_pending for resync requests
Date: Wed, 26 Apr 2017 16:40:20 +0800
Message-ID: <599ae320-3375-8bd6-f1cd-4091ecc0a529@suse.de>
References: <1493023635-5652-1-git-send-email-xni@redhat.com>
 <20170425171034.peeh6uuvwycqtise@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170425171034.peeh6uuvwycqtise@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, ncroxon@redhat.com, neilb@suse.com
List-Id: linux-raid.ids

On 2017/4/26 上午1:10, Shaohua Li wrote:
> Hi,
> Cc: Coly and Neil.
> 
> On Mon, Apr 24, 2017 at 04:47:15PM +0800, Xiao Ni wrote:
>> In newer barrier codes, raise_barrier waits if conf->nr_pending[idx] is not zero.
>> After all the conditions are true, the resync request can go on be handling. But
>> it adds conf->nr_pending[idx] again. The next resync request hit the same bucket
>> idx need to wait the resync request which is submitted before. The performance
>> of resync/recovery is degraded.
>>
>> I did some tests:
>> 1. Before removing the codes, the resync performance is:
>> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
>> sdc               0.00     0.00    0.00  164.00     0.00    10.13   126.46     0.95    5.80    0.00    5.80   5.82  95.40
>> sdb               0.00     0.00  163.00    2.00    10.19     0.00   126.47     0.04    0.25    0.18    5.50   0.25   4.10
>> 2. After removing the codes, the resync performance is:
>> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
>> sdc               0.00  2164.00    0.00  751.00     0.00   182.06   496.49     7.49    9.95    0.00    9.95   1.33 100.00
>> sdb            2162.00     0.00  752.00    0.00   182.25     0.00   496.34     0.56    0.74    0.74    0.00   0.65  48.80
> 
> A big resync regression, thanks to check it! Your analysis makes sense to me,
> but the patch doesn't. freeze_array() depends on nr_pending to wait for all
> normal IO and resync. This change will make the wait for resync disappear.
> 
> I think the problem is we are abusing nr_pending here. freeze_array() waits for
> a condition which doesn't need to be maintained by nr_pending. It makes sense
> raise_barrier to wait for nr_pending caused by normal IO, but it doesn't make
> sense to wait for other raise_barrier.
> 
> We could add another vairable, increase it in raise_barrier, decrease it in
> lower_barrier and let freeze_array() check the new variable. That should fix
> the problem and not expose race condition for freeze_array().

Shaohua,

Adding another variable to recode pending resync I/O is good idea. We
can do something like this,

@@ -869,7 +869,7 @@ static void raise_barrier()

-       atomic_inc(&conf->nr_pending[idx]);
+       atomic_inc(&conf->nr_resync_pending[idx]);
        spin_unlock_irq(&conf->resync_lock);
 }

@@ -880,7 +880,7 @@ static void lower_barrier()

        atomic_dec(&conf->barrier[idx]);
-       atomic_dec(&conf->nr_pending[idx]);
+       atomic_dec(&conf->nr_resync_pending[idx]);
        wake_up(&conf->wait_barrier);
 }

@@ -1018,7 +1018,8 @@ static int get_unqueued_pending()
        int idx, ret;

        for (ret = 0, idx = 0; idx < BARRIER_BUCKETS_NR; idx++)
-               ret += atomic_read(&conf->nr_pending[idx]) -
+               ret += atomic_read(&conf->nr_pending[idx]) +
+                       atomic_read(&conf->nr_resync_pending[idx]) -
                        atomic_read(&conf->nr_queued[idx]);

        return ret;

Xiao,

Nice catch! From your email, it seems resync request on raid1 device can
be non-linear, otherwise, it won't hit same barrier bucket by different
resync I/O to raise barrier. This is some thing I don't know. Thank you !

The reason to increase conf->nr_pending[idx] is from 'commit 34e97f17
("md/raid1: count resync requests in nr_pending.")', because normal I/O
and resync I/O can happen at same time on same raid1 device. And both of
them can be queued by reschedule_retry(), raise_barrier() need to
increase conf->nr_pending[idx] to make sure pending I/Os will be equal
to queued I/Os when array is frozen. We cannot remove
conf->nr_pending[idx] operations from raise_barrier()/lower_barrier().

Would you like to compose a patch by Shaohua's suggestion ?

Thanks.

Coly Li
