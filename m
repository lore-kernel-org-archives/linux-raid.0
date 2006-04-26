From: "Tuomas Leikola" <tuomas.leikola@gmail.com>
Subject: Re: Two-disk RAID5?
Date: Wed, 26 Apr 2006 21:46:19 +0300
Message-ID: <5b170a7d0604261146m55d37c65peb316bb28c38da58@mail.gmail.com>
References: <1146069707.10253.50.camel@kenny>
	 <Pine.LNX.4.61.0604261314060.1846@soloth.lewis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0604261314060.1846@soloth.lewis.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Jon Lewis <jlewis@lewis.org>
Cc: John Rowe <rowe@excc.ex.ac.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> No.  When one of the 2 drives in your RAID5 dies, and all you have for
> some blocks is parity info, how will the missing data be reconstructed?
>
> You could [I suspect] create a 2 disk RAID5 in degraded mode (3rd member
> missing), but it'll obviously lack redundancy until you add a 3rd disk,
> which won't add anything to your RAID5 storage capacity.

IMO if you have a 2-disk raid5, the parity for each block is the same
as the data. There is performance drop as I suspect md isn't smart
enough to read data from both disks, but that's all.

When one disk fails, the (lone) parity block is quite enough to
reconstruct. With XOR parity, you can always assume any amount of
additional disks full of zero, it doesn't really change the algorithm.

(maybe mdadm could/can change a raid-1 into raid5 by just changing the
superblocks, for the purpose of expanding into more disks..)

- tuomas
