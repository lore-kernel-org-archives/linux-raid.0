From: "Majed B." <majedb@gmail.com>
Subject: Re: mdadm segfault when assembling the array
Date: Wed, 7 Oct 2009 11:50:36 +0300
Message-ID: <70ed7c3e0910070150u4445daa8u194d00f0e3f25b8f@mail.gmail.com>
References: <4ACC5265.2020602@wpkg.org> <70ed7c3e0910070140l1240d48ak1d12738f9f00f0e9@mail.gmail.com>
	<4ACC55C1.6020603@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4ACC55C1.6020603@wpkg.org>
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

My bad. I haven't noticed that you were using 3.0.2

Try to force the assembly of the array -Af and see if it works. If
that doesn't work, run it again using strace (strace mdadm ...) and
that should give much more detail into why this is happening.

On Wed, Oct 7, 2009 at 11:48 AM, Tomasz Chmielewski <mangoo@wpkg.org> w=
rote:
>
> Majed B. schrieb:
>>
>> If you're not using the latest version of mdadm, grab it, compile it=
, install it and try. I faced the same problem because I was using an o=
lder version.
>
> AFAIK mdadm 3.0.2 is the latest-greatest (stable) release:
>
> http://www.kernel.org/pub/linux/utils/raid/mdadm/
>
>
> --
> Tomasz Chmielewski
> http://wpkg.org



--
=C2=A0 =C2=A0 =C2=A0 Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
