From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH V3 2/2] RAID1: avoid unnecessary spin locks in I/O barrier
 code
Date: Sat, 18 Feb 2017 02:35:55 +0800
Message-ID: <27155d3f-6b88-6215-f080-aaafa41a7fe9@suse.de>
References: <1487176523-109075-1-git-send-email-colyli@suse.de>
 <1487176523-109075-2-git-send-email-colyli@suse.de>
 <87r32yvcoz.fsf@notabene.neil.brown.name>
 <58e7810c-16db-1c45-c981-63c36eb0b1c8@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <58e7810c-16db-1c45-c981-63c36eb0b1c8@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
Cc: Shaohua Li <shli@fb.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

On 2017/2/17 下午3:56, Coly Li wrote:
> On 2017/2/16 下午3:04, NeilBrown wrote:
>> On Thu, Feb 16 2017, colyli@suse.de wrote:
>>
>>> @@ -2393,6 +2455,11 @@ static void handle_write_finished(struct
>>> r1conf *conf, struct r1bio *r1_bio) idx =
>>> sector_to_idx(r1_bio->sector); conf->nr_queued[idx]++; 
>>> spin_unlock_irq(&conf->device_lock); +		/* +		 * In case
>>> freeze_array() is waiting for condition +		 *
>>> get_unqueued_pending() == extra to be true. +		 */ +
>>> wake_up(&conf->wait_barrier); 
>>> md_wakeup_thread(conf->mddev->thread); } else { if
>>> (test_bit(R1BIO_WriteError, &r1_bio->state)) @@ -2529,9 +2596,7
>>> @@ static void raid1d(struct md_thread *thread) retry_list); 
>>> list_del(&r1_bio->retry_list); idx =
>>> sector_to_idx(r1_bio->sector); -
>>> spin_lock_irqsave(&conf->device_lock, flags); 
>>> conf->nr_queued[idx]--; -
>>> spin_unlock_irqrestore(&conf->device_lock, flags);
>>
>> Why do you think it is safe to decrement nr_queued without holding
>> the lock? Surely this could race with handle_write_finished, and an
>> update could be lost.
> 
> conf->nr_queued[idx] is an integer and aligned to 4 bytes address, so
> conf->nr_queued[idx]++ is same to atomic_inc(&conf->nr_queued[idx]),
> it is atomic operation. And there is no ordering requirement, so I
> don't need memory barrier here. This is why I remove spin lock, and
> change it from atomic_t back to int.
> 
> 
> IMHO, the problematic location is not here, but in freeze_array(). Now
> the code assume array is froze when "get_unqueued_pending(conf) ==
> extra" gets true. I think it is incorrect.

Hmm, I am wrong here. conf->nr_queued[idx]++ is not atomic. Yes, it
should be atomic_t, I will fix it in next version.

Coly Li

