Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PbXSRPIH"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD497E8
	for <linux-raid@vger.kernel.org>; Mon, 20 Nov 2023 22:02:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700546573;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6W5xplE02zao2bFqJUVuDizmmtHpfz820tf0kUlxTXY=;
	b=PbXSRPIHv9sKiadJIZKirC1YOiIfPUmMKBeu14mEkMisBacoCSobEUPvEB1DfPIHsC9LW7
	wSjOm9dIpIiwUyepUCA5O7kquge8S8VUMc8RjadILv7CICyeOgUvCWPJdpXGJed6FP4aZ+
	cML/m2VYbey0D/VudAXyraknH8p/ank=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-172-XEUW8xVaPs-Kf-w8egeOIQ-1; Tue, 21 Nov 2023 01:02:52 -0500
X-MC-Unique: XEUW8xVaPs-Kf-w8egeOIQ-1
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-5b9344d72bbso6977750a12.0
        for <linux-raid@vger.kernel.org>; Mon, 20 Nov 2023 22:02:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700546571; x=1701151371;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6W5xplE02zao2bFqJUVuDizmmtHpfz820tf0kUlxTXY=;
        b=Sy2Wf987aFwArT6+BxmeaHfjTreiflW7/ab4e8SOaQNr3LIiSqf2qmQ3ywFGv0Ucoo
         LAW/tf1xFKeYsrnvLP3I2jLVPCs+n5CFZF7LHgD7Qy7l7rYEUo0VWbbFtSzA1WwZGNUX
         qDa3aDDLa+3c3JQ3wLskd4vXMglHTw9dbciBx4XlkekxIhlJlMWtahTwiYCegTpP76Oi
         pJr3m4tqBGew8Uwo05A4jyfsLWORX/Q9PqydryZGOJl/QfgQZZWUBEzS+ySdD6K2ZOzM
         LXVv0zP1RUdeB8cenJ+WN3V6By2u7aNlN+Ccyl1IkwowY2iYPa3+kLKDEB3lckiMy1a8
         KRkw==
X-Gm-Message-State: AOJu0YzdD4iRGQMJkxqT3rHCuBDzJnAovqN8IoM+WJ/7hSxHXBqjswDd
	WFqHX9D720xdbF8vbvGf2BSVFiF9BZwYh7Jj54kZizGL2O30DeJ71oup6KY/OGFYImTLU3xyjWL
	B8vIu2v2PRUa16Bw6XCSWXF3QEvk5kgnUpVwiNg==
X-Received: by 2002:a05:6a21:788e:b0:187:4118:c0ee with SMTP id bf14-20020a056a21788e00b001874118c0eemr12717937pzc.46.1700546571115;
        Mon, 20 Nov 2023 22:02:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGiNn+1r/6LZHZ+G1ssb2FAp+Ul2ROZOrINmKuHG4Ikj4Kcrdtds80JSKjPMdejl502VCaVJl394+1GdumJVTI=
X-Received: by 2002:a05:6a21:788e:b0:187:4118:c0ee with SMTP id
 bf14-20020a056a21788e00b001874118c0eemr12717921pzc.46.1700546570759; Mon, 20
 Nov 2023 22:02:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231110172834.3939490-1-yukuai1@huaweicloud.com> <20231110172834.3939490-7-yukuai1@huaweicloud.com>
In-Reply-To: <20231110172834.3939490-7-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 21 Nov 2023 14:02:39 +0800
Message-ID: <CALTww2-ivzhRRMYBoVSZ32uRUPL8Lii=z3SHGbMijsximdn=7A@mail.gmail.com>
Subject: Re: [PATCH -next 6/8] md: factor out a helper to stop sync_thread
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, yukuai3@huawei.com, neilb@suse.de, 
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, yi.zhang@huawei.com, 
	yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 10, 2023 at 5:34=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> stop_sync_thread(), md_set_readonly() and do_md_stop() are trying to
