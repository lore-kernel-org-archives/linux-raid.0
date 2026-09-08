Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5F85803A6
	for <linux-raid@vger.kernel.org>; Tue,  8 Sep 2026 18:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788892686; cv=none; b=hVP8dFrnqTSK3mk47UZiQa/cRsLq7KjgSA6dp8Mok0wBq87tA1OkZRz3SKTn0cDxeobsgApGVLWd3WZnDdllAhyURVJnNHgVVWdtDtz/1ZYO5h1CCqKz4/6WSzgrqghA9YKPoVbPw2OIQKluWpqS+IrhcMdHcDY4koJMbZimevo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788892686; c=relaxed/simple;
	bh=6e+ja0OsGfPRUab28A9NuLrTEt2T8q02pzK8To+hlK0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=RnVj4yBfhY/gBVR8Nv7hc6+ziGzEcLgKqA1+w0KtwnjNUshTrVqges5sdXQZJScdldOait8CcskcIyQ/TMzeLD/Y8HS5+aj3CLaErsj4dz5wcwfLXd6f3Tbkqi6QWHa4LUcYJvY9halBGttkDLZVkneBUkoEI82I94ir0gq55s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wqck4ncx; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wqck4ncx"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-49cf4f81d86so39237235e9.2
        for <linux-raid@vger.kernel.org>; Tue, 08 Sep 2026 11:38:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788892680; x=1789497480; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bbL8mdieOnIioHRce66Hp7mnAaFodvIyUSH93OTUvqw=;
        b=Wqck4ncx+2VR9gsRdT5KVLWr7Hd0PQPGyZzr7L8UAAC6iSwj6SLxT+g/cDJCgBJ9uF
         CJeHpF3nsqPvmAsVO9xqG5ANoma/7EbOuDaXqdK3JNwQuwSgNQnDkx3adcQF0BQQsyWa
         Vk1uzaTdVwNemRJrCstnSZnLDgjAT5sZWkpUURFeG5/Y0I02bRUEy3XrxQKo5YdknAiB
         a+VKYGzvCHhFQ2UpWDQwQildTfMUMfC2w1bvjT64DmLWUzGY5OdKckInHnv0amCpcmeu
         aXBzGbPpMU5EGfOl1afuA+gQJbpe33I1eGEJtWusbI2Xe837Zn9oOTu5QOHOPLDTSLcK
         0dWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788892680; x=1789497480;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :references:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bbL8mdieOnIioHRce66Hp7mnAaFodvIyUSH93OTUvqw=;
        b=Yy45n+FTGTzJo68lAibiCGO2ATeedkFKdLkKnTmnhYUtIhdcehufaTRBMOFgGBvlry
         UlpAluTJL/NzALwgkzGd/+5Iy5TPW+rxl7jHqCicvkuxVdPPGPmR9D/g7WcuK1+Kk6Ic
         M5E7T4JAuHYIIe6XJSH3g6KlQ1mjGiEbQVF5vOO5f+4+NoGziaP1jqpegcFC2Ez34oRk
         scFdhAfFJpv4bKmtrvRxGMG6iXHEyesutrvp1oEt81J8yb/buE16JqppeQ3BJn7F74Vr
         exsWd0cnJxTwAMryzxTbRxlaCPOTLn8bREdshiYJUeCuJ70Fpxg28XiGAiCGHKDynIHD
         B9Pg==
X-Gm-Message-State: AFuF++lhNrnp2O6ua/B+N4xU4o38hAx5DwJ4Ikj5G875mwoGvHZB0k+3
	QXOm1oHkEsftwbsAWO6Y1AQAYo7CL1d6fH2meBjfcKkWZIUUm0qCHCfk
