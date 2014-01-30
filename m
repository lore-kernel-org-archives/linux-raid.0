From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Questions about bitrot and RAID 5/6
Date: Thu, 30 Jan 2014 13:59:54 -0700
Message-ID: <980ACFFB-58BE-424E-A746-63D352B06E7F@colorremedies.com>
References: <20140121171943.GC6553@blisses.org> <52DFA01E.8000301@hesbynett.no> <78DCA4D1-9386-4BE7-894C-47EF4772C431@colorremedies.com> <52E0D060.3020508@hesbynett.no> <DE020E0C-E6EC-48E9-8D7B-09F5A65A2DF5@colorremedies.com> <52E16536.2070608@turmel.org> <30218363-7819-40A1-B647-D19C1FD90548@colorremedies.com> <52E2691E.4050701@turmel.org> <0466C42D-F51E-41D1-B220-F38EB43C1A38@colorremedies.com> <52E29CEF.7030408@turmel.org> <62EB0D79-9A50-4C50-ACBF-1C507D6F449B@colorremedies.com> <52E2AD10.5080208@turmel.org> <E222FBA0-8A1A-48EF-BEAA-BD059A8C1554@colorremedies.com> <52E2C5A3.1050803@turmel.org> <4ACB5D8F-CC0F-4CF2-96C7-03D05E40C89A@colorremedies.com> <52E3DCE4.4020909@turmel.org> <52E3F7FE.6000004@hardwarefreak.com> <0EDC3349-197C-402E-8940-06AF44A164B6@colorremedies.com> <alpine.DEB.2.0
 2.1401270810350.20074@uplift.swm.pp.se> <73BCC7B7-234C-4FD9-A1A0-BD5CCA7B9E09@colorremedies.com> <alpine.DEB.2.02.1401301049180.11807@uplift.swm.pp.se>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1401301049180.11807@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Jan 30, 2014, at 3:22 AM, Mikael Abrahamsson <swmike@swm.pp.se> wrot=
e:

> On Mon, 27 Jan 2014, Chris Murphy wrote:
>=20
>>> This is your interpretation of the claim. My interpretation of the =
data is that you will get an URE for every 10^14 bits read.
>>=20
>> How does your interpretation differ if the < sign is removed from th=
e stated spec? Linguistically, how do you alter the description if that=
 symbol is and isn't present?
>=20
> THe spec is an SLA. THe manufacturer will try to beat that number to =
keep the SLA. Sometimes they're a lot better, sometimes they're worse a=
nd then they have to compensate the customer.

The spec being an agreement that activates a warrantied replacement is =
a plausible argument. And I agree with the characterization that a part=
icular drive may be perform better or worse.

But the spec says "less than 1 per 1E14 bits" not "less than or equal t=
o". If we actually get 1 URE in 1E14 bits read, that's busting the spec=
=2E An average of 1 URE in 1E14 bits read is likewise busting the spec.=
 And if that were an average across a population it would mean drive ma=
nufacturers are on the hook for some 50% of their drives being replaced=
, and we know that is definitely not happening.

And I'm not reading this as "the first time you get 2 UREs in less than=
 1E14 read" you've hit the SLA, although someone could possibly make th=
at argument.

I'd say overwhelmingly drives are performing a lot better than this spe=
c. The idea we should expect a URE on average just by reading a 4TB dri=
ve three times in a row makes no sense. People would be having all sort=
s of problems, which they aren't. And if it really were a mean, this sh=
ould be readily reproducible yet it isn't. In 12x full reads of three 3=
TB drives, zero UREs. That's over 100TB read without a URE. And these a=
re ~2 year old drives.

>=20
>> And we also know that the size of the packet does affect error rates=
, just not within an order of magnitude, such is also the case with HDD=
s between conventional and AF disks. But the allowance of up to but not=
 including an order of magnitude is necessarily implied by the less tha=
n sign or it wouldn't be there. It's a continuum, it's not a statement =
of what will happen on average. It's a statement that error will occur =
but won't exceed X errors in Y bits.
>=20
> If you run the connection full, the packet size doesn't affect the bi=
t error rate, only the result of the bit error.

Packet size doesn't affect raw bit error rate, it does affect the packe=
t error rate. Bigger packets means a higher packet error rate. The URE =
is argued to be "errors per bits read" not "bit errors per bits read" s=
o comparing URE to BER is mixing units.=20

The URE is more analogous to packet error rate. The limitation with tha=
t comparison is that network CRC is the same regardless of packet size.=
 Whereas the ECC in 512 byte and 4096 byte sector drives is not the sam=
e.


>=20
>>> Where exactly in the available data does it say that?
>>=20
>> Drive manufacturers saying AF disks means better error correction bo=
th because of the larger size of sectors, and also more ECC bits.
>>=20
>> http://www.snia.org/sites/default/files2/SDC2011/presentations/wedne=
sday/CurtisStevens_Advanced_Format_Legacy.pdf
>>=20
>> http://storage.toshiba.eu/export/sites/toshiba-sdd/media/downloads/a=
dvanced_format/4KWhitePaper_TEG.pdf
>> ", if the data field to be protected in each sector is larger than 5=
12 bytes, the ECC algorithm could be improved to correct for a higher n=
umber of bits in error"
>>=20
>> http://www.idema.org/wp-content/plugins/download-monitor/download.ph=
p?id=3D1244
>> page 3, 2nd figure "errors per 512 bytes vs physical block size"
>>=20
>> There's loads of information on this=85
>=20
> The 4k sector design is an internal design means to achieve the speci=
fied SLA. So while 4k ECC is better, the manufacturer might use a highe=
r density with a higher bit error rate, but which end result is still w=
ithin the offered SLA because of better error correction method.
>=20
> So we're back to what the 10^-14 means. This is all you have to go on=
, because internally the manufacturer is free to use 512b sector size, =
4k sector size, or pixie dust to achieve the specs they're offering the=
 end customer. There is nothing that says that you as a customer gets t=
o partake in any improvement due to internal changes within the unit.

Agreed, insofar as we only knowt the max error rate anticipated by the =
spec. We do not know the average occurrence based on the spec. To compu=
te that we need a scientific sample of drives, with all of the drives p=
roducing error rates greater than 1 URE in 1E14 bits discarded. An unwe=
ighted average would be useless because such drives should trigger a wa=
rranty replacement. And I don't know of any published studies that have=
 done that - presumably this has been done by drive manufacturers thoug=
h.


Chris Murphy

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
