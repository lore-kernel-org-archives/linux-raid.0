Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29BF8146A85;
	Mon, 10 Jun 2024 17:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718040971; cv=none; b=O7e7Ml2B/ag+dM3AtiefuSyAclm8xGgPPW8MabwE48/RUNN8dvabHRf9FAmt5MeJ/p8URJATSjsaocYQNnJV3753xn1TsQKJfwezCKeWvqONAO3fhwMPkvs3Y7tL2FwTzS7sRjx6aq7JU4nt1x7p58bdlu3wpleq6bd91VdUYNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718040971; c=relaxed/simple;
	bh=RpbmXndHJoXl3SlguVLnsaEn/mZZ/EfBgJrAofv9UJg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XrVBojAaU2MpIZWGDm36lEUA2GHj8/vCOq+IBS9TXzvLmwmkCn5UOViznCaiDYoADdqwQ5nTyUjvkU0t3TS6yUbrGKHnZH9+h5ll6R5bt1jdgTd6TVxbh63mJfZ+aLT825t1MdViaxCGYiGfQ+iigBkC1ihYWnEbbbtjAyWoz7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SlR55hcP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SlR55hcP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A87A3C4AF1A;
	Mon, 10 Jun 2024 17:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718040970;
	bh=RpbmXndHJoXl3SlguVLnsaEn/mZZ/EfBgJrAofv9UJg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=SlR55hcP8LrDzbTWKjBbz+lXT4DRX+LBTHKynKlVM35BsnmEpZ5tAEBQSQmuhoqXd
	 R0o7LIKbqEa5dy9MBMZWmoupp7jrwV+99ysyRqnEXEcJ6wVxNviL6u8QrkCLLl4FEA
	 vwOETgouukNUwgq0JOuq4fkTQUd4wsM/Jltk5ppnC0IF6hoBLMySrzu/63c5nuda+s
	 FgdjzoZ9IgdaIrOOzmZvNGKqGx4myrMM0bQCPMRKrIBfToV5iSJFJ76tBxfQuvuLT/
	 1s1QxXlWxuTall47DrW/BhSPzUQuKSicF6b4XXqVBxMGSLA6GDjnt+FCFnQWjhOz1U
	 14iXLNyuIuyQw==
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2e78fe9fc2bso67213421fa.3;
        Mon, 10 Jun 2024 10:36:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWbLY3yq1is8kKNKQD6lDtTVn61O2H3Ik84Qe/Y4CFGjo7hEeOOwQUbPchQPA/uKx5s8POfN6syw9MK+x6N/7fojxp9xQ8nn0cyneHa
X-Gm-Message-State: AOJu0Ywa0wtutvdY+HAPP71cHnq18MwuwCg8fVluamRfcPBfSUHZZL6C
	sxcBl7zEB9zmo8f/PmaXDjDRGuQClJudozGseGvA9tp7gW13TPJXtJfLMhiY7sGcFRwmedLjFc0
	DBtMKMTbx0EKznQpwf3o/WhOi8oM=
X-Google-Smtp-Source: AGHT+IHKImW/r87B7AguekV84AH/VQm9GeY3xw5nAWreXqk6nEvsypEgOSR3wcoLjO/JvlBu8Tfr8iQJsfPcxNBcrwE=
X-Received: by 2002:a2e:b0f6:0:b0:2eb:d4b0:6ed8 with SMTP id
 38308e7fff4ca-2ebd4b073d2mr39323531fa.36.1718040969068; Mon, 10 Jun 2024
 10:36:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240508092053.1447930-1-linan666@huaweicloud.com>
In-Reply-To: <20240508092053.1447930-1-linan666@huaweicloud.com>
From: Song Liu <song@kernel.org>
Date: Mon, 10 Jun 2024 10:35:57 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7Q9=wu1EM2DAQS4Xw6Ja5YcJppCwe2=+RnXEO7wSVf4w@mail.gmail.com>
Message-ID: <CAPhsuW7Q9=wu1EM2DAQS4Xw6Ja5YcJppCwe2=+RnXEO7wSVf4w@mail.gmail.com>
Subject: Re: [PATCH] md: do not delete safemode_timer in mddev_suspend
To: linan666@huaweicloud.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, 
	yukuai3@huawei.com, yi.zhang@huawei.com, houtao1@huawei.com, 
	yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 8, 2024 at 2:31=E2=80=AFAM <linan666@huaweicloud.com> wrote:
>
> From: Li Nan <linan122@huawei.com>
>
> The deletion of safemode_timer in mddev_suspend() is redundant and
> potentially harmful now. If timer is about to be woken up but gets
> deleted, 'in_sync' will remain 0 until the next write, causing array
> to stay in the 'active' state instead of transitioning to 'clean'.
>
> Commit 0d9f4f135eb6 ("MD: Add del_timer_sync to mddev_suspend (fix
> nasty panic))" introduced this deletion for dm, because if timer fired
> after dm is destroyed, the resource which the timer depends on might
> have been freed.
>
> However, commit 0dd84b319352 ("md: call __md_stop_writes in md_stop")
> added __md_stop_writes() to md_stop(), which is called before freeing
> resource. Timer is deleted in __md_stop_writes(), and the origin issue
> is resolved. Therefore, delete safemode_timer can be removed safely now.
>
> Signed-off-by: Li Nan <linan122@huawei.com>

Applied to md-6.11. Thanks!

Song
