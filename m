From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Benchmarks: Linux Kernel RAID vs a Hardware RAID setup
Date: Mon, 21 Jul 2008 12:55:23 -0400
Message-ID: <4884BF7B.6030206@tmr.com>
References: <1216130769.5633.318.camel@sam.localdomain> <20080715163932.GA23164@rap.rap.dk> <487CEF1A.6050402@wasp.net.au> <20080715201221.GB26439@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080715201221.GB26439@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: Brad Campbell <brad@wasp.net.au>, Ben Martin <monkeyiq@users.sourceforge.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Keld J=F8rn Simonsen wrote:
> On Tue, Jul 15, 2008 at 10:40:26PM +0400, Brad Campbell wrote:
>  =20
>> Keld J=F8rn Simonsen wrote:
>>
>>    =20
>>> I would also welcome test with mobo HW RAID - Many mobo's today com=
e
>>> with some HW raid functionality, and many people would be in the
>>> situation of whether to choose a HW or SW configuration.
>>>      =20
>> Do you have some pointers for information on motherboards that come =
with=20
>> hardware raid? I'd be interested to have a look at them. I've certai=
nly=20
>> seen plenty of "fakeraid" systems, but I've not yet come across hard=
ware=20
>> raid on an MB.
>>    =20
>
> It is possible that I am thinking of what you call fakeraid.
>  =20

I like "firmware raid" better, but the bottom line here is that the rai=
d=20
is still done in the system CPU. These often have little or no hardware=
=20
support, such as cache so that multiple drives can be written without=20
passing the data through the system bus more than once (and chancing=20
change while that happens).
> Anyway this is what many users buy and look at employing.
> And my understanding is that you can set up the mobo controller in th=
e
> bios, and then have it running with Linux, without further software.=20
>  =20

Yes, although the reliability of firmware raid under device failure=20
conditions is dependent on the vendor, firmware level, etc, etc.
> I would then like to see what the differences are, and I hope to
> document that Linux raid is better... Anyway I am first and foremost
> just curious, and if HW/fake raid is faster or better, the I would
> gladly recommend it.
>  =20

Don't confuse HW and firmware raid, they don't have the same failure=20
points and capabilities.

--=20
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will stil=
l
  be valid when the war is over..." Otto von Bismark=20



--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
