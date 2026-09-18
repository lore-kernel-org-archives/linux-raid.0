Received: from va-2-54.ptr.blmpb.com (va-2-54.ptr.blmpb.com [209.127.231.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED43D388860
	for <linux-raid@vger.kernel.org>; Fri, 18 Sep 2026 09:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789723844; cv=none; b=NpF1s9PpWjX24GIL2zM+uJ5LIVofTK5hE91P+79kcdJt6E5/ICU5EqQAS/1eO2fZ+CgT5LnkuaRSjKvIrEpMslLiyl3rht0hjaW0am8ifKTj0o7k85FsUm3uVh06pGlYJn98ssUoSvkVY/l6EdbO7uGj+lLm1JKMwnFuRUlf+o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789723844; c=relaxed/simple;
	bh=HZu/b9PKY4JG0y4vWTHaJMG2QeSPoNUs7zjz2XuF+fI=;
	h=From:Message-Id:Date:Mime-Version:Cc:Content-Type:In-Reply-To:To:
	 Subject:References; b=PBnq0LElSumgKW6FA0aGMCObf/Z4MOh9F6xy7WwdasHAkTbMDR8KYkrNCMYVEp8bHPPMqDPn+vnTj/zbSlnB8wFYmm1pF/QJnReLlpK/Hc0BimVd9WJU54fp6ojMX8KpTECLPr6kefaQ8CetNzB7p2yd3RV8O2I1bQ6ZAa3Eq38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=FD5Z5DNr; arc=none smtp.client-ip=209.127.231.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="FD5Z5DNr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1789723830;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=BKXI4hxq+8/R2aINHWyAjCYccoyWBzM/I7RvguDDHfc=;
 b=FD5Z5DNrINXKNh+H83Isikav6b8tclWq6bYZnTGfKEahIS/dOClmxkJOROv2N3jeZnkMsl
 20dNRMuXP+RPLFwznJRR5ZYZmH4Ct7ftgTnnNK4ZiCNJyvB/sD4aLIrV+DDDDTCs4mFdYP
 2qDkcIZrAnTURMjBx9ClJ9W82PWv/KMdZaEQwQJ4EawlyHzHkYQP1x4UmY62QJG5LFhf6z
 LfdUdu7JkhhB++KBWqIJ+7v2DNnOoWzXENByPn+j5VItRrA9bM3sY1JeA8d1khq/miy+rG
 YIeRlcjqsIZGEHD8dxvewLdQ0t1C96aGRc2Efavct2n277ss47cwfFZhmII01w==
Reply-To: yukuai@fygo.io
From: "yu kuai" <yukuai@fygo.io>
Message-Id: <12b0bc4c-5dfb-4936-8ecd-849137b597d8@fygo.io>
Received: from [192.168.1.104] ([39.182.0.142]) by smtp.larksuite.com with ESMTPS; Fri, 18 Sep 2026 09:30:28 +0000
Date: Fri, 18 Sep 2026 17:30:25 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26aad04b5+1aff4f+vger.kernel.org+yukuai@fygo.io>
User-Agent: Mozilla Thunderbird
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<yangerkun@huawei.com>, <yi.zhang@huawei.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <m2wlsj3poi.fsf@gmail.com>
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>, 
	"Zhihao Cheng" <chengzhihao1@huawei.com>, <song@kernel.org>, 
	<xiao@kernel.org>, <magiclinan@didiglobal.com>, <eadavis@sina.com>, 
	"yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH v3] md: Fix the null-ptr-deref of 'mddev->private' while submitting IO
X-Original-From: yu kuai <yukuai@fygo.io>
References: <20260918070900.1945351-1-chengzhihao1@huawei.com> <m233v7586k.fsf@gmail.com> <249f987d-9d2d-8f5c-91dd-3af6baefe587@huawei.com> <m2zexf3r84.fsf@gmail.com> <856a065c-38ef-08cd-7701-8f579212a1a3@huawei.com> <m2wlsj3poi.fsf@gmail.com>

Hi,

=E5=9C=A8 2026/9/18 16:54, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:
> Hi Zhihao,
>
> On Fri, Sep 18, 2026 at 16:34 +0800, Zhihao Cheng wrote:
>> =E5=9C=A8 2026/9/18 16:20, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:
>>> On Fri, Sep 18, 2026 at 15:38 +0800, Zhihao Cheng wrote:
>>>> =E5=9C=A8 2026/9/18 15:29, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:
>>>>> Hi Zhihao,
>>>>>
>>>>> On Fri, Sep 18, 2026 at 15:09 +0800, Zhihao Cheng wrote:
>>>>>> Concurrent processes md_stop and IO submitting could trigger a
>>>>>> null-ptr-deref of 'mddev->private':
>>>>>>
>>>>>>     BUG: kernel NULL pointer dereference, address: 0000000000000070
>>>>>>     RIP: 0010:_wait_barrier+0x2f/0x250
>>>>>>     Call Trace:
>>>>>>      raid1_make_request+0x150/0xf50
>>>>>>      md_handle_request+0x104/0x530
>>>>>>      md_submit_bio+0x76/0x130
>>>>>>      submit_bio+0xdd/0x250
>>>>>>      submit_bio_wait+0x1f/0x40
>>>>>>      __blkdev_direct_IO_simple+0x1f6/0x370
>>>>>>      blkdev_write_iter+0x3b2/0x520
>>>>>>      ksys_write+0x7d/0x190
>>>>>>
>>>>>>                  P1
>>>>>>      fd =3D open(/dev/md0, O_RDWR)
>>>>>> 	                      P2 (forked from P1, fd' <=3D fd)
>>>>>>      write(fd)
>>>>>>       submit_bio
>>>>>>        md_handle_request
>>>>>>         raid1_make_request
>>>>>>          raid1_write_request
>>>>>>                                      ioctl(fd, STOP_ARRAY)
>>>>>> 		                   mddev_set_closing_and_sync_blockdev
>>>>>> 				   // check passed, mddev->openers =3D 1,
>>>>>> 				   // because md_open() is only called
>>>>>> 				   // once in P1->open
>>>>>> 				   do_md_stop
>>>>>> 				    __md_stop
>>>>>> 				     mddev->private =3D NULL
>>>>>>
>>>>>>           conf =3D mddev->private // NULL
>>>>>>            wait_barrier(conf, sector) // null-ptr-deref !
>>>>>>
>>>>>> It is a common problem for raid0/1/10/5, and __md_stop could be trig=
gered
>>>>>> by several paths(eg. ioctl, sysfs, ->dtr). Fix it by replacing
>>>>>> mddev_lock() with mddev_suspend_and_lock() for all __md_stop() calle=
rs.
>>>>>> The caller dm_table_destroy() is guaranteed being invoked with devic=
e
>>>>>> suspended, so raid_dtr() could keep using mddev_lock_nointr().
>>>>>> The caller array_state_store() is guaranteed by the check
>>>>>> mddev_set_closing_and_sync_blockdev(mddev, 0). For example, someone =
open
>>>>>> /dev/mdx, write something and close /dev/mdx, it won't trigger the
>>>>>> problem, all dirty pages can be flushed before mddev->openers decrem=
ent.
>>>>>> Besides, fail the submitting IO in md_handle_request() if the
>>>>>> 'mddev->pers' becomes NULL.
>>>>>>
>>>>>> Fetch a reproducer in https://bugzilla.kernel.org/show_bug.cgi?id=3D=
222020
>>>>>>
>>>>>> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>>>>>> Reported-by: syzbot+3fe892ea5fc292e1353f@syzkaller.appspotmail.com
>>>>>> Closes: https://syzkaller.appspot.com/bug?extid=3D3fe892ea5fc292e135=
3f
>>>>>> Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
>>>>>> ---
>>>>>>     v1->v2:
>>>>>>      1. Add 'mddev->pers !=3D NULL' check before make_request
>>>>>>      2. Delete dm-raid caller(->dtr) modifications
>>>>>>      3. Move memalloc_noio_restore after mddev_unlock_and_resume
>>>>>>     v2->v3:
>>>>>>      1. Remove modifications in array_state_store()
>>>>>>      2. update commit msg
>>>>>>     drivers/md/md.c | 15 +++++++++++++++
>>>>>>     1 file changed, 15 insertions(+)
>>>>>>
>>>>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>>>>> index 680b34a63cb3..e73338c26d53 100644
>>>>>> --- a/drivers/md/md.c
>>>>>> +++ b/drivers/md/md.c
>>>>>> @@ -414,6 +414,20 @@ bool md_handle_request(struct mddev *mddev, str=
uct bio *bio)
>>>>>>     		if (!percpu_ref_tryget_live(&mddev->active_io))
>>>>>>     			goto check_suspended;
>>>>>>     	}
>>>>>> +	if (!mddev->pers) {
>>>>> Isn't this case already handled by md_submit_bio(). take a look in
>>>>> md_submit_bio()
>>>> Hi,Abd-Alrhman
>>>> I understand that 'mddev =3D=3D NULL || mddev->pers =3D=3D NULL' in
>>>> md_submit_bio() is a qiuck check, there still exists a small race wind=
ow:
>>>>         P1                     P2
>>>> md_submit_bio
>>>>     if (mddev =3D=3D NULL || mddev->pers =3D=3D NULL)
>>>>                            md_ioctl
>>>>                             mddev_suspend_and_lock
>>>>                             do_md_stop->__md_stop
>>>>                             // set mddev->pers/private as NULL
>>>>                             mddev_unlock_and_resume
>>>>     md_handle_request
>>>>      if (is_suspended(mddev, bio))
>>>>      percpu_ref_tryget_live(&mddev->active_io)
>>>>      mddev->pers // null-ptr-deref
>>> It makes sense. It would solve only the null pointer reference, but I
>>> see another issue. Look at the comment before calling
>>> mddev_set_closing_and_sync_blockdev() in md_ioctl(). it says "Need to
>>> flush page cache, and ensure no-one else opens and writes". The
>>> suspending happens after flushing the page cache, in this case,
>>> there might be other writes in-flight.
>> At present, the current implementation does not align with the expected
>> annotations. Yu Kai privately gave me a feasible suggestion, which is to
>> have md_ioctl operate on a character device(like /dev/mapper/control)
>> instead of an md block device. This fix patch will serve as a temporary
>> solution before the official implementation is merged. By the way, I
>> don't have much time to implment it, do you have time to deal with the
>> official solution?
> Thanks for the summary. I can take on the official implementation.
> Before I get started, could we align on the interface details and any
> other relevant considerations?

I think the following procedures(details should be considered more):

1) add a new char device in mdraid to issue ioctl to array;
2) update mdadm to use the new ioctl;
3) a kernel message to warn the old block device ioctl is deprecated, and s=
uggest
user to upgrade mdadm;
4) Since the new ioctl will introduce UAPI change, we should wait for a lon=
g time,
perhaps more than 1 year, before the deprecated old ioctl code in kernel ca=
n be removed.

