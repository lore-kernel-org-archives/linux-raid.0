From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] block: make sure FSEQ_DATA request has the same rq_disk
 as the original
Date: Fri, 03 Sep 2010 13:42:13 +0200
Message-ID: <4C80DF15.20100@kernel.org>
References: <1283162296-13650-1-git-send-email-tj@kernel.org> <1283162296-13650-5-git-send-email-tj@kernel.org> <20100830132836.GB5283@redhat.com> <4C7BB932.1070405@kernel.org> <4C7BD202.4040700@kernel.org> <4C7DFD8F.6070200@ct.jp.nec.com> <4C7FE251.2020003@kernel.org> <4C808BF8.7060402@ct.jp.nec.com> <4C80C0D6.4030405@kernel.org> <4C80CDC6.8060100@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C80CDC6.8060100@ct.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: Mike Snitzer <snitzer@redhat.com>, jaxboe@fusionio.com, j-nomura@ce.jp.nec.com, jamie@shareable.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de
List-Id: linux-raid.ids

Hello,

On 09/03/2010 12:28 PM, Kiyoshi Ueda wrote:
> Thank you for pointing it.
> Yes, the interface should also set rq->q.
> 
> About the naming of the interface, blk_set_<something> sounds
> reasonable to me.
> But does blk_set_rq_q() take request and queue as arguments?
> Then, I'm afraid we can't find bdev for bio from given queue.

Oh, right.  Maybe blk_set_rq_bdev() then?

Thanks.

-- 
tejun
