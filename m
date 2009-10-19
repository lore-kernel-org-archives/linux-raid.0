From: hank peng <pengxihan@gmail.com>
Subject: Re: XFS mount failuer on RAID5
Date: Mon, 19 Oct 2009 08:54:35 +0800
Message-ID: <389deec70910181754xf671441vbb481ea48b63316@mail.gmail.com>
References: <389deec70910152009i7656aaf2s9d929b8b68e4e740@mail.gmail.com>
	 <4AD89128.2010206@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AD89128.2010206@sandeen.net>
Sender: linux-raid-owner@vger.kernel.org
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

2009/10/16 Eric Sandeen <sandeen@sandeen.net>:
> hank peng wrote:
>>
>> Hi, all:
>> I have a self-built board, cpu is MPC8548(PPC arch), kernel is based
>> on MPC8548CDS demo board, version is 2.6.23.
>> A SATA controller is conected to CPU via PCIX, and I have 3 disks
>> attached to it.
>>
> ...
>
>> root@Storage:~# mkfs.xfs -f -ssize=3D4k /dev/vg/lvtest
>> Warning - device mapper device, but no dmsetup(8) found
>> Warning - device mapper device, but no dmsetup(8) found
>> meta-data=3D/dev/vg/lvtest =C2=A0 =C2=A0 =C2=A0 =C2=A0 isize=3D256 =C2=
=A0 =C2=A0agcount=3D4, agsize=3D6553600
>> blks
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sectsz=3D4096 =C2=A0attr=3D2
>> data =C2=A0 =C2=A0 =3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bsize=3D4096 =C2=A0 blocks=3D26214400, =
imaxpct=3D25
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sunit=3D0 =C2=A0 =C2=A0 =C2=A0sw=
idth=3D0 blks
>> naming =C2=A0 =3Dversion 2 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0bsize=3D4096
>> log =C2=A0 =C2=A0 =C2=A0=3Dinternal log =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 bsize=3D4096 =C2=A0 blocks=3D12800, version=3D2
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sectsz=3D4096 =C2=A0sunit=3D1 bl=
ks, lazy-count=3D0
>> realtime =3Dnone =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 extsz=3D4096 =C2=A0 blocks=3D0, rtextents=3D0
>> root@Storage:~# mkdir tmp
>> root@Storage:~# mount -t xfs /dev/vg/lvtest ./tmp/
>> Filesystem "dm-0": Disabling barriers, not supported by the underlyi=
ng
>> device
>> XFS mounting filesystem dm-0
>> XFS: totally zeroed log
>> Filesystem "dm-0": XFS internal error xlog_clear_stale_blocks(2) at
>> line 1252 of file fs/xfs/xfs_log_recover.c. =C2=A0Caller 0xc018ec88
>
>
> Can you try the patch that Andy Poling posted to the list just yester=
day?
> =C2=A0Slight longshot but it may be it.
>
> Otherwise I will look at this in a bit; on the road today though.
>
Reason is found, it is because there are some problem in our hardware
XOR driver firmware. I am sure now it is not related with XFS.
Thx to all you guys, we will try to fix it.

> -Eric
>



--=20
The simplest is not all best but the best is surely the simplest!
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
