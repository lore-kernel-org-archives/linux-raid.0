From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: Performance question, RAID5
Date: Tue, 1 Feb 2011 12:32:26 -0200
Message-ID: <AANLkTikKyofrDej_4mcnoSaUZGE1mUMAAVZka_qz-hW_@mail.gmail.com>
References: <AANLkTimXp-vGP8fb2Y-2EiaGxj+H6UJ9DfjtYMVDhDri@mail.gmail.com>
	<20110130035352.1d72e8d1@natsu>
	<AANLkTi=ii-iLybJBS8ncajwXWZnkwLY=u0AcQiBJKPUf@mail.gmail.com>
	<20110130015231.GA1435@www2.open-std.org>
	<AANLkTimw6CTP66FZdbH07kjMmHoxoFRF6Eq9WDR_LYt8@mail.gmail.com>
	<20110130055616.GA13022@www2.open-std.org>
	<AANLkTi=CdiOjA15umaaO9ORDQ9StoesC2eD5q0_e3Bb0@mail.gmail.com>
	<4D47F086.9000308@anonymous.org.uk>
	<AANLkTi=Y7E0EvMiXkd-CoMc8tPjCwETnW_gDBi6+WqfS@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=Y7E0EvMiXkd-CoMc8tPjCwETnW_gDBi6+WqfS@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>
Cc: John Robinson <john.robinson@anonymous.org.uk>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

nice, with my ocz vertex2 tests i get this:
sata1 can get about 130MB/s (sata1 =3D 1,5gb/s)
sata2 can get about 270MB/s (sata1 =3D 3gb/s)

i don=B4t remember but i think that each =B4x=B4 on pci-express =3D 2.5=
gb/s, 4x=3D10gb/s

onboard sata controllers are pci-express or pci based board (it=B4s har=
d
linked in north bridge)


2011/2/1 Mathias Bur=E9n <mathias.buren@gmail.com>:
> On 1 February 2011 11:37, John Robinson <john.robinson@anonymous.org.=
uk> wrote:
>> On 30/01/2011 12:12, Mathias Bur=E9n wrote:
>> [...]
>>>
>>> Ah, good point. The sda is a 60GB SSD, I should definitely move tha=
t
>>> to the PCI-E card, as it doesn't do heavy IO (just small random r/w=
).
>>> Then i can have 4 RAID HDDs on the onboard ctrl, and 2 on the PCI-E
>>> shared with the SSD. If the SSD is idle then I should get ideal
>>> throughputs.
>>
>> Hmm, if you have an SSD, you might look at using bcache to speed up =
write
>> access to your array. On the other hand, with only one SSD you poten=
tially
>> lose redundancy - do SSDs crash and burn like hard drives do?
>>
>> If the SSD is only being used as a boot/OS drive - so near idle in n=
ormal
>> use - I'd swap it for a cheap small laptop hard drive and find somew=
here
>> else to put the SSD to better use.
>>
>> Cheers,
>>
>> John.
>>
>>
>
> Thanks for the input. My initial question was basically, "where's my
> bottleneck". The SSD is hosting the OS + an XBMC database :-) so I
> can't use it for anything else.
>
> // Mathias
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
