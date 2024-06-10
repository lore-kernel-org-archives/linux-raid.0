Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E08E14EC58
	for <linux-raid@vger.kernel.org>; Mon, 10 Jun 2024 18:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718042619; cv=none; b=H8W3/x5wIrSsl8b07CiKEI5a5n9MT1K03CNxAghZxEiZNNgV/pSNMBcnRlN2qo4HAPVm+bfOZoRp1DZLllrE5d1JITNGI+53pSxRNXj+0JKP61LUHBAgFk6hzR+SGgPtUfNI/TQlYclmqnlRYhVH4IocCDvaS8bQojyh87iyaq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718042619; c=relaxed/simple;
	bh=seWYmAtLdhRDifQRHh/649XXVE6GPWUCYVVqV81F/w0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S5t5lG5FddSGshKp8wmqWAFrYns+6gc5kZzGjEOMiTVUswxQd+MO67GY6YGkL5RAwpIZBktdrGP6ZD1a5m06YMhnh5Q9F3o1QX0WCJm7oAe1C7S8CKlFUNgHNn2LS11fwpBZeoz/T599+reqGYNfNN3JPOgmj+S6fxZAOtOKsEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IjtDWWb7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IjtDWWb7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17643C4AF4D
	for <linux-raid@vger.kernel.org>; Mon, 10 Jun 2024 18:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718042619;
	bh=seWYmAtLdhRDifQRHh/649XXVE6GPWUCYVVqV81F/w0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=IjtDWWb7Ppaji6uTNCpad9Y6AzYACWGjTpmnvroMOdVPS5T0V5NFREGN/MezPYx4f
	 FwE0Hh5J+58fXmz7+F4AruIVSjcRgALtScRbvctLchf5CAkrcVgP/6Hxu0SBAiH8jD
	 HfO6Q4oYUzttdsc5koW15T9Arho0/s936FWwapBEQcrM7VZ1WcKEjNljiBhwWsGgJl
	 /U5hd7UI3veGapVWJTnsHAadj5v5RrnfS9NC3LUE2sBks27k3IEkCgS8Pkfr3YVAgE
	 apcUwkU7cwhljBhGmuVvIOxpDD9KsZI3XxGIClN/BvYuwnKfhQq0rWFdKS6ho5E9bB
	 ZlcHqJE5bPM1A==
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2eaafda3b5cso61236241fa.3
        for <linux-raid@vger.kernel.org>; Mon, 10 Jun 2024 11:03:38 -0700 (PDT)
X-Gm-Message-State: AOJu0YxQFOdw7sEhLLEkJ6RjORhHTneglxVzvFJlbYLJSo3rtnGPIAv5
	ez4jdxrwLVDupjFH38Nk/ne44n2Y5xiQo4q2xQE9finLH0/vddkhxcgCX7LjXBNYzRbey5LJoNB
	dd7EhbI9AlrfiiAoaTAitzRggJGM=
X-Google-Smtp-Source: AGHT+IFJb7tHedB4lEAMij2auawZncr5wUB+llzWW16ck+fdEin39Dzb0+5dD2DIisDV2HSIrNs/j08RIm1tRTbOpIc=
X-Received: by 2002:a2e:9cce:0:b0:2ea:7f5d:ed93 with SMTP id
 38308e7fff4ca-2eadce9160bmr59829381fa.50.1718042617443; Mon, 10 Jun 2024
 11:03:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240522073310.8014-1-kinga.stefaniuk@intel.com> <20240522073310.8014-2-kinga.stefaniuk@intel.com>
In-Reply-To: <20240522073310.8014-2-kinga.stefaniuk@intel.com>
From: Song Liu <song@kernel.org>
Date: Mon, 10 Jun 2024 11:03:25 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7xOdQgcWLjOVjYDLqBzMo+TgZxmEbUqCwGZFtGGA0rXQ@mail.gmail.com>
Message-ID: <CAPhsuW7xOdQgcWLjOVjYDLqBzMo+TgZxmEbUqCwGZFtGGA0rXQ@mail.gmail.com>
Subject: Re: [PATCH v6 1/1] md: generate CHANGE uevents for md device
To: Kinga Stefaniuk <kinga.stefaniuk@intel.com>
Cc: linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 22, 2024 at 12:32=E2=80=AFAM Kinga Stefaniuk
<kinga.stefaniuk@intel.com> wrote:
>
[...]

> ---
>  drivers/md/md.c     | 47 ++++++++++++++++++++++++++++++---------------
>  drivers/md/md.h     |  2 +-
>  drivers/md/raid10.c |  2 +-
>  drivers/md/raid5.c  |  2 +-
>  4 files changed, 35 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index aff9118ff697..2ec696e17f3d 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -313,6 +313,16 @@ static int start_readonly;
>   */
>  static bool create_on_open =3D true;
>
> +/*
> + * Send every new event to the userspace.
> + */
> +static void trigger_kobject_uevent(struct work_struct *work)
> +{
> +       struct mddev *mddev =3D container_of(work, struct mddev, event_wo=
rk);
> +
> +       kobject_uevent(&disk_to_dev(mddev->gendisk)->kobj, KOBJ_CHANGE);
> +}
> +
>  /*
>   * We have a system wide 'event count' that is incremented
>   * on any 'interesting' event, and readers of /proc/mdstat
> @@ -325,10 +335,15 @@ static bool create_on_open =3D true;
>   */
>  static DECLARE_WAIT_QUEUE_HEAD(md_event_waiters);
>  static atomic_t md_event_count;
> -void md_new_event(void)
> +void md_new_event(struct mddev *mddev, bool trigger_event)
>  {
>         atomic_inc(&md_event_count);
>         wake_up(&md_event_waiters);
> +
> +       if (trigger_event)
> +               kobject_uevent(&disk_to_dev(mddev->gendisk)->kobj, KOBJ_C=
HANGE);
> +       else
> +               schedule_work(&mddev->event_work);

event_work is also used by dmraid. Will this cause an issue with dmraid?

Thanks,
Song
