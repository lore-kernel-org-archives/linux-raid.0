Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 872CA1BF33
	for <linux-raid@vger.kernel.org>; Tue, 30 Dec 2025 07:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767080725; cv=none; b=nlFWRIPN7oCbGwu0HBPnosl+yXMDXye39rGuM4OYo6CUxR25du/X3GL62qAHPqB0K/ICnGO4aAwkHnYQA3jsnocUID4sun9d5Bh6j+hZv9jZiCBllprrUc8rorwY6w+VRaLSHnShJYGAfosO+wMEDVzMabKNr9U9ImzClZmyJ18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767080725; c=relaxed/simple;
	bh=idq+F5E2ANowpkTlTkRhc0VY3IXCQhuC5T2FZ2qVyZg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JQJjlcWYlQyXbHYBfB7hmjQfcgyb+LJZUhOGI0XQFRsBSa14EE3RP9D2m4qnaAU0SiDh+MPJfXxoPkMSsUywJE0jk9VZmgsd0UarJV/3cSHHu/qDUWUuaI9WCkXeJ/1zL3snvIuQJz81b89lO1OdWCev52hOAvTdMeZAXCGWBLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hmPVDOJJ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=U2lPeLrB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hmPVDOJJ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="U2lPeLrB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767080722;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mYWv31KO+EKN03UQWjbpkp75R8nA/LOronBe40W+BO0=;
	b=hmPVDOJJGwgd0yTGM8xGrYu87t0nQZGmVNx0q6Cvjt/PI39q4m0OHTWfdRVsqHw+mr1oYQ
	nb52T10mawQV9tGTiJnGtnfGOMyV6vARmlk5tSksvOmV6p5AzvHSXNzgcbkpk9bOggi+Ti
	XNGtafIg83xPj1+Nkk9khYyhsk3wTbs=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-146-x2Yqf-GzPD2tVXonVAHhrg-1; Tue, 30 Dec 2025 02:45:21 -0500
X-MC-Unique: x2Yqf-GzPD2tVXonVAHhrg-1
X-Mimecast-MFC-AGG-ID: x2Yqf-GzPD2tVXonVAHhrg_1767080719
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-597c3a566e8so7385436e87.3
        for <linux-raid@vger.kernel.org>; Mon, 29 Dec 2025 23:45:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767080719; x=1767685519; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mYWv31KO+EKN03UQWjbpkp75R8nA/LOronBe40W+BO0=;
        b=U2lPeLrBs0i5OQ3wglonibDzCvthTI3YTfBxXCZ7jpNN3ZFc6D0oGAW41vnooDiJdu
         fNbiaecDMBy2+zEZi182aS1d27qdYK9Y996Np6A2QRFFrm9BES75amNNH/T75AD5N1Na
         69n7Jr271c/2LPbig6DPc2SqM3WKGCDEAFWLuj8z7tTgMvL6S1icg5/gCTVD1ijIEEqE
         fiKgJXuo4/eTnBHENqgcCZgYtN5ulEiBTmeiHigS+zJGqhQM9HTCzZ4OZ+n00KvbObru
         fcJXMw4YQlSQSYEKMFR0NO3LGVYfi8sJR8aaKN4fKQglmn0iIZu0dcIH0HBbD1hNIz89
         i2SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767080719; x=1767685519;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mYWv31KO+EKN03UQWjbpkp75R8nA/LOronBe40W+BO0=;
        b=aEnVRPLyEQtiIUU9MSm+C6wMloaBV95jryvde3Dd8lqBwbZUnEN51vdeiGr/5QG1y8
         V38gBlP7yKAGTzIDaxsKYDPsaHiHu8MkK3JrXgoi3IJQdaFj8Ged7q2iMCBj6WuI51Ma
         4sCMqk5SjjGGDF9t6+I73pVDeqs8TwiQunHzDG+r4OdBhQBAfTTZhRtXYhgf3cxHSIwA
         q+wjIpEsBm1D+1PJgPqTbXTVQ/9R0bT8VpqSvi2HClA1E32VXhs4hHRpbernDyN34mep
         PWKvFLy1oWLLmuJudjSz/Kaiqbd8ZIRGw7P56ih+NV2lC24bOn4mYMHoB5yo+YpYmVhn
         QPrQ==
