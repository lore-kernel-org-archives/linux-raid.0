From: =?UTF-8?B?Vm9qdMSbY2ggS2xldGXEjWth?= <vojta.kletecka@gmail.com>
Subject: Re: USB-to-SATA and RAID
Date: Tue, 23 Jan 2018 23:23:03 +0100
Message-ID: <CAEmSg0_ERGs7uZnsp45-O61C4+hVT=4OZEaUHyY5wqEKnj4Cbw@mail.gmail.com>
References: <20180123201614.GI23784@otheros> <3b12354d-d8bb-9593-8bee-489574caf84f@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3b12354d-d8bb-9593-8bee-489574caf84f@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wol's lists <antlists@youngman.org.uk>
Cc: =?UTF-8?Q?Linus_L=C3=BCssing?= <linus.luessing@c0d3.blue>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have only a little technical insight into this topic, however, I
have some (terrible) personal experience with USB raid and I would
point out another aspect.
Although USBs are good for occasional connections of simple drives
they have quite a strong tendency to wear out. This becomes a problem
especially if you plan to connect raid often and means that wires
might not connect or lose connection during the transition of data.
I happened to have raid connected to older USB ports and connection
was pretty unstable. Multiple times unexpected disconnection due to
wires losing contact caused a problem and the disconnected disk
(although almost perfectly valid) had to be completely rebuilt. I
thought it was not that bad but later it caused sort of desync and I
was unable to connect any two of three disks so the data was lost. My
only luck was that I had all the data (at least important data) backed
up.

So if you're considering raid over USB I suggest you don't do that. It
will probably save you a lot of troubles.

With kind regards,

2018-01-23 21:46 GMT+01:00 Wol's lists <antlists@youngman.org.uk>:
> On 23/01/18 20:16, Linus L=C3=BCssing wrote:
>>
>> Hi,
>>
>> By chance I found this statement in the Linux RAID Wiki:
>>
>> "Do NOT use [USB devices] as part of your array. They have
>>   a timeout/disconnect mechanism which interacts very
>>   badly with the raid code." [0]
>
>
> That was me that wrote that on the wiki. However, I'm just editing stuff =
so
> I don't actually have any experience of it.
>>
>>
>> Could someone elaborate further on this? Does "interacts very
>> badly" mean that there will be potential data loss / data
>> corruption? Or does "very badly" just mean short, temporary
>> performance issues / lags upon a disk failure?
>>
> The wiki also mentions the timeout problem. As far as I can make out - an=
d
> bear in mind as I said above I don't have personal experience - it seems =
to
> me from what I've picked up that USB suffers this problem in spades.
>
> In other words, what I *think* happens, from what I've picked up, is that
> the USB bus times out. And when the raid comes along to use the disk, the
> USB bus is no longer responding ... BOOM!
>
>> Regards, Linus
>>
> I hope that's helpful, and maybe people who know more will chime in, but
> that's it as I understand it.
>
> Cheers,
> Wol
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--=20
Pokud tento mail obsahuje tautologii, pak z=C5=99ejm=C4=9B tautologii skute=
=C4=8Dn=C4=9B obsahuje.

Vojt=C4=9Bch Klete=C4=8Dka
