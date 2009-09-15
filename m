From: "Majed B." <majedb@gmail.com>
Subject: Re: Port Multipliers
Date: Tue, 15 Sep 2009 21:12:30 +0300
Message-ID: <70ed7c3e0909151112m14f5f3a5ge3b3ff20425cc427@mail.gmail.com>
References: <c268e4660909100556x14b48207w32017a59be889f@mail.gmail.com>
	<70ed7c3e0909100911q926fa9cs9185854b15dd8764@mail.gmail.com>
	<c268e4660909101135w4b933cbaj3e6a18e6b586fd62@mail.gmail.com>
	<70ed7c3e0909101144u2c42a1b2scf69e83df931035d@mail.gmail.com>
	<B1A260D7-B6A2-40D3-83FF-9571D80B66B8@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <B1A260D7-B6A2-40D3-83FF-9571D80B66B8@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Drew <drew.kay@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Well, just because the PCI-e 1x bus can do 250 MB/s, it doesn't mean
that the Port Multiplier (PM) can reach that speed, hence me telling
you to test the card itself with 1 disk to see its max speed, then add
another and so on.

Some PMs can communicate with each other. Check the specification
sheet to see if your PM can do that. If that's the case, keep your
disks of one array connected to PMs of the same chip, and use the
built-in ports of the motherboard for another array or just normal
disks.

On Tue, Sep 15, 2009 at 8:56 PM, Doug Ledford <dledford@redhat.com> wro=
te:
> On Sep 10, 2009, at 2:44 PM, Majed B. wrote:
>>
>> The maximum throughput you'll get is the PCI bus's speed. Make sure =
to
>> note which version your server has.
>>
>> The silicon image controller will be your bottleneck here, but I don=
't
>> have any numbers to say how much of a loss you'll be at. You'd have =
to
>> search around for those who already benchmarked their systems, or
>> buy/request a card to test it out.
>
> I've actually been doing some of those benchmarks here. =C2=A0Given a=
 Silicon
> Image 3124 card in a x1 PCI-e slot, my maximum throughput should be a=
bout
> 250MB/s (PCI-e limitation). =C2=A0My drives behind the pm are all cap=
able of
> about 80MB/s, and I have 4 drives. =C2=A0What I've found is that when=
 accessing
> one drive by itself, I get 80MB/s. =C2=A0When accessing more than one=
 drive, I
> get a total of about 120MB/s, but it's divided by however many drives=
 I'm
> accessing. =C2=A0So, two drives is roughly 60MB/s each, 3 drives abou=
t 40MB/s
> each, and 4 drives about 30MB/s each.
>
> This is then complicated by whether or not you have motherboard ports=
 in the
> same raid array. =C2=A0As the motherboard ports all get simultaneous =
drive speed
> more or less (up to 500MB/s aggregate in my test machine anyway), it'=
s worth
> noting that the motherboard drives slow down to whatever speed you ar=
e
> getting on the drives behind the pm whenever they are combined. =C2=A0=
So, even if
> 5 drives on the motherboard could do 500MB/s total, 100MB/s each, if =
they
> are combined with 4 drives behind a pm at 30MB/s each, they switch do=
wn to
> 30MB/s each as well, and the combined total would then become 9 * 30M=
B/s for
> 270MB/s, considerably slower than just the 5 drives on the motherboar=
d by
> themselves. =C2=A0However, if all your drives are behind pms, then I =
would expect
> to get a fairly linear speed increase as you increase the number of p=
ms.
> =C2=A0You can then control how fast the overall array is by controlli=
ng how many
> drives are behind each pm up to the point that you reach PCI bus or m=
emory
> or CPU bottlenecks.
>
>> If you do get a card and test it, make sure that you report back to =
us
>> and update the wiki: http://linux-raid.osdl.org/index.php/Performanc=
e
>>
>> On Thu, Sep 10, 2009 at 9:35 PM, Drew<drew.kay@gmail.com> wrote:
>>>>
>>>> If you're looking at port multipliers, you need to find PCI-Expres=
s
>>>> modules if you want them to be fast. The PCI ones are gonna be ver=
y
>>>> slow when you have more than 2 disks per card.
>>>
>>> I'm definitely going to use the PCIX/PCIe slots for the Host Adapte=
r.
>>>
>>> What I'm wondering is if I use a HBA and Port Multiplier that suppo=
rt
>>> FIS based switching, say a Sil 3124 & 3726, how much of a loss in d=
ata
>>> transfer rate can I expect from the RAID array built off the PM as
>>> opposed to each disk plugged in separately?
>>>
>>> An example configuration I'm looking at is a Sil3124 4 port HBA wit=
h
>>> three of the ports having Sil3726 5to1 PMs attached. Each PM then h=
as
>>> four disks hung off the PM. If I create a RAID5 array for example o=
n
>>> each PM, what sort of speed degradation would I be looking at compa=
red
>>> to making a RAID5 off just the 3124?
>>>
>>> --
>>> Drew
>>>
>>> "Nothing in life is to be feared. It is only to be understood."
>>> --Marie Curie
>>>
>>
>>
>>
>> --
>> =C2=A0 =C2=A0 =C2=A0Majed B.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>
>
> --
>
> Doug Ledford <dledford@redhat.com>
>
> GPG KeyID: CFBFF194
> http://people.redhat.com/dledford
>
> InfiniBand Specific RPMS
> http://people.redhat.com/dledford/Infiniband
>
>
>
>
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
