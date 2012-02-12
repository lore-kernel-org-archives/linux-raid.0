From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RAID corruption with kernel 3.2?
Date: Sat, 11 Feb 2012 20:43:15 -0800
Message-ID: <4F374363.8040306@zytor.com>
References: <4F372848.5050105@zytor.com> <CADNH=7GGPdi87v2nJ1Jfsnym133uYdTiJ4yhtj8mJew2FMjFJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7GGPdi87v2nJ1Jfsnym133uYdTiJ4yhtj8mJew2FMjFJQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TWF0aGlhcyBCdXLDqW4=?= <mathias.buren@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/11/2012 08:14 PM, Mathias Bur=C3=A9n wrote:
>
> Details? My>3.2 RAID6 still works fine.
>

What is your hardware configuration?  Especially your CPU?

The current suspicion -- but we don't know yet -- is that this is a=20
problem on Sandy Bridge and some Penryn CPUs which have the XSAVE=20
instruction, but we might very well be completely wrong on that.

	-hpa
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
