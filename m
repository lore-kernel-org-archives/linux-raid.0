From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: Re: hung-task panic in raid5_make_request
Date: Mon, 13 Jan 2020 12:10:47 +0100
Message-ID: <2a9e8231-c5e2-8f63-2fc4-bed24fc21959@cloud.ionos.com>
References: <CAGRgLy4Yi1HNqNO0MLq5xjRRgWe7EaByRYF5sA3fFVa1tmpNvA@mail.gmail.com>
 <09e8a682-3f91-6b34-58a0-235dbb130901@cloud.ionos.com>
 <CAGRgLy4netkysnF6CS2MkVBp17ipZr5D4Z4wQ6B0w2XXg51OkQ@mail.gmail.com>
 <CAGRgLy6xx5dT0StoiUNLThVknLvNUR5Emc0mEg_dnJmWth3=9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy6xx5dT0StoiUNLThVknLvNUR5Emc0mEg_dnJmWth3=9A@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, liu.song.a23@gmail.com
List-Id: linux-raid.ids

Hi Alex,

On 1/12/20 8:46 AM, Alexander Lyakas wrote:
> Hi Guoqing,
>
> We have tried the proposed patch, but still hit the hung-task panic in
> the same place[1]. How can we debug this further?

Can you print the information (atomic_read(&conf->active_stripes),
conf->max_nr_stripes and conf->cache_state)  just before the
wait_event_lock_irq? Then we can verify which condition is not meet
here. Also pls dump the value of sysfs nodes, something like.

linux:/sys/block/md5/md # find -mindepth 1 -maxdepth 1 -type 
f|sort|xargs -r egrep .


BTW, could you try latest kernel? And is it possible to reproduce the panic?

Thanks,
Guoqing
