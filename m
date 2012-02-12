From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: RAID corruption with kernel 3.2?
Date: Sun, 12 Feb 2012 04:53:15 +0000
Message-ID: <CADNH=7GP_7RvVf9nnhKtubo7gzXAw64k76LEnYZEyukx_FOM0A@mail.gmail.com>
References: <4F372848.5050105@zytor.com>
	<CADNH=7GGPdi87v2nJ1Jfsnym133uYdTiJ4yhtj8mJew2FMjFJQ@mail.gmail.com>
	<4F374363.8040306@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F374363.8040306@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12 February 2012 04:43, H. Peter Anvin <hpa@zytor.com> wrote:
> On 02/11/2012 08:14 PM, Mathias Bur=C3=A9n wrote:
>>
>>
>> Details? My>3.2 RAID6 still works fine.
>>
>
> What is your hardware configuration? =C2=A0Especially your CPU?
>
> The current suspicion -- but we don't know yet -- is that this is a p=
roblem
> on Sandy Bridge and some Penryn CPUs which have the XSAVE instruction=
, but
> we might very well be completely wrong on that.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0-hpa

The CPU is an old Intel Atom, so nothing special.  3.2.5 with CK patche=
s.

Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
