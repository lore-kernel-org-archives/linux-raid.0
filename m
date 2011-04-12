From: Linux Raid Study <linuxraid.study@gmail.com>
Subject: Re: iostat with raid device...
Date: Tue, 12 Apr 2011 12:36:35 -0700
Message-ID: <BANLkTi=yz4zu-TS3BGxqfbtK5p-6neph-Q@mail.gmail.com>
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
	<20110412125141.679baaf0@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110412125141.679baaf0@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Robin Hill <robin@robinhill.me.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Neil,

=46or the benchmarking purpose, I've configured array of ~30GB.
stripe_cache_size is 1024 (so 1M).

BTW, I'm using Windows copy (robocopy) utility to test perf and I
believe block size it uses is 32kB. But since everything gets written
thru VFS, I'm not sure how to change stripe_cache_size to get optimal
performance with this setup...

Thanks.

On Mon, Apr 11, 2011 at 7:51 PM, NeilBrown <neilb@suse.de> wrote:
> On Mon, 11 Apr 2011 18:57:34 -0700 Linux Raid Study
> <linuxraid.study@gmail.com> wrote:
>
>> If I use --assume-clean in mdadm, I see performance is 10-15% lower =
as
>> compared to the case wherein this option is not specified. When I ru=
n
>> without --assume_clean, I wait until mdadm prints "recovery_done" an=
d
>> then run IO benchmarks...
>>
>> Is perf drop expected?
>
> No. =C2=A0And I cannot explain it.... unless the array is so tiny tha=
t it all fits
> in the stripe cache (typically about 1Meg).
>
> There really should be no difference.
>
> NeilBrown
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
