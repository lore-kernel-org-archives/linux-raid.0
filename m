Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9D74B1D19
	for <linux-raid@vger.kernel.org>; Fri, 18 Sep 2026 08:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789721670; cv=none; b=qJqgNh2N3ZB0pYBrMWNDPdNwR53GO7/RLNQJObdpK9bHcx34vwcWroYQMYIYk05txbWuTZCOFhMzphb241LBnGT9Zcv59evaxmJkcI/lI517BYz14+XvP/rsdHnMiZJzRYB6F6DKszcj44J/nG2+L8FFPb+ee6SY36LTm61FiJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789721670; c=relaxed/simple;
	bh=GjJp4+MoOVgFz8FbjXWPExkscjTWKHrWx4K/ofPuzLg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=k3Ljn1zBok40JJaO5LRLLoVMU8I4bUJUBliNtIW7prP4FAd97vV+Z4XXrTiUDHR8Wl+MRRREOJ3TS0nLAoAjnDW/t8RFR/qWvoT7n0wPJm99vFpcZm3za+aKqJiZWF7wfyT5+1PDPwrGxQ3ZvhCAQZ4aihH1QUJn4tyb+gn7sZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IxcA0Lod; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IxcA0Lod"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-485ac898fa4so386444f8f.0
        for <linux-raid@vger.kernel.org>; Fri, 18 Sep 2026 01:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789721665; x=1790326465; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DX5xBtiBsqr4ICF7MQ+7hgta5AIRA84ekraA1M5DNPk=;
        b=IxcA0LodBbQKBBwwBxfGrewYkONuGCXIrbJePx2Y3++MdGRcJo7Fmp9BpSGoTmikNz
         GicvUUUnN8/iZpqzTubJveGdM3DVF7YWyEYEofJ8rTFRpqd2rpAUravggfMftKIFSXTj
         /gUbknB43XebS60NSzV91RKlapK++gW+NqYME/6EN52yEKYcPHgmcEKpwDc6KqYOpYvh
         j6qP+FL75QbMYuJLJVOikBzIP4XrcYKy0i5s12NKkiI9dW+/SrLQbg2N7v6dyCc/EYL5
         CMtDai4CfNFDNGuCbmscA6X8Yk+ppFfJI32JlUbyAXpwoOrgPaEsZ3G23OX+1Xcugnam
         R/Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789721665; x=1790326465;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :references:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DX5xBtiBsqr4ICF7MQ+7hgta5AIRA84ekraA1M5DNPk=;
        b=LfiWpVBqW39WBvdmbQugca38uJQsmcocXNfYeO9uoVJd6DUL7F+bnsSG+k3492pYcV
         Oj4VjbKQlg8kOHnmMaG8zWU5gr/Ff8wxh5WE+QW4z2nEpxefd2WqqlL13wzZHNOBYJS5
         BRtoQFDQ3YXJKCv0VO69AFXkdYFWM35uYQIcMT+f2LKz+FRozTPuA3iGsAiaUJTFnXSt
         MUTlKTS+EtG52+6/Ta2waHSrL9ZYgDYwcMGjQutV/BWKmA//BtJfCoSlyvUeYUkhez1z
         lRnRRqsFOEF0cuWUFRJ2zsgFDeb0zIoTw4yd6UhrClVu6XqrdvjbKtPScJxXKQtkvJ6h
         iw9A==
X-Gm-Message-State: AFuF++ke1rOqjTSgCHoegpdmnz6CyQfuhL8fC1FFW5qI+BEoS2PEJ3H+
	jOO/3UhLvpGTPbPdQWt5pMhlD97VK9d6QeBkCfZANphYVn7jFk2YQGHJ4TQCqA==
X-Gm-Gg: AYBFou2aO0ujYyjfYtE3J0YjlbCefiCevUNwvFMt4NRMCA0ONM8+V1REKgKkSx6Gk/d
	6GFTweC+truNG1cejOSxov/HPBePwkh/cMc2gYsU7762EcEs7BZAF70dX2i2KdhWwUcskAFjW0x
	j5Orl5kJjHcYjZjUKucdFWJ2zBOaAn1wKGTnhrdQfoBAULFMPRGApez8751HotnHHezz62U4zdx
	+n+6W2Woleb9SsnghsCTpgIjoCIg3X0LCmXiwCJN1fuw2/K9A4Hsl0vVcZ5ayKnfuG2oCaAO6df
	HmbsQcsWIKQVnr6e8nqECr7CJR5Y6aAB6v7F31ybAYogTX96rEBVdta/YSQaUBwtavcJL0/U0wW
	kSVrSWc24rXMlS3+AOEO9FMTp+J2CuyjMlZEFITbxR9/ntImsV1u5WOYETwcNcVO7khONeH58TL
	mWQlkRM5T0Kki0zgc5JYOp7gaTO+QIerzNkBfvzM1kc6VcbJ5O1SDkABERhoV4wDHWxQYGFyE4z
	bcGE2c5qfJv/AiJ9MSgZaL3y/bm9rQw5yrVJ1M3wg==
