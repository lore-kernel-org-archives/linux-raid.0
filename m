From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH UPDATED 4/5] dm: implement REQ_FLUSH/FUA support for request-based
 dm
Date: Fri, 03 Sep 2010 14:46:32 +0900
Message-ID: <4C808BB8.6040005@ct.jp.nec.com>
References: <1283162296-13650-1-git-send-email-tj@kernel.org> <1283162296-13650-5-git-send-email-tj@kernel.org> <20100830132836.GB5283@redhat.com> <4C7BB932.1070405@kernel.org> <4C7BD202.4040700@kernel.org> <4C7DFD8F.6070200@ct.jp.nec.com> <4C7FA531.7060300@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C7FA531.7060300@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Mike Snitzer <snitzer@redhat.com>, jaxboe@fusionio.com, j-nomura@ce.jp.nec.com, jamie@shareable.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de
List-Id: linux-raid.ids

Hi Tejun,

On 09/02/2010 10:22 PM +0900, Tejun Heo wrote:
> On 09/01/2010 09:15 AM, Kiyoshi Ueda wrote:
>>> @@ -2619,9 +2458,8 @@ int dm_suspend(struct mapped_device *md,
>>>  	up_write(&md->io_lock);
>>>
>>>  	/*
>>> -	 * Request-based dm uses md->wq for barrier (dm_rq_barrier_work) which
>>> -	 * can be kicked until md->queue is stopped.  So stop md->queue before
>>> -	 * flushing md->wq.
>>> +	 * Stop md->queue before flushing md->wq in case request-based
>>> +	 * dm defers requests to md->wq from md->queue.
>>>  	 */
>>>  	if (dm_request_based(md))
>>>  		stop_queue(md->queue);
>> 
>> Request-based dm doesn't use md->wq now, so you can just remove
>> the comment above.
> 
> I sure can remove it but md->wq already has most stuff necessary to
> process deferred requests and when someone starts using it, having the
> comment there about the rather delicate ordering would definitely be
> helpful, so I suggest keeping the comment.

OK, makes sense.

Thanks,
Kiyoshi Ueda
