From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH] block: make sure FSEQ_DATA request has the same rq_disk
 as the original
Date: Fri, 03 Sep 2010 19:28:22 +0900
Message-ID: <4C80CDC6.8060100@ct.jp.nec.com>
References: <1283162296-13650-1-git-send-email-tj@kernel.org> <1283162296-13650-5-git-send-email-tj@kernel.org> <20100830132836.GB5283@redhat.com> <4C7BB932.1070405@kernel.org> <4C7BD202.4040700@kernel.org> <4C7DFD8F.6070200@ct.jp.nec.com> <4C7FE251.2020003@kernel.org> <4C808BF8.7060402@ct.jp.nec.com> <4C80C0D6.4030405@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C80C0D6.4030405@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Mike Snitzer <snitzer@redhat.com>, jaxboe@fusionio.com, j-nomura@ce.jp.nec.com, jamie@shareable.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de
List-Id: linux-raid.ids

Hi Tejun,

On 09/03/2010 06:33 PM +0900, Tejun Heo wrote:
> On 09/03/2010 07:47 AM, Kiyoshi Ueda wrote:
>> By the way, I had been considering a block-layer interface which remaps
>> struct request and its bios to a block device such as:
>> void blk_remap_request(struct request *rq, struct block_device *bdev)
>> {
>> 	rq->rq_disk = bdev->bd_disk;
>>
>> 	__rq_for_each_bio(bio, rq) {
>> 		bio->bi_bdev = bdev->bd_disk;
>> 	}
>> }
>>
>> If there is such an interface and remapping drivers use it, then these
>> kind of issues may be avoided in the future.
> 
> I think the problem is more with request initialization.  After all,
> once bios are packed into a request, they are (or at least should be)
> just data containers.  We now have multiple request init paths in
> block layer and different ones initialize different subsets and it's
> not very clear which fields are supposed to be initialized to what by
> whom.
> 
> But yeah I agree removing discrepancy between request and bio would be
> nice to have too.  It's not really remapping tho.  Maybe just
> blk_set_rq_q() or something like that (it should also set rq->q)?

Thank you for pointing it.
Yes, the interface should also set rq->q.

About the naming of the interface, blk_set_<something> sounds
reasonable to me.
But does blk_set_rq_q() take request and queue as arguments?
Then, I'm afraid we can't find bdev for bio from given queue.

Thanks,
Kiyoshi Ueda
