From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Failed drive in raid6 while doing data-check
Date: Sun, 3 Jun 2012 21:35:39 +0100
Message-ID: <CADNH=7H1C8HoQyQ_mFp62cN17G+EA4FxN6rZW99J+Fnc6TOvQg@mail.gmail.com>
References: <1338744674.28212.293.camel@oxygen.netxsys.com>
	<CA+sTkh5rvJpfgCd6HVJrziutW_z97CU3ueCW05CbKGo7JY8TTg@mail.gmail.com>
	<1338748687.28212.296.camel@oxygen.netxsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1338748687.28212.296.camel@oxygen.netxsys.com>
Sender: linux-raid-owner@vger.kernel.org
To: Krzysztof Adamski <k@adamski.org>
Cc: Igor M Podlesny <for.poige+lsr@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 3 June 2012 19:38, Krzysztof Adamski <k@adamski.org> wrote:
> On Mon, 2012-06-04 at 02:32 +0800, Igor M Podlesny wrote:
>> On 4 June 2012 01:31, Krzysztof Adamski <k@adamski.org> wrote:
>> [=E2=80=A6]
>> > The cat /proc/mdstat is:
>> > Personalities : [raid1] [raid6] [raid5] [raid4]
>> > md7 : active raid6 sdd2[0] sdab2[11] sdaa2[10] sdz2[9] sdy2[8] sde=
2[7] sdh2[6] sdf2[5] sdg2[4] sdb2[3](F) sdc2[2] sda2[1]
>> > =C2=A0 =C2=A0 =C2=A029283121600 blocks super 1.2 level 6, 32k chun=
k, algorithm 2 [12/11] [UUU_UUUUUUUU]
>> > =C2=A0 =C2=A0 =C2=A0[=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>.....=
=2E.] =C2=A0check =3D 65.3% (1913765076/2928312160) finish=3D44345.9min=
 speed=3D381K/sec
>> > =C2=A0 =C2=A0 =C2=A0bitmap: 1/22 pages [4KB], 65536KB chunk
>> >
>> > I don't really want to wait 30 days for this to finish, what is co=
rrect
>> > thing to do before I replace the failed drive?
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml

Don't quote me on this,

But since you are running a RAID6 with 1 degraded drive  you could
stop the check (echo idle > /sys/block/mdX/md/sync_action , I
believe). Then you could manually fail the broken HDD, remove it, then
physically replace it. However, it looks like MD already did that for
you ([UUU_UUUUUUUU]).

If possible I'd unmount any filesystems on the array first just in case=
=2E

Kind regards,
Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
