Received: from va-2-50.ptr.blmpb.com (va-2-50.ptr.blmpb.com [209.127.231.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1C147C105
	for <linux-raid@vger.kernel.org>; Thu, 17 Sep 2026 07:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789630917; cv=none; b=lBPhfj41PO9ikb1B47JADngbPZMC0Su2PEkDILPNye+PUcWpDZpRAsj0VdDk0h8QSN5s3OVpKnVwMZ9xAEZfytsZgqw6/mNRIKndZ0SES6j5/OG+diu5szii19VaR43TlQAvBr7OugEyNybtpKVnFEbejIY/bom9GbClb1BFU9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789630917; c=relaxed/simple;
	bh=Htva7IVgdUSCMSawzKt6aahv9iOKUZiiWvrGlQKKvR8=;
	h=Message-Id:References:Content-Type:Cc:In-Reply-To:Date:
	 Mime-Version:Subject:To:From; b=FjZn4SAGkJE6pXT0h43pI2UV9IFSXAprXQfLF5VxBzF/N5XBdvRML0onDV/AzH7xsvuBTJbybCUm734ZUDu6XlJoRS8N85++Za1FO3gBf+xxVVjazvxpl0QWyJKIFQV5aSJDJ3f9tln7ZrqB2ec5rsq1jhKgIII2RrqBq74LgXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=niFYCo2w; arc=none smtp.client-ip=209.127.231.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="niFYCo2w"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1789630903;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Zc48n57R5ccgs/+2BBrNr272vzQE8uOWL57/kdRMEco=;
 b=niFYCo2wRQf0vr9yzVZmY6DtYUXQgBrj4aTAB6FxiBFkCaK/bxARq4YVOgJFvfZv428FHW
 5QqqdavP+ClNgd7hk8BUR6FrejoCaWC9w93B/fc861Ulm+p6nGmVxiF63J1t7W8Q3bQtt8
 Wm9ypW8nUK87p1e2JOKgZS5bv8NclWj/z4zpEeeIM8WaAcabjoItFNXlePFRbow8NnIEN+
 BI9Y1Jo8PPKwjsxLDU2mp2Fms3PjBYTq++LcjDZR++eSB007GY0O4bWnerQ20V2KXo+Kt4
 fYuaTTQRFUOX2H/oSER5Em7cuwdbIeyeN+SvzvyNeYNTPWXORhYqBzOrtw+qpQ==
Message-Id: <9cd00dc3-765c-4cc1-871c-692ddb86b0c8@fygo.io>
References: <20260915083354.1603416-1-dayou5941@163.com>
Received: from [192.168.1.104] ([39.182.0.142]) by smtp.larksuite.com with ESMTPS; Thu, 17 Sep 2026 07:41:41 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Reply-To: yukuai@fygo.io
Cc: <magiclinan@didiglobal.com>, <xiao@kernel.org>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	"Li Youhong" <liyouhong@kylinos.cn>, 
	<syzbot+68e1f51046d68329940f@syzkaller.appspotmail.com>
In-Reply-To: <20260915083354.1603416-1-dayou5941@163.com>
Date: Thu, 17 Sep 2026 15:41:38 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26aab99b6+9bd8a2+vger.kernel.org+yukuai@fygo.io>
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md: don't flush md_misc_wq from md_alloc()
X-Original-From: yu kuai <yukuai@fygo.io>
To: "Li Youhong" <dayou5941@163.com>, <song@kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>

Hi,

=E5=9C=A8 2026/9/15 16:33, Li Youhong =E5=86=99=E9=81=93:
> From: Li Youhong <liyouhong@kylinos.cn>
>
> md_alloc() is called from md_probe(), while blk_probe_dev() still holds
> major_names_lock. The flush of md_misc_wq in md_alloc() is only meant to
> wait for the previous mddev_delayed_delete() to finish.
>
> md_misc_wq also runs sync_work (md_start_sync), and md_start_sync takes
> reconfig_mutex. On the other path, md_ioctl() already holds
> reconfig_mutex when md_import_device() opens a bdev and takes
> major_names_lock.
>
> Flushing md_misc_wq under major_names_lock therefore creates a lockdep
> cycle:
>
>    major_names_lock -> md_misc_wq -> reconfig_mutex -> major_names_lock
>
> Move del_work to a dedicated workqueue and flush only that queue from
> md_alloc(). Leave sync_work on md_misc_wq.
>
> Reported-by: syzbot+68e1f51046d68329940f@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D68e1f51046d68329940f
> Fixes: e804ac780e2f ("md: fix and update workqueue usage")
> Signed-off-by: Li Youhong <liyouhong@kylinos.cn>
> ---
>   drivers/md/md.c | 28 +++++++++++++++++++++-------
>   1 file changed, 21 insertions(+), 7 deletions(-)

Patch itself look correct, however, this is not the solution I'd like.
Since legacy_async_del_gendisk is introduced a long time now, I think it's
time to remove the related legacy async code, so there is no need to keep
del_work, and then the flush_workqueue() from md_alloc() is not needed anym=
ore.

>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 680b34a63cb3..87a851466892 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -86,13 +86,16 @@ static const struct kobj_type md_ktype;
>   static DECLARE_WAIT_QUEUE_HEAD(resync_wait);
>  =20
>   /*
> - * This workqueue is used for sync_work to register new sync_thread, and=
 for
> - * del_work to remove rdev, and for event_work that is only set by dm-ra=
id.
> + * md_misc_wq runs sync_work (new sync_thread) and event_work (dm-raid).
> + * sync_work grabs reconfig_mutex, so this queue must not be flushed whi=
le
> + * holding reconfig_mutex, nor while holding major_names_lock (md_probe =
/
> + * md_alloc is called from blk_probe_dev with that lock held).
>    *
> - * Noted that sync_work will grab reconfig_mutex, hence never flush this
> - * workqueue whith reconfig_mutex grabbed.
> + * md_del_wq runs only del_work (mddev_delayed_delete). md_alloc() flush=
es
> + * this queue to wait for a previous instance of the same device to go a=
way.
>    */
>   static struct workqueue_struct *md_misc_wq;
> +static struct workqueue_struct *md_del_wq;
>  =20
>   static int remove_and_add_spares(struct mddev *mddev,
>   				 struct md_rdev *this);
> @@ -651,7 +654,7 @@ static void __mddev_put(struct mddev *mddev)
>   	 * Call queue_work inside the spinlock so that flush_workqueue() after
>   	 * mddev_find will succeed in waiting for the work to be done.
>   	 */
> -	queue_work(md_misc_wq, &mddev->del_work);
> +	queue_work(md_del_wq, &mddev->del_work);
>   }
>  =20
>   static void mddev_put_locked(struct mddev *mddev)
> @@ -6329,9 +6332,12 @@ struct mddev *md_alloc(dev_t dev, char *name)
>  =20
>   	/*
>   	 * Wait for any previous instance of this device to be completely
> -	 * removed (mddev_delayed_delete).
> +	 * removed (mddev_delayed_delete). Do not flush md_misc_wq: it also
> +	 * runs sync_work, which takes reconfig_mutex and can take
> +	 * major_names_lock via md_import_device(). md_alloc() is called from
> +	 * md_probe() while blk_probe_dev() already holds major_names_lock.
>   	 */
> -	flush_workqueue(md_misc_wq);
> +	flush_workqueue(md_del_wq);
>  =20
>   	mutex_lock(&disks_mutex);
>   	mddev =3D mddev_alloc(dev);
> @@ -10765,6 +10771,10 @@ static int __init md_init(void)
>   	if (!md_misc_wq)
>   		goto err_misc_wq;
>  =20
> +	md_del_wq =3D alloc_workqueue("md_del", WQ_PERCPU, 0);
> +	if (!md_del_wq)
> +		goto err_del_wq;
> +
>   	ret =3D __register_blkdev(MD_MAJOR, "md", md_probe);
>   	if (ret < 0)
>   		goto err_md;
> @@ -10783,6 +10793,8 @@ static int __init md_init(void)
>   err_mdp:
>   	unregister_blkdev(MD_MAJOR, "md");
>   err_md:
> +	destroy_workqueue(md_del_wq);
> +err_del_wq:
>   	destroy_workqueue(md_misc_wq);
>   err_misc_wq:
>   	md_llbitmap_exit();
> @@ -11093,6 +11105,7 @@ static __exit void md_exit(void)
>   	spin_unlock(&all_mddevs_lock);
>  =20
>   	destroy_workqueue(md_misc_wq);
> +	destroy_workqueue(md_del_wq);
>   	md_bitmap_exit();
>   }
>  =20

--=20
Thanks,
Kuai
