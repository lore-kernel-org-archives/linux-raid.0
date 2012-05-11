From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: md RAID with enterprise-class SATA or SAS drives
Date: Thu, 10 May 2012 20:53:19 -0500
Message-ID: <4FAC710F.7030705@hardwarefreak.com>
References: <4FAAE8F1.8000600@pocock.com.au> <CALFpzo5ObdwFATdT4e20znnxzU5hX9SVSfqJcdqOXM1FEYJQuw@mail.gmail.com> <4FABC7C6.4030107@turmel.org> <4FAC2FF2.5060305@hardwarefreak.com> <4FAC33CC.6040203@pocock.com.au>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FAC33CC.6040203@pocock.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Pocock <daniel@pocock.com.au>
Cc: Phil Turmel <philip@turmel.org>, Marcus Sorensen <shadowsor@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/10/2012 4:31 PM, Daniel Pocock wrote:

> Actually, the TLER term is mentioned elsewhere, for example the Adaptec
> blog I came across

The term "Time-Limited Error Recovery" (TLER) was introduced to the
world by Western Digital on August 3, 2004, almost 8 years ago.  They
introduced the term in their press release announcing their (then) new
RAID Edition (RE) serial ATA drives.

http://www.wdc.com/en/company/pressroom/releases.aspx?release=3f62e91b-288b-4852-8f6c-5abe507ec8dd

This term is exclusive to Western Digital Corporation.  It does not
apply to any other vendors' hard drives, nor any other product of any
kind.  It is not a general term for a function.  The general term for
this function is called Error Recovery Control (ERC).  If anyone applies
this term to any drive other than a WDC model, using it as a general
term, then s/he is uninformed and using the term incorrectly.

I do not currently, nor have I ever, worked for WDC.  I simply hate
marketing buzzwords, and hate even more people's misuse of such
marketing buzzwords.

> Economists often talk about price selectivity, e.g. the coffee shops
> that charge an extra pound/euro/dollar for `organic' coffee.  Does it
> really cost an extra pound to produce one teaspoon of coffee in an
> organic way?  Of course not, it's just a gimmick to extract an extra
> pound from people who won't lose any sleep over spending an extra pound.

Price gouging for gourmet coffee isn't an apt analogue of the disk drive
business.

Manufacturers do make more profit per enterprise SATA drive than they do
desktop SATA drives.  But the overall cost difference has nothing to do
with price gouging, nor this additional profit.  The cost difference is
due to the following factors:

1.  Vastly lower numbers produced, on the order of 1000:1
    We're all familiar with economy of scale yes?

2.  Firmware features that are developed for a handful of drive
    models.  The R&D dollars expended for this are spread over far
    fewer units sold, yet require an order of magnitude more
    verification work

3.  Compatibility testing and verification with hundreds of PCIe RAID
    controllers and HBAs, standalone RAID enclosures w/onboard
    controllers, JBOD chassis with and without SAS expanders, iSCSI and
    Fiber Channel arrays, etc, etc, etc.

4.  A greatly enhanced and more time consuming QC process for the drive
    hardware and firmware

#3 and #4 account for the majority of the cost premium of an enterprise
SATA drive vs a desktop SATA drive.  Labor is typically the most costly
aspect of manufacturing for electronics products.  3/4 are extremely
labor/time intensive.

> I'm going the opposite direction, trying to move away from
> cheap drives - but I don't want to invest heavily in something that is
> 
> a) just a marketing gimmick

Enterprise drives aren't a marketing gimmick.  Some of the merketing
language surrounding them is, but that's always the case with marketing.

> b) not going to do me any good if md doesn't exercise the special
> features of the hardware

If you will not be using a server nor JBOD chassis with an SAS expander
backplane for which your hard drives are certified, then there is little
benefit for you WRT enterprise SATA drives and md raid, other than
overall increased quality and a longer warranty.

>> Either that, or md raid is only used by hobbyists. ;)
>>
> Better a hobbyist running Linux than a professional running Windows with
> fakeraid

Heheh, no doubt.

For those who don't grasp the tongue-in-cheek nature of it, my stating
"md raid is only used by hobbyists" is obviously not a literal face
value statement.  There are dozens of enterprise NAS products on the
market that ship using md raid, and there are plenty of enterprise
size/caliber IT shops that use mdraid, though probably not exclusively.
 There are many more than use md raid striping or concatenation to
stitch together multiple hardware RAID logical drives and/or SAN LUNs.

The statement is also meant to poke the ribs of the pure hobbyist users
in an attempt to get them more into an enterprise way of approaching
RAID implementation and management.

-- 
Stan