X-Forwarded-Encrypted: i=1; AJvYcCVTB4xneinngR12ZVShJYYeWEoKOccq/uDE/Dy9Qfyar1GG1JgJ7B/Vvh52dhmD1KGhCkZ4lRHIiAAl@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3aVb6QQpNY/QR+KlcaSqd+4XquSXpMBEDpQ7ykH8ylgjFcSK/
	is1dDvumLwXHIRIXAlbqCym3p1K4+X/VSNs/YLsw4+5N3YuaFxCeEUDMG7lwsrD63aDe9UWVMUj
	UBNx1PybauOanuhYmPUuY2GYco8wRQ3XfKvx3pzwCONR8MNzBg7W+Vw2ASqXpp0i2YscccrnPK0
	Ldc5PEfERtS5tSPtT7tMXidjd8ECnqUgmAg/AVKeSoZi9CJQ==
X-Gm-Gg: AY/fxX4JZaT9fn4LrMxCdQrAl/lSXZ8AAG9DYwyWx3KSs1qflTDZKV1u7PLb9kDiVzB
	E1oFk617elMoRb5UmNUvhg77hdih5HaJa1oUuGhgaX4wD60ismNei0peF1C1VLw30j+J/9KCoTk
	jmq7DHBGDmnMhszLRDXxpGvkZ8mtTr5CDGo+wzZKY7zkH0fjpmfOs4oD7SqD6SCyrQEdPnvTwt5
	4H1Y0NPgi1J3qlY7ydAoOEpkCOyPYPDVEnOKpe2uDFG1/2c3Zm4X27i5Q206ufsPoSpGQ==
X-Received: by 2002:a05:6512:3d1e:b0:598:8f91:a03e with SMTP id 2adb3069b0e04-59a17df1de2mr10972181e87.50.1767080718872;
        Mon, 29 Dec 2025 23:45:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEIwYQSsVZvsneEf8aTM88bnx/ri3ezu83gs6H51b71oekGQb40gpHhnNZzrSfxWIrUaW1gux/LtuNR8o/eXms=
X-Received: by 2002:a05:6512:3d1e:b0:598:8f91:a03e with SMTP id
 2adb3069b0e04-59a17df1de2mr10972175e87.50.1767080718437; Mon, 29 Dec 2025
 23:45:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251226101816.4506-1-dannyshih@synology.com> <CALTww29RPghH2+x9HwtDjCAXZfgK8gBkisXNKy0k8g9d5hiV_Q@mail.gmail.com>
 <589ae017-741f-4cc6-a069-13588a516465@synology.com>
In-Reply-To: <589ae017-741f-4cc6-a069-13588a516465@synology.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 30 Dec 2025 15:45:05 +0800
X-Gm-Features: AQt7F2pwhZlmVORlIcuGEzAZoyOcqoQpAH_HRy9LRgt7KiID6glSsfvhS_45Q5Y
Message-ID: <CALTww2_fvBai53XCgui_QmgiyhJufVDCEXTG0Pt8d7p2CpnPtA@mail.gmail.com>
Subject: Re: [PATCH v2] md: suspend array while updating raid_disks via sysfs
To: FengWei Shih <dannyshih@synology.com>
Cc: song@kernel.org, yukuai@fnnas.com, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 30, 2025 at 12:08=E2=80=AFPM FengWei Shih <dannyshih@synology.c=
om> wrote:
>
> Hi Xiao
>
> Xiao Ni =E6=96=BC 2025/12/29 =E4=B8=8B=E5=8D=88 05:19 =E5=AF=AB=E9=81=93:
> > Hi FengWei and Kuai
> >
> > On Fri, Dec 26, 2025 at 6:27=E2=80=AFPM dannyshih<dannyshih@synology.co=
m> wrote:
> >> From: FengWei Shih<dannyshih@synology.com>
> >>
> >> In raid1_reshape(), freeze_array() is called before modifying the r1bi=
o
> >> memory pool (conf->r1bio_pool) and conf->raid_disks, and
> >> unfreeze_array() is called after the update is completed.
> >>
> >> However, freeze_array() only waits until nr_sync_pending and
> >> (nr_pending - nr_queued) of all buckets reaches zero. When an I/O erro=
r
> >> occurs, nr_queued is increased and the corresponding r1bio is queued t=
o
> >> either retry_list or bio_end_io_list. As a result, freeze_array() may
> >> unblock before these r1bios are released.
> > Could you explain more about this? Why can't freeze_array block when
> > io error occurs? If io error occurs, the nr_pending number should be
> > equal with nr_queued, right?
> >
> > Best Regards
> > Xiao
>
> Even though nr_pending =3D=3D nr_queued, the r1bio is still alive and was
> allocated under the old raid_disks value. Allowing freeze_array()
> to unblock at this point permits an in-flight r1bio to span across the
> reshape.
>
> Assuming raid_disks is changed from 2 to 3, the sequence is roughly:
>
>    normal I/O                        raid1 reshape
>
>    nr_pending++
>
>    r1bio allocated
>    (raid_disks =3D=3D 2)
>
>    /* submit I/O */
>                                  echo 3 > /sys/block/mdX/md/raid_disks
>                                    raid1_reshape() -> freeze_array()
>                                   (waiting for nr_pending =3D=3D nr_queue=
d)
>
>    I/O error occurs and triggers
>    reschedule_retry()
>    r1bio queued to retry_list
>    nr_queued++       ------------>  freeze_array() unblocks
>                                     conf->r1bio_pool is changed
>                                     conf->raid_disks is changed
>                                     unfreeze_array()
>
>    /* r1bio retry handling */
>    free r1bio
>    (conf->raid_disks =3D=3D 3)
>
> Therefore, freeze_array() cannot guarantee that all r1bios allocated
> under the old array layout have been fully processed and freed.

