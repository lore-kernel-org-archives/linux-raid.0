From: Igor M Podlesny <for.poige+lsr@gmail.com>
Subject: Re: Software RAID checksum performance on 24 disks not even close to
 kernel reported
Date: Thu, 7 Jun 2012 13:22:21 +0800
Message-ID: <CA+sTkh4-3wawWBEiGtzNuMvdyv8uP6Jrh22JDhTP+mu7vDW7nw@mail.gmail.com>
References: <CA+4vN7wPd0Av_sbtA0JD5y=fGcsuq20SOQVHWnE8BUFpDxOEXQ@mail.gmail.com>
 <CA+4vN7xQgecd95FO6gYVLMuPDKXbfZfzuXS1dzHd+e-otrPxwg@mail.gmail.com>
 <CA+sTkh5m9vumG=56n024jBFobaozOQQJjesh=Cc--C7J0FCnfg@mail.gmail.com>
 <CA+4vN7xWST=vgMpd9s0Q0MGmPQq1Fe=FZkSc_qPEfX0vOQskoA@mail.gmail.com>
 <CA+sTkh6xUbQGLXpNiUHmHZoqPaQUrGgoyyX1EssjpO8g8hVZNQ@mail.gmail.com>
 <20431.57247.76819.834529@tree.ty.sabi.co.UK> <CA+sTkh6=Kn1EJ79zCxWW6Xr-H23E+-HpqJVD33vP4rJMQ3ON4g@mail.gmail.com>
 <4FD0353C.1050006@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FD0353C.1050006@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Peter Grandi <pg@lxra2.to.sabi.co.uk>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 7 June 2012 12:59, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> On 6/6/2012 10:41 PM, Igor M Podlesny wrote:
>> =C2=A0 =C2=A0They try, for sure, but try is still a try. For e. g., =
you pvmove'd
>> your LVM with XFS from one RAID to another one having different
>> "layout", things can just stop working well all of the sudden.
>
> Filesystems that have zero awareness of the storage geometry have poo=
r
> performance on striped RAID devices. =C2=A0XFS has excellent performa=
nce on
> striped RAID specifically due to this awareness. =C2=A0Now you descri=
be this

   And Btrfs is way faster (~ 30 %) on single sustained 22 GiB reading
=E2=80=94 http://poige.livejournal.com/560643.html

   XFS is excellent but for parallel I/O mainly due to its multiple
allocation groups, not "RAID awareness" =E2=80=94 EXT3/4 can be formatt=
ed
adjusted to RAID's layout just as XFS, in case you didn't know it.

> strength as a weakness due to a volume portability corner case no SA =
in
> his right mind would attempt.
>
> The proper way to do this is to perform an xfsdump of the filesystem =
to
> a file, create a new XFS with the proper stripe geometry in the new
> storage location (which takes all of 1 second BTW), then xfsrestore t=
he
> dump file.

   Damn the proper way, Stan, if it's inconvenient one, and some
better results can be automagically achieved using another way. Which
one is more proper then? )

   I see no point in arguing just to argue. I see no drawbacks in
chunks not limited to 2^n, since at least it doesn't prohibit 2^n as
well. So, there's no point really.

--
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
