Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E2CB3F39F1
	for <linux-raid@vger.kernel.org>; Fri, 18 Sep 2026 09:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789724471; cv=none; b=QNT/YhQAtAMUnxdBxd6H33/noKzP24k1tiucPuHMMU/qTYl0/iIoY8Z6OE5MXyR3LvzHCPCEV4MdaTFlIIYCchNtVsm4cc8aJUMq76G07HOGeiYXXc3UyWC8wrXFzTtfc4SEGnO7BRYWi9FiPnXsZCtPX8XTdHud8IuUkUlh3II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789724471; c=relaxed/simple;
	bh=lAmGPjgC9g5IQl8kDhSTdrOoqcbI4yIrTQQgcW6k2Q4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=QNrMWzasDkWImlw3oCsAQubk3fzcLCqy2Peh4L5EeGp0+KOw3CqSApZUKpS+jMkNVX137VE6HQ7PCst0ysmr2/aHcxA5c5Ae8msPBdL+6CWq7svqEXubf31KpnNgTEEWcMseOimWdyXRsv2GP/IRx2BC45tx7J7NKULX+Ib3iDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BxiMdXGr; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BxiMdXGr"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49e6598dd44so2994365e9.1
        for <linux-raid@vger.kernel.org>; Fri, 18 Sep 2026 02:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789724467; x=1790329267; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9lyz7KsqbgiRHXCzgXytWiqYCcnNV7OEQjlWDA7ERYo=;
        b=BxiMdXGr1H7KWp6fnWKThbGft3uwi41etUeJKX4lMWg6RAsKAduRgwvYN6EwuDh+V3
         pwzXDNORdiry9toi9fdEdY7zTqnrHOShdIFLPmz23YfZQlNMvFqbMDaDpbdmpHYKc4b+
         vAd0lit5Y648eOwu/7XClGR8AddBE0NbhygjNNON2HgvkhZsjUWEydtaFOTvCOhOzIxH
         T0TyTq9epMbwLWF9y35BQgkuEGCWFHlSkyT7271/oeJO8qz7m6NlHAYHKZGyyho95keu
         cs6W9aJmQNWgY6IyQ8VHsFckFeXnjHka7TMMy4ntLF7/XwsENIbW4Ky4yyIMc30O0Vn4
         EB5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789724467; x=1790329267;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :references:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9lyz7KsqbgiRHXCzgXytWiqYCcnNV7OEQjlWDA7ERYo=;
        b=H2dSGCiHWq4a/vdlwXJngDNDLwCa4qxQzhA0CSYB3zQIcpeF+r1RswtS8Ip58cx0v6
         BGnJN0X6GI3AGKWx/PvDRBRg3vUDU3meRCmXoc0F3sTX6tnUEVXmTySgvdBTW/kqmY3/
         FIMRmt5b/h86akH5QPMYg+8s3yc9GcT3OUyvwrPQ12G/EOVh02nc0w7yERISu8rgBgLf
         Tb6Dq1xuvqutdtxqFv3sqiSuHAmuholiFYXyswOpZh5AmlTsdu68EJSnSggrZnG0I7le
         baqf33mxpyaHt7LYMzDjMMA3A4//mwReY1nItvd6KwTxUz4a2EJYz7UyXBKx9t7HhexS
         218w==
X-Gm-Message-State: AFuF++njjZU1k4hr+tLCxQy6HIhsDa5jMPbvMzeoyGw+UUKpx3BsCCFQ
	nBaqlHt98Sniyz6K4v9vwJlAGsHwMpesMhCVz8vU6qEi/1brromPi0Cd
