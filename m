From: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Subject: Re: raid and elevator
Date: Mon, 27 Mar 2006 14:42:11 +0200
Message-ID: <5d96567b0603270442t190156d9x54102230e63b85c6@mail.gmail.com>
References: <5d96567b0603261329o39a5e777w5bc39ad5251b4ecb@mail.gmail.com>
	 <20060327122747.GK8186@suse.de>
	 <5d96567b0603270436x69eba93cx4b55b942c422afe0@mail.gmail.com>
	 <20060327123951.GL8186@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060327123951.GL8186@suse.de>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

i am sending 1MB buffer to a raid of 1MB chunk size.
i know that each offset is aligned by the chunk size.


On 3/27/06, Jens Axboe <axboe@suse.de> wrote:
>
> don't top-post!
>
> On Mon, Mar 27 2006, Raz Ben-Jehuda(caro) wrote:
> > I know that.
> > Currently i did some stupid stuff in the deadline.
> > I am thinking of creating some sort of awaiting list in the raid
> > layer by hooking into the make_request.
> >
> > Let me give u an example:
> > when issue 15 iops over a single disk i have an average latency of 580
> > ms ( 1MB IO buffers).
> > when i 60 iops over  raid5 of 4 disks i am getting 750 ms average latency.
> > I believe this is due to non balancing hence non fairness.
> > i need some sort of strict batching.
> > Do u agree ?
>
> That raid setup will always get you a little higher latency, simply
> because you will be waiting for more disks. As an example - submitting
> two ios to separate drives will always get higher latency than just one
> of the ios, since you want to wait for both to complete. Throughput may
> be better, but that doesn't say anything about the average or max
> experienced latency.
>
> --
> Jens Axboe
>
>


--
Raz
