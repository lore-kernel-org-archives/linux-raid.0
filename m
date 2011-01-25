From: Oliver Brakmann <obrakmann@gmx.net>
Subject: Re: raid1 mirror optimizations
Date: Tue, 25 Jan 2011 21:19:15 +0100
Message-ID: <tqn318-q0c.ln1@oberon.scorpius.lan>
References: <AANLkTimUbWcHi8w6UzxKjkavpOihV7V5Nm58mV7HA0AE@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimUbWcHi8w6UzxKjkavpOihV7V5Nm58mV7HA0AE@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

On 2011-01-25 19:56, Roberto Spadim wrote:
> could we implement a 'inverted' mirror? just for hard disks (for ssd
> it=C2=B4s a small loss of cpu/memory)

If I understood that correctly, this is exactly what the raid10 'far'
layout does.

Regards,
Oliver

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
