From: Igor M Podlesny <for.poige+lsr@gmail.com>
Subject: Re: Software RAID checksum performance on 24 disks not even close to
 kernel reported
Date: Tue, 5 Jun 2012 11:36:42 +0800
Message-ID: <CA+sTkh6rA_yoeM3Fw1s47sgEsJRWG7vbtXH9QaPWbwG6Mvt7fQ@mail.gmail.com>
References: <CA+4vN7wPd0Av_sbtA0JD5y=fGcsuq20SOQVHWnE8BUFpDxOEXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+4vN7wPd0Av_sbtA0JD5y=fGcsuq20SOQVHWnE8BUFpDxOEXQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ole Tange <ole@tange.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5 June 2012 07:14, Ole Tange <ole@tange.dk> wrote:
> On my new 24 disk array I get 900 MB/s of raw read or write using `dd=
`
> to all the disks.

   =E2=80=94 Array of layout what?

> When I set the disks up as a 24 disk software RAID6 I get 400 MB/s
> write and 600 MB/s read. It seems to be due to checksuming, as I have
> a single process (md0_raid6) taking up 100% of one CPU.
[=E2=80=A6]
> I tested this by creating 24 devices in RAM, used different chunk
> sizes, and then copied the linux kernel source. Test script can be
> found on http://oletange.blogspot.dk/2012/05/software-raid-performanc=
e-on-24-disks.html

   What a wild train of thoughts=E2=80=A6 Are those 24 disks HDDs or th=
ey're "in RAM"?

> By doing it in RAM the results are not affected by physical disks or
> disk controller. So the only change is the speed of computing
> checksums. This can also be seen as the time the process md0_raid0 is
> running.
>
> The results were:
>
> Chunk size =C2=A0 =C2=A0 =C2=A0Time to copy 10 linux kernel sources a=
s files =C2=A0 Time to copy
> 10 linux kernel sources as a single tar file
> 16 =C2=A0 =C2=A0 =C2=A032s =C2=A0 =C2=A0 13s
[=E2=80=A6]
> 4096 =C2=A0 =C2=A01m38s =C2=A0 16s

   You were talking bout MB/secs and now you're not. It doesn't help
understanding you either.

> It makes sense that it is faster to copy 10 big files than 10 times
[=E2=80=A6]
>
> But I cannot explain why even the best performance (4600 MB/11s =3D 4=
20
> MB/s) is not even close to the checksum performance reported by the
> kernel at boot (6196 MB/s):
>
> =C2=A0 =C2=A0Mar 13 16:02:42 server kernel: [ =C2=A0 35.120035] raid6=
: using
> algorithm sse2x4 (6196 MB/s)
>
> Can you explain why I only get 420 MB/s of real world checksumming
> instead of 6196 MB/s?

   Again =E2=80=94 420 MB/sec on HDD-based RAID or in-RAM one? What do =
you
think LSR subscribers are =E2=80=94 mediums?

--
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
