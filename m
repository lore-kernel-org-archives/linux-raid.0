Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E40BC9475
	for <linux-raid@vger.kernel.org>; Thu, 23 May 2024 14:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716476186; cv=none; b=ORFsMmOC6rQw3+roi5hu3qYrqMUQzwGekzwfZme6ajiecLO0Zyvt5IXPDxzEoIW1q6f+b002A/UATGHLLu1NTOMfpXqHcswIlwXHmRBbMTVlVpDGZBA0sfj3HBwwbeIY0ee/e/CXTkEhpZ3UeE4anFaREbmnbDVHyLBHhQM4QUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716476186; c=relaxed/simple;
	bh=C5wahDM07k/RO80iueg1my0qNv6e7dGqyRWBQtPMGvo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DSs8jtW9r3Z8AAniuEukO/2zrHmUgMOwqGoHTFTDk4KwfpBKi863oE0LKtQ8Gu8xMo20f47JYUmT/DhlNrtxIbMmhohN2m1QAeeQpCUSIUhng1bWDT3IudkX6mMuB0/9/ex0QZ1XF1+Uu9EdrG7SC9EoqoymcfVWMKMWPhPUwx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Gjz+84D4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gjz+84D4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716476184;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wh0Q89LEzHKrTtsipqoVeHsyEpfvHdvTz2TQv3QdHiY=;
	b=Gjz+84D45tjnE6Wkj4ut2mBd5bZjEJCYFGIQ5b2IemoTkGVLuZCmRcgnMVfhmjnC12s2l8
	8mwi+JvHVOpaocl619GSDhtjE1FaHowPwOd6sTVwdOA0GbMyfNa9N/FKxabr0emx/RlL5I
	tcDb+uxhhLZj6UuNc+m0L0KIVdpMrto=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-495-QSvgG2FlMby-HNPrvxHPTA-1; Thu, 23 May 2024 10:56:22 -0400
X-MC-Unique: QSvgG2FlMby-HNPrvxHPTA-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-1ed3b77d45aso2656195ad.0
        for <linux-raid@vger.kernel.org>; Thu, 23 May 2024 07:56:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716476181; x=1717080981;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wh0Q89LEzHKrTtsipqoVeHsyEpfvHdvTz2TQv3QdHiY=;
        b=mcBp26R5P2IbRLrQFkJxzV70xh9vzgGImsElI9UYP6bgS9ZVxdxUivjB4yuKUVGmMo
         7E/vf4cQtPY1Ei6sHxXzWq1Ql1x8VFc9Wdu8NaeHJW6uqipxyvBMcpBDu9lYEPHBTF4h
         n/oWDq2OdXWk+0Y7f/svKYZFrB9L7Q087a7wEWkqpHM7Yp7R4MvgyFWvL1VVyhF5/17x
         iZrZs8GHhWelFfXY4gNJK+BmwWaP7Rx86XuKs8GLp3xyIhDZeJ81yFYs6pu7lySLkwQ/
         OzAUTjye1KtpqTcdeml4ofK+8vjfLFF22QVew4BdZhD75zSXbSqJozsHWy0D/OnoiUwg
         6fCQ==
X-Gm-Message-State: AOJu0Yy3MoyjMRMcmvJnqaKc3lH5wb3mSPARRw4RA02f6MLr4PmwZc9R
	koYfMmhihd8TQHPEqWErJXFVlnC5JcxwJaXPpdFzdNNUj5lb6Bn/DjsfaVP1adrfNYV7wRnzAXs
	poEtUnUwK123vIryZD0hzoSV28EK7406gmTYaOuY3Th18EVRUvC1DELz+gtM91HMOz62y8Bw9Vn
	+sZPhUwxOIg3n1TBH82YN1nMrhuFME2gChNQ==
X-Received: by 2002:a17:90a:9314:b0:2bd:d877:cf7a with SMTP id 98e67ed59e1d1-2bdd877d04dmr3282081a91.14.1716476181496;
        Thu, 23 May 2024 07:56:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFT2yAKtGYxU1mR4ULL9wCihpWgHMb/mbJZDvtEbdszfjCURfg0FxaIQaBXjhHs71hGUrmAbHocjVqhQc2PNMw=
X-Received: by 2002:a17:90a:9314:b0:2bd:d877:cf7a with SMTP id
 98e67ed59e1d1-2bdd877d04dmr3282065a91.14.1716476181160; Thu, 23 May 2024
 07:56:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240522085056.54818-1-xni@redhat.com> <20240522085056.54818-5-xni@redhat.com>