X-Gm-Gg: AYBFou19RiCe0BARL9ty+IS9iFD5DMMoyARy5QCbTD1EVyHQwBqP/u4ZK+NQn+4/TD8
	HSYB8tXir/WaApWPbXnqIOfMkbnpd1FM7DS3BVqCKR/Lprq0QuPx2vUk9Aysm97tnxWmE/ApPOY
	ccc8FVOa7B2TkPQpuQ7X9A+W/xWbWVxaav09OdR7SnGLOPmc+W3+h0F7K1MWlb7w89/6flBb8xO
	PeRr+mpHCHdNz9+yOFLgOdn+tKzgUzYasndpNCezEYS3SDFB/RlAc0XJzCT7XKYrTf0sgkVMYWE
	kMIbGyQFyIPratp8mX7M+HB7M12hRBGe/gAblH2A1T0OuYj+uF+0a+GXQsmJh1IE/I4bb3SKClt
	toUfNO79llTkFdzJFZonSovXNliBevL0f5zb2PmIck1+pGoO+bAaE7MzrfWqSbVrJ7t6sPJT9Rt
	vrghB/Qs53Qxpk8dseIEMWpSRIPNmWuE0pmZJpF0YxB6q54Vofc/YSwOUvTXh/0cwNNRNiNQrky
	dvCP2f5T4LfrN7H1N6kqJOJTZj87k+AZ0B+mfgroQ==
X-Received: by 2002:a05:600c:a00f:b0:49e:645e:2616 with SMTP id 5b1f17b1804b1-49fc56692e0mr24091905e9.5.1789724467404;
        Fri, 18 Sep 2026 02:41:07 -0700 (PDT)
