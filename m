Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB8D19F421;
	Thu,  9 Jan 2025 07:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736407691; cv=none; b=h8B11RGRi2IpUN6uF7iyhxhhD/oCrUErJynLat1NPRNhyYOQyHiZJ8VHWQkJyNcdvs+k6qWOORTY1Aw877KRaz4J7LDRo67A42o4tVAW0qa4MK+vupuq4n1sl8esfsHIxleGqw3mNS8Mbb7PocYv7X/+rrIWMYgBCKWt+Oxq/98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736407691; c=relaxed/simple;
	bh=Of3jHJucusha32g6tVsUgWuqcr+lWCeTLo+NZzTjZpM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uANWNMmrJikKjaWse5o0Xvgi7lmDUhhSVABsh4/l8aGAS2tnCpQaYi9zGLgxl48Pl1kQsmZtoH0AKamxg2H2NvZEwLEYyuB28yk2D4yjR5Hfz2sqKNGhqDIo01qt6JlH6ICt4rWTo8moFTrNNOpMWJuvUUW3qyWP95XPMyreeJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Min6a2/m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Min6a2/m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4907BC4CED2;
	Thu,  9 Jan 2025 07:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736407691;
	bh=Of3jHJucusha32g6tVsUgWuqcr+lWCeTLo+NZzTjZpM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Min6a2/mW9zBCyFtd1RXH3wSbXdDVbJLlLZFdEWZJmY9k1bD04ELqTL+Day82dp8I
	 bQxa8FHURR5/jFuKhp2FFzCYoB6EmrVE/2Vu8dCwmbFsmnFX5LbDtKvp/2pK++hRNR
	 OM4VjyYUQS9Alc0MLQ/kOvphfXJ+9ePwoJwDnMdBoq9Qqm+knRzjVd9PavfUs+WZON
	 BKf9OH9Xx1ZCy0B+LBdKtIVH1bxDgvB8GTJA2ArBBTBxupgnJXJZ2YHqC1+iIQek8s
	 U7I78kWPoDIj151oqD25CcnXQehzehHUu4l1VVwQaPntfuWJw2iUZ2VtrV2nRWQcS7
	 JDvNGC6XpOfjA==
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-844d555491eso16915139f.0;
        Wed, 08 Jan 2025 23:28:11 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUibQEh2TlupJAllKTYkLoR30YOLagm7LtQBS6ZNLRwbDY9H3eY8oGBkQuHVlM+XSWMz0Gk/fp7n3Ga@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1geYULsycUk9CJH+ZAH7cK0e8Pm41cph6iajwKMA+thYqhAAF
	/TpKt0xz604k/+ZO3htgfoOCgOoL3aNoGEoikL1A0m6sy2dEwkOnk8YuEdunMgjCrOYHTwc/1WK
	ORWaLvUbM+/bYqhs28KBW0DxoH7U=
X-Google-Smtp-Source: AGHT+IFxCjc79oxvgeCeQKPy1Ai4QlkYQRvVB3Jz5ZI1qcv5EX7LUW+KKZ2LLanxsK69027ViwHmTY4cy/BCP3cF1lA=
X-Received: by 2002:a05:6e02:160e:b0:3a7:c5b1:a55f with SMTP id
 e9e14a558f8ab-3ce3a893945mr45995285ab.0.1736407690664; Wed, 08 Jan 2025
 23:28:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250109063444.865682-1-dungeonlords789@naver.com>
In-Reply-To: <20250109063444.865682-1-dungeonlords789@naver.com>
From: Song Liu <song@kernel.org>
Date: Wed, 8 Jan 2025 23:27:59 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6C+emJKBfe6qhCBwyXtA14xAbe+p8MGGOsGvj9pqmv_Q@mail.gmail.com>
X-Gm-Features: AbW1kva9yrdnbIggo7TSKwGFcgkSD2IJBU8aROGyPGc8hWSoXkv6G5RdLLKEns4
Message-ID: <CAPhsuW6C+emJKBfe6qhCBwyXtA14xAbe+p8MGGOsGvj9pqmv_Q@mail.gmail.com>
Subject: Re: [PATCH 1/1] md: Fix typo in comment
To: Cherniaev Andrei <dungeonlords789@naver.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, 
	yukuai3@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 8, 2025 at 10:44=E2=80=AFPM Cherniaev Andrei
<dungeonlords789@naver.com> wrote:
>
> Signed-off-by: Cherniaev Andrei <dungeonlords789@naver.com>
> ---
>  include/uapi/linux/raid/md_p.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/include/uapi/linux/raid/md_p.h b/include/uapi/linux/raid/md_=
p.h
> index 5a43c23f53bf..36a3394e5066 100644
> --- a/include/uapi/linux/raid/md_p.h
> +++ b/include/uapi/linux/raid/md_p.h
> @@ -76,10 +76,10 @@
>  #define MD_DISK_SYNC           2 /* disk is in sync with the raid set */
>  #define MD_DISK_REMOVED                3 /* disk is in sync with the rai=
d set */
>  #define MD_DISK_CLUSTER_ADD     4 /* Initiate a disk add across the clus=
ter
> -                                  * For clustered enviroments only.
> +                                  * For clustered environments only.
>                                    */
>  #define MD_DISK_CANDIDATE      5 /* disk is added as spare (local) until=
 confirmed
> -                                  * For clustered enviroments only.
> +                                  * For clustered environments only.
>                                    */

These "fixes" are not necessary.

Song
