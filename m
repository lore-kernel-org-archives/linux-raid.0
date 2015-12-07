From: "John Stoffel" <john@stoffel.org>
Subject: Re: I/O errors without erros from underlying device
Date: Mon, 7 Dec 2015 12:23:15 -0500
Message-ID: <22117.49283.546268.719858@quad.stoffel.home>
References: <201512071705.27177.a.miskiewicz@gmail.com>
	<22117.46523.245486.830064@quad.stoffel.home>
	<201512071803.26434.arekm@maven.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201512071803.26434.arekm@maven.pl>
Sender: linux-raid-owner@vger.kernel.org
To: Arkadiusz =?iso-8859-2?Q?Mi=B6kiewicz?= <arekm@maven.pl>
Cc: John Stoffel <john@stoffel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Arkadiusz" =3D=3D Arkadiusz Mi=B6kiewicz <arekm@maven.pl> writes=
:

Arkadiusz> On Monday 07 of December 2015, John Stoffel wrote:
Arkadiusz> 4.3.0 kernel, raid6 array:
>>=20
>> I think there's a bug in the 4.3.x and 4.4-rc3 and lower with block
>> merges.  I ran into these over the weekend, where v4.2.6 was stable,
>> but anything higher would lock up and crash on me.

Arkadiusz> Well, no crashes here.

That's good.  It was hard(er) to hit when I wasn't running KVM VMs at
the same time on the server, and I was running strictly RAID1 disks,
so it's hard to know.

>> So first step would be to make sure you get and test v4.4-rc4.

Arkadiusz> Do you know which commit there?

Try this, from the master lkml git repository:

    2873d32ff493ecbfb7d2c7f56812ab941dda42f4




>>=20
Arkadiusz> md7 : active raid6 sdg[10] sdad1[9] sdac1[8] sdag1[7] sdaf1[=
6]
>> sdae1[5] sdaj1[4] sdai1[3] sdah1[2] sdn1[1] Arkadiusz>       3125508=
9152
>> blocks super 1.2 level 6, 512k chunk, algorithm 2 [10/10] [UUUUUUUUU=
U]
Arkadiusz> bitmap: 1/30 pages [4KB], 65536KB chunk
>>=20
Arkadiusz> array had weird failure where many disks went into failed st=
ate
>> but Arkadiusz> remove && adding these disks "fixed" it (turns out no=
t
>> really fixed it).
>>=20
Arkadiusz> Unfortunately now some reads fail:
>>=20
Arkadiusz> pread(4, 0x1483a00, 4096, 16003680464896) =3D -1 EIO (Input/=
output
>> error)
>>=20
Arkadiusz> To reproduce used xfs_io
Arkadiusz> xfs_io -d -c "pread 16003680464896 4096" /dev/md7
Arkadiusz> pread64: Input/output error
Arkadiusz> which does pread exactly as shown above.
>>=20
Arkadiusz> write also fails for that area:
Arkadiusz> xfs_io -d -c "pwrite 16003680464896 4096" /dev/md7
Arkadiusz> pwrite64: Input/output error
>>=20
Arkadiusz> Note that nothing is written in dmesg when that happens.
>>=20
Arkadiusz> I've tried various offsets and sizes of pread and at some po=
int
>> that was logged: Arkadiusz> [  848.988518] Buffer I/O error on dev m=
d7,
>> logical block 3907148544, async page read
>>=20
Arkadiusz> but no error from underlying devices.
>>=20
Arkadiusz> List of bad blocks:
Arkadiusz> http://sprunge.us/XSWI
>>=20
Arkadiusz> What can I do now?
>>=20
Arkadiusz> (loosing data from that few sectors is acceptable if the res=
t
>> will be readable)
>>=20
Arkadiusz> Thanks,
Arkadiusz> --
Arkadiusz> Arkadiusz Mi=B6kiewicz, arekm / ( maven.pl | pld-linux.org )
Arkadiusz> --
Arkadiusz> To unsubscribe from this list: send the line "unsubscribe
>> linux-raid" in Arkadiusz> the body of a message to
>> majordomo@vger.kernel.org
Arkadiusz> More majordomo info at=20
>> http://vger.kernel.org/majordomo-info.html


Arkadiusz> --=20
Arkadiusz> Arkadiusz Mi=B6kiewicz, arekm / ( maven.pl | pld-linux.org )
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
