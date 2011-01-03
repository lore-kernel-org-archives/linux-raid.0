From: "Sven Eschenberg" <sven@whgl.uni-frankfurt.de>
Subject: Re: [Slightly OT] Cheap 4-port PCI-E SATA card?
Date: Mon, 3 Jan 2011 18:02:51 +0100 (CET)
Message-ID: <1625d1dff8a739c00a1b1738d98b9c31.squirrel@ssl.verfeiert.org>
References: <4D20E9F7.2080800@anonymous.org.uk>
    <20110103033100.40a80113@natsu> <4D21E726.7070306@anonymous.org.uk>
Reply-To: sven@whgl.uni-frankfurt.de
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D21E726.7070306@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


http://skinflint.co.uk/eu/a367722.html

I got one of those, still a little too expensive imho, but it does it's
job as expected.

In-kernel drivers seem to work well till now (used several 2.6.33.x and
following kernel versions without any problems so far).

Does have PCI-e x4 thus providing more bandwidth that the 4 connected
drives can achieve and should support FIS PMPs aswell.

lspci agrees on this: LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train-
SlotClk+ DLActive- BWMgmt- ABWMgmt-.

/dev/md127:
 Timing O_DIRECT cached reads:   888 MB in  2.00 seconds =3D 443.38 MB/=
sec
 Timing O_DIRECT disk reads: 602 MB in  3.00 seconds =3D 200.40 MB/sec

Since I use a raid 6 setup on the four drives and reading from each mem=
ber
drive's cache yiels roughly 220MB/sec the value of 440 MB/sec seems
reasonable. I don't have the chance right now to set up a stripeset of =
4
drives to check if I could get around 800MB from their caches, but I di=
d
achieve roughly 450 MB/sec from a SSD stripe I had connected. So I cann=
ot
tell you what the upper limit of the card/chipset is there, but I found
the rates fair enough for my needs.

I couldn't find any UK Reseller for an equivalent board at a similiar l=
ow
price (unfortunately) - misco UK does have the following:

http://www.misco.co.uk/applications/SearchTools/item-details.asp?EdpNo=3D=
399329&Tab=3D2&NoMapp=3D0

Which is definately too expensive ... maybe you got better luck digging
for a card+reseller with that chipset.

Regards

-Sven




On Mon, January 3, 2011 16:11, John Robinson wrote:
> On 02/01/2011 22:31, Roman Mamedov wrote:
>> On Sun, 02 Jan 2011 21:11:19 +0000
>> John Robinson<john.robinson@anonymous.org.uk>  wrote:
>>
>>> Please could someone suggest a cheap PCI-E SATA card with 4 interna=
l
>>> ports?
>>
>> "Marvell 88SE6445 Raid 0,1,5,10 and JBOD", $60 at eBay:
>> http://ur1.ca/2qa3t
>
> In the UK the best I've found is the Highpoint 2640x1 at =A392 ex del=
ivery
> and taxes, which at current exchange rates is $142. I'm slightly
> reluctant to buy a no-brand item direct from China.
>
>> "LSI SAS3041E-R 4-Port SAS/SATA Host Bus Adapter", $73 at DX:
>> http://www.dealextreme.com/details.dx/sku.51317
>
> =A3113 or $174 is the best I can find in the UK. I wonder if they shi=
p
> internationally... their $73 is =A348...
>
>> Or if you meant 'cheap' as in $20-30 cheap, then there's no such (4-=
Port
>> PCI-E)
>> thing, but you can easily get not one, but two 2-Port PCI-E x1 board=
s
>> for that
>> price. If you go that route, make sure you get the JMB363 chip, unli=
ke
>> SiI3132
>> it has not been spotted having any data corruption issues AFAIK.
>
> Well, there are 4-port PCI cards in the =A317-25 cheap range, so I ha=
d
> hoped there would be 4-port PCI-E cards in the =A335-50 range, which =
is
> the ballpark for basic cheap motherboards with 4-6 SATA ports on them=
,
> but it's not generally true.
>
> Anyway thanks for the help, I shall chase up DX and think on...
>
> Cheers,
>
> John.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