In-Reply-To: <20240522085056.54818-5-xni@redhat.com>
From: Xiao Ni <xni@redhat.com>
Date: Thu, 23 May 2024 22:56:10 +0800
Message-ID: <CALTww2-+-1=0oBR8NyRFE74dpgY4+KVtJojzxP6APRUHhwh1yA@mail.gmail.com>
Subject: Re: [PATCH 04/19] mdadm/tests: test enhance
To: mariusz.tkaczyk@linux.intel.com
Cc: linux-raid@vger.kernel.org, heinzm@redhat.com, ncroxon@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 22, 2024 at 4:51=E2=80=AFPM Xiao Ni <xni@redhat.com> wrote:
>
> There are two changes.
> First, if md module is not loaded, it gives error when reading
> speed_limit_max. So read the value after loading md module which
> is done in do_setup
>
> Second, sometimes the test reports error sync action doesn't
> happen. But dmesg shows sync action is done. So limit the sync
> speed before test. It doesn't affect the test run time. Because
> check wait sets the max speed before waiting sync action. And
> recording speed_limit_max/min in do_setup.
>
> Fixes: 4c12714d1ca0 ('test: run tests on system level mdadm')
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  test          | 10 +++++-----
>  tests/func.sh | 26 +++++++++++++++++++++++---
>  2 files changed, 28 insertions(+), 8 deletions(-)
>
> diff --git a/test b/test
> index 338c2db44fa7..ff403293d60b 100755
> --- a/test
> +++ b/test
> @@ -6,7 +6,10 @@ targetdir=3D"/var/tmp"
>  logdir=3D"$targetdir"
>  config=3D/tmp/mdadm.conf
>  testdir=3D$PWD/tests
> -system_speed_limit=3D`cat /proc/sys/dev/raid/speed_limit_max`
> +system_speed_limit_max=3D0
> +system_speed_limit_min=3D0
> +test_speed_limit_min=3D100
> +test_speed_limit_max=3D500
>  devlist=3D
>
>  savelogs=3D0
> @@ -39,10 +42,6 @@ ctrl_c() {
>         ctrl_c_error=3D1
>  }
>
> -restore_system_speed_limit() {
> -       echo $system_speed_limit > /proc/sys/dev/raid/speed_limit_max
> -}
> -
>  mdadm() {
>         rm -f $targetdir/stderr
>         case $* in
> @@ -103,6 +102,7 @@ do_test() {
>                 do_clean
>                 # source script in a subshell, so it has access to our
>                 # namespace, but cannot change it.
> +               control_system_speed_limit

It controls the system speed here. You can see
restore_system_speed_limit in the source code. It was added in
4c12714d1ca06533fe7a887966df2558fd2f96b2


>                 echo -ne "$_script... "
>                 if ( set -ex ; . $_script ) &> $targetdir/log
>                 then
> diff --git a/tests/func.sh b/tests/func.sh
> index b474442b6abe..221cff158f8c 100644
> --- a/tests/func.sh
> +++ b/tests/func.sh
> @@ -136,6 +136,23 @@ check_env() {
>         fi
>  }
>
> +record_system_speed_limit() {
> +       system_speed_limit_max=3D`cat /proc/sys/dev/raid/speed_limit_max`
> +       system_speed_limit_min=3D`cat /proc/sys/dev/raid/speed_limit_min`
> +}
> +
> +# To avoid sync action finishes before checking it, it needs to limit
> +# the sync speed
> +control_system_speed_limit() {
> +       echo $test_speed_limit_min > /proc/sys/dev/raid/speed_limit_min
> +       echo $test_speed_limit_max > /proc/sys/dev/raid/speed_limit_max
> +}
> +
> +restore_system_speed_limit() {
> +       echo $system_speed_limit_min > /proc/sys/dev/raid/speed_limit_max
> +       echo $system_speed_limit_max > /proc/sys/dev/raid/speed_limit_max
> +}
> +
>  do_setup() {
>         trap cleanup 0 1 3 15
>         trap ctrl_c 2
> @@ -214,6 +231,7 @@ do_setup() {
>         ulimit -c unlimited
>         [ -f /proc/mdstat ] || modprobe md_mod
>         echo 0 > /sys/module/md_mod/parameters/start_ro
> +       record_system_speed_limit

And it records the system speed here.

Best Regards
Xiao

>  }
>
>  # check various things
> @@ -265,15 +283,17 @@ check() {
>                 fi
>         ;;
>         wait )
> -               p=3D`cat /proc/sys/dev/raid/speed_limit_max`
> -               echo 2000000 > /proc/sys/dev/raid/speed_limit_max
> +               min=3D`cat /proc/sys/dev/raid/speed_limit_min`
> +               max=3D`cat /proc/sys/dev/raid/speed_limit_max`
> +               echo 200000 > /proc/sys/dev/raid/speed_limit_max
>                 sleep 0.1
>                 while grep -Eq '(resync|recovery|reshape|check|repair) *=
=3D' /proc/mdstat ||
>                         grep -v idle > /dev/null /sys/block/md*/md/sync_a=
ction
>                 do
>                         sleep 0.5
>                 done
> -               echo $p > /proc/sys/dev/raid/speed_limit_max
> +               echo $min > /proc/sys/dev/raid/speed_limit_min
> +               echo $max > /proc/sys/dev/raid/speed_limit_max
>         ;;
>         state )
>                 grep -sq "blocks.*\[$2\]\$" /proc/mdstat ||
> --
> 2.32.0 (Apple Git-132)
>
>

