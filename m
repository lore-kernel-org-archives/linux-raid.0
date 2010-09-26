From: Mike Hartman <mike@hartmanipulation.com>
Subject: Re: Accidental grow before add
Date: Sun, 26 Sep 2010 06:18:09 -0400
Message-ID: <AANLkTikOr3LdZ_uy5Vnj=wu0k7Ag8A+LXRYwxf69YNOv@mail.gmail.com>
References: <AANLkTi=PydpqTR1x=KTfW16en3U3+KxoLV85iWpWtRC9@mail.gmail.com>
	<AANLkTi=3MEirXZs_Qv7nO7fvAKxvErnkvAiEe8fdxQA=@mail.gmail.com>
	<AANLkTimPPD6TfoX7GVbaNgQo1CPpjc7LLG-nWDz7=En=@mail.gmail.com>
	<alpine.DEB.1.10.1009261159120.28005@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.1009261159120.28005@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> You need to start looking in dmesg / other logs to see what has happe=
ned and
> why things have failed. Without that information it's impossible to t=
ell
> what's going on.
>
> --
> Mikael Abrahamsson =A0 =A0email: swmike@swm.pp.se
>

I've uploaded the dmesg output starting with the reshape to
www.hartmanipulation.com/raid/dmesg_6.txt. It looks like /dev/sdd is
having some kind of intermittent read issues (which wasn't happening
before the reshape started) but I still don't understand why it
wouldn't be marked as failed in the md2 section of mdstat, since md0
is accessing it via md2.

At any rate, that doesn't help me with my most immediate issue: does a
drive failing during a reshape corrupt the array? Or am I safe to
resume the reshape? Is there any way to restore my safety net a bit
before resuming the reshape, or will I just have to hope nothing else
goes wrong between now and the time the new hot spare is finally
incorporated?

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
