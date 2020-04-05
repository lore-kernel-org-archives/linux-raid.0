From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: Re: [PATCH] raid5: use memalloc_noio_save()/restore in
 resize_chunks()
Date: Sun, 5 Apr 2020 17:53:08 +0200
Message-ID: <fa7e30b9-7480-6c03-0f43-d561fed912fb@cloud.ionos.com>
References: <20200402081312.32709-1-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200402081312.32709-1-colyli@suse.de>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, songliubraving@fb.com
Cc: linux-raid@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>, Michal Hocko <mhocko@suse.com>
List-Id: linux-raid.ids

On 02.04.20 10:13, Coly Li wrote:
> -	scribble = kvmalloc_array(cnt, obj_size, flags);
> +	scribble = kvmalloc_array(cnt, obj_size, GFP_KERNEL);

Maybe it is simpler to call kvmalloc_array between memalloc_noio_save 
and memalloc_noio_restore.
And seems sched/mm.h need to be included per the report from LKP.

Thanks,
Guoqing
