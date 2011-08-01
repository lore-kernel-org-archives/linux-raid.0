From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: component device mismatches found: 9600
Date: Mon, 1 Aug 2011 20:49:47 +0100
Message-ID: <CADNH=7Gr6h_4Fpn5QwwKnyJrd18EUo36tidCJJ5WrKvAMqkmog@mail.gmail.com>
References: <4E359DC0.5090608@vorgon.com>
	<CADNH=7H0+RP7yiE01NmxncTBapsMLRt1XkqAHxZr=FEAC9Zx1A@mail.gmail.com>
	<4E370227.2070804@vorgon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E370227.2070804@vorgon.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Timothy D. Lenz" <tlenz@vorgon.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 1 August 2011 20:44, Timothy D. Lenz <tlenz@vorgon.com> wrote:
>
> Don't think I have smartctl installed. Tried with/out sudo
> =C2=A0vorg@x64VDR:~$ smartctl -a /dev/sda
> =C2=A0-bash: smartctl: command not found

So install it, or compile it from source and run it (smartmontools).
It would be interesting to see if you have a problem with
HDDs/controllers/backplanes/cables.

/M
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
