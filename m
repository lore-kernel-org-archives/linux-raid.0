Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC211400F
	for <linux-raid@vger.kernel.org>; Thu,  7 Dec 2023 18:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XZtEUJFT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCAD5C433CA;
	Thu,  7 Dec 2023 18:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701973491;
	bh=TFDAjpdgkNrVFuP09kuXa8cBSyHPUJTONtfHhK5KAF8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=XZtEUJFTAvCj6DyX8vxVXxTjD5YjJ/WJrcxDNUlcnRBSEJ1JMExugTaMAGNMLVc47
	 Z3GncuUjyCxD4TA7GawunDxij0Xdj1rEj4xQHu8b8AiCutMq9lSC1vKVlXnKrLoOhO
	 S1Bt/wSB9E2CxdhsserdsWWpU6cr8MxZvlzwRoWgU7X/lbidD5RF599dM2j/K2m7FU
	 HC6I7W12faHc7VDui71Jh3aYlEk3eSp2V5Uqw2PDT34LrRDC68hzTpJx1dXo0lu1Jc
	 Fa/4if7JKV4o4QBYscpYFe2JGOo9eNLL9JTk91SSTIYTTZIDejApdAnsbHNr3WcKzG
	 OjbCPuYftSBrg==
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-50bef9b7a67so1245256e87.1;
        Thu, 07 Dec 2023 10:24:51 -0800 (PST)
X-Gm-Message-State: AOJu0YwSeAnGK8UccDsEb6Yjse1ddZGlFBV2VhMT+9VjzsJBTN9r6vei
	3O2q55DoARvhQqysxXptrpTz/aNZFRKp7pLeo8E=
X-Google-Smtp-Source: AGHT+IGlmRYc4vXht3q8KHvwAnFI8GwVfUHZY9n0Bl9Rz2Y6kSVhoStUxO2W1P9bVc814rM4Xz3nvq1SNWHBqHlez2o=
X-Received: by 2002:ac2:5634:0:b0:50b:f302:5e40 with SMTP id
 b20-20020ac25634000000b0050bf3025e40mr1568105lff.34.1701973490061; Thu, 07
 Dec 2023 10:24:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231207020724.2797445-1-yukuai1@huaweicloud.com>
In-Reply-To: <20231207020724.2797445-1-yukuai1@huaweicloud.com>
From: Song Liu <song@kernel.org>
Date: Thu, 7 Dec 2023 10:24:38 -0800
X-Gmail-Original-Message-ID: <CAPhsuW65GoX1Sewndu9ViUYTCKgLxy-VhbPkkXPBO6P2g-1UrQ@mail.gmail.com>
Message-ID: <CAPhsuW65GoX1Sewndu9ViUYTCKgLxy-VhbPkkXPBO6P2g-1UrQ@mail.gmail.com>
Subject: Re: [PATCH v2] md: split MD_RECOVERY_NEEDED out of mddev_resume
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: yukuai3@huawei.com, pmenzel@molgen.mpg.de, janpieter.sollie@edpnet.be, 
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, 
	yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 6, 2023 at 6:08=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> wr=
ote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> New mddev_resume() calls are added to synchronize IO with array
> reconfiguration, however, this introduces a performance regression while
> adding it in md_start_sync():
>
> 1) someone sets MD_RECOVERY_NEEDED first;
> 2) daemon thread grabs reconfig_mutex, then clears MD_RECOVERY_NEEDED and
>    queues a new sync work;
> 3) daemon thread releases reconfig_mutex;
> 4) in md_start_sync
>    a) check that there are spares that can be added/removed, then suspend
>       the array;
>    b) remove_and_add_spares may not be called, or called without really
>       add/remove spares;
>    c) resume the array, then set MD_RECOVERY_NEEDED again!
>
> Loop between 2 - 4, then mddev_suspend() will be called quite often, for
> consequence, normal IO will be quite slow.
>
> Fix this problem by don't set MD_RECOVERY_NEEDED again in md_start_sync()=
,
> hence the loop will be broken.
>
> Fixes: bc08041b32ab ("md: suspend array in md_start_sync() if array need =
reconfiguration")
> Suggested-by: Song Liu <song@kernel.org>
> Reported-by: Janpieter Sollie <janpieter.sollie@edpnet.be>
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=3D218200
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>

Thanks for the fix! I added a comment and applied it to md-fixes.

Song
