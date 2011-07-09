From: "Tyler J. Wagner" <tyler@tolaris.com>
Subject: Re: Reinstall OS Without Disturbing Software Raid Array
Date: Sat, 09 Jul 2011 21:55:58 +0100
Message-ID: <1310244958.14923.2.camel@baal>
References: <1310234009.6441.3.camel@babel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1310234009.6441.3.camel@babel>
Sender: linux-raid-owner@vger.kernel.org
To: Noah Swint <noah.swint@gmail.com>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, 2011-07-09 at 13:53 -0400, Noah Swint wrote:
> Can I reinstall fedora 14 without destroying the software raid array?=
=20

Any other Linux with md raid support will be able to read the array. Th=
e
exception would be if you are using a 1.x metadata format array, and
tried to move it to a very old kernel that doesn't support it. A newer
OS will always be fine.

I cannot promise the Fedora installer won't delete the contents of the
array. I'm not familiar with it.

Regards,
Tyler

--=20
"If we confuse dissent with disloyalty =E2=80=94 if we deny the right o=
f the
individual to be wrong, unpopular, eccentric or unorthodox =E2=80=94 if=
 we
deny the essence of racial equality then hundreds of millions in Asia a=
nd
Africa who are shopping about for a new allegiance will conclude that w=
e
are concerned to defend a myth and our present privileged status. Every
act that denies or limits the freedom of the individual in this country
costs us the ... confidence of men and women who aspire to that freedom
and independence of which we speak and for which our ancestors fought."
   -- Edward R. Murrow

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