Received: from Abds-MacBook-Air.local ([2a02:3037:31e:59ba:b091:766d:f5d2:bc1a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fbd216028sm141427195e9.7.2026.09.18.02.41.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 02:41:05 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: yu kuai <yukuai@fygo.io>, Zhihao Cheng <chengzhihao1@huawei.com>,
 song@kernel.org, xiao@kernel.org, magiclinan@didiglobal.com,
 eadavis@sina.com, yu kuai <yukuai@fygo.io>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yangerkun@huawei.com, yi.zhang@huawei.com
Subject: Re: [PATCH v3] md: Fix the null-ptr-deref of 'mddev->private' while
 submitting IO
In-Reply-To: <12b0bc4c-5dfb-4936-8ecd-849137b597d8@fygo.io>
References: <20260918070900.1945351-1-chengzhihao1@huawei.com>
 <m233v7586k.fsf@gmail.com>
 <249f987d-9d2d-8f5c-91dd-3af6baefe587@huawei.com>
 <m2zexf3r84.fsf@gmail.com>
 <856a065c-38ef-08cd-7701-8f579212a1a3@huawei.com>
 <m2wlsj3poi.fsf@gmail.com> <12b0bc4c-5dfb-4936-8ecd-849137b597d8@fygo.io>
Date: Fri, 18 Sep 2026 11:41:03 +0200
Message-ID: <m2tsnm5234.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


Hi Kuai,

On Fri, Sep 18, 2026 at 17:30 +0800, yu kuai wrote:
> Hi,
>
> =E5=9C=A8 2026/9/18 16:54, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:
>> Hi Zhihao,
>>
>> On Fri, Sep 18, 2026 at 16:34 +0800, Zhihao Cheng wrote:
>>> =E5=9C=A8 2026/9/18 16:20, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:
>>>> On Fri, Sep 18, 2026 at 15:38 +0800, Zhihao Cheng wrote:
>>>>> =E5=9C=A8 2026/9/18 15:29, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:
>>>>>> Hi Zhihao,
>>>>>>
>>>>>> On Fri, Sep 18, 2026 at 15:09 +0800, Zhihao Cheng wrote:
>>>>>>> Concurrent processes md_stop and IO submitting could trigger a
>>>>>>> null-ptr-deref of 'mddev->private':
>>>>>>>
>>>>>>>     BUG: kernel NULL pointer dereference, address: 0000000000000070
>>>>>>>     RIP: 0010:_wait_barrier+0x2f/0x250
>>>>>>>     Call Trace:
>>>>>>>      raid1_make_request+0x150/0xf50
>>>>>>>      md_handle_request+0x104/0x530
>>>>>>>      md_submit_bio+0x76/0x130
>>>>>>>      submit_bio+0xdd/0x250
>>>>>>>      submit_bio_wait+0x1f/0x40
>>>>>>>      __blkdev_direct_IO_simple+0x1f6/0x370
>>>>>>>      blkdev_write_iter+0x3b2/0x520
>>>>>>>      ksys_write+0x7d/0x190
>>>>>>>
>>>>>>>                  P1
>>>>>>>      fd =3D open(/dev/md0, O_RDWR)
>>>>>>> 	                      P2 (forked from P1, fd' <=3D fd)
>>>>>>>      write(fd)
>>>>>>>       submit_bio
>>>>>>>        md_handle_request
>>>>>>>         raid1_make_request
>>>>>>>          raid1_write_request
>>>>>>>                                      ioctl(fd, STOP_ARRAY)
>>>>>>> 		                   mddev_set_closing_and_sync_blockdev
>>>>>>> 				   // check passed, mddev->openers =3D 1,
>>>>>>> 				   // because md_open() is only called
>>>>>>> 				   // once in P1->open
>>>>>>> 				   do_md_stop
>>>>>>> 				    __md_stop
>>>>>>> 				     mddev->private =3D NULL
>>>>>>>
>>>>>>>           conf =3D mddev->private // NULL
>>>>>>>            wait_barrier(conf, sector) // null-ptr-deref !
>>>>>>>
>>>>>>> It is a common problem for raid0/1/10/5, and __md_stop could be tri=
ggered
>>>>>>> by several paths(eg. ioctl, sysfs, ->dtr). Fix it by replacing
>>>>>>> mddev_lock() with mddev_suspend_and_lock() for all __md_stop() call=
ers.
>>>>>>> The caller dm_table_destroy() is guaranteed being invoked with devi=
ce
>>>>>>> suspended, so raid_dtr() could keep using mddev_lock_nointr().
>>>>>>> The caller array_state_store() is guaranteed by the check
>>>>>>> mddev_set_closing_and_sync_blockdev(mddev, 0). For example, someone=
 open
>>>>>>> /dev/mdx, write something and close /dev/mdx, it won't trigger the
>>>>>>> problem, all dirty pages can be flushed before mddev->openers decre=
ment.
>>>>>>> Besides, fail the submitting IO in md_handle_request() if the
>>>>>>> 'mddev->pers' becomes NULL.
>>>>>>>
>>>>>>> Fetch a reproducer in https://bugzilla.kernel.org/show_bug.cgi?id=
=3D222020
>>>>>>>
>>>>>>> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>>>>>>> Reported-by: syzbot+3fe892ea5fc292e1353f@syzkaller.appspotmail.com
>>>>>>> Closes: https://syzkaller.appspot.com/bug?extid=3D3fe892ea5fc292e13=
53f
>>>>>>> Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
>>>>>>> ---
>>>>>>>     v1->v2:
>>>>>>>      1. Add 'mddev->pers !=3D NULL' check before make_request
>>>>>>>      2. Delete dm-raid caller(->dtr) modifications
>>>>>>>      3. Move memalloc_noio_restore after mddev_unlock_and_resume
>>>>>>>     v2->v3:
>>>>>>>      1. Remove modifications in array_state_store()
>>>>>>>      2. update commit msg
>>>>>>>     drivers/md/md.c | 15 +++++++++++++++
>>>>>>>     1 file changed, 15 insertions(+)
>>>>>>>
>>>>>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>>>>>> index 680b34a63cb3..e73338c26d53 100644
>>>>>>> --- a/drivers/md/md.c
>>>>>>> +++ b/drivers/md/md.c
>>>>>>> @@ -414,6 +414,20 @@ bool md_handle_request(struct mddev *mddev, st=
ruct bio *bio)
>>>>>>>     		if (!percpu_ref_tryget_live(&mddev->active_io))
>>>>>>>     			goto check_suspended;
>>>>>>>     	}
>>>>>>> +	if (!mddev->pers) {
>>>>>> Isn't this case already handled by md_submit_bio(). take a look in
>>>>>> md_submit_bio()
>>>>> Hi,Abd-Alrhman
>>>>> I understand that 'mddev =3D=3D NULL || mddev->pers =3D=3D NULL' in
>>>>> md_submit_bio() is a qiuck check, there still exists a small race win=
dow:
>>>>>         P1                     P2
>>>>> md_submit_bio
>>>>>     if (mddev =3D=3D NULL || mddev->pers =3D=3D NULL)
>>>>>                            md_ioctl
>>>>>                             mddev_suspend_and_lock
>>>>>                             do_md_stop->__md_stop
>>>>>                             // set mddev->pers/private as NULL
>>>>>                             mddev_unlock_and_resume
>>>>>     md_handle_request
>>>>>      if (is_suspended(mddev, bio))
>>>>>      percpu_ref_tryget_live(&mddev->active_io)
>>>>>      mddev->pers // null-ptr-deref
>>>> It makes sense. It would solve only the null pointer reference, but I
>>>> see another issue. Look at the comment before calling
>>>> mddev_set_closing_and_sync_blockdev() in md_ioctl(). it says "Need to
>>>> flush page cache, and ensure no-one else opens and writes". The
>>>> suspending happens after flushing the page cache, in this case,
>>>> there might be other writes in-flight.
>>> At present, the current implementation does not align with the expected
>>> annotations. Yu Kai privately gave me a feasible suggestion, which is to
>>> have md_ioctl operate on a character device(like /dev/mapper/control)
>>> instead of an md block device. This fix patch will serve as a temporary
>>> solution before the official implementation is merged. By the way, I
>>> don't have much time to implment it, do you have time to deal with the
>>> official solution?
>> Thanks for the summary. I can take on the official implementation.
>> Before I get started, could we align on the interface details and any
>> other relevant considerations?
>
> I think the following procedures(details should be considered more):
>
> 1) add a new char device in mdraid to issue ioctl to array;
> 2) update mdadm to use the new ioctl;
> 3) a kernel message to warn the old block device ioctl is deprecated, and=
 suggest
