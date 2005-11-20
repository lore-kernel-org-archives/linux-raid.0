From: Lajber Zoltan <lajbi@lajli.gau.hu>
Subject: Re: comparing FreeBSD to linux
Date: Sun, 20 Nov 2005 12:59:14 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0511201258150.30165@lajli.gau.hu>
References: <5d96567b0511200350x215f37a1r5185d7b188f37639@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5d96567b0511200350x215f37a1r5185d7b188f37639@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, 20 Nov 2005, Raz Ben-Jehuda(caro) wrote:

> I have evaluated which is better in terms cpu load when dealing with raid.
> FreeBSD vinum's or linux raid.
> When i issued a huge amount of io's read to linux raid i got 93% cpu
> load ( 7% idle),
> while i having 10% cpu load  ( 90% idle ) in the freebsd.
>
> I need to switch to linux from freebsd. I am using in linux 2.6.6 kernel .
> is problem is a known issue in linux , is it fixed ?

It's not a sw raid problem, i never got such load. It seams to be a driver
problem. Do you use good kernel for your hardware?

Bye,
-=Lajbi=----------------------------------------------------------------
 LAJBER Zoltan               Szent Istvan Egyetem,  Informatika Hivatal
 Most of the time, if you think you are in trouble, crank that throttle!
