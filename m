Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D63621
	for <linux-raid@vger.kernel.org>; Thu,  5 Sep 2024 05:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725515558; cv=none; b=G2SbdzE+9K/Hj4LNAqgHpT2Klljud5tMNTwF1N7/2cO/ie+3HFYrCgc0CXZsrBOr0lTnPkvNUj+4bbN1rik/nLk78XpaDl9kXTUeNmysJqEq7rGNXZcQiTpI3N5HyZKOekzztZPWZ576r97StP19fBNxLeymTEVsgm1p63KIGcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725515558; c=relaxed/simple;
	bh=72ziJHOfMZ/0DZJehoqiok6bkn6mO/Vn7koff7zGY+Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E+jSRqYONZVFmWIBoebYuSaLkxvXdLjLqsDAKTjIbbsBijDzaXmYodIGtC3qD1MNvOeYdrtGGG0u4rNaEcijtYJab+KCe6iibVkrNfjE4SEDVY1GoI8RhVjnshAk+btR/ju3wItzgxc49eMFYNmVxtlaly7qPB2P5z0SMzcXTFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p7bNpGkw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p7bNpGkw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A50A3C4CEC5
	for <linux-raid@vger.kernel.org>; Thu,  5 Sep 2024 05:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725515557;
	bh=72ziJHOfMZ/0DZJehoqiok6bkn6mO/Vn7koff7zGY+Y=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=p7bNpGkw6UPImMtdQwTCii/m4pUbhE1L3jCfeXrdep3yKP+zaKxjOTAIQFBRTtg+R
	 yJyE1mGClFT1hhv9YHHfL4VhVAr/cZYBQS6ySfuOQ+ZKZGKXZQkS1tG8qn9y3YecLU
	 udXmjQhTMpHegTaHy1Nl0EAL8ReIOpR/+f/TiMbu4QThmC7zPNQ4y7rFJlzzY3r8Un
	 M8GN2bKltgAFmUp0BIUPjj3RqNIwMkCIZEP6SeLMit9hA1J1vCmHvztxsh3N95r1zL
	 iS5A11/cwgbdmkcu1zoCt0Z1+FLmQjdekApKmjQ7cD4iPhkmEXEjM1XpvOladtPTK8
	 UHhHhoob6BD4w==
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-39fdd5c44d3so1563895ab.3
        for <linux-raid@vger.kernel.org>; Wed, 04 Sep 2024 22:52:37 -0700 (PDT)
X-Gm-Message-State: AOJu0YzP0IB0sH/Ct8uLlytVH/DCP/941ewcoIvEGlcaG04YfWO/ztLA
	nM1DG8bvLaUyzFnKeBW0ekUpaZESsFcOzVrYFrsKwlv2XNoPyJ9VIFJEwnC+jXhiQpeaKHHQPaO
	h7SEQoX35sYG6LY+R0s21b7xUzlE=
X-Google-Smtp-Source: AGHT+IHU3KzS7ZrLgsbwtKu9fte06MVR6xD71C7Och29Zx6g+qMS2p1wyVEXqTZUUwNkJ66WsriOFJGOZQ7G/oSVjMU=
X-Received: by 2002:a05:6e02:1d0c:b0:39d:1694:d261 with SMTP id
 e9e14a558f8ab-39f4f68e352mr211876345ab.12.1725515557037; Wed, 04 Sep 2024
 22:52:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240904235453.99120-1-xni@redhat.com>
In-Reply-To: <20240904235453.99120-1-xni@redhat.com>
From: Song Liu <song@kernel.org>
Date: Wed, 4 Sep 2024 22:52:25 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4Et6e+=BLPwWTTVAzCGG7evzkDRrMiGcMFhJmmLHZyYQ@mail.gmail.com>
Message-ID: <CAPhsuW4Et6e+=BLPwWTTVAzCGG7evzkDRrMiGcMFhJmmLHZyYQ@mail.gmail.com>
Subject: Re: [PATCH V3 md-6.12 1/1] md: add new_level sysfs interface
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, pmenzel@molgen.mpg.de, yukuai1@huaweicloud.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 4, 2024 at 4:55=E2=80=AFPM Xiao Ni <xni@redhat.com> wrote:
>
> Reshape needs to specify a backup file when it can't update data offset
> of member disks. For this situation, first, it starts reshape and then
> it kicks off mdadm-grow-continue service which does backup job and
> monitors the reshape process. The service is a new process, so it needs
> to read superblock from member disks to get information.
>
> But in the first step, it doesn't update new level in superblock. So
> in the second step, the new level that systemd service reads from
> superblock is wrong. It can't change to the right new level after reshape
> finishes. This interface is used to update new level during reshape
> progress.
>
> Reproduce steps:
> mdadm -CR /dev/md0 -l6 -n4 /dev/loop[0-3]
> mdadm --wait /dev/md0
> mdadm /dev/md0 --grow -l5 --backup=3Dbackup
> cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4] [raid0] [raid1] [raid10]
> md0 : active raid6 loop3[3] loop2[2] loop1[1] loop0[0]
>
> Test case 07changelevels from mdadm regression tests can trigger this
> problem.

Please briefly describe how the user space (mdadm or something else)
will use the new API to fix this issue.

No need to resend the patch. You can just reply here.

Thanks,
Song

>
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
> V3: explain more about the root cause
> V2: add detail about test information
>  drivers/md/md.c | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index d3a837506a36..3c354e7a7825 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -4141,6 +4141,34 @@ level_store(struct mddev *mddev, const char *buf, =
size_t len)
>  static struct md_sysfs_entry md_level =3D
>  __ATTR(level, S_IRUGO|S_IWUSR, level_show, level_store);
>
> +static ssize_t
> +new_level_show(struct mddev *mddev, char *page)
> +{
> +       return sprintf(page, "%d\n", mddev->new_level);
> +}
> +
> +static ssize_t
> +new_level_store(struct mddev *mddev, const char *buf, size_t len)
> +{
> +       unsigned int n;
> +       int err;
> +
> +       err =3D kstrtouint(buf, 10, &n);
> +       if (err < 0)
> +               return err;
> +       err =3D mddev_lock(mddev);
> +       if (err)
> +               return err;
> +
> +       mddev->new_level =3D n;
> +       md_update_sb(mddev, 1);
> +
> +       mddev_unlock(mddev);
> +       return len;
> +}
> +static struct md_sysfs_entry md_new_level =3D
> +__ATTR(new_level, 0664, new_level_show, new_level_store);
> +
>  static ssize_t
>  layout_show(struct mddev *mddev, char *page)
>  {
> @@ -5666,6 +5694,7 @@ __ATTR(serialize_policy, S_IRUGO | S_IWUSR, seriali=
ze_policy_show,
>
>  static struct attribute *md_default_attrs[] =3D {
>         &md_level.attr,
> +       &md_new_level.attr,
>         &md_layout.attr,
>         &md_raid_disks.attr,
>         &md_uuid.attr,
> --
> 2.32.0 (Apple Git-132)
>
