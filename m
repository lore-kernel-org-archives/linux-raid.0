From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: raid5: two writing algorithms
Date: Fri, 8 Feb 2008 02:10:41 +0100
Message-ID: <20080208011041.GD12985@rap.rap.dk>
References: <20080207161337.GA6044@rap.rap.dk> <18347.26939.358283.172299@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18347.26939.358283.172299@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Feb 08, 2008 at 07:25:31AM +1100, Neil Brown wrote:
> On Thursday February 7, keld@dkuug.dk wrote:
> > As I understand it, there are 2 valid algoritms for writing in raid5.
> > 
> > 1. calculate the parity data by XOR'ing all data of the relevant data
> > chunks.
> > 
> > 2. calculate the parity data by kind of XOR-subtracting the old data to
> > be changed, and then XOR-adding the new data. (XOR-subtract and XOR-add
> > is actually the same).
> > 
> > There are situations where method 1 is the fastest, and situations where
> > method 2 is the fastest.
> > 
> > My idea is then that the raid5 code in the kernel can calculate which
> > method is the faster. 
> > 
> > method 1 is faster, if all data is already available. I understand that
> > this method is employed in the current kernel. This would eg be the case
> > with sequential writes.
> > 
> > Method 2 is faster, if no data is available in core. It would require
> > 2 reads and two writes, which always will be faster than n reads and 1
> > write, possibly except for n=2. method 2 is thus faster normally for
> > random writes.
> > 
> > I think that method 2 is not used in the kernel today. Mayby I am wrong,
> > but I did have a look in the kernel code.
> 
> It is very odd that you would think something about the behaviour of
> the kernel with actually having looked.
> 
> It also seems a little arrogant to have a clever idea and assume that
> no one else has thought of it before.

Oh well, I have to admit that I do not understand the code fully.
I am not a seasoned kernel hacker, as I also indicated in my ad hoc
signature.

> > So I hereby give the idea for inspiration to kernel hackers.
> 
> and I hereby invite you to read the code ;-)

I did some reading.  Is there somewhere a description of it, especially
the raid code, or are the comments and the code the best documentation?

Do you say that this is already implemented?

I am sorry if you think I am mailing too much on the list.
But I happen to think it is fun.
And I do try to give something back.

> Code reading is a good first step to being a
> > 
> > Yoyr kernel hacker wannabe
>        ^^^^^^^^^^^^^
> 
> NeilBrown

Well, I do have a hack in mind, on the raid10,f2.
I need to investigate some more, and possibly test out
what really happens. But maybe the code already does what I want it to.
You are possibly the one that knows the code best, so maybe you can tell
me if raid10,f2 always does its reading in the first part of the disks?

best regards
keld
