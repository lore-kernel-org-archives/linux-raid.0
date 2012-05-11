From: Daniel Pocock <daniel@pocock.com.au>
Subject: Re: md RAID with enterprise-class SATA or SAS drives
Date: Fri, 11 May 2012 08:31:13 +0000
Message-ID: <4FACCE51.7050809@pocock.com.au>
References: <4FAAE8F1.8000600@pocock.com.au> <CALFpzo5ObdwFATdT4e20znnxzU5hX9SVSfqJcdqOXM1FEYJQuw@mail.gmail.com> <4FABC7C6.4030107@turmel.org> <4FAC2FF2.5060305@hardwarefreak.com> <4FAC33CC.6040203@pocock.com.au> <4FAC710F.7030705@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FAC710F.7030705@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Phil Turmel <philip@turmel.org>, Marcus Sorensen <shadowsor@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 11/05/12 01:53, Stan Hoeppner wrote:
> On 5/10/2012 4:31 PM, Daniel Pocock wrote:
> 
>> Actually, the TLER term is mentioned elsewhere, for example the Adaptec
>> blog I came across
> 
> The term "Time-Limited Error Recovery" (TLER) was introduced to the
> world by Western Digital on August 3, 2004, almost 8 years ago.  They
> introduced the term in their press release announcing their (then) new
> RAID Edition (RE) serial ATA drives.
> 
> http://www.wdc.com/en/company/pressroom/releases.aspx?release=3f62e91b-288b-4852-8f6c-5abe507ec8dd
> 
> This term is exclusive to Western Digital Corporation.  It does not
> apply to any other vendors' hard drives, nor any other product of any
> kind.  It is not a general term for a function.  The general term for
> this function is called Error Recovery Control (ERC).  If anyone applies
> this term to any drive other than a WDC model, using it as a general
> term, then s/he is uninformed and using the term incorrectly.
> 
> I do not currently, nor have I ever, worked for WDC.  I simply hate
> marketing buzzwords, and hate even more people's misuse of such
> marketing buzzwords.

I agree, so I'll stop using that term for now

>> Economists often talk about price selectivity, e.g. the coffee shops
>> that charge an extra pound/euro/dollar for `organic' coffee.  Does it
>> really cost an extra pound to produce one teaspoon of coffee in an
>> organic way?  Of course not, it's just a gimmick to extract an extra
>> pound from people who won't lose any sleep over spending an extra pound.
> 
> Price gouging for gourmet coffee isn't an apt analogue of the disk drive
> business.

Actually, it is relevant

I realise many vendors are well-intentioned and really do give you the
extra things you pay for - but it should never be taken for granted.

That's why I ask questions about the drive hardware.

> 
>> I'm going the opposite direction, trying to move away from
>> cheap drives - but I don't want to invest heavily in something that is
>>
>> a) just a marketing gimmick
> 
> Enterprise drives aren't a marketing gimmick.  Some of the merketing
> language surrounding them is, but that's always the case with marketing.

There is also an `ambush' concept in marketing: if everyone is looking
for `enterprise' drives, then someone comes along and puts `enterprise'
stickers on a desktop drive for making a quick buck.  There are plenty
of examples of this in other domains.  So 9 out of 10 enterprise
products might really be what I want, but there may be 1 out of 10 that
is just a gimmick?

>>> Either that, or md raid is only used by hobbyists. ;)
>>>
>> Better a hobbyist running Linux than a professional running Windows with
>> fakeraid
> 
> Heheh, no doubt.
> 
> For those who don't grasp the tongue-in-cheek nature of it, my stating
> "md raid is only used by hobbyists" is obviously not a literal face
> value statement.  There are dozens of enterprise NAS products on the
> market that ship using md raid, and there are plenty of enterprise
> size/caliber IT shops that use mdraid, though probably not exclusively.
>  There are many more than use md raid striping or concatenation to
> stitch together multiple hardware RAID logical drives and/or SAN LUNs.

There is a whole world between enterprise and hobbyist

Think about:
- home users who want to make an extra effort to protect their digital
photo/video collection (RAID is no substitute for backup of course)
- small businesses - 30% of employment is in small business.  For
businesses with less than 10 staff, they really do look at IT costs
closely.  When I was a student I spent a lot of time selling Linux
solutions to such businesses, now I work with larger enterprises.  I had
one client who was offline for half a day having their server disk
replaced, when I offered them a hot swap solution they said it wasn't
worth the money, they could survive without email and catch up on some
paperwork for 2-3 hours as long as it didn't happen every other month.
- other budget-critical users: research, education, health care, etc.
They often work within fixed budgets, and if they can get an acceptable
IT facility for less money, the cash they save goes elsewhere (or buys
more drive space for example)

> The statement is also meant to poke the ribs of the pure hobbyist users
> in an attempt to get them more into an enterprise way of approaching
> RAID implementation and management.
> 
There are many things in Linux that are not exactly the way things are
expected to be in an enterprise product: but the same can be said for
Windows.