Ah I c, thanks very much for the detailed explanation!

Best Regards
Xiao
>
> Thanks,
> FengWei Shih
>
> >> This can lead to a situation where conf->raid_disks and the mempool ha=
ve
> >> already been updated while queued r1bios, allocated with the old
> >> raid_disks value, are later released. Consequently, free_r1bio() may
> >> access memory out of bounds in put_all_bios() and release r1bios of th=
e
> >> wrong size to the new mempool, potentially causing issues with the
> >> mempool as well.
> >>
> >> Since only normal I/O might increase nr_queued while an I/O error occu=
rs,
> >> suspending the array avoids this issue.
> >>
> >> Note: Updating raid_disks via ioctl SET_ARRAY_INFO already suspends
> >> the array. Therefore, we suspend the array when updating raid_disks
> >> via sysfs to avoid this issue too.
> >>
> >> Signed-off-by: FengWei Shih<dannyshih@synology.com>
> >> ---
> >> v2:
> >>    * Suspend array unconditionally when updating raid_disks
> >>    * Refine commit message to describe the issue more concretely
> >> ---
> >>   drivers/md/md.c | 4 ++--
> >>   1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/md/md.c b/drivers/md/md.c
> >> index e5922a682953..6bcbe1c7483c 100644
> >> --- a/drivers/md/md.c
> >> +++ b/drivers/md/md.c
> >> @@ -4407,7 +4407,7 @@ raid_disks_store(struct mddev *mddev, const char=
 *buf, size_t len)
> >>          if (err < 0)
> >>                  return err;
> >>
> >> -       err =3D mddev_lock(mddev);
> >> +       err =3D mddev_suspend_and_lock(mddev);
> >>          if (err)
> >>                  return err;
> >>          if (mddev->pers)
> >> @@ -4432,7 +4432,7 @@ raid_disks_store(struct mddev *mddev, const char=
 *buf, size_t len)
> >>          } else
> >>                  mddev->raid_disks =3D n;
> >>   out_unlock:
> >> -       mddev_unlock(mddev);
> >> +       mddev_unlock_and_resume(mddev);
> >>          return err ? err : len;
> >>   }
> >>   static struct md_sysfs_entry md_raid_disks =3D
> >> --
> >> 2.17.1
> >>
> >>
> >> Disclaimer: The contents of this e-mail message and any attachments ar=
e confidential and are intended solely for addressee. The information may a=
lso be legally privileged. This transmission is sent in trust, for the sole=
 purpose of delivery to the intended recipient. If you have received this t=
ransmission in error, any use, reproduction or dissemination of this transm=
ission is strictly prohibited. If you are not the intended recipient, pleas=
e immediately notify the sender by reply e-mail or phone and delete this me=
ssage and its attachments, if any.
> >>
>
>
> Disclaimer: The contents of this e-mail message and any attachments are c=
onfidential and are intended solely for addressee. The information may also=
 be legally privileged. This transmission is sent in trust, for the sole pu=
rpose of delivery to the intended recipient. If you have received this tran=
smission in error, any use, reproduction or dissemination of this transmiss=
ion is strictly prohibited. If you are not the intended recipient, please i=
mmediately notify the sender by reply e-mail or phone and delete this messa=
ge and its attachments, if any.
>

