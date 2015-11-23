From: Semyon Enskiy <semyon.enskiy@yandex.ru>
Subject: Re: Recovering RAID5 with 2, actually 1, faulty disks.
Date: Mon, 23 Nov 2015 18:57:25 +0300
Message-ID: <3290501448294245@web16j.yandex.ru>
References: <189791448292518@web28m.yandex.ru>
	 <2542241448292944@web16h.yandex.ru> <5653351C.7070302@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5653351C.7070302@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> Something I couldn't work out from your post - what are your drives? Are
> they proper raid drives, or desktop drives? Is SCTERC (think that's what
> it's called) enabled and functioning?
>
> I won't be able to help beyond that, but the experts will want that info...
>
> smartctl -x
>
> Cheers,
> Wol

Thanks for your reply, Wol.

As written in first message of this thread, all disks are 4TB WD Red,
"WDC WD40EFRX-68WT0N0", in-kernel timeout for them is 30s.
