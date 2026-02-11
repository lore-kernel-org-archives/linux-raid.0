Received: from sg-1-36.ptr.blmpb.com (sg-1-36.ptr.blmpb.com [118.26.132.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF1A3C465
	for <linux-raid@vger.kernel.org>; Wed, 11 Feb 2026 03:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770779874; cv=none; b=T3CKJdRb+fKlY3PN5DowYR0eCkscFWZMAJmXEp07DAeuqU+hxAnU8D0Jn2vhRAqRI5kxl55KaYMWDZeFRaWCSpdIRhWOKaJ1qyUL5vKo+/QrhrYQ+p0vvOlqpzcDsH/YLENW/m2W50Mh1KKJFMiQV08YyYB1+b3s3X1b85J6G7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770779874; c=relaxed/simple;
	bh=sDiXyhHu1qAUDfXRR+T2jCbxdP7eXH0ytddIeAWyBc8=;
	h=Content-Type:From:Subject:References:Date:Mime-Version:To:Cc:
	 Message-Id:In-Reply-To; b=vFXbZPQQ4zbLn0wcI5K/+8zV7lG5WUm89kOw+TIKR5DYT1FH3iOonJhm8bGEMUxrcYJgDGzdK4rps1VgUFuyanmpHqkwh8jBrdp1z+MuoMUMFls0irRLkTlU0EZmeW8cvZmTqQvrfdMDJFXJl1xD3Jkx/4VPe2lKJtvEoLd4tE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=AzS8+Qsa; arc=none smtp.client-ip=118.26.132.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="AzS8+Qsa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1770779746;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=bP1mBCBbbwiGi5Ak1qFdG268/xvMANElKLVTFN0CvkI=;
 b=AzS8+QsaDmPO34RQ2ICfTW0uNN2Uw0KFrarbjOtO7ko1iqx2TtPEgNQeqnpjeo0hwyC00F
 vyurhUu6U55g9RjM9yt66UA370zmLZ0j5ySde0Csu5fJ0e/CSy7ppH3wUZNniO+BpU/Psc
 YyhMeG26c35AgouwmO4To819OyqYFPaC8AUJlWM0vSAuA1tC3FJJFtnJAGzy8dlM9tHkjZ
 VuAzOTbX9ZRahBEKtgt117lU3rG26mytYTAbHZPOHF+TjKywdm5XiB1azhVTwmdMfssiuG
 YahmcpMAU8isd3mT6+fACIRXaoIPfztj7BRwctQvrM8TzSUg6ddciu5d9dgsbQ==
Content-Type: text/plain; charset=UTF-8
X-Original-From: Yu Kuai <yukuai@fnnas.com>
From: "Yu Kuai" <yukuai@fnnas.com>
Subject: Re: [PATCH 2/2] md/raid1: serialize overlapped io for writemostly disk
Received: from [192.168.1.104] ([39.182.0.137]) by smtp.feishu.cn with ESMTPS; Wed, 11 Feb 2026 11:15:43 +0800
Content-Language: en-US
References: <20260206053826.37416-1-xni@redhat.com> <20260206053826.37416-3-xni@redhat.com> <9bd6581f-289a-4490-af6d-f15589446e1e@fnnas.com> <CALTww29NpmNbEb79KbVCX-rAF4o39rEd3-P1TjiDTc1OWpQiAw@mail.gmail.com>
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@fnnas.com
Date: Wed, 11 Feb 2026 11:15:42 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
To: "Xiao Ni" <xni@redhat.com>
Cc: <song@kernel.org>, <linux-raid@vger.kernel.org>, 
	<linan666@huaweicloud.com>, <yukuai@fnnas.com>
Message-Id: <a753611f-91ee-4cee-97c8-706154d1cade@fnnas.com>
X-Lms-Return-Path: <lba+2698bf460+d74054+vger.kernel.org+yukuai@fnnas.com>
In-Reply-To: <CALTww29NpmNbEb79KbVCX-rAF4o39rEd3-P1TjiDTc1OWpQiAw@mail.gmail.com>

Hi,

=E5=9C=A8 2026/2/11 10:44, Xiao Ni =E5=86=99=E9=81=93:
> On Wed, Feb 11, 2026 at 10:32=E2=80=AFAM Yu Kuai <yukuai@fnnas.com> wrote=
:
>> Hi,
>>
>> =E5=9C=A8 2026/2/6 13:38, Xiao Ni =E5=86=99=E9=81=93:
>>> In behind mode, overlap bios for writemostly device are queued. They
>>> In behind mode, bios which overlap the bio from the interval tree
>>> need to wait in waitqueue. Those bios will be handled once the in-tree
>>> bio finishes. They are waken up and try to get the tree lock. The bio
>>> which gets the lock will be handled. So the sequence can't be guarantee=
d.
>>>
>>> For example
>>> bio1(100,200)
>>> bio2(150,200)
>>> bio3(150,300)
>>> The write sequence of fast device is bio1,bio2,bio3. But the write
>>> sequence of slow device is bio1,bio3,bio2. This causes data corruption.
>>> Replace waitqueue with a fifo list to guarantee the write sequence.
>> To be honest, I think this is fine with the respect user won't send over=
lap
>> bios. In this case, bio1 is done in fast disk and pending in slow disk, =
then
>> bio2 will stuck while issuing and waiting for bio1 to return from slow d=
isk.
>> So send bio3 in this case is not expected, and if you do you can't guara=
ntee
>> the complete order from fast disk as bio2, bio3 as well.
> Hi Kuai
>
> In write behind mode, raid1 returns bio1 to the upper layer once the
> write on the fast disk finishes. The upper layer (app/filesystem)
> thinks that bio1 has finished, while the write of bio1 to the slow
> disk is still in progress. So bio2 will not be stuck while issuing, am
> I right? If so, bio2 can be submitted to raid1 once the write of bio1
> to the fast disk finishes. And bio3 can be submitted to raid1 once the
> write of bio2 to fast disk finishes.

I just take a look at raid1 code, turns out raid1_write_request() just allo=
cate
bio and issue it directly in each rdev iteration, I misunderstood.

This solution looks fine to me, however, I'll suggest to keep the wait_queu=
e and
use prepare_to_wait_exclusive() to guarantee the fifo order.

>
> Best Regards
> Xiao
>>> Signed-off-by: Xiao Ni <xni@redhat.com>
>>> ---
>>>    drivers/md/md.c    |  1 -
>>>    drivers/md/md.h    |  4 +++-
>>>    drivers/md/raid1.c | 39 +++++++++++++++++++++++++++++----------
>>>    3 files changed, 32 insertions(+), 12 deletions(-)
>>>
>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>> index 59cd303548de..ab91d17c2d68 100644
>>> --- a/drivers/md/md.c
>>> +++ b/drivers/md/md.c
>>> @@ -188,7 +188,6 @@ static int rdev_init_serial(struct md_rdev *rdev)
>>>
>>>                spin_lock_init(&serial_tmp->serial_lock);
>>>                serial_tmp->serial_rb =3D RB_ROOT_CACHED;
>>> -             init_waitqueue_head(&serial_tmp->serial_io_wait);
>>>        }
>>>
>>>        rdev->serial =3D serial;
>>> diff --git a/drivers/md/md.h b/drivers/md/md.h
>>> index ac84289664cd..64ffbb2efb87 100644
>>> --- a/drivers/md/md.h
>>> +++ b/drivers/md/md.h
>>> @@ -126,7 +126,6 @@ enum sync_action {
>>>    struct serial_in_rdev {
>>>        struct rb_root_cached serial_rb;
>>>        spinlock_t serial_lock;
>>> -     wait_queue_head_t serial_io_wait;
>>>    };
>>>
>>>    /*
>>> @@ -382,6 +381,9 @@ struct serial_info {
>>>        sector_t start;         /* start sector of rb node */
>>>        sector_t last;          /* end sector of rb node */
>>>        sector_t _subtree_last; /* highest sector in subtree of rb node =
*/
>>> +     struct list_head        list_node;
>>> +     struct list_head        waiters;
>>> +     struct completion       ready;
>>>    };
>>>
>>>    /*
>>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>>> index a41b1ec3d695..38c73538d038 100644
>>> --- a/drivers/md/raid1.c
>>> +++ b/drivers/md/raid1.c
>>> @@ -57,19 +57,25 @@ INTERVAL_TREE_DEFINE(struct serial_info, node, sect=
or_t, _subtree_last,
>>>                     START, LAST, static inline, raid1_rb);
>>>
>>>    static int check_and_add_serial(struct md_rdev *rdev, struct r1bio *=
r1_bio,
>>> -                             struct serial_info *si, int idx)
>>> +                             struct serial_info *si)
>>>    {
>>>        unsigned long flags;
>>>        int ret =3D 0;
>>>        sector_t lo =3D r1_bio->sector;
>>>        sector_t hi =3D lo + r1_bio->sectors - 1;
>>> +     int idx =3D sector_to_idx(r1_bio->sector);
>>>        struct serial_in_rdev *serial =3D &rdev->serial[idx];
>>> +     struct serial_info *head_si;
>>>
>>>        spin_lock_irqsave(&serial->serial_lock, flags);
>>>        /* collision happened */
>>> -     if (raid1_rb_iter_first(&serial->serial_rb, lo, hi))
>>> +     head_si =3D raid1_rb_iter_first(&serial->serial_rb, lo, hi);
>>> +     if (head_si && head_si !=3D si) {
>>> +             si->start =3D lo;
>>> +             si->last =3D hi;
>>> +             list_add_tail(&si->list_node, &head_si->waiters);
>>>                ret =3D -EBUSY;
>>> -     else {
>>> +     } else if (!head_si) {
>>>                si->start =3D lo;
>>>                si->last =3D hi;
>>>                raid1_rb_insert(si, &serial->serial_rb);
>>> @@ -83,19 +89,23 @@ static void wait_for_serialization(struct md_rdev *=
rdev, struct r1bio *r1_bio)
>>>    {
>>>        struct mddev *mddev =3D rdev->mddev;
>>>        struct serial_info *si;
>>> -     int idx =3D sector_to_idx(r1_bio->sector);
>>> -     struct serial_in_rdev *serial =3D &rdev->serial[idx];
>>>
>>>        if (WARN_ON(!mddev->serial_info_pool))
>>>                return;
>>>        si =3D mempool_alloc(mddev->serial_info_pool, GFP_NOIO);
>>> -     wait_event(serial->serial_io_wait,
>>> -                check_and_add_serial(rdev, r1_bio, si, idx) =3D=3D 0);
>>> +     INIT_LIST_HEAD(&si->waiters);
>>> +     INIT_LIST_HEAD(&si->list_node);
>>> +     init_completion(&si->ready);
>>> +     while (check_and_add_serial(rdev, r1_bio, si)) {
>>> +             wait_for_completion(&si->ready);
>>> +             reinit_completion(&si->ready);
>>> +     }
>>>    }
>>>
>>>    static void remove_serial(struct md_rdev *rdev, sector_t lo, sector_=
t hi)
>>>    {
>>>        struct serial_info *si;
>>> +     struct serial_info *first_si;
>>>        unsigned long flags;
>>>        int found =3D 0;
>>>        struct mddev *mddev =3D rdev->mddev;
>>> @@ -106,16 +116,25 @@ static void remove_serial(struct md_rdev *rdev, s=
ector_t lo, sector_t hi)
>>>        for (si =3D raid1_rb_iter_first(&serial->serial_rb, lo, hi);
>>>             si; si =3D raid1_rb_iter_next(si, lo, hi)) {
>>>                if (si->start =3D=3D lo && si->last =3D=3D hi) {
>>> -                     raid1_rb_remove(si, &serial->serial_rb);
>>> -                     mempool_free(si, mddev->serial_info_pool);
>>>                        found =3D 1;
>>>                        break;
>>>                }
>>>        }
>>>        if (!found)
>>>                WARN(1, "The write IO is not recorded for serialization\=
n");
>>> +     else {
>>> +             raid1_rb_remove(si, &serial->serial_rb);
>>> +             if (!list_empty(&si->waiters)) {
>>> +                     first_si =3D list_first_entry(&si->waiters,
>>> +                                             struct serial_info, list_=
node);
>>> +                     list_del_init(&first_si->list_node);
>>> +                     list_splice_init(&si->waiters, &first_si->waiters=
);
>>> +                     raid1_rb_insert(first_si, &serial->serial_rb);
>>> +                     complete(&first_si->ready);
>>> +             }
>>> +             mempool_free(si, mddev->serial_info_pool);
>>> +     }
>>>        spin_unlock_irqrestore(&serial->serial_lock, flags);
>>> -     wake_up(&serial->serial_io_wait);
>>>    }
>>>
>>>    /*
>> --
>> Thansk,
>> Kuai
>>
>
--=20
Thansk,
Kuai
