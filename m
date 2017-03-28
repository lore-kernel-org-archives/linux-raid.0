From: jes.sorensen@gmail.com
Subject: Re: [PATCH v1] mdadm/Build:check the level parameter when build new array
Date: Tue, 28 Mar 2017 14:27:01 -0400
Message-ID: <wrfjinmtfea2.fsf@gmail.com>
References: <wrfjshlyidnx.fsf@gmail.com>
        <20170328135227.6081-1-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170328135227.6081-1-zlliu@suse.com> (Zhilong Liu's message of
        "Tue, 28 Mar 2017 21:52:27 +0800")
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Zhilong Liu <zlliu@suse.com> writes:
> check if user forgets to specify the --level
> when build a new array. such as:
> ./mdadm -B /dev/md0 -n2 /dev/loop[0-1]
>
> Signed-off-by: Zhilong Liu <zlliu@suse.com>
> ---
>  Build.c | 4 ++++
>  1 file changed, 4 insertions(+)

Applied!

Thanks,
Jes
