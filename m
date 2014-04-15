From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Nvidia Raid5 Failure
Date: Mon, 14 Apr 2014 22:18:04 -0500
Message-ID: <534CA4EC.7050307@hardwarefreak.com>
References: <DUB122-W521994A2683B8CBD327D3DA3550@phx.gbl>	<CAK_KU4ZHZik=_=2=fMPW1c_y-xc0DW_9=ucsYQXU2e=eSOtYQg@mail.gmail.com>	<CACJz6QtoddN1nOcfzeJeV-09j+t9fhT=E2a17Ppxq4gXpZDcVA@mail.gmail.com>	<534B7CAD.3080908@hardwarefreak.com>	<20140414195035.4adaa221@notabene.brown>	<534BBE94.8010408@hardwarefreak.com> <CAK_KU4aRbK-sD6h7xqieW_D9FhBYBAy799wZHXq222DAMLjRng@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK_KU4aRbK-sD6h7xqieW_D9FhBYBAy799wZHXq222DAMLjRng@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Scott D'Vileskis <sdvileskis@gmail.com>
Cc: NeilBrown <neilb@suse.de>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 4/14/2014 8:51 AM, Scott D'Vileskis wrote:
> I'd be curious to see the benchmarks of some of these, specifically
> how properly-tuned software raid in Linux (with ample memory and CPU
> bandwidth) compares against the "hardware" solutions.
>
> I'm already sold on software raid for ease of use and recovery,
> maturity, knowledge base, etc.. But the numbers would be fun. I know =
I
> can simply google it, but surely one of you two has a great bookmark!

With the emergence of bcache and cousins, their equivalent in RAID card
firmware, and the low cost of SSDs, RAID implementation, software or
hardware, is no longer a real issue WRT performance.  Streaming non RMW
throughput is usually identical between the two, limited by the drives,
not the RAID.  Random IO will be very similar as well, with a slight
edge to RAID cards with DRAM cache in front of the SSD cache.

Thus it is the other qualities and deficiencies of each and the intende=
d
use case that drives the decision.  The needs of the personal or SOHO
server, a UNI department on a tight budget, etc, are often quite
different than those of the enterprise customer with deeper pockets.
=46or the former cost is usually a significant factor, while for the
latter the cost of the RAID card is inconsequential given the high cost
of the enterprise drives attached to it, where only one or two drives
equal the price of the RAID card.

In an enterprise environment, light path management is a must--an LED i=
s
required for drive failure identification and easy replacement.
Linux/md does not yet provide this functionality (though efforts are
being made) and typically forces users to carefully document which
drives are in which chassis/backplane slots, and maintain those records
every time a drive is swapped.  Most RAID cards have provided failure
LED support for ~20 years.

md has the same management interface on any Linux host.  If one buys
RAID cards from multiple vendors they must learn multiple interfaces.

md is more flexible WRT to mixing different drive types within an array=
=2E
 Hardware RAID controllers are typically more finicky here, requiring
drives with a low and uniform ERC/TLER value, and of matching firmware
revs across the drives in an array.

And of course md can do the one thing hardware RAID cards cannot:
stitch arrays on multiple RAID cards together into a single disk device
using a nested stripe or a linear array depending on the workload.  Thi=
s
gives you a bit of the best features of both technologies, and allows
you to scale to a level not easily achievable using only one of either
technology.

Cheers,

Stan





> Thanks!
> --Scott
>=20
> On Mon, Apr 14, 2014 at 6:55 AM, Stan Hoeppner <stan@hardwarefreak.co=
m> wrote:
>> On 4/14/2014 4:50 AM, NeilBrown wrote:
>>> On Mon, 14 Apr 2014 01:14:05 -0500 Stan Hoeppner <stan@hardwarefrea=
k.com>
>>> wrote:
>>>
>>>> Better classification for the current era:
>>>>
>>>> 1.  RAID controller - ASIC firmware, BBWC
>>>> 2.  HBA w/RAID      - ASIC firmware, cache less
>>>> 3.  Fake-RAID       - host software
>>
>> To be clear, above I am differentiating between the various flavors =
of
>> "hardware RAID" devices, and part of the classification is based on
>> where the RAID binary is executed.  I do not address software only R=
AID
>> above.
>>
>>> Can we come up with a better adjective than "fake"?
>>
>> Many already have, but the terms were not adopted en masse.
>>
>>> It makes sense if you say "fake RAID controller", but people don't.=
  They
>>> safe "fake RAID", which sounds like the RAID is fake, which it isn'=
t.
>>
>> I'm not attempting to reinvent the wheel above.  "FakeRAID", and var=
ious
>> spellings of it, is the term in common use for a decade+, is widely
>> recognized and understood.  It is even used in official Linux distro
>> documentation:
>>
>> https://help.ubuntu.com/community/FakeRaidHowto
>> https://wiki.archlinux.org/index.php/Installing_with_Fake_RAID
>>
>>> How about "BIOS RAID" ??  or "host RAID" ??
>>
>> I agree that a better descriptive short label would be preferable.
>> However I don't see either of these working.  "BIOS RAID" will be
>> confusing to some as many folks
>>
>> A.  don't understand the difference between BIOS and firmware
>> B.  have a BIOS config setup utility on their RAID controller or HBA
>> w/RAID card, and both devices "boot from the card's BIOS"
>>
>> "Host RAID" has been used extensively over the years in various circ=
les
>> to describe host software only RAID solutions.  Additionally this
>> wouldn't be an accurate description because there have been many add=
-in
>> IDE/SATA "RAID" cards that split RAID duty between card BIOS/firmwar=
e
>> and host OS driver in this manner.  HighPoint has such current produ=
ct:
>>
>> http://www.highpoint-tech.com/USA_new/series_rr272x.htm
>>
>> They describes this as "Hardware-Assisted RAID", which is a pretty g=
ood
>> description IMO.
>>
>> Any effort or campaign to supplant "fakeRAID" with another term I th=
ink
>> will be extremely difficult and prone to fail as "fakeRAID" is alrea=
dy
>> so entrenched in the lexicon, and has been used in official distro
>> documentation.
>>
>> Just my 2=A2
>>
>> Cheers,
>>
>> Stan
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
