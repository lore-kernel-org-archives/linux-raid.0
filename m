Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74578189518
	for <linux-raid@vger.kernel.org>; Thu,  5 Sep 2024 05:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725515719; cv=none; b=t4SyMH0Nbg78lOl0m8dlLNpOZ7r1z3O7M1V3to8Y4ze/PrWnIO/ZPxoG9c8DN3Dvy9JuZ6x2FRm14BnVr4UGLDVhuBl1xhZX4NN4Xd+UyWbZlXst2XHAII2EEGZMdhSplM35gRsr/1ZIaG0LCbugsgFfOuTglZhTx9Lnl2ImN+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725515719; c=relaxed/simple;
	bh=uJwXY0CsPn/lR3jkJTzpy93JUI4OM2ZUHynXZzF/Ai0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CrNKGPpXegmocmuVRJMnoT16n7dlxYIrNB0QthU+1RTk9eQ4gOOFpMeTCi+uTpBivQpTmsGdlgYp22xZnROUrMpiKRJzuNxt1KEy60Nb2mK2KpAHsEqPnhIuf1j6+xdDnUoAz9zMyb0HnRvgypE8/KbrrMX6IMuWDwK63Lbhnek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dEkb/GR1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dEkb/GR1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 184B0C4CEC7
	for <linux-raid@vger.kernel.org>; Thu,  5 Sep 2024 05:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725515719;
	bh=uJwXY0CsPn/lR3jkJTzpy93JUI4OM2ZUHynXZzF/Ai0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=dEkb/GR1qJnVXHDHkfd2v+K7YvxbpeV/rMqRnF8vHtfMRDiNM/a2h9ttRQVqDgh/Z
	 Cwq9pGgvnDbnm6OabO1eDXGE47F8HPYbopjic8Sk5lY54TW47U8HDkX+iMO51mQOwO
	 uTfZzFQtUpke3njiqtao/CIHBhDxmGmgwdH4EtDh/OQiJyRBGHkgl5zQR5sJGG2Ad6
	 /YduZ8rd/t3iyY7iND8ys9G8qt9ac8dBXgWHICU/kuPrjfWGs6nnog21kq0xq6L1C5
	 zVnlF8V6v3Omr/AgRHvPek3N+uAI4elLMzZWZAHsXH0RarRSJgfIjbj54E8UJQDjy4
	 57+lHs6/JOMGA==
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-82a1b84e6e1so14308839f.3
        for <linux-raid@vger.kernel.org>; Wed, 04 Sep 2024 22:55:19 -0700 (PDT)
X-Gm-Message-State: AOJu0YxZfrTsEC7KzvGGnjuOBUvgCw8sMsTM91nbsHDvCFsejhfsxaJZ
	pleHedIfHPNy1bvOhvtL+M+tGxHf6RltYm8vylUP8djp7LtXqgDVOxxo/46pwBn/QpDB64eLREX
	0FJ18c+upzb66yWdHoj6vZjTscXw=
X-Google-Smtp-Source: AGHT+IFFr4pnQCpCU6X3e8ixFjZvm417sMR81qH4U7pzFwN0YDSggBgrFWvGjnTxpdxdoULxF7OneemS24yNouCWsVE=
X-Received: by 2002:a05:6e02:527:b0:39f:7318:c1c6 with SMTP id
 e9e14a558f8ab-39f7318c2b2mr55657595ab.15.1725515718462; Wed, 04 Sep 2024
 22:55:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240904235453.99120-1-xni@redhat.com>
In-Reply-To: <20240904235453.99120-1-xni@redhat.com>
From: Song Liu <song@kernel.org>
Date: Wed, 4 Sep 2024 22:55:07 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4xb8cuk0kKuLivHVkzzHOyNMDiD4iv7DBqghZ9DmwM6A@mail.gmail.com>
Message-ID: <CAPhsuW4xb8cuk0kKuLivHVkzzHOyNMDiD4iv7DBqghZ9DmwM6A@mail.gmail.com>
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

Actually, since we can read and write "new_level", please describe how
it will be used (read and write).

Thanks,
Song
