From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Nvidia Raid5 Failure
Date: Mon, 14 Apr 2014 05:55:16 -0500
Message-ID: <534BBE94.8010408@hardwarefreak.com>
References: <DUB122-W521994A2683B8CBD327D3DA3550@phx.gbl>	<CAK_KU4ZHZik=_=2=fMPW1c_y-xc0DW_9=ucsYQXU2e=eSOtYQg@mail.gmail.com>	<CACJz6QtoddN1nOcfzeJeV-09j+t9fhT=E2a17Ppxq4gXpZDcVA@mail.gmail.com>	<534B7CAD.3080908@hardwarefreak.com> <20140414195035.4adaa221@notabene.brown>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140414195035.4adaa221@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Drew <drew.kay@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 4/14/2014 4:50 AM, NeilBrown wrote:
> On Mon, 14 Apr 2014 01:14:05 -0500 Stan Hoeppner <stan@hardwarefreak.=
com>
> wrote:
>=20
>> Better classification for the current era:
>>
>> 1.  RAID controller - ASIC firmware, BBWC
>> 2.  HBA w/RAID      - ASIC firmware, cache less
>> 3.  Fake-RAID       - host software

To be clear, above I am differentiating between the various flavors of
"hardware RAID" devices, and part of the classification is based on
where the RAID binary is executed.  I do not address software only RAID
above.

> Can we come up with a better adjective than "fake"?

Many already have, but the terms were not adopted en masse.

> It makes sense if you say "fake RAID controller", but people don't.  =
They
> safe "fake RAID", which sounds like the RAID is fake, which it isn't.

I'm not attempting to reinvent the wheel above.  "FakeRAID", and variou=
s
spellings of it, is the term in common use for a decade+, is widely
recognized and understood.  It is even used in official Linux distro
documentation:

https://help.ubuntu.com/community/FakeRaidHowto
https://wiki.archlinux.org/index.php/Installing_with_Fake_RAID

> How about "BIOS RAID" ??  or "host RAID" ??

I agree that a better descriptive short label would be preferable.
However I don't see either of these working.  "BIOS RAID" will be
confusing to some as many folks

A.  don't understand the difference between BIOS and firmware
B.  have a BIOS config setup utility on their RAID controller or HBA
w/RAID card, and both devices "boot from the card's BIOS"

"Host RAID" has been used extensively over the years in various circles
to describe host software only RAID solutions.  Additionally this
wouldn't be an accurate description because there have been many add-in
IDE/SATA "RAID" cards that split RAID duty between card BIOS/firmware
and host OS driver in this manner.  HighPoint has such current product:

http://www.highpoint-tech.com/USA_new/series_rr272x.htm

They describes this as "Hardware-Assisted RAID", which is a pretty good
description IMO.

Any effort or campaign to supplant "fakeRAID" with another term I think
will be extremely difficult and prone to fail as "fakeRAID" is already
so entrenched in the lexicon, and has been used in official distro
documentation.

Just my 2=A2

Cheers,

Stan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
