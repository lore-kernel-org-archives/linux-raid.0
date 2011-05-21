From: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Subject: Re: HBA Adaptor advice
Date: Sat, 21 May 2011 13:29:09 +0200
Message-ID: <4DD7A205.8070106@grumpydevil.homelinux.org>
References: <4DD50C89.8060006@wildgooses.com> <20110520020853.GC4759@bitfolk.com> <4DD61948.8050302@wildgooses.com> <4DD6409F.9070904@hardwarefreak.com> <4DD79F4E.7000509@wildgooses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DD79F4E.7000509@wildgooses.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ed W <lists@wildgooses.com>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Ed,

I understand your thinking. There is one big cost not mentioned in this=
=20
calculation though:
- what is the cost if the data is lost/corrupt?

compared to that cost, how relevant is the cost of a proper card?

I am getting the feeling of "penny wise, pound foolish"

Now that mind set, of course, describes many a business....

Cheers,


Rudy

On 05/21/2011 01:17 PM, Ed W wrote:
> Hi Stan
>
> Thanks for the time in composing your reply
>
>   =20
>> I'm curious why you are convinced that you need BBWC, or even simply=
 WC,
>> on an HBA used for md RAID.
>>     =20
> In the past I have used battery backed cards and where the write spee=
d
> is "fsync constrained" the writeback cache makes the app performance =
fly
> at perhaps 10-100x the speed
>
> So for example postfix delivery speeds and mysql write performance ar=
e
> examples of applications which generate regular fsyncs.  The whole ap=
p
> pauses for basically the seek time of the drive head and performance =
is
> bounded by seek time (assuming spinning media).
>
> If we add a writeback cache then it would appear that you take a coup=
le
> of "green" 2TB drives and suddenly your desktop server acquires short
> term performance which matches a bunch of high end drives? (noted onl=
y
> in bursts, after some seconds you catch up with the drives IOPs).  Fo=
r
> my basically "small server" requirements this gives me a big boost in
> the feeling of interactivity for perhaps less than the price of a cou=
ple
> of those high end drives
>
>
>   =20
>>   I'm also curious as to why you are so
>> adamant about _not_ using the RAID ASIC on an HBA, given that it wil=
l
>> take much greater advantage of the BBWC than md RAID will.
>>     =20
> Only for a single reason: Its a small office server and I want the
> flexibility to move the drives to a different card (eg failed server,
> failed card or something else).  Buying a spare card changes the
> dynamics quite a bit when the whole server (sans raid card) only cost=
s
> =A31,000 ish?
>
>
>    You may be
>   =20
>> interested to know:
>>
>> 1.  When BBWC is enabled, all internal drive caches must be disabled=
=2E
>>      Otherwise you eliminate the design benefit of the BBU, and may =
as
>>      well not have one.
>>     =20
> Yes, I hadn't thought of that.  Good point!
>
>   =20
>> 2.  w/md RAID on an HBA, if you have a good UPS and don't suffer
>>      kernel panics, crashes, etc, you can disable barrier support in
>>      your FS and you can use the drive caches.
>>     =20
> I don't buy this...
>
> Note we are discussing "long tail events" here. ie catastrophic event=
s
> which occur very infrequently. At this point experience is everything
> and I concede limited experience, you likely have more, but I'm going=
 to
> claim that these events are sufficiently rare that your experience
> probably still isn't sufficient to draw proper conclusions...
>
> In my limited experience hardware is pretty reliable and goes bad
> rarely.  However, my estimate is that powercables fall out, PSUs fail
> and UPSs go bad at least as often as the power fails?
>
> Obviously it's application dependent, some may tolerate small datalos=
s
> in the event of powerdown, but I should think most people want a
> guarantee that the system is "recoverable" in the event of sudden
> powerdown.
>
> I think disabling barriers might not be the best way to avoid fsync
> delays, compared with the incremental cost of adding BBU writeback
> cache? (basically the same thing, but smaller chance of failure)
>
>
>   =20
>> For a stable system with good UPS and auto shutdown configured, BBWC=
 is
>> totally overrated.  If the system never takes a nose dive from power
>> drop, and doesn't crash due to software or hardware failure, then BB=
WC
>> is a useless $200-1000 option.
>>     =20
> It depends on the application, but I claim that there is a fairly
> significant chance of hard unexpected powerdown even with a good UPS.
> You still are at risk from cables getting pulled, UPSs failing, etc
>
> I think in a properly setup datacenter (racked) environment then it's
> easier to control these accidents.  Cables can be tied in, layers of
> power backup can be managed, it becomes efficient to add quality
> surge/lightning protection, etc.  However, there is a large proportio=
n
> of the market that have a few machines in an office and now it's much
> harder to stop the cleaner tripping over the UPS, or hiding it under
> boxes of paper until it melts due to overheating...
>
>
>   =20
>> If your current reasoning for wanting write cache on the HBA is
>> performance, then forget about the write cache as you don't need it =
with
>> md RAID.  If you want the BBWC combo for safety as your system isn't
>> stable or you have a crappy or no UPS, then forgo md RAID and use th=
e
>> hardware RAID and BBWC combo.
>>     =20
> I want BB writeback cache purely to get the performance of effectivel=
y
> disabling fsync, but without the loss of protection which occurs if y=
ou
> do so.
>
>
>   =20
>> One last point:  If you're bargain hunting, especially if looking at
>> used gear on Ebay, that mindset is antithetical to proper system
>> integration, especially when talking about a RAID card BBU.
>>     =20
> I think there are few businesses who actually don't care about budget=
=2E
> Everything is about optimisation of cost vs performance vs reliabilit=
y.
>   Like everything else, my question is really about the tradeoff of a
> small incremental spend, which in turn might generate a substantial
> performance increase for certain classes of application.  Largely I'm
> thinking about performance tradeoffs for small office servers priced =
in
> the =A3500-3,000 kind of range (not "proper" high end storage devices=
)
>
> I think at that kind of level it makes sense to look for bargains,
> especially if you are adding servers in small quantities, eg singles =
or
> pairs.
>
>
>   =20
>> If you buy
>> a use card, the first thing you muse do is chuck the BBU and order a=
 new
>> one,
>>     =20
> Agreed
>
>
>   =20
>> Buy 12:
>> http://www.seagate.com/ww/v/index.jsp?name=3Dst91000640ss-constellat=
ion2-6gbs-sas-1-tb-hd&vgnextoid=3Dff13c5b2933d9210VgnVCM1000001a48090aR=
CRD&vgnextchannel=3Df424072516d8c010VgnVCM100000dd04090aRCRD&locale=3De=
n-US&reqPage=3DSupport#tTabContentSpecifications
>>     =20
> Out of curiosity I check the power consumption and reliability number=
s
> of the 3.5" "Green" drives and it's not so clear cut that the 2.5"
> drives outperform?
>
>
> Thanks for your thoughts - I think this thread has been very
> constructive - still very interested to hear good/bad reports of
> specific cards - perhaps someone might archive it into some kind of l=
ist?
>
> Cheers
>
> Ed W
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   =20

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
