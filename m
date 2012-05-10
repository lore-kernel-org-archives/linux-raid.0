From: Daniel Pocock <daniel@pocock.com.au>
Subject: Re: md RAID with enterprise-class SATA or SAS drives
Date: Thu, 10 May 2012 21:31:56 +0000
Message-ID: <4FAC33CC.6040203@pocock.com.au>
References: <4FAAE8F1.8000600@pocock.com.au> <CALFpzo5ObdwFATdT4e20znnxzU5hX9SVSfqJcdqOXM1FEYJQuw@mail.gmail.com> <4FABC7C6.4030107@turmel.org> <4FAC2FF2.5060305@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FAC2FF2.5060305@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Phil Turmel <philip@turmel.org>, Marcus Sorensen <shadowsor@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 10/05/12 21:15, Stan Hoeppner wrote:
> On 5/10/2012 8:51 AM, Phil Turmel wrote:
> 
>> Hardware RAID cards usually offer battery-backed write cache, which is
>> very valuable in some applications.  I don't have a need for that kind
>> of performance, so I can't speak to the details.  (Is Stan H.
>> listening?)
> 
> Yes, I'm here to drop the hammer, and start a flame war. ;)  I've been
> lurking and trying to stay out of the fray, but you "keep dragging me
> back in!" --Michael Corleone
> 
> I find the mere existence of this thread a bit comical, as with all
> others that have preceded it.  I made the comment on this list quite
> some time ago that md raid is mostly used by hobbyists, and took a lot
> of heat for that.  The existence of this thread adds ammunition to that
> argument.

Well while talking about ammunition, did you know HP dropped some nukes?

When they released the N36L Microserver, there was a statement on their
web site saying that there are no Linux drivers for the AMD (fake)RAID,
but they weren't necessary because Linux has built in RAID


> If not for the fact Western Digital added "TLER" to the spec sheet of
> it's RE and Raptor series drives many years ago, nobody would have every
> mentioned it.
> 
> WD did this because those in the "channel" marketplace weren't buying
> the drives.  They saw no difference with these new "enterprise" drives
> but the much higher price.  WD has never sold RE/Raptor drives to
> server/storage OEMs.  WD has never had a presence in enterprise storage.
>  Seagate, Hitachi/IBM, Fujitsu, and to a small degree Toshiba, have
> owned that space for over a decade.
> 
> So in an attempt to drive sales, they added "TLER" to the sheet to
> differentiate from their desktop drives.  So what happens?  All the
> hobbyists immediately want to enable this "TLER" feature from the
> "enterprise" drives on their consumer models, because "TLER" is all that
> makes them "enterprise" drives, after all, "all WD drives are the same,
> just with different firmware, right?".
> 
> Proof point:  Few write about this subject using the generic term "ERC",
> which is used by Seagate, or the term Samsung uses, "CCTL".  Everyone
> seems to talk about "TLER".  Hmmm...  Coincidence?  No, marketing.

Actually, the TLER term is mentioned elsewhere, for example the Adaptec
blog I came across

Economists often talk about price selectivity, e.g. the coffee shops
that charge an extra pound/euro/dollar for `organic' coffee.  Does it
really cost an extra pound to produce one teaspoon of coffee in an
organic way?  Of course not, it's just a gimmick to extract an extra
pound from people who won't lose any sleep over spending an extra pound.

> You won't find a single discussion about ERC/TLER/CCTL on any enterprise
> storage forum, unless its brought up by someone desiring to cut cost
> corners using consumer drives.

Not quite, I'm going the opposite direction, trying to move away from
cheap drives - but I don't want to invest heavily in something that is

a) just a marketing gimmick
b) not going to do me any good if md doesn't exercise the special
features of the hardware

> So if md raid is not limited to use by hobbyists, and is indeed used in
> enterprise environments, then why aren't the enterprise boys discussing
> "the problems w/TLER and enterprise drives"?  Because obviously md raid
> has no issues when being used with enterprise (ERC/TLER/CCTL) drives.
> 
> Either that, or md raid is only used by hobbyists. ;)
> 
Better a hobbyist running Linux than a professional running Windows with
fakeraid

