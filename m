From: Nate Dailey <nate.dailey@stratus.com>
Subject: Re: raid1: freeze_array/wait_all_barriers deadlock
Date: Mon, 16 Oct 2017 11:34:37 -0400
Message-ID: <51f41b85-6945-4893-c9ce-acc23ffe5671@stratus.com>
References: <2e2fb33a-12a6-763a-bd8e-8dc4aa05fc13@stratus.com>
 <c63d6d36-b155-2e47-8b0d-d03d0916f410@suse.de>
 <45dc8dda-0a3a-4a99-34ea-5d52f868480d@stratus.com>
 <0763376f-0929-122d-426c-ae4934972aab@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0763376f-0929-122d-426c-ae4934972aab@suse.de>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Coly, I'm not 100% sure that's going to work.

What I'm imagining is that close_sync gets the lock, so now 
raid1d/handle_read_error/freeze_array is blocked waiting for it.

Is it possible that raid1d might need to complete some sync IO from the 
retry_list, that close_sync/wait_all_barriers is waiting for? In that case, 
there would still be a deadlock.

Actually, what if close_sync just did this:

static void close_sync(struct r1conf *conf)
{
         int idx;

         for (idx = 0; idx < BARRIER_BUCKETS_NR; idx++) {
                 _wait_barrier(conf, idx);
                 _allow_barrier(conf, idx);
         }
...

Is there any reason all the _wait_barriers have to complete before starting on 
_allow_barrier? If not, then I think this change would work (but will think 
about it more).

Nate



On 10/16/2017 10:43 AM, Coly Li wrote:
> On 2017/10/16 下午8:58, Nate Dailey wrote:
>> Hi Coly, I'm not sure I understand the change you're proposing. Would it
>> be something like the following?
>>
>>          spin_lock_irq(&conf->resync_lock);
>>          conf->array_frozen = 1;
>>          raid1_log(conf->mddev, "wait freeze");
>>          while (get_unqueued_pending(conf) != extra) {
>>              wait_event_lock_irq_cmd_timeout(
>>                  conf->wait_barrier,
>>                  get_unqueued_pending(conf) == extra,
>>                  conf->resync_lock,
>>                  flush_pending_writes(conf),
>>                  timeout);
>>          }
>>          spin_unlock_irq(&conf->resync_lock);
>>
>> On its own, I don't see how this would make any difference. Until
>> array_frozen == 0, wait_all_barriers will continue to be blocked, which
>> in turn will prevent the condition freeze_array is waiting on from ever
>> becoming true.
> Hi Nate,
>
> You are right, this idea does not help too much, we need to find another
> way.
>
>> Or should something else be done inside the new freeze_array loop that
>> would allow wait_all_barriers to make progress?
> It seems wait_all_barriers() is only used in close_sync(), which is to
> make sure all sync requests hit platters before raid1_sync_request()
> returns.
>
> How about setting a critical section in close_sync() and protected by
> another lock. It might be something like this,
>
> static void close_sync(struct r1conf *conf)
> {
> +	mutex_lock close_sync_lock;
>          wait_all_barriers(conf);
> +	mutex_unlock close_sync_lock;
>          allow_all_barriers(conf);
> 	[snip]
> }
>
>
> static void freeze_array(struct r1conf *conf, int extra)
> {
> +	mutex_lock close_sync_lock
>          spin_lock_irq(&conf->resync_lock);
> 	[snip]
>          spin_unlock_irq(&conf->resync_lock);
> +	mutex_unlock close_sync_lock
> }
>
> Then conf->array_frozen won't be set when wait_all_barriers() partially
> iterated on barrier buckets. Then a deadlock can be avoided.
>
> How do you think of this one ?
>
> Thanks.
>
> Coly Li
>
>
> [snip]
>

