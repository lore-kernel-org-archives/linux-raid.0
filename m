From: Ming Lei <ming.lei@canonical.com>
Subject: Re: [PATCH] MD: make bio mergeable
Date: Tue, 26 Apr 2016 23:17:57 +0800
Message-ID: <CACVXFVO02xNNsTXy1QNM1TYQ+rxC9or6H-FfAtTiaGsZV6WYkw@mail.gmail.com>
References: <384a0e0c7d6f2700aadbcbdef003cece88fa7dd7.1461626533.git.shli@fb.com>
	<CACVXFVMgKQmtKRQvkpyD5GMh0AN0i7uNyq8ecVvQQ5kmdLEm+A@mail.gmail.com>
	<571F7961.4090703@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <571F7961.4090703@kernel.dk>
Sender: stable-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Shaohua Li <shli@fb.com>, linux-block@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>, Ju Hyung Park <qkrwngud825@gmail.com>, FB Kernel Team <Kernel-team@fb.com>, "v4.3+" <stable@vger.kernel.org>, Jens Axboe <axboe@fb.com>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

On Tue, Apr 26, 2016 at 10:21 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 04/26/2016 03:56 AM, Ming Lei wrote:
>>
>> On Tue, Apr 26, 2016 at 7:52 AM, Shaohua Li <shli@fb.com> wrote:
>>>
>>> blk_queue_split marks bio unmergeable, which makes sense for normal bio.
>>> But if dispatching the bio to underlayer disk, the blk_queue_split
>>> checks are invalid, hence it's possible the bio becomes mergeable.
>>
>>
>> If the bio from md is splitted and marked as NOMERGE, it means some
>> queue limits are reached. So looks the raid's queue limit is set as not
>> big enough, could your find which limit causes the splitting and nomerge?
>
>
> raid0 sets a limit of the stripe size for IO. Once the IO has passed md,
> there's no reason why we can't merge for the lower driver. This is
> (potentially) a huge performance issue on trim, since a lot of devices are
> trim ops / sec limited rather than throughput limited.

Just found raid0 maps the chunk sectors into max hw sectors of queue,
and dm uses blk_stack_limits() to set up the limits.

So looks a raid specific issue, then the fix is correct, sorry for the noise.

thanks,
Ming
