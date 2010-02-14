From: Volker Armin Hemmann <volkerarmin@googlemail.com>
Subject: Re: Linux mdadm superblock question.
Date: Sun, 14 Feb 2010 02:51:59 +0100
Message-ID: <201002140251.59668.volkerarmin@googlemail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>0.90 has a very bad problem, which is that it is hard to distinguish
>between a RAID partition at the end of volume and a full RAID device.
>This is because 0.90 doesn't actually tell you the start of the device=
=2E
>
>Then, of course, there are a lot of limitations on size, number of
>devices, and so on in 0.90.

but it is the only format supporting autodetection.=20

So - when will autodetection be introduced with 1.X? And if not, why no=
t?

All I found was 'autodetection might be troublesome' and nothing else.
 But dealing with initrds is troublesome too. Pure evil even.=20

Gl=FCck Auf,
Volker
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