X-Received: by 2002:a05:6000:2084:b0:486:f3db:e0f2 with SMTP id ffacd0b85a97d-4871e21b8d1mr2580511f8f.14.1789721664813;
        Fri, 18 Sep 2026 01:54:24 -0700 (PDT)
Received: from Abds-MacBook-Air.local ([2a02:3037:31e:59ba:f5a3:393a:4cdc:d23f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-487200737d6sm2651823f8f.24.2026.09.18.01.54.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 01:54:24 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: Zhihao Cheng <chengzhihao1@huawei.com>, song@kernel.org, yukuai@fygo.io,
 xiao@kernel.org, magiclinan@didiglobal.com, eadavis@sina.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yangerkun@huawei.com, yi.zhang@huawei.com
Subject: Re: [PATCH v3] md: Fix the null-ptr-deref of 'mddev->private' while
 submitting IO
In-Reply-To: <856a065c-38ef-08cd-7701-8f579212a1a3@huawei.com>
References: <20260918070900.1945351-1-chengzhihao1@huawei.com>
 <m233v7586k.fsf@gmail.com>
 <249f987d-9d2d-8f5c-91dd-3af6baefe587@huawei.com>
 <m2zexf3r84.fsf@gmail.com>
 <856a065c-38ef-08cd-7701-8f579212a1a3@huawei.com>
Date: Fri, 18 Sep 2026 10:54:21 +0200
Message-ID: <m2wlsj3poi.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


Hi Zhihao,

On Fri, Sep 18, 2026 at 16:34 +0800, Zhihao Cheng wrote:
> =E5=9C=A8 2026/9/18 16:20, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:
>> On Fri, Sep 18, 2026 at 15:38 +0800, Zhihao Cheng wrote:
>>> =E5=9C=A8 2026/9/18 15:29, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:
>>>>
>>>> Hi Zhihao,
>>>>
>>>> On Fri, Sep 18, 2026 at 15:09 +0800, Zhihao Cheng wrote:
>>>>> Concurrent processes md_stop and IO submitting could trigger a
>>>>> null-ptr-deref of 'mddev->private':
>>>>>
>>>>>    BUG: kernel NULL pointer dereference, address: 0000000000000070
>>>>>    RIP: 0010:_wait_barrier+0x2f/0x250
>>>>>    Call Trace:
>>>>>     raid1_make_request+0x150/0xf50
>>>>>     md_handle_request+0x104/0x530
>>>>>     md_submit_bio+0x76/0x130
>>>>>     submit_bio+0xdd/0x250
>>>>>     submit_bio_wait+0x1f/0x40
>>>>>     __blkdev_direct_IO_simple+0x1f6/0x370
>>>>>     blkdev_write_iter+0x3b2/0x520
>>>>>     ksys_write+0x7d/0x190
>>>>>
>>>>>                 P1
>>>>>     fd =3D open(/dev/md0, O_RDWR)
>>>>> 	                      P2 (forked from P1, fd' <=3D fd)
>>>>>     write(fd)
>>>>>      submit_bio
>>>>>       md_handle_request
>>>>>        raid1_make_request
>>>>>         raid1_write_request
>>>>>                                     ioctl(fd, STOP_ARRAY)
>>>>> 		                   mddev_set_closing_and_sync_blockdev
>>>>> 				   // check passed, mddev->openers =3D 1,
>>>>> 				   // because md_open() is only called
>>>>> 				   // once in P1->open
>>>>> 				   do_md_stop
>>>>> 				    __md_stop
>>>>> 				     mddev->private =3D NULL
>>>>>
>>>>>          conf =3D mddev->private // NULL
>>>>>           wait_barrier(conf, sector) // null-ptr-deref !
>>>>>
>>>>> It is a common problem for raid0/1/10/5, and __md_stop could be trigg=
ered
>>>>> by several paths(eg. ioctl, sysfs, ->dtr). Fix it by replacing
>>>>> mddev_lock() with mddev_suspend_and_lock() for all __md_stop() caller=
s.
>>>>> The caller dm_table_destroy() is guaranteed being invoked with device
>>>>> suspended, so raid_dtr() could keep using mddev_lock_nointr().
>>>>> The caller array_state_store() is guaranteed by the check
>>>>> mddev_set_closing_and_sync_blockdev(mddev, 0). For example, someone o=
pen
>>>>> /dev/mdx, write something and close /dev/mdx, it won't trigger the
>>>>> problem, all dirty pages can be flushed before mddev->openers decreme=
nt.
>>>>> Besides, fail the submitting IO in md_handle_request() if the
>>>>> 'mddev->pers' becomes NULL.
>>>>>
>>>>> Fetch a reproducer in https://bugzilla.kernel.org/show_bug.cgi?id=3D2=
22020
>>>>>
>>>>> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>>>>> Reported-by: syzbot+3fe892ea5fc292e1353f@syzkaller.appspotmail.com
>>>>> Closes: https://syzkaller.appspot.com/bug?extid=3D3fe892ea5fc292e1353f
>>>>> Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
>>>>> ---
>>>>>    v1->v2:
>>>>>     1. Add 'mddev->pers !=3D NULL' check before make_request
>>>>>     2. Delete dm-raid caller(->dtr) modifications
>>>>>     3. Move memalloc_noio_restore after mddev_unlock_and_resume
>>>>>    v2->v3:
>>>>>     1. Remove modifications in array_state_store()
>>>>>     2. update commit msg
>>>>>    drivers/md/md.c | 15 +++++++++++++++
>>>>>    1 file changed, 15 insertions(+)
>>>>>
>>>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>>>> index 680b34a63cb3..e73338c26d53 100644
>>>>> --- a/drivers/md/md.c
>>>>> +++ b/drivers/md/md.c
>>>>> @@ -414,6 +414,20 @@ bool md_handle_request(struct mddev *mddev, stru=
ct bio *bio)
>>>>>    		if (!percpu_ref_tryget_live(&mddev->active_io))
>>>>>    			goto check_suspended;
>>>>>    	}
>>>>> +	if (!mddev->pers) {
>>>> Isn't this case already handled by md_submit_bio(). take a look in
>>>> md_submit_bio()
>>> Hi,Abd-Alrhman
>>> I understand that 'mddev =3D=3D NULL || mddev->pers =3D=3D NULL' in
>>> md_submit_bio() is a qiuck check, there still exists a small race windo=
w:
>>>        P1                     P2
>>> md_submit_bio
>>>    if (mddev =3D=3D NULL || mddev->pers =3D=3D NULL)
>>>                           md_ioctl
>>>                            mddev_suspend_and_lock
>>>                            do_md_stop->__md_stop
>>>                            // set mddev->pers/private as NULL
>>>                            mddev_unlock_and_resume
>>>    md_handle_request
>>>     if (is_suspended(mddev, bio))
>>>     percpu_ref_tryget_live(&mddev->active_io)
>>>     mddev->pers // null-ptr-deref
>>=20
>> It makes sense. It would solve only the null pointer reference, but I
>> see another issue. Look at the comment before calling
>> mddev_set_closing_and_sync_blockdev() in md_ioctl(). it says "Need to
>> flush page cache, and ensure no-one else opens and writes". The
>> suspending happens after flushing the page cache, in this case,
>> there might be other writes in-flight.
>
> At present, the current implementation does not align with the expected=20
> annotations. Yu Kai privately gave me a feasible suggestion, which is to=
=20
> have md_ioctl operate on a character device(like /dev/mapper/control)=20
> instead of an md block device. This fix patch will serve as a temporary=20
> solution before the official implementation is merged. By the way, I=20
> don't have much time to implment it, do you have time to deal with the=20
> official solution?

Thanks for the summary. I can take on the official implementation.
Before I get started, could we align on the interface details and any
other relevant considerations?

>>=20
>>>>
>>>>> +		/*
>>>>> +		 * The __md_stop() sets 'mddev->private' to NULL during
>>>>> +		 * the IO submitting, check 'mddev->pers' before the IO
>>>>> +		 * being processed by specific driver to avoid the
>>>>> +		 * null-ptr-deref of 'mddev-><member>'. The check is
>>>>> +		 * safe because the IO has got the 'mddev->active_io'
>>>>> +		 * reference, and all __md_stop() callers will wait for
>>>>> +		 * the reference to be zero.
>>>>> +		 */
>>>>> +		bio_io_error(bio);
>>>>> +		percpu_ref_put(&mddev->active_io);
>>>>> +		return true;
>>>>> +	}
>>>>>    	if (!mddev->pers->make_request(mddev, bio)) {
>>>>>    		percpu_ref_put(&mddev->active_io);
>>>>>    		if (mddev_is_dm(mddev) && mddev->pers->prepare_suspend)
>>>>> @@ -8299,6 +8313,7 @@ static bool md_ioctl_need_suspend(unsigned int =
cmd)
>>>>>    	case HOT_REMOVE_DISK:
>>>>>    	case SET_BITMAP_FILE:
>>>>>    	case SET_ARRAY_INFO:
>>>>> +	case STOP_ARRAY:
>>>>>    		return true;
>>>>>    	default:
>>>>>    		return false;
>>>>> --=20
>>>>> 2.52.0
>>>>>
>>>>
>>>
>>=20
>

--=20
Best Regards,
Abd-Alrhman
