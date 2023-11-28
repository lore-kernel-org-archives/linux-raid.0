Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94EE7D27B
	for <linux-raid@vger.kernel.org>; Tue, 28 Nov 2023 03:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a0o6bTTt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26702C433CA;
	Tue, 28 Nov 2023 03:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701143426;
	bh=rUzlbwnwEjMuYJ5IqzIor5c2caIY5fV4IWy4R8Nuxks=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=a0o6bTTtfgxVYFWoheHsb4monVNkuJFNFdx+rPAXE6EUCydIiMCzu+xGAzoNeLzTL
	 m3adAo/l1QwzyaUjTMgFXzwOh34ERD8kmjMxFPt5Ihlfgu4T+YLGjMIW/5RBlJJ6nT
	 sZXvtK+jtAc+viWZuxV484q2SKbTv+8Dxzq7hBoahpAemIU3asd4JDJawZHzouagkz
	 tDme3LWxBudMQ9U24510F2VZdA7xFReUQuX8JgF8zGBZ4xtOcKYLB+eTAA+r8Wyq0Z
	 MJkXiKPrRHNvsWJLsBMWLnVGTJg3JSN7e3VV4WRPLHM3inDoE/+VV7qEEzAUvyuOGj
	 aTHs+HqPyh0gg==
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-50a6ff9881fso7590248e87.1;
        Mon, 27 Nov 2023 19:50:26 -0800 (PST)
X-Gm-Message-State: AOJu0Yz9GiPzXqdAbkOPcJRV8+Vg8ycGjKOkiKicFJVE1mMn++FVtin9
	WMvnNtPgyV1NIDDWRpiWvKqRwGzZ++PUuCk86/Y=
X-Google-Smtp-Source: AGHT+IGDjBDlrqSWJXvdZnc0hDl+kIlfgezKloDDV2IGGYQWZx5FTf4ga8MR7D433aE3JaPLuWUwNldnUauCbhc3Gmw=
X-Received: by 2002:a05:651c:3d1:b0:2c9:a274:a511 with SMTP id
 f17-20020a05651c03d100b002c9a274a511mr3716655ljp.43.1701143424266; Mon, 27
 Nov 2023 19:50:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231125081604.3939938-1-yukuai1@huaweicloud.com>
In-Reply-To: <20231125081604.3939938-1-yukuai1@huaweicloud.com>
From: Song Liu <song@kernel.org>
Date: Mon, 27 Nov 2023 19:50:12 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4sSVBiicnDY_3MTznNkJjrdL8mpDXyJpXLOt_eBybcgw@mail.gmail.com>
Message-ID: <CAPhsuW4sSVBiicnDY_3MTznNkJjrdL8mpDXyJpXLOt_eBybcgw@mail.gmail.com>
Subject: Re: [PATCH -next v3 0/5] md: remove rcu protection to access rdev
 from conf
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, 
	yukuai3@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 25, 2023 at 12:16=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> =
wrote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> Changes in v3:
>  - remove patch 1 from v2, and since all the print_conf() is called
>  while 'reconfig_mutex' is held, it's safe to remove
>  rcu_read_lock/unlock() directly.
>  - remove the definition of flag RemoveSynchronized;

Applied v3 to md-next. Thanks!

Song
