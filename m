From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: RAID6 data-check took almost 2 hours, clicking sounds, system unresponsive
Date: Thu, 14 Apr 2011 22:19:18 +0100
Message-ID: <BANLkTinttwOaDm=QK5nbUd6Vbfzwur1Lyw@mail.gmail.com>
References: <259379.79604.qm@web65105.mail.ac2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <259379.79604.qm@web65105.mail.ac2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gavin Flower <gavinflower@yahoo.com>
Cc: Phil Turmel <philip@turmel.org>, neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 14 April 2011 22:14, Gavin Flower <gavinflower@yahoo.com> wrote:
> --- On Fri, 15/4/11, Phil Turmel <philip@turmel.org> wrote:
>
>> From: Phil Turmel <philip@turmel.org>
>> Subject: Re: RAID6 data-check took almost 2 hours, clicking sounds, =
system unresponsive
>> To: "Gavin Flower" <gavinflower@yahoo.com>
>> Cc: "Mathias Bur=C3=A9n" <mathias.buren@gmail.com>, neilb@suse.de, l=
inux-raid@vger.kernel.org
>> Date: Friday, 15 April, 2011, 1:16
>> Hi Gavin,
>>
>> I think you might want to investigate your *power supply*
> [...]
>
> Attaching OpenDocument file with full details of smart output and com=
parison table.
>
>
> Cheers,
> Gavin

sda has a value higher than 0 on reported uncorrected sectors. That's
enough for me to replace a drive. (heck, even if I see 1 reallocated
sector I'd RMA it ASAP).

Regards,
Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
