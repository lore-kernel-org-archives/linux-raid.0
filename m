From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/2 V1] [PATCH] fs/block-dev.c:fix performance regression
 in O_DIRECT writes to md block devices
Date: Thu, 02 Aug 2012 09:51:27 +0200
Message-ID: <501A317F.40408@kernel.dk>
References: <201207161422001403795@gmail.com>,  <20120717130434.670e51e9@notabene.brown> <201208021448392819731@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <201208021448392819731@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: viro <viro@ZenIV.linux.org.uk>, linux-raid <linux-raid@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

On 08/02/2012 08:48 AM, majianpeng wrote:
> On 2012-07-17 11:04 NeilBrown <neilb@suse.de> Wrote:
>> On Mon, 16 Jul 2012 14:22:03 +0800 majianpeng <majianpeng@gmail.com> wrote:
>>
>>> For regular file, write operaion used blk_plug function.But for block
>>> file,write operation did not use blk_plug.
>>> This patch is also for write-cache mode for block-device.
>>>
>>> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
>>
>> Reviewed-by: NeilBrown <neilb@suse.de>
>>
>> Will you take this Jens?  Though mail to you seem to be bouncing:
>>
>> <axboe@fusionio.com>: host mail.fusionio.com[10.101.1.19] said: 554 5.4.6 Hop
>>    count exceeded - possible mail loop (in reply to end of DATA command)
>>
>> so I'm not sure you'll even see this :-(
>>
>> NeilBrown
>>
>>> ---
>>>  fs/block_dev.c |    3 +++
>>>  1 files changed, 3 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/fs/block_dev.c b/fs/block_dev.c
>>> index c2bbe1f..cf10778 100644
>>> --- a/fs/block_dev.c
>>> +++ b/fs/block_dev.c
>>> @@ -1579,9 +1579,11 @@ ssize_t blkdev_aio_write(struct kiocb *iocb, const struct iovec *iov,
>>>  {
>>>  	struct file *file = iocb->ki_filp;
>>>  	ssize_t ret;
>>> +	struct blk_plug plug;
>>>  
>>>  	BUG_ON(iocb->ki_pos != pos);
>>>  
>>> +	blk_start_plug(&plug);
>>>  	ret = __generic_file_aio_write(iocb, iov, nr_segs, &iocb->ki_pos);
>>>  	if (ret > 0 || ret == -EIOCBQUEUED) {
>>>  		ssize_t err;
>>> @@ -1590,6 +1592,7 @@ ssize_t blkdev_aio_write(struct kiocb *iocb, const struct iovec *iov,
>>>  		if (err < 0 && ret > 0)
>>>  			ret = err;
>>>  	}
>>> +	blk_finish_plug(&plug);
>>>  	return ret;
>>>  }
>>>  EXPORT_SYMBOL_GPL(blkdev_aio_write);
>>
>>
> 
> How about this patch? apply or reject? Thanks!

I've applied it for a bit of testing, then it'll got into 3.6. Thanks.

-- 
Jens Axboe

