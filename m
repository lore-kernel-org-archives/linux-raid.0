From: Drew <drew.kay@gmail.com>
Subject: Re: Linux Raid performance
Date: Mon, 5 Apr 2010 06:49:22 -0700
Message-ID: <u2jc268e4661004050649t90fa506cm9bd377218ffebc20@mail.gmail.com>
References: <r2v7efa8a7d1003311242vfa92024ar93ad2123a7b49806@mail.gmail.com>
	<x2q7efa8a7d1004021055oe2e832ccl8877e9171b8f3442@mail.gmail.com>
	<l2j5bdc1c8b1004021739z969b99v6011fcc6fddd470a@mail.gmail.com>
	<4BB69670.3040303@sauce.co.nz> <4BB7856C.30808@shiftmail.org>
	<4BB79D76.7090206@sauce.co.nz> <4BB8A979.3020502@shiftmail.org>
	<w2j7efa8a7d1004041126id2b84d47k7bd275606712d0e3@mail.gmail.com>
	<k2t5bdc1c8b1004041146uec5162b8x5c95bfda2153ebd@mail.gmail.com>
	<4F42B9A76007451DA63A90BA27FEFBDC@m5>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F42B9A76007451DA63A90BA27FEFBDC@m5>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> This seemed like a fair question to me. =C2=A0I just wonder why Winbl=
ows was left
> out. =C2=A0After all, if any OS, including Winblows can outperform Li=
nux, we
> should know about it.

Because M$ Windows implementation of software raid sucks?

As part of my job I support windows servers and almost every 3rd party
manual I've ever read says something along the lines of "If your data
is mission critical, do not depend on windows built-in software raid.
Get a real hardware raid card." Some then go on to explain all the
pitfalls if a user is still inclined to use it, and some of the issues
are scary.

Contrast that to the reports I see on here of people using 6+, 10+,
12+ member raid arrays on mdadm (software) raid and having no issues
other then perhaps some performance tweaking.


--=20
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
