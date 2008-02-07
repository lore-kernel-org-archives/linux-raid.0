From: Neil Brown <neilb@suse.de>
Subject: Re: raid5: two writing algorithms
Date: Fri, 8 Feb 2008 07:25:31 +1100
Message-ID: <18347.26939.358283.172299@notabene.brown>
References: <20080207161337.GA6044@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday February 7, keld@dkuug.dk wrote:
> As I understand it, there are 2 valid algoritms for writing in raid5.
> 
> 1. calculate the parity data by XOR'ing all data of the relevant data
> chunks.
> 
> 2. calculate the parity data by kind of XOR-subtracting the old data to
> be changed, and then XOR-adding the new data. (XOR-subtract and XOR-add
> is actually the same).
> 
> There are situations where method 1 is the fastest, and situations where
> method 2 is the fastest.
> 
> My idea is then that the raid5 code in the kernel can calculate which
> method is the faster. 
> 
> method 1 is faster, if all data is already available. I understand that
> this method is employed in the current kernel. This would eg be the case
> with sequential writes.
> 
> Method 2 is faster, if no data is available in core. It would require
> 2 reads and two writes, which always will be faster than n reads and 1
> write, possibly except for n=2. method 2 is thus faster normally for
> random writes.
> 
> I think that method 2 is not used in the kernel today. Mayby I am wrong,
> but I did have a look in the kernel code.

It is very odd that you would think something about the behaviour of
the kernel with actually having looked.

It also seems a little arrogant to have a clever idea and assume that
no one else has thought of it before.

> 
> So I hereby give the idea for inspiration to kernel hackers.

and I hereby invite you to read the code ;-)

Code reading is a good first step to being a
> 
> Yoyr kernel hacker wannabe
       ^^^^^^^^^^^^^

NeilBrown


> keld
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
