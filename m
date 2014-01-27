From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Questions about bitrot and RAID 5/6
Date: Mon, 27 Jan 2014 11:20:50 -0700
Message-ID: <73BCC7B7-234C-4FD9-A1A0-BD5CCA7B9E09@colorremedies.com>
References: <20140121171943.GC6553@blisses.org> <52DFA01E.8000301@hesbynett.no> <78DCA4D1-9386-4BE7-894C-47EF4772C431@colorremedies.com> <52E0D060.3020508@hesbynett.no> <DE020E0C-E6EC-48E9-8D7B-09F5A65A2DF5@colorremedies.com> <52E16536.2070608@turmel.org> <30218363-7819-40A1-B647-D19C1FD90548@colorremedies.com> <52E2691E.4050701@turmel.org> <0466C42D-F51E-41D1-B220-F38EB43C1A38@colorremedies.com> <52E29CEF.7030408@turmel.org> <62EB0D79-9A50-4C50-ACBF-1C507D6F449B@colorremedies.com> <52E2AD10.5080208@turmel.org> <E222FBA0-8A1A-48EF-BEAA-BD059A8C1554@colorremedies.com> <52E2C5A3.1050803@turmel.org> <4ACB5D8F-CC0F-4CF2-96C7-03D05E40C89A@colorremedies.com> <52E3DCE4.4020909@turmel.org> <52E3F7FE.6000004@hardwarefreak.com> <0EDC3349-197C-402E-8940-06AF44A164B6@colorremedies.com> <alpine.DEB.2.0
 2.1401270810350.20074@uplift.swm.pp.se>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1401270810350.20074@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: stan@hardwarefreak.com, Phil Turmel <philip@turmel.org>, "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Jan 27, 2014, at 12:16 AM, Mikael Abrahamsson <swmike@swm.pp.se> wro=
te:

> On Sun, 26 Jan 2014, Chris Murphy wrote:
>=20
>> I accept that. But since there are two sector sizes, one URE does no=
t represent the same amount of data loss.
>=20
> This is your interpretation of the claim. My interpretation of the da=
ta is that you will get an URE for every 10^14 bits read.

How does your interpretation differ if the < sign is removed from the s=
tated spec? Linguistically, how do you alter the description if that sy=
mbol is and isn't present?

> How many data bits that are lost by this URE is not important, either=
 you lose 512 bytes or 4096 bytes. The bit error rate is still calcluat=
ed on total amount read, regardless of how many bits are when this URE =
happens.
>=20
> In data communication (ethernet for instance), we say the bit error r=
ate is 10^-12. When you get a bit error, you're going to lose the entir=
e packet. The size of the packet doesn't count in the error rate calcul=
ation. I don't see why HDDs would be different.

This is a really good point. Data communication standards are more read=
ily published and must be interoperable. But even the network specs des=
cribe BER in "less than X in Y" or "X in Y, max" terms, not as an error=
 occurring every Y bits.

And we also know that the size of the packet does affect error rates, j=
ust not within an order of magnitude, such is also the case with HDDs b=
etween conventional and AF disks. But the allowance of up to but not in=
cluding an order of magnitude is necessarily implied by the less than s=
ign or it wouldn't be there. It's a continuum, it's not a statement of =
what will happen on average. It's a statement that error will occur but=
 won't exceed X errors in Y bits.

> The bit error rate is one thing, the consequence of the bit error and=
 how much data is lost is another thing. You insist that these are dire=
ctly coupled.

No, I'm saying that the actual break down of bits lost translates to an=
 irrational consequence when reading the spec as if there isn't a less =
than symbol present.


>=20
>> Fine, but if you accept that the probability of URE is the same betw=
een conventional and AF disks, you accept that there are more bits bein=
g lost on AF disks than conventional disks. Yet the available data says=
 the opposite is true.
>=20
> Where exactly in the available data does it say that?

Drive manufacturers saying AF disks means better error correction both =
because of the larger size of sectors, and also more ECC bits.

http://www.snia.org/sites/default/files2/SDC2011/presentations/wednesda=
y/CurtisStevens_Advanced_Format_Legacy.pdf


http://storage.toshiba.eu/export/sites/toshiba-sdd/media/downloads/adva=
nced_format/4KWhitePaper_TEG.pdf
", if the data field to be protected in each sector is larger than 512 =
bytes, the ECC algorithm could be improved to correct for a higher numb=
er of bits in error"

http://www.idema.org/wp-content/plugins/download-monitor/download.php?i=
d=3D1244
page 3, 2nd figure "errors per 512 bytes vs physical block size"

There's loads of information on this=85




Chris Murphy

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
