From: Ed W <lists@wildgooses.com>
Subject: Re: HBA Adaptor advice
Date: Sat, 21 May 2011 12:17:34 +0100
Message-ID: <4DD79F4E.7000509@wildgooses.com>
References: <4DD50C89.8060006@wildgooses.com> <20110520020853.GC4759@bitfolk.com> <4DD61948.8050302@wildgooses.com> <4DD6409F.9070904@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DD6409F.9070904@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Stan

Thanks for the time in composing your reply

> I'm curious why you are convinced that you need BBWC, or even simply =
WC,
> on an HBA used for md RAID.

In the past I have used battery backed cards and where the write speed
is "fsync constrained" the writeback cache makes the app performance fl=
y
at perhaps 10-100x the speed

So for example postfix delivery speeds and mysql write performance are
examples of applications which generate regular fsyncs.  The whole app
pauses for basically the seek time of the drive head and performance is
bounded by seek time (assuming spinning media).

If we add a writeback cache then it would appear that you take a couple
of "green" 2TB drives and suddenly your desktop server acquires short
term performance which matches a bunch of high end drives? (noted only
in bursts, after some seconds you catch up with the drives IOPs).  For
my basically "small server" requirements this gives me a big boost in
the feeling of interactivity for perhaps less than the price of a coupl=
e
of those high end drives


>  I'm also curious as to why you are so
> adamant about _not_ using the RAID ASIC on an HBA, given that it will
> take much greater advantage of the BBWC than md RAID will.

Only for a single reason: Its a small office server and I want the
flexibility to move the drives to a different card (eg failed server,
failed card or something else).  Buying a spare card changes the
dynamics quite a bit when the whole server (sans raid card) only costs
=A31,000 ish?


  You may be
> interested to know:
>=20
> 1.  When BBWC is enabled, all internal drive caches must be disabled.
>     Otherwise you eliminate the design benefit of the BBU, and may as
>     well not have one.

Yes, I hadn't thought of that.  Good point!

> 2.  w/md RAID on an HBA, if you have a good UPS and don't suffer
>     kernel panics, crashes, etc, you can disable barrier support in
>     your FS and you can use the drive caches.

I don't buy this...

Note we are discussing "long tail events" here. ie catastrophic events
which occur very infrequently. At this point experience is everything
and I concede limited experience, you likely have more, but I'm going t=
o
claim that these events are sufficiently rare that your experience
probably still isn't sufficient to draw proper conclusions...

In my limited experience hardware is pretty reliable and goes bad
rarely.  However, my estimate is that powercables fall out, PSUs fail
and UPSs go bad at least as often as the power fails?

Obviously it's application dependent, some may tolerate small dataloss
in the event of powerdown, but I should think most people want a
guarantee that the system is "recoverable" in the event of sudden
powerdown.

I think disabling barriers might not be the best way to avoid fsync
delays, compared with the incremental cost of adding BBU writeback
cache? (basically the same thing, but smaller chance of failure)


> For a stable system with good UPS and auto shutdown configured, BBWC =
is
> totally overrated.  If the system never takes a nose dive from power
> drop, and doesn't crash due to software or hardware failure, then BBW=
C
> is a useless $200-1000 option.

It depends on the application, but I claim that there is a fairly
significant chance of hard unexpected powerdown even with a good UPS.
You still are at risk from cables getting pulled, UPSs failing, etc

I think in a properly setup datacenter (racked) environment then it's
easier to control these accidents.  Cables can be tied in, layers of
power backup can be managed, it becomes efficient to add quality
surge/lightning protection, etc.  However, there is a large proportion
of the market that have a few machines in an office and now it's much
harder to stop the cleaner tripping over the UPS, or hiding it under
boxes of paper until it melts due to overheating...


> If your current reasoning for wanting write cache on the HBA is
> performance, then forget about the write cache as you don't need it w=
ith
> md RAID.  If you want the BBWC combo for safety as your system isn't
> stable or you have a crappy or no UPS, then forgo md RAID and use the
> hardware RAID and BBWC combo.

I want BB writeback cache purely to get the performance of effectively
disabling fsync, but without the loss of protection which occurs if you
do so.


> One last point:  If you're bargain hunting, especially if looking at
> used gear on Ebay, that mindset is antithetical to proper system
> integration, especially when talking about a RAID card BBU. =20

I think there are few businesses who actually don't care about budget.
Everything is about optimisation of cost vs performance vs reliability.
 Like everything else, my question is really about the tradeoff of a
small incremental spend, which in turn might generate a substantial
performance increase for certain classes of application.  Largely I'm
thinking about performance tradeoffs for small office servers priced in
the =A3500-3,000 kind of range (not "proper" high end storage devices)

I think at that kind of level it makes sense to look for bargains,
especially if you are adding servers in small quantities, eg singles or
pairs.


> If you buy
> a use card, the first thing you muse do is chuck the BBU and order a =
new
> one,

Agreed


> Buy 12:
> http://www.seagate.com/ww/v/index.jsp?name=3Dst91000640ss-constellati=
on2-6gbs-sas-1-tb-hd&vgnextoid=3Dff13c5b2933d9210VgnVCM1000001a48090aRC=
RD&vgnextchannel=3Df424072516d8c010VgnVCM100000dd04090aRCRD&locale=3Den=
-US&reqPage=3DSupport#tTabContentSpecifications

Out of curiosity I check the power consumption and reliability numbers
of the 3.5" "Green" drives and it's not so clear cut that the 2.5"
drives outperform?


Thanks for your thoughts - I think this thread has been very
constructive - still very interested to hear good/bad reports of
specific cards - perhaps someone might archive it into some kind of lis=
t?

Cheers

Ed W

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
