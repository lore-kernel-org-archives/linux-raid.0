From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: raind-1 resync speed slow down to 50% by the time it finishes
Date: Wed, 5 Aug 2009 10:08:36 +0200
Message-ID: <20090805080836.GC23696@rap.rap.dk>
References: <20090730073554.GA17665@cthulhu.home.robinhill.me.uk> <20090730101846.GA17332@rap.rap.dk> <72dbd3150907301311t5abef2fai91cdae154b987d33@mail.gmail.com> <20090731175455.GA11463@rap.rap.dk> <72dbd3150907311310s2ccfc379u2c23fe724007b9bb@mail.gmail.com> <20090801130043.GA24915@rap.rap.dk> <72dbd3150908010813n3aed3804s3a0c0265cb2c2c6d@mail.gmail.com> <20090801175734.GB27831@rap.rap.dk> <72dbd3150908041521q1d71994cl25159d5ec3e7f326@mail.gmail.com> <4A78C1AE.9040002@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A78C1AE.9040002@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: David Rees <drees76@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Aug 05, 2009 at 12:18:06AM +0100, John Robinson wrote:
> On 04/08/2009 23:21, David Rees wrote:
> [...]
>> As I mentioned earlier, I was having a hard time visualizing the data
>> layout.  So here's a simple diagram that shows near/far layout and why
>> Keld was right - with a far layout, reads can be isolated to the fast
>> half of the disk.
> [...]
>> Near layout, 4 disks, 2 copies:
>> a b c d
>> 0 0 1 1
>> 2 2 3 3
>> 4 4 5 5
>> 6 6 7 7
>>
>> Far layout, 4 disks, 2 copies
>> a b c d
>> 0 1 2 3
>> 4 5 6 7
>> 7 0 1 2
>> 3 4 5 6
>
> But I don't think I'd want reads isolated to the first half of the disc.  
> If I wanted a block read, and the drive which has its near copy is  
> already busy, but the drive with the far copy is idle, I'd probably  
> rather the read came from the far copy, than wait for the drive with the  
> near copy to come free.
>
> For example, say I want block 0, and there's a write pending for block  
> 3. I want block 0 from drive b now, not drive a later.

That is not how IO works for disks. There is a queue for each physical
disk, and your reads are put into that queue. An elevator algorithm then
orders the requests in the queue, normally by taking the requests in the
sequence of their sector numbers. In this way the head movement is
minimized and thus speeding up total transfers by a factor of maybe 4.

So there is not something about getting IO "now", you are always in a
queue, at least on a system with some load. Systems without loads are
probably not interesting, then you get your data immediately.


> Or will I actually get more IOPS by waiting, if I'm doing a lot of small  
> reads and writes?

Yes, you get many times more IOPS by having an elavator algorithm in
place, also with small reads and writes. Confining the reads to only to
the faster half gets you even more speed improvements, also for IOPS. 
Maybe not that much, like  a little more than half of the total head
movement from start to end per queue run of the elevator, maybe about 5 %

best regards
keld
