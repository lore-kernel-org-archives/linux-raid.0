From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] MD: make bio mergeable
Date: Tue, 26 Apr 2016 08:21:21 -0600
Message-ID: <571F7961.4090703@kernel.dk>
References: <384a0e0c7d6f2700aadbcbdef003cece88fa7dd7.1461626533.git.shli@fb.com>
 <CACVXFVMgKQmtKRQvkpyD5GMh0AN0i7uNyq8ecVvQQ5kmdLEm+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACVXFVMgKQmtKRQvkpyD5GMh0AN0i7uNyq8ecVvQQ5kmdLEm+A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@canonical.com>, Shaohua Li <shli@fb.com>
Cc: linux-block@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>, qkrwngud825@gmail.com, FB Kernel Team <Kernel-team@fb.com>, "v4.3+" <stable@vger.kernel.org>, Jens Axboe <axboe@fb.com>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

On 04/26/2016 03:56 AM, Ming Lei wrote:
> On Tue, Apr 26, 2016 at 7:52 AM, Shaohua Li <shli@fb.com> wrote:
>> blk_queue_split marks bio unmergeable, which makes sense for normal bio.
>> But if dispatching the bio to underlayer disk, the blk_queue_split
>> checks are invalid, hence it's possible the bio becomes mergeable.
>
> If the bio from md is splitted and marked as NOMERGE, it means some
> queue limits are reached. So looks the raid's queue limit is set as not
> big enough, could your find which limit causes the splitting and nomerge?

raid0 sets a limit of the stripe size for IO. Once the IO has passed md, 
there's no reason why we can't merge for the lower driver. This is 
(potentially) a huge performance issue on trim, since a lot of devices 
are trim ops / sec limited rather than throughput limited.

-- 
Jens Axboe
