From: "Peter T. Breuer" <ptb@inv.it.uc3m.es>
Subject: Re: remark and RFC
Date: Wed, 16 Aug 2006 18:15:58 +0200 (MET DST)
Message-ID: <200608161615.k7GGFwI17683@inv.it.uc3m.es>
References: <62b0912f0608160746l34d4e5e5r6219cc2e0f4a9040@mail.gmail.com>
Reply-To: ptb@inv.it.uc3m.es
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <62b0912f0608160746l34d4e5e5r6219cc2e0f4a9040@mail.gmail.com> from
 "Molle Bestefich" at "Aug 16, 2006 04:46:37 pm"
Sender: linux-raid-owner@vger.kernel.org
To: Molle Bestefich <molle.bestefich@gmail.com>
Cc: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

"Also sprach Molle Bestefich:"
[Charset ISO-8859-1 unsupported, filtering to ASCII...]
> Peter T. Breuer wrote:
> > We can't do a HOT_REMOVE while requests are outstanding, as far as I
> > know.
> 
> Actually, I'm not quite sure which kind of requests you are talking about.

Only one kind. Kernel requests :). They come in read and write
flavours (let's forget about the third race for the moment).

> Also, there's been relatively recent changes to this code:
> http://marc.theaimsgroup.com/?l=linux-raid&m=108075865413863&w=2

That's 2004 and is about the inclusion of the bitmapping code into
md/raid. We're years beyond there. What I'm talking about presupposes
all those changes in the raid layers, and laments that it's still 
missing one more thing that was in the FR1/5 patches .. namely
the ability for the underlying device to communicate with the md 
layer about its state of health, taking itself in and out of the
array as appropriate.


Peter
