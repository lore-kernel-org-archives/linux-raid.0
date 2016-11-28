From: Coly Li <colyli@suse.de>
Subject: Re: raid0 vs. mkfs
Date: Mon, 28 Nov 2016 17:15:32 +0800
Message-ID: <47bb768e-6276-76da-22f4-33de964e6755@suse.de>
References: <56c83c4e-d451-07e5-88e2-40b085d8681c@scylladb.com>
 <87oa108a1x.fsf@notabene.neil.brown.name>
 <286a5fc1-eda3-0421-a88e-b03c09403259@scylladb.com>
 <87inr880au.fsf@notabene.neil.brown.name>
 <df73ebc4-9b78-09b5-022b-089c30dea17c@scylladb.com>
 <20161128090053.GA9393@infradead.org>
 <8f633d1b-6250-6f9d-0311-70931d31fe0a@scylladb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8f633d1b-6250-6f9d-0311-70931d31fe0a@scylladb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Avi Kivity <avi@scylladb.com>
Cc: Christoph Hellwig <hch@infradead.org>, NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2016/11/28 下午5:11, Avi Kivity wrote:
> On 11/28/2016 11:00 AM, Christoph Hellwig wrote:
>> On Mon, Nov 28, 2016 at 10:58:24AM +0200, Avi Kivity wrote:
>>> What I guess is happening is that since the NVMe queue depth is so
>>> high, and
>>> request the driver receives is sent immediately to the disk and there is
>>> nothing to merge it to.  That could indicate the absence of plugging, or
>>> just a reluctance to merge TRIMs.
>> That is exactly the case, and it's also an issue with online trim.
>> I have work in progress block layer trim patches that always plug trims
>> and have various TRIM merge improvements including support for ranged
>> TRIMs.  It needs a bit more work, but I hope I can post it later
>> this week.
> 
> Great, good to know.
> 
> I still think it should also be fixed in the RAID layer.  There's no
> reason to break a single request in millions of smaller ones, then try
> to merge them into one request back again.  The queuing layer can merge
> when it's given bad patterns from uncontrolled sources, not as an excuse
> to generate bad patterns from within the kernel.

Personally I agree with your opinion. We can improve both in block layer
and md code.

Coly