X-Gm-Gg: AYBFou1pc3N3GwQ+Q3lFINqE04rGqahHveTgab6JxHR3aC4F0OvloD4ZLFMlVv5ggKZ
	u4j08HffIqnYBJmiFZVsDHm6AmufIY84BZK5/0HRcQbWK1yb2onjCCX3hMC4mV1I29WADc65x7w
	Sg95gKdzXEA4RS9jHyILykOiL4pce0T6tsfFq3HflMW9R9RrjAIeOYc1fhs4U9wlP1pfxKgs1lm
	vtmK/SLi8dyj6bQMuwmubbtn808z6Jj2qaNiSUIx5jwKBUfptmWwd9huGmh1eWndOPiuuB/Kflx
	qROByIjYyZy1XB+xm09tuQ+MX628K3lWTzWh8xO4oq26Oo9Mb3p2R5yWWpmIM18ZlZKAqLjbP+U
	9fc7GKPV4uxZ+Y4XhyjZ7i3WLqTCz04RreW7Kf0l1r8j9Sb2Kz0knhKuZ3tBt5Ko5nBnpc6zPxI
	gxv/gx7KI1PYGJ5V75mUuRPXqzrEugEQBCpJy7XvTu9QSMVWCY6XXvpH6S/nX/3x0m3HwWCUoJ/
	5HLKbT86M961RXzoQWBjDQ/SIYfOETD
X-Received: by 2002:a05:600c:4585:b0:49c:fc6c:be16 with SMTP id 5b1f17b1804b1-49cfea09f08mr260839935e9.28.1788892679712;
        Tue, 08 Sep 2026 11:37:59 -0700 (PDT)
