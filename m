From: jes.sorensen@gmail.com
Subject: Re: [PATCH 3/4] mdadm/Create:declaring an existing struct within same function
Date: Wed, 05 Apr 2017 11:47:36 -0400
Message-ID: <wrfjzifudffr.fsf@gmail.com>
References: <20170401125145.14440-1-zlliu@suse.com>
        <20170401125145.14440-4-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170401125145.14440-4-zlliu@suse.com> (Zhilong Liu's message of
        "Sat, 1 Apr 2017 20:51:44 +0800")
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Zhilong Liu <zlliu@suse.com> writes:
> Create:declaring 'struct stat stb' twice within the same
> function, rename stb as stb2 when declares 'struct stat'
> at the second time.
>
> Signed-off-by: Zhilong Liu <zlliu@suse.com>
> ---
>  Create.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)

Applied!

Thanks,
Jes
