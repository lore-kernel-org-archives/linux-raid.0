From: Christoph Hellwig <hch@lst.de>
Subject: Re: cleanup the partitioning code
Date: Mon, 23 Mar 2020 18:05:46 +0100
Message-ID: <20200323170546.GA30587@lst.de>
References: <20200312151939.645254-1-hch@lst.de> <20200323165234.GA29925@lst.de> <7b7eb188-441a-b503-d526-f5bc029891fc@kernel.dk> <7bb040b9-41c5-9e11-c74d-fec7912e0e3c@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ext4-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7bb040b9-41c5-9e11-c74d-fec7912e0e3c@kernel.dk>
Sender: linux-ext4-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ext4@vger.kernel.org, reiserfs-devel@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Mar 23, 2020 at 10:57:07AM -0600, Jens Axboe wrote:
> On 3/23/20 10:55 AM, Jens Axboe wrote:
> > On 3/23/20 10:52 AM, Christoph Hellwig wrote:
> >> ping?
> >>
> >> On Thu, Mar 12, 2020 at 04:19:18PM +0100, Christoph Hellwig wrote:
> >>> Hi Jens,
> >>>
> >>> this series cleans up the partitioning code.
> >> ---end quoted text---
> > 
> > I did take a look, looks fine to me. Doesn't apply to the 5.7/block
> > branch though, I'll take a look in a bit, probably an easy reject.
> 
> Yeah, looks like a trivial conflict with:
> 
> commit e598a72faeb543599bdf0d930df3a71906404e6f
> Author: Balbir Singh <sblbir@amazon.com>
> Date:   Fri Mar 13 05:30:05 2020 +0000
> 
>     block/genhd: Notify udev about capacity change

FYI, I still think that series has a bug in the virtio conversion..
