From: NeilBrown <neilb@suse.de>
Subject: Re: iostat with raid device...
Date: Thu, 14 Apr 2011 07:00:11 +1000
Message-ID: <20110414070011.68691ab5@notabene.brown>
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
	<BANLkTi=yz4zu-TS3BGxqfbtK5p-6neph-Q@mail.gmail.com>
	<BANLkTiknrqo7CxGBnWamSh6U5qKY+59xqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTiknrqo7CxGBnWamSh6U5qKY+59xqg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid Study <linuxraid.study@gmail.com>
Cc: Robin Hill <robin@robinhill.me.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 13 Apr 2011 11:21:52 -0700 Linux Raid Study
<linuxraid.study@gmail.com> wrote:

> Let me reword previous email...
>=20
> I tried to change stripe_cache_size as following and tried values
> between 16 to 4096
> echo 512 > /sys/block/md0/md/stripe_cache_size
>=20
> But, I'm not seeing too much difference in performance. I'm running o=
n
> 2.6.27sh kernel.

I wouldn't expect much difference.

>=20
> Any ideas...

On what exactly?
What exactly are you doing, what exactly are the results?  What exactly=
 don't
you understand?

Detail help.

NeilBrown



>=20
> Thanks for your help...
>=20
> On Tue, Apr 12, 2011 at 12:36 PM, Linux Raid Study
> <linuxraid.study@gmail.com> wrote:
> > Hello Neil,
> >
> > For the benchmarking purpose, I've configured array of ~30GB.
> > stripe_cache_size is 1024 (so 1M).
> >
> > BTW, I'm using Windows copy (robocopy) utility to test perf and I
> > believe block size it uses is 32kB. But since everything gets writt=
en
> > thru VFS, I'm not sure how to change stripe_cache_size to get optim=
al
> > performance with this setup...
> >
> > Thanks.
> >
> > On Mon, Apr 11, 2011 at 7:51 PM, NeilBrown <neilb@suse.de> wrote:
> >> On Mon, 11 Apr 2011 18:57:34 -0700 Linux Raid Study
> >> <linuxraid.study@gmail.com> wrote:
> >>
> >>> If I use --assume-clean in mdadm, I see performance is 10-15% low=
er as
> >>> compared to the case wherein this option is not specified. When I=
 run
> >>> without --assume_clean, I wait until mdadm prints "recovery_done"=
 and
> >>> then run IO benchmarks...
> >>>
> >>> Is perf drop expected?
> >>
> >> No. =A0And I cannot explain it.... unless the array is so tiny tha=
t it all fits
> >> in the stripe cache (typically about 1Meg).
> >>
> >> There really should be no difference.
> >>
> >> NeilBrown
> >>
> >

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
