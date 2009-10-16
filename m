From: "Majed B." <majedb@gmail.com>
Subject: Re: Disappointing RAID10 Performance
Date: Fri, 16 Oct 2009 20:36:18 +0300
Message-ID: <70ed7c3e0910161036v71e6c1e6tde8956440c0c24f6@mail.gmail.com>
References: <364346.70897.qm@web38808.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <364346.70897.qm@web38808.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: adfas asd <chimera_god@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Have you tried the tips in this page?
http://linux-raid.osdl.org/index.php/Performance#Some_problem_solving_f=
or_benchmarking

On Fri, Oct 16, 2009 at 8:32 PM, adfas asd <chimera_god@yahoo.com> wrot=
e:
> I was hoping to get better performance with RAID10 than from the raw =
disks, but that's turned out to not be the case. =C2=A0Experimenting wi=
th the readahead buffer I get these bandwidths with the following comma=
nd:
> # time dd if=3D{somelarge}.iso of=3D/dev/null bs=3D{readahead size}
>
> /dev/sd?
> =C2=A01024 71.3 MB/s
> =C2=A02048 71.2 MB/s
> =C2=A04096 77.7 MB/s
> =C2=A08192 69.4 MB/s
> =C2=A016384 76.6 MB/s
>
> /dev/md2
> =C2=A01024 =C2=A067.1
> =C2=A02048 =C2=A069.1
> =C2=A04096 =C2=A075.7
> =C2=A08192 =C2=A064.9
> =C2=A016384 69.0
>
> Using RAID10offset2 on 2 WD 2TB drives, and always the same input fil=
e.
>
> Why would RAID10 performance be -poorer-?
> If it weren't for mirroring, this wouldn't be worth it.
>
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