> user to upgrade mdadm;
> 4) Since the new ioctl will introduce UAPI change, we should wait for a l=
ong time,
> perhaps more than 1 year, before the deprecated old ioctl code in kernel =
can be removed.
>

Thanks, I=E2=80=99ll start working on the implementation.

>>
>>>>>>> +		/*
>>>>>>> +		 * The __md_stop() sets 'mddev->private' to NULL during
>>>>>>> +		 * the IO submitting, check 'mddev->pers' before the IO
>>>>>>> +		 * being processed by specific driver to avoid the
>>>>>>> +		 * null-ptr-deref of 'mddev-><member>'. The check is
>>>>>>> +		 * safe because the IO has got the 'mddev->active_io'
>>>>>>> +		 * reference, and all __md_stop() callers will wait for
>>>>>>> +		 * the reference to be zero.
>>>>>>> +		 */
>>>>>>> +		bio_io_error(bio);
>>>>>>> +		percpu_ref_put(&mddev->active_io);
>>>>>>> +		return true;
>>>>>>> +	}
>>>>>>>     	if (!mddev->pers->make_request(mddev, bio)) {
>>>>>>>     		percpu_ref_put(&mddev->active_io);
>>>>>>>     		if (mddev_is_dm(mddev) && mddev->pers->prepare_suspend)
>>>>>>> @@ -8299,6 +8313,7 @@ static bool md_ioctl_need_suspend(unsigned in=
t cmd)
>>>>>>>     	case HOT_REMOVE_DISK:
>>>>>>>     	case SET_BITMAP_FILE:
>>>>>>>     	case SET_ARRAY_INFO:
>>>>>>> +	case STOP_ARRAY:
>>>>>>>     		return true;
>>>>>>>     	default:
>>>>>>>     		return false;
>>>>>>> --=20
>>>>>>> 2.52.0
>>>>>>>
> --=20
> Thanks,
> Kuai

--=20
Best Regards,
Abd-Alrhman
