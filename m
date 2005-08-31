From: Al Boldi <a1426z@gawab.com>
Subject: Re: Where is the performance bottleneck?
Date: Wed, 31 Aug 2005 07:30:38 -0300
Message-ID: <200508310730.38112.a1426z@gawab.com>
References: <Pine.LNX.4.61.0508291811480.24072@diagnostix.dwd.de> <200508292310.39903.a1426z@gawab.com> <Pine.LNX.4.61.0508301909220.25574@diagnostix.dwd.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0508301909220.25574@diagnostix.dwd.de>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Holger Kiehl wrote:
> On Mon, 29 Aug 2005, Al Boldi wrote:
> > You may be hitting a 2.6 kernel bug, which has something to do with
> > readahead, ask Jens Axboe about it! (see "[git patches] IDE update"
> > thread) Sadly, 2.6.13 did not fix it either.
>
> I did read that threat, but due to my limited understanding about kernel
> code, don't see the relation to my problem.

Basically the kernel is loosing CPU cycles while accessing bockdevices.
The problem shows most when the CPU/DISK ratio is low.
Throwing more CPU cycles at the problem may seemingly remove this bottleneck.

> But I am willing to try any patches to solve the problem.

No patches yet.

> > Did you try 2.4.31?
>
> No. Will give this a try if the problem is not found.

Keep us posted!

--
Al
