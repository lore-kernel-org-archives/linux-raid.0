Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7940935A28A;
	Mon, 18 Aug 2025 15:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755532581; cv=none; b=vFFfMy9RskUWY3xy1TeYXGAmtn1l7VCO/ow4h9wRmgYrExdltwkIhLupDFD/hK8xoLzJkqzEnz+IdcSLhdqDHSWOxd5n9un8qwxdWgYa8/wxr90utCl4SC61i4kz/DIuQGGQWkcV7Odx71Ukx7Yd2yAJBwXDzAH4VdPhAolLgSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755532581; c=relaxed/simple;
	bh=5wFwh3p20P5/Jg2Ui6lOZbe2fHtyQ444SI9HF/NknyI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g1jNg/Kug0IxKwKQkO/vCk7OVRlq8VheTKFbz740lTvZXXcGKnksEQ7X5E3k952mxtIIgD1MtbOWRkNmxSKiq6d6Bl/ToBIWnKaG0L8ZEyxvmf1dJszPSsKMX3j/nspkk4TrT6yMUmcmwPuWvuU7mcho0yexq0/e6Gw6+xwBGRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KVIqnhJx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KVIqnhJx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22A57C4CEF1;
	Mon, 18 Aug 2025 15:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755532581;
	bh=5wFwh3p20P5/Jg2Ui6lOZbe2fHtyQ444SI9HF/NknyI=;
	h=Date:Reply-To:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KVIqnhJxRfk9+4Oag66JBDeOsYde9p4DeHvnqL00/rkVmbOE5FyC0sEMmC5pMjwMs
	 Ru8ridbyGmDV8oROz9MYIQDRh71Gvo/uGc5oGN8HKzudTi8LTZ706ZUFYLtcGjAFj2
	 rxQNEVqCSspNbVmrQcXHf3KAvoypssPHLdkK1EySDG0UCvZpEPVuup+CtqzXBcVob3
	 Z4+dZicsDP79GTVK0o0DPO+ggImVL5/R2JhvSU/KDFrEmhh5W0ibQjez6pTS53TbmJ
	 aJgtxXjrLXsChcSxuUFs97GtZpLdIxaAMY2Kv2ZIlgIqoFwVvJO/4hPLUNw5bRvwYL
	 9iw4uqNWl5j3g==
Message-ID: <f2dbf110-e2a7-4101-b24c-0444f708fd4e@kernel.org>
Date: Mon, 18 Aug 2025 23:56:19 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@kernel.org
Subject: Re: [PATCH] md/raid5-ppl: Fix invalid context sleep in
 ppl_io_unit_finished() on PREEMPT_RT
To: Yunseong Kim <ysk@kzalloc.com>, Yu Kuai <yukuai1@huaweicloud.com>,
 Song Liu <song@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
 linux-raid@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20250817113114.1335810-3-ysk@kzalloc.com>
 <acd0a040-18ce-05f5-4896-ad24dda6fb00@huaweicloud.com>
 <6450c5b4-b3cf-490f-ba7e-6201669829d9@kzalloc.com>
Content-Language: en-US
From: Yu Kuai <yukuai@kernel.org>
In-Reply-To: <6450c5b4-b3cf-490f-ba7e-6201669829d9@kzalloc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

在 2025/8/18 19:54, Yunseong Kim 写道:
> Hi Yu,
>
> On 8/18/25 9:56 AM, Yu Kuai wrote:
>> Hi,
>>
>> 在 2025/08/17 19:31, Yunseong Kim 写道:
>>> The function ppl_io_unit_finished() uses a local_irq_save()/spin_lock()
>>> sequence. On a PREEMPT_RT enabled kernel, spin_lock() can sleep. Calling it
>>> with interrupts disabled creates an atomic context where sleeping is
>>> forbidden.
>>>
>> What? I believe spin_lock can never sleep.
> I think you might have been a bit surprised by me sending a patch out of
> the blue. It would be helpful to refer to the references below:
>
>   On PREEMPT_RT kernels, these lock types are converted to sleeping locks:
>    local_lock
>    spinlock_t
>    rwlock_t
>
> Link: https://docs.kernel.org/locking/locktypes.html#sleeping-locks
>
>>> Ensuring that the interrupt state is managed atomically with the lock
>>> itself. The change is applied to both the 'log->io_list_lock' and
>>> 'ppl_conf->no_mem_stripes_lock' critical sections within the function.
>>>
>>> Signed-off-by: Yunseong Kim <ysk@kzalloc.com>
>>> ---
>>>    drivers/md/raid5-ppl.c | 12 ++++--------
>>>    1 file changed, 4 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
>>> index 56b234683ee6..650bd59ead72 100644
>>> --- a/drivers/md/raid5-ppl.c
>>> +++ b/drivers/md/raid5-ppl.c
>>> @@ -553,15 +553,13 @@ static void ppl_io_unit_finished(struct ppl_io_unit *io)
>>>          pr_debug("%s: seq: %llu\n", __func__, io->seq);
>>>    -    local_irq_save(flags);
>>> -
>>> -    spin_lock(&log->io_list_lock);
>>> +    spin_lock_irqsave(&log->io_list_lock, flags);
>   The changes in spinlock_t and rwlock_t semantics on PREEMPT_RT kernels
>   have a few implications. For example, on a non-PREEMPT_RT kernel the
>   following code sequence works as expected:
>
>   local_irq_disable();
>   spin_lock(&lock);
>   
>   and is fully equivalent to:
>   
>   spin_lock_irq(&lock);
>   
>   Same applies to rwlock_t and the _irqsave() suffix variants.
>
> Link: https://docs.kernel.org/locking/locktypes.html#spinlock-t-and-rwlock-t

Yes, lessons are learned. Perhaps add a link tag in the commit message
just in case someone else will be confused?

Thanks,
Kuai

>
>>>        list_del(&io->log_sibling);
>>> -    spin_unlock(&log->io_list_lock);
>>> +    spin_unlock_irqrestore(&log->io_list_lock, flags);
>>>          mempool_free(io, &ppl_conf->io_pool);
>>>    -    spin_lock(&ppl_conf->no_mem_stripes_lock);
>>> +    spin_lock_irqsave(&ppl_conf->no_mem_stripes_lock, flags);
>> Please notice, local_irq_save + spin_lock is the same as
>> spin_lock_irqsave, I don't think your changes have any functonal
>> chagnes.
> This issue has also been a problem in other subsystems, such as USB:
>
> [BUG] usb: gadget: dummy_hcd: Sleeping function called from invalid
> context in dummy_dequeue on PREEMPT_RT
>
> Link: https://lore.kernel.org/lkml/20250816065933.EPwBJ0Sd@linutronix.de/t/#u
>
> I am currently contributing to the kernel to address the areas that need to
> adapt to this paradigm shift so that the PREEMPT_RT Linux kernel can be
> well supported. I have CC’d other RT people so they can also review
> this part.
>
>> Thanks,
>> Kuai
> Thank you!
>
> Yunseong
>
