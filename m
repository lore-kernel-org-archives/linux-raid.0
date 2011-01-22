From: Matt Garman <matthew.garman@gmail.com>
Subject: Re: Low cost PCI-E unRAID - Supermicro AOC-SASLP-MV8 Driver/LBA
 questions for HW owners/users
Date: Sat, 22 Jan 2011 16:42:37 -0600
Message-ID: <AANLkTikoH59jfP=q5ReprWKQ9Vq=eEQ9kYhmTBq9pt4R@mail.gmail.com>
References: <AANLkTimp7xxQTv419oL7x6L-sbrhv1ZcEqLq+CfY6gs5@mail.gmail.com>
	<4D39D8B5.1090901@hardwarefreak.com>
	<AANLkTin2UZJc8yP6DGf2fgcDemQHznch5rGozmnL+V_u@mail.gmail.com>
	<4D3B0009.6020006@hardwarefreak.com>
	<AANLkTimqNjq6H5X5dPnM8Aw5W3NWtdY7ptGqQJ3ogJmO@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimqNjq6H5X5dPnM8Aw5W3NWtdY7ptGqQJ3ogJmO@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Another way to get an LSI SAS 1068 based card is the IBM ServeRAID
BR10i, discussed in detail here:

    http://www.servethehome.com/ibm-serveraid-br10i-lsi-sas3082e-r-pcie=
xpress-sas-raid-controller/

I bought two off ebay for $50 US.

The only caveat with these LSI SAS1068 cards is a driver bug that pops
up when using smartd on drives connected to the controller.  IIRC, the
bug was fixed in kernel version 2.6.36.  Lots of info on this on the
web and the list archives.

-Matt

On Sat, Jan 22, 2011 at 2:36 PM, Michael Evans <mjevans1983@gmail.com> =
wrote:
> On Sat, Jan 22, 2011 at 8:04 AM, Stan Hoeppner <stan@hardwarefreak.co=
m> wrote:
>> Michael Evans put forth on 1/21/2011 11:50 PM:
>>
>>> I wouldn't mind spending an extra $50 on the controller IF I knew i=
t
>>> supported 48 or 64 bit LBA, however neither the documentation on In=
tel
>>
>> No product descriptions list 48 bit LBA because ALL SAS/SATA devices=
 and HbAs
>> since ATA-6 (around 2003) natively support 48 bit LBA. =A0LBA48 is w=
hat got us
>> past the 137GB barrier. =A0The industry jumped from 28 bit LBA strai=
ght to 48 bit
>> LBA. =A0Google will show you this information in about 0.5 seconds. =
=A0I'll save you
>> those 0.5s: =A0http://www.48bitlba.com/
>
> Thank you, /that/ was the missing part of the picture; that ATA-6
> required support for it.
>
> Ironically I'd seen most of the result articles on Wikipedia, but was
> expecting something like that in a place other than the very top
> paragraph. =A0I was looking for some kind of table that specifically
> associated a standard with relevant minimal requirements. =A0I'm also
> very glad that I asked here first since I would have just gone with
> the better sounding hardware (4x PCI-e 2.0) over the more reliable an=
d
> closely priced older hardware (the 8x PCI-e 1.0).
>
> Also, you are half right about this being a 'dream' system. =A0For ye=
ars
> I've been using a carefully selected 6 port motherboard, and 3 PCI-e
> 1x cards to get a total of 12 ports. =A0However I'm looking to rebuil=
d
> that aging system and now that I have the proper funds want to do it
> with more reliable hardware. =A0I wanted to buy an adapter that would
> last until whatever standard comes out in another decade or so and
> handle any drives that might come on the market within that time.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
