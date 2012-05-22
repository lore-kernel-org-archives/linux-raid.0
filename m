From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: SSSE6 / RAID6
Date: Wed, 23 May 2012 00:37:32 +0100
Message-ID: <CADNH=7HtXPqwe_MDPg=hwPTjFgBUcXkyv3WkhZyJ2cpv4J1aqA@mail.gmail.com>
References: <CADNH=7HByQyQy=Bbn5AjO=nz8437QOCjGbkVhiUAKwp61_is0A@mail.gmail.com>
	<4FBC10AC.3000803@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FBC10AC.3000803@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 22 May 2012 23:18, H. Peter Anvin <hpa@zytor.com> wrote:
> On 05/22/2012 02:27 PM, Mathias Bur=C3=A9n wrote:
>> Hi list,
>>
>> I just compiled 3.4 for my little Atom box. Is there any way I can
>> confirm if the RAID6 check is using SSSE6 instructions?
>>
>
> It should be printed in the boot log (/var/log/dmesg or similar.)
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0-hpa
>
>
> --
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel. =C2=A0I don't speak on their behalf.
>

$ dmesg|grep -i sss
[    1.003566] sha1_ssse3: Using SSSE3 optimized SHA-1 implementation
$ dmesg|grep -i raid
[    0.240120] raid6: int64x1    333 MB/s
[    0.296660] raid6: int64x2    558 MB/s
[    0.353377] raid6: int64x4    573 MB/s
[    0.410019] raid6: int64x8    660 MB/s
[    0.466731] raid6: sse2x1     578 MB/s
[    0.523360] raid6: sse2x2    1024 MB/s
[    0.579973] raid6: sse2x4    1846 MB/s
[    0.579978] raid6: using algorithm sse2x4 (1846 MB/s)
[    1.017503] sata_mv: Highpoint RocketRAID BIOS CORRUPTS DATA on all
attached drives, regardless of if/how they are configured. BEWARE!
[    1.017509] sata_mv: For data safety, do not use sectors 8-9 on
"Legacy" drives, and avoid the final two gigabytes on all RocketRAID
BIOS initialized drives.
[    1.211831] md: raid6 personality registered for level 6
[    1.211835] md: raid5 personality registered for level 5
[    1.211840] md: raid4 personality registered for level 4
[    5.436217] md/raid:md0: device sdf1 operational as raid disk 4
[    5.436223] md/raid:md0: device sdh1 operational as raid disk 5
[    5.436229] md/raid:md0: device sdg1 operational as raid disk 0
[    5.436234] md/raid:md0: device sde1 operational as raid disk 6
[    5.436239] md/raid:md0: device sdc1 operational as raid disk 3
[    5.436244] md/raid:md0: device sdd1 operational as raid disk 2
[    5.436250] md/raid:md0: device sdb1 operational as raid disk 1
[    5.438070] md/raid:md0: allocated 7450kB
[    5.438627] md/raid:md0: raid level 6 active with 7 out of 7
devices, algorithm 2
[    5.438636] RAID conf printout:
[ 1244.523593] md: data-check of RAID array md0

Hm, doesn't look like it's working? (I missed linux-raid)
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
