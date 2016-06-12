From: Jens Axboe <axboe@fb.com>
Subject: Re: [PATCH] bcache: Remove deprecated create_workqueue
Date: Sat, 11 Jun 2016 20:03:33 -0600
Message-ID: <575CC2F5.2030407@fb.com>
References: <20160607202719.GA16208@Karyakshetra>
 <20160611225202.GD31708@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160611225202.GD31708@htj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, Shaohua Li <shli@kernel.org>, Eric Wheeler <git@linux.ewheeler.net>, Zheng Liu <wenqing.lz@taobao.com>, Hannes Reinecke <hare@suse.de>, Jeff Moyer <jmoyer@redhat.com>, Pekka Enberg <penberg@kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On 06/11/2016 04:52 PM, Tejun Heo wrote:
> On Wed, Jun 08, 2016 at 01:57:19AM +0530, Bhaktipriya Shridhar wrote:
>> alloc_workqueue replaces deprecated create_workqueue().
>>
>> Dedicated workqueues have been used since bcache_wq and moving_gc_wq
>> are workqueues for writes and are being used on a memory reclaim path.
>> WQ_MEM_RECLAIM has been set to ensure forward progress under memory
>> pressure.
>> Since there are only a fixed number of work items, explicit concurrency
>> limit is unnecessary here.
>>
>> Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
>
> Acked-by: Tejun Heo <tj@kernel.org>

Added to 4.8, thanks.

-- 
Jens Axboe
