From: "John Stoffel" <john@stoffel.org>
Subject: Re: I/O errors without erros from underlying device
Date: Mon, 7 Dec 2015 11:37:15 -0500
Message-ID: <22117.46523.245486.830064@quad.stoffel.home>
References: <201512071705.27177.a.miskiewicz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201512071705.27177.a.miskiewicz@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: arekm@maven.pl
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Arkadiusz> 4.3.0 kernel, raid6 array:

I think there's a bug in the 4.3.x and 4.4-rc3 and lower with block
merges.  I ran into these over the weekend, where v4.2.6 was stable,
but anything higher would lock up and crash on me.

So first step would be to make sure you get and test v4.4-rc4.

Arkadiusz> md7 : active raid6 sdg[10] sdad1[9] sdac1[8] sdag1[7] sdaf1[=
6] sdae1[5] sdaj1[4] sdai1[3] sdah1[2] sdn1[1]
Arkadiusz>       31255089152 blocks super 1.2 level 6, 512k chunk, algo=
rithm 2 [10/10] [UUUUUUUUUU]
Arkadiusz>       bitmap: 1/30 pages [4KB], 65536KB chunk

Arkadiusz> array had weird failure where many disks went into failed st=
ate but
Arkadiusz> remove && adding these disks "fixed" it (turns out not reall=
y fixed it).

Arkadiusz> Unfortunately now some reads fail:

Arkadiusz> pread(4, 0x1483a00, 4096, 16003680464896) =3D -1 EIO (Input/=
output error)

Arkadiusz> To reproduce used xfs_io
Arkadiusz>  xfs_io -d -c "pread 16003680464896 4096" /dev/md7
Arkadiusz> pread64: Input/output error
Arkadiusz> which does pread exactly as shown above.

Arkadiusz> write also fails for that area:
Arkadiusz> xfs_io -d -c "pwrite 16003680464896 4096" /dev/md7
Arkadiusz> pwrite64: Input/output error

Arkadiusz> Note that nothing is written in dmesg when that happens.

Arkadiusz> I've tried various offsets and sizes of pread and at some po=
int that was logged:
Arkadiusz> [  848.988518] Buffer I/O error on dev md7, logical block 39=
07148544, async page read

Arkadiusz> but no error from underlying devices.

Arkadiusz> List of bad blocks:
Arkadiusz> http://sprunge.us/XSWI

Arkadiusz> What can I do now?

Arkadiusz> (loosing data from that few sectors is acceptable if the res=
t will be readable)

Arkadiusz> Thanks,
Arkadiusz> --=20
Arkadiusz> Arkadiusz Mi=B6kiewicz, arekm / ( maven.pl | pld-linux.org )
Arkadiusz> --
Arkadiusz> To unsubscribe from this list: send the line "unsubscribe li=
nux-raid" in
Arkadiusz> the body of a message to majordomo@vger.kernel.org
Arkadiusz> More majordomo info at  http://vger.kernel.org/majordomo-inf=
o.html
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
