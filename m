From: Jens Axboe <axboe@suse.de>
Subject: Re: 2.5.39 raid0 on Alpha: bug: can't convert block across chunks or bigger than 32k
Date: Sun, 29 Sep 2002 18:32:16 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020929163216.GA22484@suse.de>
References: <87elbdwpe0.fsf@student.uni-tuebingen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87elbdwpe0.fsf@student.uni-tuebingen.de>
To: Falk Hueffner <falk.hueffner@student.uni-tuebingen.de>
Cc: linux-raid@vger.kernel.org, Neil Brown <neilb@cse.unsw.edu.au>
List-Id: linux-raid.ids

On Sun, Sep 29 2002, Falk Hueffner wrote:
> Hi,
> 
> I've tried to mount a raid0 on an Alpha with kernel 2.5.39. It works
> fine with a RedHat 2.4.18. On 2.5.39, I quickly get the following
> messages, though:
> 
> raid0_make_request bug: can't convert block across chunks or bigger than 32k 138506232 48
> raid0_make_request bug: can't convert block across chunks or bigger than 32k 138506232 8

This is a bug in raid0 (well, all of the raid levels I suppose). They
need to set queue limitations based on low level device, and they need
to add a q->merge_bvec_fn() for the odd case.

Neil knows about this, so I hope he will fix it soon.

-- 
Jens Axboe

