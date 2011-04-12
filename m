From: NeilBrown <neilb@suse.de>
Subject: Re: iostat with raid device...
Date: Tue, 12 Apr 2011 12:51:41 +1000
Message-ID: <20110412125141.679baaf0@notabene.brown>
References: <BANLkTi=6uvCsQTpCi4xLUWzx5X7o99_=5g@mail.gmail.com>
	<20110409094629.2eae2d5b@notabene.brown>
	<BANLkTin2KP-_vy8jbmV3JB-LHHJNOEVCKw@mail.gmail.com>
	<20110409085044.GB417@cthulhu.home.robinhill.me.uk>
	<BANLkTim4fenro-GQchqJ0JzrcDAcJXG0UQ@mail.gmail.com>
	<20110411092559.GA20532@cthulhu.home.robinhill.me.uk>
	<BANLkTikYTECzE-2dCnC+jDT0wHNtgkNQ8Q@mail.gmail.com>
	<20110411095355.GB20532@cthulhu.home.robinhill.me.uk>
	<20110411201808.47cd19d5@notabene.brown>
	<BANLkTinFxHPuCgxERGc88W2KmZkzU_GF9Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTinFxHPuCgxERGc88W2KmZkzU_GF9Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid Study <linuxraid.study@gmail.com>
Cc: Robin Hill <robin@robinhill.me.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 11 Apr 2011 18:57:34 -0700 Linux Raid Study
<linuxraid.study@gmail.com> wrote:

> If I use --assume-clean in mdadm, I see performance is 10-15% lower as
> compared to the case wherein this option is not specified. When I run
> without --assume_clean, I wait until mdadm prints "recovery_done" and
> then run IO benchmarks...
> 
> Is perf drop expected?

No.  And I cannot explain it.... unless the array is so tiny that it all fits
in the stripe cache (typically about 1Meg).

There really should be no difference.

NeilBrown
