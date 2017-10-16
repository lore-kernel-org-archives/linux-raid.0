From: Coly Li <colyli@suse.de>
Subject: Re: raid1: freeze_array/wait_all_barriers deadlock
Date: Mon, 16 Oct 2017 22:43:14 +0800
Message-ID: <0763376f-0929-122d-426c-ae4934972aab@suse.de>
References: <2e2fb33a-12a6-763a-bd8e-8dc4aa05fc13@stratus.com>
 <c63d6d36-b155-2e47-8b0d-d03d0916f410@suse.de>
 <45dc8dda-0a3a-4a99-34ea-5d52f868480d@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45dc8dda-0a3a-4a99-34ea-5d52f868480d@stratus.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Nate Dailey <nate.dailey@stratus.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2017/10/16 下午8:58, Nate Dailey wrote:
> Hi Coly, I'm not sure I understand the change you're proposing. Would it
> be something like the following?
> 
>         spin_lock_irq(&conf->resync_lock);
>         conf->array_frozen = 1;
>         raid1_log(conf->mddev, "wait freeze");
>         while (get_unqueued_pending(conf) != extra) {
>             wait_event_lock_irq_cmd_timeout(
>                 conf->wait_barrier,
>                 get_unqueued_pending(conf) == extra,
>                 conf->resync_lock,
>                 flush_pending_writes(conf),
>                 timeout);
>         }
>         spin_unlock_irq(&conf->resync_lock);
> 
> On its own, I don't see how this would make any difference. Until
> array_frozen == 0, wait_all_barriers will continue to be blocked, which
> in turn will prevent the condition freeze_array is waiting on from ever
> becoming true.

Hi Nate,

You are right, this idea does not help too much, we need to find another
way.

> Or should something else be done inside the new freeze_array loop that
> would allow wait_all_barriers to make progress?

It seems wait_all_barriers() is only used in close_sync(), which is to
make sure all sync requests hit platters before raid1_sync_request()
returns.

How about setting a critical section in close_sync() and protected by
another lock. It might be something like this,

static void close_sync(struct r1conf *conf)
{
+	mutex_lock close_sync_lock;
        wait_all_barriers(conf);
+	mutex_unlock close_sync_lock;
        allow_all_barriers(conf);
	[snip]
}


static void freeze_array(struct r1conf *conf, int extra)
{
+	mutex_lock close_sync_lock
        spin_lock_irq(&conf->resync_lock);
	[snip]
        spin_unlock_irq(&conf->resync_lock);
+	mutex_unlock close_sync_lock
}

Then conf->array_frozen won't be set when wait_all_barriers() partially
iterated on barrier buckets. Then a deadlock can be avoided.

How do you think of this one ?

Thanks.

Coly Li


[snip]

