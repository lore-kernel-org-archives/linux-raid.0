From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC] raid5: add a log device to fix raid5/6 write hole issue
Date: Tue, 31 Mar 2015 20:47:04 -0700
Message-ID: <CAPcyv4jqb+OphP-1sy0dqMYG-uNK-CwtNDmOM4YeQU=MXH72Hw@mail.gmail.com>
References: <20150330222459.GA575371@devbig257.prn2.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150330222459.GA575371@devbig257.prn2.facebook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>, Song Liu <songliubraving@fb.com>, Kernel-team@fb.com
List-Id: linux-raid.ids

On Mon, Mar 30, 2015 at 3:25 PM, Shaohua Li <shli@fb.com> wrote:
> This is my attempt to fix raid5/6 write hole issue, it's not for merge
> yet, I post it out for comments. Any comments and suggestions are
> welcome!
>
> Thanks,
> Shaohua
>
> We expect a completed raid5/6 stack with reliability and high
> performance. Currently raid5/6 has 2 issues:
>
> 1. read-modify-write for small size IO. To fix this issue, a cache layer
> above raid5/6 can be used to aggregate write to full stripe write.
> 2. write hole issue. A write log below raid5/6 can fix the issue.
>
> We plan to use a SSD to fix the two issues. Here we just fix the write
> hole issue.
>
> 1. We don't try to fix the issues together. A cache layer will do write
> acceleration. A log layer will fix write hole. The seperation will
> simplify things a lot.
>
> 2. Current assumption is flashcache/bcache will be used as the cache
> layer. If they don't work well, we can fix them or add a simple cache
> layer for raid write aggregation later. We also assume cache layer will
> absorb write, so log doesn't worry about write latency.

It seems neither bcache nor dm-cache are tackling the write-buffering
problem head on... they still seem to be concerned with some amount of
read caching which I can see as useful for file servers and
workstations, but not necessarily scale out storage.

I'll try to set aside time to take a look at the patch this week.
