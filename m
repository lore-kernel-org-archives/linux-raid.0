From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: raind-1 resync speed slow down to 50% by the time it finishes
Date: Wed, 05 Aug 2009 00:18:06 +0100
Message-ID: <4A78C1AE.9040002@anonymous.org.uk>
References: <AC5E1C3367E37D44970B81A6ADD1DA2C07C7D7D6@SDCEXCHANGE01.ad.amcc.com> 	<20090730073554.GA17665@cthulhu.home.robinhill.me.uk> <20090730101846.GA17332@rap.rap.dk> 	<72dbd3150907301311t5abef2fai91cdae154b987d33@mail.gmail.com> 	<20090731175455.GA11463@rap.rap.dk> <72dbd3150907311310s2ccfc379u2c23fe724007b9bb@mail.gmail.com> 	<20090801130043.GA24915@rap.rap.dk> <72dbd3150908010813n3aed3804s3a0c0265cb2c2c6d@mail.gmail.com> 	<20090801175734.GB27831@rap.rap.dk> <72dbd3150908041521q1d71994cl25159d5ec3e7f326@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <72dbd3150908041521q1d71994cl25159d5ec3e7f326@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Rees <drees76@gmail.com>
Cc: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/08/2009 23:21, David Rees wrote:
[...]
> As I mentioned earlier, I was having a hard time visualizing the data
> layout.  So here's a simple diagram that shows near/far layout and why
> Keld was right - with a far layout, reads can be isolated to the fast
> half of the disk.
[...]
> Near layout, 4 disks, 2 copies:
> a b c d
> 0 0 1 1
> 2 2 3 3
> 4 4 5 5
> 6 6 7 7
> 
> Far layout, 4 disks, 2 copies
> a b c d
> 0 1 2 3
> 4 5 6 7
> 7 0 1 2
> 3 4 5 6

But I don't think I'd want reads isolated to the first half of the disc. 
If I wanted a block read, and the drive which has its near copy is 
already busy, but the drive with the far copy is idle, I'd probably 
rather the read came from the far copy, than wait for the drive with the 
near copy to come free.

For example, say I want block 0, and there's a write pending for block 
3. I want block 0 from drive b now, not drive a later.

Or will I actually get more IOPS by waiting, if I'm doing a lot of small 
reads and writes?

Cheers,

John.