Received: from Abds-MacBook-Air.local ([2a02:3037:27d:11c4:e998:7531:be5e:1dcd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-485885b1320sm36974805f8f.27.2026.09.08.11.37.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 11:37:59 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: Jinpu Wang <jinpu.wang@cloud.ionos.com>, Nilay Shroff <nilay@linux.ibm.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, linux-block
 <linux-block@vger.kernel.org>, Song Liu <song@kernel.org>, Jens Axboe
 <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Damien Le Moal
 <dlemoal@kernel.org>, Yu Kuai <yukuai@fygo.io>, tom.leiming@gmail.com
Subject: Re: [PATCH 0/6] md: don't wait for q->limits_lock while md holds
 back I/O
In-Reply-To: <CAMGffEmKrqcxYAtdTxg6GnwwFjJJg50wxpTfBobps-_QwQAoGg@mail.gmail.com>
References: <20260907133929.1081540-1-jinpu.wang@ionos.com>
 <e6ad5b61-0ba2-49fa-96c7-e821defe45a7@linux.ibm.com>
 <CAMGffEmKrqcxYAtdTxg6GnwwFjJJg50wxpTfBobps-_QwQAoGg@mail.gmail.com>
Date: Tue, 08 Sep 2026 20:37:56 +0200
Message-ID: <m2bja7612z.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


Hi Jack and Nilay,

On Tue, Sep 08, 2026 at 14:09 +0200, Jinpu Wang wrote:
> On Tue, Sep 8, 2026 at 1:16=E2=80=AFPM Nilay Shroff <nilay@linux.ibm.com>=
 wrote:
>>
>> On 9/7/26 7:09 PM, Jack Wang wrote:
>> > From: Jack Wang<jinpu.wang@cloud.ionos.com>
>> >
>> > Writing to a queue limits attribute of an md array while a spare is
>> > being re-added deadlocks the array.  I reported this earlier here:
>> >
>> >    https://lore.kernel.org/linux-raid/CAMGffE=3DheGA3y8FjQ0Sm1jj-kd-=
=3DH9Y54WozKASSEZhc9UNKjA@mail.gmail.com/
>> >
>> > Four tasks, one array:
>> >
>> >    udev-worker    queue_attr_store() holds q->limits_lock, waits in
>> >                   blk_mq_freeze_queue() for q_usage_counter to drain
>> >    fio            holds a q_usage_counter reference, parked in
>> >                   md_handle_request()'s is_suspended() loop
>> >    mdadm          suspended the array, waits for reconfig_mutex
>> >    md_start_sync  holds reconfig_mutex, waits for q->limits_lock
>> >
>> > The last leg is mddev_stack_new_rdev() from ->hot_add_disk().  Since
>> > commit c99f66e4084a ("block: fix queue freeze vs limits lock order in
>> > sysfs store methods") the sysfs store holds q->limits_lock across the
>> > freeze, so md must not block on that lock while it is holding back the
>> > I/O the freeze waits for.  That is the same hazard mddev_suspend()
>> > already documents for reconfig_mutex.
>> >
>> > The rule this series applies is that q->limits_lock nests outside both
>> > reconfig_mutex and the suspend.  Where md cannot arrange that, because
>> > it is called with reconfig_mutex already held or from the sync thread,
>> > it takes the update with a trylock and does without one on a contended
>> > pass.
>> >
>> > Patches 1, 2 and 4 are plumbing with no functional change.  Patches 3
>> > and 5 convert the two callers that cannot own an update.  Patch 6 does
>> > the hoists, all in one patch because a mix of the two lock orders is an
>> > ABBA.
>> >
>> > Two callers still take q->limits_lock inside reconfig_mutex, both with
>> > the array suspended, and patch 6 says why: ->start_reshape() from
>> > action_store(), which suspends before flushing sync_work, and
>> > raid*_run() -> queue_limits_set() from level_store(), which already
>> > hangs on its own because it freezes the queue while suspended.  Both
>> > need more restructuring than belongs here.
>> >
>> > The patches are based on v7.3-rc2.
>> >
>> > Tested there with a raid1 of two ram devices, fio in flight and a loop
>> > writing queue/max_sectors_kb: 20 fail/remove/add cycles complete,
>> > where the same test wedges the array before the series.  Every patch
>> > builds on its own.  A reshape and a level change are not covered by th=
at
>> > test.
>>
>> Overall, I think the direction looks good. With this series, we now have=
 the
>> locking order where q->limits_lock is acquired before the suspend and
>> reconfig_mutex.
>>
>> However, when I ran these changes through blktests, I hit the lockdep sp=
lat[1],
>> which exposes an ABBA dependency between disk->open_mutex and q->limits_=
lock.
>>
>> Looking at the existing dependency chain, disk->open_mutex is expected to
>> be acquired before q->limits_lock. However, with this change, md_ioctl()
>> acquires q->limits_lock first and subsequently reaches md_import_device(=
),
>> which acquires disk->open_mutex. This reverses the existing lock ordering
>> and introduces the ABBA dependency, so I think this needs to be addresse=
d.
>>
>
> Thanks for running this through blktests.
>
> You are right, and it is worse than the one path you hit.  The import is
> not the only offender: everything in the mddev->pers branch of
> md_add_new_disk() that opens or closes a component device runs with
> q->limits_lock held.  Besides md_import_device() there are four
> export_rdev() calls and one md_kick_rdev_from_array(), and export_rdev()
> ends in fput(rdev->bdev_file), so it takes disk->open_mutex too.
> rdev_attr_store() looks like a second instance: it starts the update for
> every state_store() write, and "remove" reaches
> md_kick_rdev_from_array().
>
> So the rule needs to be stronger than what I wrote: q->limits_lock nests
> outside reconfig_mutex and the suspend, and must not be held across any
> component device open or close.
>
> Two ways to get there, and I would rather hear which you prefer before
> respinning:
>
> 1) Keep the lock outermost, move the open and close out from under it.
>    md_ioctl() imports before taking q->limits_lock and releases after
>    committing and unlocking; md_add_new_disk() hands the rdev back
>    instead of exporting it.  The import then runs without
>    reconfig_mutex, so the superblock format fields need a snapshot and a
>    recheck under the lock.  Only the mddev->pers branch needs this, the
>    other two never reach add_bound_rdev().
>
> 2) Drop the hoist for ADD_NEW_DISK and stack the leg after resume, with
>    q->limits_lock on its own.  Much smaller, but the leg is live before
>    its limits are stacked and the integrity rejection lands after the
>    add rather than before it.
>
I am thinking about changeing the order of reconfig_mutex and the
suspention. we would suspend the array inside raid1_add_disk()
and raid1_remove_disk() when we add/remove the rdev from raid1 conf.

> Is there a better option?  If ->hot_add_disk() is meant to be callable
> with an update already in flight, that limits how far the open and close
> can move.
>
> Thanks,
> Jack

--=20
Best Regards,
Abd-Alrhman
