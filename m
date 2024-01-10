Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F30B4D11D
	for <linux-raid@vger.kernel.org>; Wed, 10 Jan 2024 17:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UuSWaWQO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19B33C433B1
	for <linux-raid@vger.kernel.org>; Wed, 10 Jan 2024 17:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704908542;
	bh=0zn8VgEQuJIF75bE3Da97oYKibdDBqt7Yk1Hro5f/M8=;
	h=From:Date:Subject:To:From;
	b=UuSWaWQOf/Si5bXhVZkMqEakglc3RjHFc3lb+JA+g1pQ0n1BsBEunoYIAWLKDbf3q
	 dq1lUOlzjd7kr9dR9sycNx0yklPqgZCuQgYWlgqFbAPzjNrnMXbecrn4XQk80JoC8W
	 Rz/aCdL/3ePQ8o8HID+ONbQyovA0w7K6Eq5lEeaVRVrmJZ8yn0VFzk7hbYhNSpFaWz
	 TyHzql0UaoFzaYICBi3+pO1oZ4Y3A/KzZPw5wXenql2laMfiAmQnr+tNgNYuEq2oy9
	 uWy194bOPy7KIDCpO8l0LyLy//4DjWukgZdUfzr/K9OboX25ntDaffM3f9zGjTlt8R
	 xTv2/gOfUoJgA==
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-50eaaf2c7deso4772753e87.2
        for <linux-raid@vger.kernel.org>; Wed, 10 Jan 2024 09:42:22 -0800 (PST)
X-Gm-Message-State: AOJu0Yzw15fdDAnq1mIXFvymuky/N5L8ULoLNORD1ehXtVMeSAyzKiAy
	psx+5Rnxo1GW1L3n9mdOL/eybEK5EN9mHJvyUGg=
X-Google-Smtp-Source: AGHT+IH5Pl0g5KevxTG5+v5NMlbT1kJNjGzfj3HeqNten4W/BL76ajXBvnDb+SzTAyRZu2bJakpY5cg48hLj9k+5ZHI=
X-Received: by 2002:ac2:5049:0:b0:50e:afc5:b251 with SMTP id
 a9-20020ac25049000000b0050eafc5b251mr637618lfm.93.1704908540154; Wed, 10 Jan
 2024 09:42:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Song Liu <song@kernel.org>
Date: Wed, 10 Jan 2024 09:42:08 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5YspxV-xhYdGF7HUVw=o_2PbJXMH45Y1fYRDymD8-Cqw@mail.gmail.com>
Message-ID: <CAPhsuW5YspxV-xhYdGF7HUVw=o_2PbJXMH45Y1fYRDymD8-Cqw@mail.gmail.com>
Subject: Changes in md branch management
To: linux-raid <linux-raid@vger.kernel.org>, "yukuai (C)" <yukuai3@huawei.com>, 
	Yu Kuai <yukuai1@huaweicloud.com>, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"

In the past, we managed the md patches in two branches: md-next and md-fixes.
This approach has a few issues:
1. It is not very clear which upstream version a patch will land in;
2. Around the merge window, there is no good base for md-next.

We will try to solve these issues with a new approach:
1. We will use numbered branches like md-6.9. Patches applied to the numbered
   branches are planned to land in the numbered upstream release. Git commit
   hash in these numbered branches should be the same as their final hash.
2. When there is no good base for the next numbered branch, which is usually
   after previous rc7 and before the next rc2, accepted patches will
be applied to
   md-tmp branch. These patches are expected to be cherry-picked later to a
   numbered branch, so the git commit hash may change.

Please let me know if you have comments and suggestions with this approach.

Thanks,
Song
