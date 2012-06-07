From: Igor M Podlesny <for.poige+lsr@gmail.com>
Subject: Re: Software RAID checksum performance on 24 disks not even close to
 kernel reported
Date: Thu, 7 Jun 2012 11:41:56 +0800
Message-ID: <CA+sTkh6=Kn1EJ79zCxWW6Xr-H23E+-HpqJVD33vP4rJMQ3ON4g@mail.gmail.com>
References: <CA+4vN7wPd0Av_sbtA0JD5y=fGcsuq20SOQVHWnE8BUFpDxOEXQ@mail.gmail.com>
 <CA+4vN7xQgecd95FO6gYVLMuPDKXbfZfzuXS1dzHd+e-otrPxwg@mail.gmail.com>
 <CA+sTkh5m9vumG=56n024jBFobaozOQQJjesh=Cc--C7J0FCnfg@mail.gmail.com>
 <CA+4vN7xWST=vgMpd9s0Q0MGmPQq1Fe=FZkSc_qPEfX0vOQskoA@mail.gmail.com>
 <CA+sTkh6xUbQGLXpNiUHmHZoqPaQUrGgoyyX1EssjpO8g8hVZNQ@mail.gmail.com> <20431.57247.76819.834529@tree.ty.sabi.co.UK>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20431.57247.76819.834529@tree.ty.sabi.co.UK>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg@lxra2.to.sabi.co.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 7 June 2012 06:53, Peter Grandi <pg@lxra2.to.sabi.co.uk> wrote:
[=E2=80=A6]
> =C2=A0=C2=ABA good guideline for stripe size is between 256 kB and 51=
2
> =C2=A0kB.=C2=BB
>
> It is very important to note here that "stripe size" in Vinum
> means "chunk size" in MD. For many workloads that is too large a
> chunk size.

   It depends on number of files in working set. I still can't see
reasons to have 4 KiB chunk (or stripe size) for newsdir or maildir
with the hell a lot of tiny files, really =E2=80=94 having enough of th=
em
anyways guarantees equal load distribution among all of the disks even
with rather large chunk size. But with 4 KiB _every_ I/O-op would
involve several disks, and again I don't consider it's "nice".

> =C2=A0=C2=ABAvoid powers of 2, however: they tend to cause all superb=
locks
> =C2=A0to be placed on the first subdisk. =E2=80=A6=C2=BB =E2=80=94 ht=
tp://goo.gl/sTHxY
>
>> P. S. Alas, LSR doesn't support anything but powers of 2 for
>> chunk sizes, but according to Neil Brown, it can be relatively
>> easy changed.
>
> Some important Linux filesystems try to align metadata to chunk
> boundaries instead, for example 'ext3' with 'stride=3D' and XFS
> with 'su=3D'.

   They try, for sure, but try is still a try. For e. g., you pvmove'd
your LVM with XFS from one RAID to another one having different
"layout", things can just stop working well all of the sudden. Another
drawback of 2^n chunk sizes is extending gap between them:
=E2=80=A61024=E2=80=A62048=E2=80=A64096=E2=80=A68192=E2=80=A6. You just=
 can't go and try something like 1731
or 3333 KiB for chunk size.

--
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
