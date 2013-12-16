From: "lilofile" <lilofile@aliyun.com>
Subject: =?UTF-8?B?562U5aSN77yadHdvIHJhaWQ1IHBlcmZvcm1hbmNl?=
Date: Mon, 16 Dec 2013 15:57:42 +0800
Message-ID: <fc24d5bd-da62-4c2d-8c51-c9b76a3f9dd7@aliyun.com>
References: <386c52f5-dd36-4697-b76a-d24038bbded3@aliyun.com>,52AEB15A.3050301@insync.za.net
Reply-To: "lilofile" <lilofile@aliyun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: 52AEB15A.3050301@insync.za.net
Sender: linux-raid-owner@vger.kernel.org
To: Pieter De Wit <pieter@insync.za.net>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

the disks involved in the array is sTEC ssd disk,they are connected by =
mpt2sas 6Gb/s


------------------------------------------------------------------
=E5=8F=91=E4=BB=B6=E4=BA=BA=EF=BC=9APieter De Wit <pieter@insync.za.net=
>
=E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4=EF=BC=9A2013=E5=B9=B412=E6=9C=8816=
=E6=97=A5(=E6=98=9F=E6=9C=9F=E4=B8=80) 15:52
=E6=94=B6=E4=BB=B6=E4=BA=BA=EF=BC=9Alilofile <lilofile@aliyun.com>; unl=
isted-recipients: <unlisted-recipients:>
=E6=8A=84=E3=80=80=E9=80=81=EF=BC=9Alinux-raid <linux-raid@vger.kernel.=
org>
=E4=B8=BB=E3=80=80=E9=A2=98=EF=BC=9ARe: two raid5 performance

On 16/12/2013 14:07, lilofile wrote:
> when I Create a raid5,dd  1M block size,the performance can reached t=
o 1GB/s
> when I create another raid5,dd 1M block size ,the performance can rea=
ched to 1GB/s
> when I simultaneously dd the two different raid,the total performance=
 only reached to 1.4GB/s,why can not reached to 2GB/s.
>
> the memory is 32GB,CPU is x5660,the stripe size is 4096
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
What is the disks involved in the array ? How are they connected ?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
