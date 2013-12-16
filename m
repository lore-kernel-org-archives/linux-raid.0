From: "lilofile" <lilofile@aliyun.com>
Subject: =?UTF-8?B?562U5aSN77ya562U5aSN77yadHdvIHJhaWQ1IHBlcmZvcm1hbmNl?=
Date: Mon, 16 Dec 2013 21:13:54 +0800
Message-ID: <a9545b2f-d9be-4616-be40-59bfff151032@aliyun.com>
References: <386c52f5-dd36-4697-b76a-d24038bbded3@aliyun.com> <fc24d5bd-da62-4c2d-8c51-c9b76a3f9dd7@aliyun.com>,3600622.49q3PtzSug@eseries.newtech.fi
Reply-To: "lilofile" <lilofile@aliyun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: 3600622.49q3PtzSug@eseries.newtech.fi
Sender: linux-raid-owner@vger.kernel.org
To: dag <dag@newtech.fi>
Cc: linux-raid <linux-raid@vger.kernel.org>, Pieter De Wit <pieter@insync.za.net>
List-Id: linux-raid.ids

mpt2sas 6Gb/s, PCIE 2.0=EF=BC=8Cthe card is four port,so theoretical ra=
tio can reach to 2.4Gb/s,it is not bottleneck. I test read two raid5 us=
ing dd,
such as  dd if=3D/dev/md0 of=3D/dev/zero 1M
             dd if=3D/dev/md1 of=3D/dev/zero 1M=20
the total read bandwidth  can reach to 2.3GB/s,so I/O bus is not a prob=
lem.

------------------------------------------------------------------
=E5=8F=91=E4=BB=B6=E4=BA=BA=EF=BC=9ADag Nygren <dag@newtech.fi>
=E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4=EF=BC=9A2013=E5=B9=B412=E6=9C=8816=
=E6=97=A5(=E6=98=9F=E6=9C=9F=E4=B8=80) 21:06
=E6=94=B6=E4=BB=B6=E4=BA=BA=EF=BC=9Alilofile <lilofile@aliyun.com>
=E6=8A=84=E3=80=80=E9=80=81=EF=BC=9APieter De Wit <pieter@insync.za.net=
>; linux-raid <linux-raid@vger.kernel.org>
=E4=B8=BB=E3=80=80=E9=A2=98=EF=BC=9ARe: =E7=AD=94=E5=A4=8D=EF=BC=9Atwo =
raid5 performance

On Monday 16 December 2013 15:57:42 lilofile wrote:
> the disks involved in the array is sTEC ssd disk,they are connected b=
y mpt2sas 6Gb/s

I/O bus to the card?

Best
Dag
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
