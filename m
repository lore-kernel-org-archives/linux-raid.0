From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] MD: make bio mergeable
Date: Mon, 25 Apr 2016 18:59:02 -0600
Message-ID: <571EBD56.7010204@kernel.dk>
References: <384a0e0c7d6f2700aadbcbdef003cece88fa7dd7.1461626533.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <384a0e0c7d6f2700aadbcbdef003cece88fa7dd7.1461626533.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc: qkrwngud825@gmail.com, Kernel-team@fb.com, "v4.3+" <stable@vger.kernel.org>, Ming Lei <ming.lei@canonical.com>, Jens Axboe <axboe@fb.com>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

On 04/25/2016 05:52 PM, Shaohua Li wrote:
> blk_queue_split marks bio unmergeable, which makes sense for normal bio.
> But if dispatching the bio to underlayer disk, the blk_queue_split
> checks are invalid, hence it's possible the bio becomes mergeable.
>
> In the reported bug, this bug causes trim against raid0 performance slash
> https://bugzilla.kernel.org/show_bug.cgi?id=117051

Good catch! Will apply for this series, thanks Shaohua.

-- 
Jens Axboe

