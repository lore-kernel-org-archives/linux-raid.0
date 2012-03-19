From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: lib/raid6: SSSE3 optimized recovery functions v1
Date: Mon, 19 Mar 2012 16:23:00 -0700
Message-ID: <4F67BFD4.1070104@zytor.com>
References: <1332180649-9709-1-git-send-email-james.t.kukunas@linux.intel.com> <4F67B6BC.4070006@zytor.com> <CADNH=7HV2UrkEb9J7dppMrwmy1264wmXgApmE+xKb6S=hdeq3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7HV2UrkEb9J7dppMrwmy1264wmXgApmE+xKb6S=hdeq3A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TWF0aGlhcyBCdXLDqW4=?= <mathias.buren@gmail.com>
Cc: Jim Kukunas <james.t.kukunas@linux.intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/19/2012 04:00 PM, Mathias Bur=C3=A9n wrote:
>=20
> Hi,
>=20
> Interesting! I read the PDF but could not find any numbers. Have you
> performed any benchmarks on RAID6 recovery on SSSE3 hardware with and
> without your patch?
>=20

I ran some tests on the core algorithm and found it to be about 3x fast=
er.

	-hpa

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
