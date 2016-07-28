From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] raid5: fix incorrectly counter of
 conf->empty_inactive_list_nr
Date: Wed, 27 Jul 2016 17:19:10 -0700
Message-ID: <20160728001910.GA11266@kernel.org>
References: <CAOOPZo5B8EF0C3+Yg1WVYJx_jerR6zjNjbixpHhvQx4zOJqvxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOOPZo5B8EF0C3+Yg1WVYJx_jerR6zjNjbixpHhvQx4zOJqvxw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhengyuan Liu <liuzhengyuang521@gmail.com>
Cc: linux-raid@vger.kernel.org, =?utf-8?B?5YiY5LqR?= <liuyun01@kylinos.cn>, =?utf-8?B?6IOh5rW3?= <huhai@kylinos.cn>
List-Id: linux-raid.ids

On Wed, Jul 20, 2016 at 05:22:00PM +0800, Zhengyuan Liu wrote:
> The counter conf->empty_inactive_list_nr is only used for determine if
> the raid5 is congested which is deal with in function
> raid5_congested(). It was increased in get_free_stripe() when
> conf->inactive_list got emptied and decreased in
> release_inactive_stripe_list() when  splice temp_inactive_list to
> conf->inactive_list. However, this could cause to problem when
> raid5_get_active_stripe was called, this function may call
> list_del_init(&sh->lru) to delete sh from  "conf->inactive_list +
> hash" which may cause  "conf->inactive_list + hash" to be empty when
> atomic_inc_not_zero(&sh->count) got false.
>  I have found conf->empty_inactive_list_nr to be negative number
> during my random test.
> Is there anything out of my thinking?

Good catch! I think you are right, we get a stripe from inactive list and
should decrement the count. Also we should do the same thing for
stripe_add_to_batch_list. Please resend the patch with proper format, see
Documentation/email-clients.txt

Thanks,
Shaohua
