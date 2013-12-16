From: "lilofile" <lilofile@aliyun.com>
Subject: =?UTF-8?B?562U5aSN77ya562U5aSN77ya562U5aSN77yadHdvIHJhaWQ1IHBlcmZvcm1hbmNl?=
Date: Mon, 16 Dec 2013 20:57:28 +0800
Message-ID: <e466cd25-8ce8-42da-a5c5-7374f742009d@aliyun.com>
References: <386c52f5-dd36-4697-b76a-d24038bbded3@aliyun.com>	<fc24d5bd-da62-4c2d-8c51-c9b76a3f9dd7@aliyun.com>	<babad7a0-4ee5-4de1-8200-2f912997217c@aliyun.com>,CAGA4a+Fi6KuHHYmZ0XVLC1th+7VvxajAqQRYj7Yj1gdU__zosA@mail.gmail.com
Reply-To: "lilofile" <lilofile@aliyun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: CAGA4a+Fi6KuHHYmZ0XVLC1th+7VvxajAqQRYj7Yj1gdU__zosA@mail.gmail.com
Sender: linux-raid-owner@vger.kernel.org
To: Tommy Apel <tommyapeldk@gmail.com>
Cc: linux-raid Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Yes,I test like what  you say,but the result is the same.


------------------------------------------------------------------
=E5=8F=91=E4=BB=B6=E4=BA=BA=EF=BC=9ATommy Apel <tommyapeldk@gmail.com>
=E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4=EF=BC=9A2013=E5=B9=B412=E6=9C=8816=
=E6=97=A5(=E6=98=9F=E6=9C=9F=E4=B8=80) 20:45
=E6=94=B6=E4=BB=B6=E4=BA=BA=EF=BC=9Alilofile <lilofile@aliyun.com>
=E6=8A=84=E3=80=80=E9=80=81=EF=BC=9Alinux-raid Raid <linux-raid@vger.ke=
rnel.org>
=E4=B8=BB=E3=80=80=E9=A2=98=EF=BC=9ARe: =E7=AD=94=E5=A4=8D=EF=BC=9A=E7=AD=
=94=E5=A4=8D=EF=BC=9Atwo raid5 performance

try this, this will put a dd on different cores so that you don't
starve one core with both dd processes
taskset 1 dd if=3D/dev/zero of=3Draidset1
taskset 2 dd if=3D/dev/zero of=3Draidset2

2013/12/16 lilofile <lilofile@aliyun.com>:
> In dd test,I use Linux top tools,and I found 2 raid use different cor=
es, CPU  occupancy of each raid5 reach to 80% , is any lock contention =
 between two raid?
>
>
> ------------------------------------------------------------------
> =E5=8F=91=E4=BB=B6=E4=BA=BA=EF=BC=9ATommy Apel <tommyapeldk@gmail.com=
>
> =E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4=EF=BC=9A2013=E5=B9=B412=E6=9C=88=
16=E6=97=A5(=E6=98=9F=E6=9C=9F=E4=B8=80) 16:13
> =E6=94=B6=E4=BB=B6=E4=BA=BA=EF=BC=9Alilofile <lilofile@aliyun.com>
> =E6=8A=84=E3=80=80=E9=80=81=EF=BC=9APieter De Wit <pieter@insync.za.n=
et>; linux-raid Raid <linux-raid@vger.kernel.org>; Tommy Apel <tommyape=
ldk@gmail.com>
> =E4=B8=BB=E3=80=80=E9=A2=98=EF=BC=9ARe: =E7=AD=94=E5=A4=8D=EF=BC=9Atw=
o raid5 performance
>
> Try to use taskset command to make sure the dd commands are handled b=
y different cores otherwise you'll starve 1 core.
> On Dec 16, 2013 8:58 AM, "lilofile" <lilofile@aliyun.com> wrote:
>
> the disks involved in the array is sTEC ssd disk,they are connected b=
y mpt2sas 6Gb/s
>
>
>
>
>
> ------------------------------------------------------------------
>
> =E5=8F=91=E4=BB=B6=E4=BA=BA=EF=BC=9APieter De Wit <pieter@insync.za.n=
et>
>
> =E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4=EF=BC=9A2013=E5=B9=B412=E6=9C=88=
16=E6=97=A5(=E6=98=9F=E6=9C=9F=E4=B8=80) 15:52
>
> =E6=94=B6=E4=BB=B6=E4=BA=BA=EF=BC=9Alilofile <lilofile@aliyun.com>; u=
nlisted-recipients: <unlisted-recipients:>
>
> =E6=8A=84=E3=80=80=E9=80=81=EF=BC=9Alinux-raid <linux-raid@vger.kerne=
l.org>
>
> =E4=B8=BB=E3=80=80=E9=A2=98=EF=BC=9ARe: two raid5 performance
>
>
>
> On 16/12/2013 14:07, lilofile wrote:
>
>> when I Create a raid5,dd  1M block size,the performance can reached =
to 1GB/s
>
>> when I create another raid5,dd 1M block size ,the performance can re=
ached to 1GB/s
>
>> when I simultaneously dd the two different raid,the total performanc=
e only reached to 1.4GB/s,why can not reached to 2GB/s.
>
>>
>
>> the memory is 32GB,CPU is x5660,the stripe size is 4096
>
>> --
>
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>
>> the body of a message to majordomo@vger.kernel.org
>
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> What is the disks involved in the array ? How are they connected ?
>
> --
>
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
>
> the body of a message to majordomo@vger.kernel.org
>
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>



--=20

/Tommy
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
