From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: RAID5 Performance
Date: Thu, 28 Jul 2016 18:45:46 +0100
Message-ID: <22426.17610.799702.846715@tree.ty.sabi.co.uk>
References: <7b7d730f-2951-ba5f-7f6b-33624b59a02d@websitemanagers.com.au>
	<CAFx4rwR0+wR_0GXh3Y7j1hZyv0_Gy7b4OD-D2+bfxV9MRp+b3Q@mail.gmail.com>
	<7af0cc98-e395-9446-05eb-a6c0ca20f187@websitemanagers.com.au>
	<CAFx4rwTMySfR27gT6You7f2T28Hq8m5Zxme1p43Fv1vtcpt_-Q@mail.gmail.com>
	<0eee845d-b833-0a92-8fe6-a2522218a0e6@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0eee845d-b833-0a92-8fe6-a2522218a0e6@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]
> My concern is that even if I solve *this* bottleneck (ie, the
> 530 model SSD being too busy), that there will be another
> bottleneck afterwards

There is always another bottleneck ;-).

[ ... ]
> I'm not sure, but I think I've had one of the 480GB drives
> fail, and 3 of the smaller 60GB and 80GB drives fail. So far,
> only the 480G failure was "catastrophic", the others were
> still operating . All were replaced by Intel.
[ ... ]

When flash SSD drives run over their "expected" write amount
they behave differently:

  http://www.sabi.co.uk/blog/15-one.html#150406b

Intel flash SSDs apparently do the following:

* They switch immediately to read-only.
* On the next power up they refuse even to *read*.

BTW, as to the Samsung SM863 there is a relatively recent "group
test" here:

  http://www.storagereview.com/samsung_sm863_ssd_review

The average and max latency graphs are interesting, especially
those under "Preconditioning Curve".
