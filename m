From: thomas62186218@aol.com
Subject: Re: LVM on raid10,f2 performance issues
Date: Sun, 18 Jan 2009 20:24:42 -0500
Message-ID: <8CB47EBD70FE9E8-AC4-981@WEBMAIL-DG06.sim.aol.com>
References: <49332920.5010503@gmail.com> <20081201164244.GB23899@rap.rap.dk> <4935C4B3.2060404@gmail.com> <493654C7.2090909@ziu.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <493654C7.2090909@ziu.info>
Sender: linux-raid-owner@vger.kernel.org
To: soltys@ziu.info, mauermann@gmail.com
Cc: keld@dkuug.dk, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi everyone,

I too was seeing miserable read-performance with LVM2 volumes on top of=
=20
md RAID 10's on my Ubuntu 8.04 64-bit machine. My RAID 10 has 12 x=20
300GB 15K SAS drives on a 4-port LSI PCIe SAS controller.

I use:
blockdev --setra 65536 /dev/md0

And this dramatically increased my RAID 10 read performance.

You MUST do the same for your LVM2 volumes for them to see a comparable=
=20
performance boost.

blockdev --setra 65536 /dev/mapper/raid10-testvol

Otherwise, your LVM will default to 256 read-ahead value, which stinks.=
=20
I increased my read performance by 3.5x with this one change! See below=
:

root@b410:~# dd if=3D/dev/raid10twelve256k/testvol of=3D/dev/null bs=3D=
1M=20
count=3D10000
10000+0 records in
10000+0 records out
10485760000 bytes (10 GB) copied, 50.8923 s, 206 MB/s

root@b410:~# blockdev --setra 65536 /dev/mapper/raid10twelve256k-testvo=
l

root@b410:~# dd if=3D/dev/raid10twelve256k/testvol of=3D/dev/null bs=3D=
1M=20
count=3D10000
10000+0 records in
10000+0 records out
10485760000 bytes (10 GB) copied, 14.4057 s, 728 MB/s


Enjoy!
-Thomas

-----Original Message-----
=46rom: Michal Soltys <soltys@ziu.info>
To: Holger Mauermann <mauermann@gmail.com>
Cc: Keld J=C3=B8rn Simonsen <keld@dkuug.dk>; linux-raid@vger.kernel.org
Sent: Wed, 3 Dec 2008 1:43 am
Subject: Re: LVM on raid10,f2 performance issues









Holger Mauermann wrote:=C2=A0

> Keld J=C3=B8rn Simonsen schrieb:=C2=A0

>> How is it if you use t
he raid10,f2 without lvm?=C2=A0

>> What are the numbers?=C2=A0

>
> After a fresh installation LVM performance is now somewhat better. I=C2=
=A0

> don't know what was wrong before. However, it is still not as fast as=
=C2=A0

> the raid10...=C2=A0

>
> dd on raw devices=C2=A0

> -----------------=C2=A0

>
> raid10,f2:=C2=A0

>   read : 409 MB/s=C2=A0

>   write: 212 MB/s=C2=A0

>
> raid10,f2 + lvm:=C2=A0

>   read : 249 MB/s=C2=A0

>   write: 158 MB/s=C2=A0

>
>
> sda:  sdb:  sdc:  sdd:=C2=A0

> ----------------------=C2=A0

> YYYY  ....  ....  XXXX=C2=A0

> ....  ....  ....  ....=C2=A0

> XXXX  YYYY  ....  ....=C2=A0

> ....  ....  ....  ....=C2=A0
=C2=A0

=C2=A0

Regarding the layout from your first mail - this is how it's supposed=20
to
be. LVM's header took 3*64KB (you can control that with --metadatasize,
and verify with e.g. pvs -o+pe_start), and then the first 4MB extent
(controlled with --physicalextentsize) of the first logical volume
started - on sdd and continued on sda. Mirrored data was set "far" from
that, and shifted one disk to the right - as expected from raid10,f2.=C2=
=A0
=C2=A0

As for performance, hmmm. Overally - there're few things to consider
when doing lvm on top of the raid:=C2=A0
=C2=A0

- stripe vs. extent alignment=C2=A0

- stride vs. stripe vs. extent size=C2=A0

- filesystem's awareness=20
that there's also raid a layer below=C2=A0

- lvm's readahead (iirc, only uppermost layer matters - functioning as=20
a
hint for the filesystem)=C2=A0
=C2=A0

But this is particulary important for raid with parities. Here
everything is aligned already, and parity doesn't exist.=C2=A0
=C2=A0

But the last point can be relevant - and you did test with filesystem
after all. Try setting readahead with blockdev or lvchange (the latter
will be permananet across lv activations). E.g.=C2=A0
=C2=A0

#lvchange -r 2048 /dev/mapper...=C2=A0
=C2=A0

and compare to raw raid10:=C2=A0
=C2=A0

#blockedv --setra 2048 /dev/md...=C2=A0
=C2=A0

If you did your tests with ext2/3, also try to create it with -E=20
stride=3D
stripe-width=3D option in both cases. Similary to sunit/swidth if you=20
used
xfs.=C2=A0
=C2=A0

You might also create volume group with larger extent - such as 512MB
(as 4MB granularity is often an overkill). Performance wise it=20
shouldn't
matter in this case though.=C2=A0
=C2=A0

--=C2=A0

To unsubscribe from this list: send the line "unsubscribe linux-raid"=20
in=C2=A0

the body of a message to majordomo@vger.kernel.org=C2=A0

More majordomo info at  http://vger.kernel.org/majordomo-info.html=C2=A0





--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