>
>>>>>> +		/*
>>>>>> +		 * The __md_stop() sets 'mddev->private' to NULL during
>>>>>> +		 * the IO submitting, check 'mddev->pers' before the IO
>>>>>> +		 * being processed by specific driver to avoid the
>>>>>> +		 * null-ptr-deref of 'mddev-><member>'. The check is
>>>>>> +		 * safe because the IO has got the 'mddev->active_io'
>>>>>> +		 * reference, and all __md_stop() callers will wait for
>>>>>> +		 * the reference to be zero.
>>>>>> +		 */
>>>>>> +		bio_io_error(bio);
>>>>>> +		percpu_ref_put(&mddev->active_io);
>>>>>> +		return true;
>>>>>> +	}
>>>>>>     	if (!mddev->pers->make_request(mddev, bio)) {
>>>>>>     		percpu_ref_put(&mddev->active_io);
>>>>>>     		if (mddev_is_dm(mddev) && mddev->pers->prepare_suspend)
>>>>>> @@ -8299,6 +8313,7 @@ static bool md_ioctl_need_suspend(unsigned int=
 cmd)
>>>>>>     	case HOT_REMOVE_DISK:
>>>>>>     	case SET_BITMAP_FILE:
>>>>>>     	case SET_ARRAY_INFO:
>>>>>> +	case STOP_ARRAY:
>>>>>>     		return true;
>>>>>>     	default:
>>>>>>     		return false;
>>>>>> --=20
>>>>>> 2.52.0
>>>>>>
--=20
Thanks,
Kuai
