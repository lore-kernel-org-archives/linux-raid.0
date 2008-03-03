From: "Christian Pernegger" <pernegger@gmail.com>
Subject: Re: Setting up md-raid5: observations, errors, questions
Date: Mon, 3 Mar 2008 09:38:35 +0100
Message-ID: <bb145bd20803030038o905e1feib1c1ad42c1b4b042@mail.gmail.com>
References: <bb145bd20803020423m14efea1by6e3e38bb8d0decb8@mail.gmail.com>
	 <47CAC5BF.6060600@msgid.tls.msk.ru>
	 <bb145bd20803020832x744c2674nd0a6a30e445b5453@mail.gmail.com>
	 <47CAF30F.7040502@msgid.tls.msk.ru>
	 <bb145bd20803021319o28df011sab954aa58a1c01be@mail.gmail.com>
	 <47CB228D.5020709@msgid.tls.msk.ru>
	 <bb145bd20803021617j1b15c667j96d3ee12829ee75a@mail.gmail.com>
	 <47CB694B.9000807@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <47CB694B.9000807@msgid.tls.msk.ru>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-raid.ids

>  You know how raid5 process writes, right?

Yes. What I'd forgotten, though, is that even with --assume-clean it's
still basically in degraded mode so testing writes at most serves as a
comparison between the different setups. This seems to be a common
late night error :)

>  So the bigger your chunk size is, the less chances you have to perform
>  full-stripe write, just because "large, properly aligned" writes are
>  much less frequent than "smaller, unaligned" ones

I had expected that the sequential dd-writes would be automatically
combined to write full stripes, yet they also go down massively with
increased chunk size.

>  You can get best results when writing WITHOUT a filesystem
>  (directly to /dev/mdFOO) with dd and blocksize equal to the
>  total strip size (chunk size * number of data disks, or
>  16k * 3 ..... 1M * 3, since in your raid 3 disks are data
>  in each strip)

I didn't use an fs for the dd tests, but 4*chunk size, which was
stupid. Still, I would have expected some combining to be going on
even at that level.

>  md stripe-cache makes huge difference, for obvious reasons.

Will experiment with that as well, thanks. Any other caches?

>  unless your usage pattern will be special and optimized for such a
>  setup, don't try to choose large chunk size for raid456.

I think I will be revising my test script to actually create a small
fs at the start of the device and run some tests in that. Note to
self: need a good load simulator ... ...

>  I had no time to investigate, and now I don't have a hardware to test
>  again.  In theory it should work, but I guess only a few people are
>  using [external bitmaps] if at all - most are using internal bitmaps.

I'd rather not use a feature where the probability that a bug will
bite me first is that high. :)

FWIW, using smaller bitmaps REALLY helps. Tests forthcoming.

Thanks,

C.
