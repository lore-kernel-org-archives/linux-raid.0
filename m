From: mark delfman <markdelfman@googlemail.com>
Subject: Re: xfs > md 50% write performance drop on .30+ kernel?
Date: Tue, 13 Oct 2009 16:15:55 +0100
Message-ID: <66781b10910130815j3f8cc66al2ae03953aedb66ef@mail.gmail.com>
References: <66781b10910120958k4afb637ejba79e4c23900c4da@mail.gmail.com>
	 <20091013013352.GA24869@infradead.org>
	 <66781b10910130406s4119985fg5db7679a2e9fd4f2@mail.gmail.com>
	 <70ed7c3e0910130409r1e1350b6yabfdc3d4f5c51edf@mail.gmail.com>
	 <66781b10910130412x309d9de2l574ba12a9ed4100a@mail.gmail.com>
	 <70ed7c3e0910130415k4da86d18kd92dce5217b8600d@mail.gmail.com>
	 <4AD48EFA.50303@shiftmail.org>
	 <66781b10910130813u7f9ca010t7cd05214be729fff@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <66781b10910130813u7f9ca010t7cd05214be729fff@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

PS - LSI havent publically released the SAS2 (non-raid) card as yet.
They have just released the RAID version and will follow with the
non-raid soon.

Their chips are being used on some of the later server motherboards,
so SAS2 is around but new.



On Tue, Oct 13, 2009 at 4:13 PM, mark delfman
<markdelfman@googlemail.com> wrote:
> We dont use 10 ports, we use 8 ports > 36 port expander. The 8 ports
> act as a single wide port.
>
> We are hitting a performance limit of circa 1.6 - 1.9GBsec regardless
> of number of drives, so it max's at around 8 / 9 drives (with 15K).
> RAID6 around 900MBsec i recall. =A0We expect more with emerging
> expanders.
>
> We were hoping to use DM MPIO to increase performance using multiple
> cards and paths, but MPIO at best matches performance of a single
> card, most likely pulls it down.... but this is a different topic i
> guess.
>
> XFS in the past has often increased performance - not allows on simpl=
e
> sequential writes, but FS's are a lot better at intelligently caching
> data... so I am very keen to help in whatever way i can to resolve th=
e
> FS > MD performance problem.
>
> Thanks again.... Mark
>
>
> On Tue, Oct 13, 2009 at 3:30 PM, Asdo <asdo@shiftmail.org> wrote:
>>
>>> On Tue, Oct 13, 2009 at 2:12 PM, mark delfman
>>> <markdelfman@googlemail.com> wrote:
>>>
>>>>
>>>> We upgrading mainly because of support for the emerging LSI SAS2 c=
ards
>>>> (which we are beta testing now)
>>>>
>>
>> What is this LSI SAS2 card you have with 10+ ports? The only 10+ por=
ts LSI
>> card I see is the 84016E and it is a SAS1.
>>
>> You say the driver for such card is included in the vanilla kernel a=
t
>> 2.6.30? That would be very nice... I grepped the 2.6.31 kernel sourc=
e for
>> LSI cards but I can't find device strings such as 84016E ...
>>
>> Thank you
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
