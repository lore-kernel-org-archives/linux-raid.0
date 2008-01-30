From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: In this partition scheme, grub does not find md information?
Date: Wed, 30 Jan 2008 01:22:37 +0100
Message-ID: <20080130002237.GC7975@rap.rap.dk>
References: <18334.46306.611615.493031@notabene.brown> <479F07E1.7060408@pobox.com> <479F0AAB.3090702@rabbit.us> <479F331F.7080902@msgid.tls.msk.ru> <479F3C74.1050605@rabbit.us> <479F42A5.8040007@msgid.tls.msk.ru> <479F5177.6060206@pobox.com> <479F557D.20502@rabbit.us> <479F7FCD.7030106@pobox.com> <479FBA54.6010009@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <479FBA54.6010009@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Moshe Yudkowsky <moshe@pobox.com>, Peter Rabbitson <rabbit+list@rabbit.us>, Michael Tokarev <mjt@tls.msk.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jan 29, 2008 at 06:44:20PM -0500, Bill Davidsen wrote:

> Depending on near/far choices, raid10 should be faster than raid5, with 
> far read should be quite a bit faster. You can't boot off raid10, and if 
> you put your swap on it many recovery CDs won't use it. But for general 
> use and swap on a normally booted system it is quite fast.

Hmm, why would you put swap on a raid10? I would in a production
environment always put it on separate swap partitions, possibly a number,
given that a number of drives are available.

best regards
keld