> stop sync_thread() the same way, hence factor out a helper to make code
> cleaner, and also prepare to use the new helper to fix problems later.
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> Signed-off-by: Yu Kuai <yukuai1@huaweicloud.com>
> ---
>  drivers/md/md.c | 129 ++++++++++++++++++++++++++----------------------
>  1 file changed, 69 insertions(+), 60 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index c0f2bdafe46a..7252fae0c989 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -4848,29 +4848,46 @@ action_show(struct mddev *mddev, char *page)
>         return sprintf(page, "%s\n", type);
>  }
>
> -static int stop_sync_thread(struct mddev *mddev)
> +static bool sync_thread_stopped(struct mddev *mddev, int *seq_ptr)
>  {
> -       int ret =3D 0;
> +       if (seq_ptr && *seq_ptr !=3D atomic_read(&mddev->sync_seq))
> +               return true;
>
> -       if (!test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
> -               return 0;
> +       return (!mddev->sync_thread &&
> +               !test_bit(MD_RECOVERY_RUNNING, &mddev->recovery));
> +}
>
> -       ret =3D mddev_lock(mddev);
> -       if (ret)
> -               return ret;
> +/*
> + * stop_sync_thread() - stop running sync_thread.
> + * @mddev: the array that sync_thread belongs to.
> + * @freeze: set true to prevent new sync_thread to start.
> + * @interruptible: if set true, then user can interrupt while waiting fo=
r
> + * sync_thread to be done.
> + *
> + * Noted that this function must be called with 'reconfig_mutex' grabbed=
, and
> + * fter this function return, 'reconfig_mtuex' will be released.
> + */
> +static int stop_sync_thread(struct mddev *mddev, bool freeze,
> +                           bool interruptible)
> +       __releases(&mddev->reconfig_mutex)
> +{
> +       int *seq_ptr =3D NULL;
> +       int sync_seq;
> +       int ret =3D 0;
> +
> +       if (freeze) {
> +               set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
> +       } else {
> +               clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
> +               sync_seq =3D atomic_read(&mddev->sync_seq);
> +               seq_ptr =3D &sync_seq;
> +       }
>
> -       /*
> -        * Check again in case MD_RECOVERY_RUNNING is cleared before lock=
 is
> -        * held.
> -        */
>         if (!test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
>                 mddev_unlock(mddev);
>                 return 0;
>         }
Hi Kuai

It does the unlock inside this function. For me, it's not good,
because the caller does the lock. So the caller should do the unlock
too.
>
> -       if (work_pending(&mddev->sync_work))
> -               flush_workqueue(md_misc_wq);
> -
>         set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>         /*
>          * Thread might be blocked waiting for metadata update which will=
 now
> @@ -4879,53 +4896,58 @@ static int stop_sync_thread(struct mddev *mddev)
>         md_wakeup_thread_directly(mddev->sync_thread);
>
>         mddev_unlock(mddev);

Same with above point.

> -       return 0;
> +       if (work_pending(&mddev->sync_work))
> +               flush_work(&mddev->sync_work);
> +
> +       if (interruptible)
> +               ret =3D wait_event_interruptible(resync_wait,
> +                                       sync_thread_stopped(mddev, seq_pt=
r));
> +       else
> +               wait_event(resync_wait, sync_thread_stopped(mddev, seq_pt=
r));
> +

It looks like the three roles (md_set_readonly, do_md_stop and
stop_sync_thread) need to wait for different events. We can move these
codes out this helper function and make this helper function to be
more common.

Best Regards
Xiao


> +       return ret;
>  }
>
>  static int idle_sync_thread(struct mddev *mddev)
>  {
>         int ret;
> -       int sync_seq =3D atomic_read(&mddev->sync_seq);
>         bool flag;
>
>         ret =3D mutex_lock_interruptible(&mddev->sync_mutex);
>         if (ret)
>                 return ret;
>
> -       flag =3D test_and_clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery)=
;
> -       ret =3D stop_sync_thread(mddev);
> +       flag =3D test_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
> +       ret =3D mddev_lock(mddev);
>         if (ret)
> -               goto out;
> +               goto unlock;
>
> -       ret =3D wait_event_interruptible(resync_wait,
> -                       sync_seq !=3D atomic_read(&mddev->sync_seq) ||
> -                       !test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))=
;
> -out:
> +       ret =3D stop_sync_thread(mddev, false, true);
>         if (ret && flag)
>                 set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
> +unlock:
>         mutex_unlock(&mddev->sync_mutex);
>         return ret;
>  }
>
>  static int frozen_sync_thread(struct mddev *mddev)
>  {
> -       int ret =3D mutex_lock_interruptible(&mddev->sync_mutex);
> +       int ret;
>         bool flag;
>
> +       ret =3D mutex_lock_interruptible(&mddev->sync_mutex);
>         if (ret)
>                 return ret;
>
> -       flag =3D test_and_set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
> -       ret =3D stop_sync_thread(mddev);
> +       flag =3D test_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
> +       ret =3D mddev_lock(mddev);
>         if (ret)
> -               goto out;
> +               goto unlock;
>
> -       ret =3D wait_event_interruptible(resync_wait,
> -                       mddev->sync_thread =3D=3D NULL &&
> -                       !test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))=
;
> -out:
> +       ret =3D stop_sync_thread(mddev, true, true);
>         if (ret && !flag)
>                 clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
> +unlock:
>         mutex_unlock(&mddev->sync_mutex);
>         return ret;
>  }
> @@ -6397,22 +6419,10 @@ static int md_set_readonly(struct mddev *mddev, s=
truct block_device *bdev)
>         if (mddev->external && test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_=
flags))
>                 return -EBUSY;
>
> -       if (!test_bit(MD_RECOVERY_FROZEN, &mddev->recovery)) {
> +       if (!test_bit(MD_RECOVERY_FROZEN, &mddev->recovery))
>                 did_freeze =3D 1;
> -               set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
> -       }
> -       if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
> -               set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>
> -       /*
> -        * Thread might be blocked waiting for metadata update which will=
 now
> -        * never happen
> -        */
> -       md_wakeup_thread_directly(mddev->sync_thread);
> -
> -       mddev_unlock(mddev);
> -       wait_event(resync_wait, !test_bit(MD_RECOVERY_RUNNING,
> -                                         &mddev->recovery));
> +       stop_sync_thread(mddev, true, false);
>         wait_event(mddev->sb_wait,
>                    !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
>         mddev_lock_nointr(mddev);
> @@ -6421,6 +6431,10 @@ static int md_set_readonly(struct mddev *mddev, st=
ruct block_device *bdev)
>         if ((mddev->pers && atomic_read(&mddev->openers) > !!bdev) ||
>             mddev->sync_thread ||
>             test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
> +               /*
> +                * This could happen if user change array state through
> +                * ioctl/sysfs while reconfig_mutex is released.
> +                */
>                 pr_warn("md: %s still in use.\n",mdname(mddev));
>                 err =3D -EBUSY;
>                 goto out;
> @@ -6457,30 +6471,25 @@ static int do_md_stop(struct mddev *mddev, int mo=
de,
>         struct md_rdev *rdev;
>         int did_freeze =3D 0;
>
> -       if (!test_bit(MD_RECOVERY_FROZEN, &mddev->recovery)) {
> +       if (!test_bit(MD_RECOVERY_FROZEN, &mddev->recovery))
>                 did_freeze =3D 1;
> +
> +       if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
> +               stop_sync_thread(mddev, true, false);
> +               mddev_lock_nointr(mddev);
> +       } else {
>                 set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
>         }
> -       if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
> -               set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> -
> -       /*
> -        * Thread might be blocked waiting for metadata update which will=
 now
> -        * never happen
> -        */
> -       md_wakeup_thread_directly(mddev->sync_thread);
> -
> -       mddev_unlock(mddev);
> -       wait_event(resync_wait, (mddev->sync_thread =3D=3D NULL &&
> -                                !test_bit(MD_RECOVERY_RUNNING,
> -                                          &mddev->recovery)));
> -       mddev_lock_nointr(mddev);
>
>         mutex_lock(&mddev->open_mutex);
>         if ((mddev->pers && atomic_read(&mddev->openers) > !!bdev) ||
>             mddev->sysfs_active ||
>             mddev->sync_thread ||
>             test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
> +               /*
> +                * This could happen if user change array state through
> +                * ioctl/sysfs while reconfig_mutex is released.
> +                */
>                 pr_warn("md: %s still in use.\n",mdname(mddev));
>                 mutex_unlock(&mddev->open_mutex);
>                 if (did_freeze) {
> --
> 2.39.2
>

