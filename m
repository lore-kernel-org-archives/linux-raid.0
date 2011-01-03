From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: [Slightly OT] Cheap 4-port PCI-E SATA card?
Date: Mon, 03 Jan 2011 15:29:20 +0000
Message-ID: <4D21EB50.7060301@anonymous.org.uk>
References: <4D20E9F7.2080800@anonymous.org.uk> <AANLkTimDZR0ZFaXT49UL7DQttEtWJ2X2Rkc40UAD6VkS@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimDZR0ZFaXT49UL7DQttEtWJ2X2Rkc40UAD6VkS@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/01/2011 23:04, Matt Garman wrote:
> On Sun, Jan 2, 2011 at 3:11 PM, John Robinson
> <john.robinson@anonymous.org.uk>  wrote:
>> Please could someone suggest a cheap PCI-E SATA card with 4 internal=
 ports?
>>
>> I currently have 6 motherboard SATA ports and a 5-drive hot-swap cha=
ssis, I
>> am thinking of adding a second 5-drive hot-swap chassis to my case a=
nd would
>> need another 4 SATA ports to drive it.
>>
>> Other requirements: known to work with RHEL/CentOS 5 kernels, even i=
f it
>> means installing a driver with DKMS or whatever.
>
> You can also get a SAS card, and an overpriced mini-SAS to SATA cable=
=2E
>   The LSI SAS 1068e chip is quite common and well supported by Linux.
> You can buy LSI-branded cards, or from another OEM that uses the same
> chip.  Intel makes such a card, and I just read that IBM does as well=
,
> the ServeRAID BR10i LSI SAS3082E-R.  Covered in detail here:
>
>      http://www.servethehome.com/ibm-serveraid-br10i-lsi-sas3082e-r-p=
ciexpress-sas-raid-controller/
>
> Such a card will actually give you a total of eight SATA ports, but
> you obviously don't have to use them all; you can get away with only
> buying one of the SAS to 4-SATA port fanout cables.
>
> I grabbed two of those IBM BR10i cards off of ebay for about $50.
> Unfortunately, I didn't pay close attention to the listing, and mine
> came without PCI brackets.  But so far I've tested one, and it works
> just fine.

I've just had a look on eBay and the few there are don't have brackets=20
in their pictures. But still, this is definitely an option, looks like =
I=20
might be able to pick one up for about =A350, which was pretty much the=
=20
most I really wanted to spend. More like =A360 by the time I've got the=
=20
cable, but I would have another 4 spare SATA ports :-)

>> Doesn't have to be PCI-E x1 because I've a spare x8 (logical)/x16 (p=
hysical)
>> slot, but I don't know if anything cheap's going to be anything othe=
r than
>> PCI-E x1. v2.0 (5GT/s) would be nice though.
>
> If you're using a typical consumer-grade motherboard, watch out that
> the PCIe slot supports things other than video cards.  For whatever
> reason, particularly on micro-ATX boards, the PCIe x8/x16 slots often
> won't work with anything other than video cards.  Trying to use
> something else (e.g. a RAID card) will, at best, prohibit the machine
> from booting, or at worst, cause very subtle random problems.

It's an Asus P5Q Pro, Intel P45+ICH10R, a fairly boring basic=20
workstation grade (not gaming) full ATX motherboard, and if it doesn't=20
like having something other than a video card in its second x16 slot=20
I'll start screaming at Asus.

Thanks for your advice!

Cheers,

John.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
