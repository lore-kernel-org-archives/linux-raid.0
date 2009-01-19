From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: LVM on raid10,f2 performance issues
Date: Mon, 19 Jan 2009 13:17:24 +0100
Message-ID: <20090119121724.GA23623@rap.rap.dk>
References: <49332920.5010503@gmail.com> <20081201164244.GB23899@rap.rap.dk> <4935C4B3.2060404@gmail.com> <493654C7.2090909@ziu.info> <8CB47EBD70FE9E8-AC4-981@WEBMAIL-DG06.sim.aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8CB47EBD70FE9E8-AC4-981@WEBMAIL-DG06.sim.aol.com>
Sender: linux-raid-owner@vger.kernel.org
To: thomas62186218@aol.com
Cc: soltys@ziu.info, mauermann@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hmm,=20

Why is the command

 blockdev --setra 65536 /dev/md0

really needed? I think the kernel should set a reasonable default here.

What is the logic? I am in the following trying to discuss what would b=
e
reasonable for a kernel patch to achieve.

The command sets readahead to 32 MiB . Is that really wanted?
I understand that it really is important for our benchmarks to give goo=
d
results. But is it useful in real operation? Or can a smaller value
solve the problem?

reading 32 MB takes about 300 - 500 ms - and this needs to be done for
every read, even for small reads. That is a lot. For database operation=
s
this would limit operations to 2 to 3 transactions per second. A normal
7200 rpm drive is capable of say about 100 tps, so this would slow such
transactions down with a factor of 30 to 50...

maybe a parameter to blockdev of 16384 - or 8 MiB - would be sufficient=
?
This would limit the time spent on each transaction to about 100 ms.

And this could be dependent on the relevant parameters, say drive
numbers and chunk size. Maybe the trick is to read a full stripe set,
that is number of drives times chunk size. For a 4 drive array with
chunk size 256 KiB this would be 1 MiB or a --setra paramaeter of 2048.

Maybe the trick is to read more stripe sets at the same time.
=46or raid5 and raid6 reads the parity chunks need not be read so it
would be a waiste to read the full stripe set.
I am not fully sure what is going on. Maybe somebody can enlighten me.

Or maybe the readahead is not the real parameter that needs to be set
correctly - but maybe something else needs to be fixed, maybe some
logic.

best regards
keld

On Sun, Jan 18, 2009 at 08:24:42PM -0500, thomas62186218@aol.com wrote:
> Hi everyone,
>=20
> I too was seeing miserable read-performance with LVM2 volumes on top =
of=20
> md RAID 10's on my Ubuntu 8.04 64-bit machine. My RAID 10 has 12 x=20
> 300GB 15K SAS drives on a 4-port LSI PCIe SAS controller.
>=20
> I use:
> blockdev --setra 65536 /dev/md0
>=20
> And this dramatically increased my RAID 10 read performance.
>=20
> You MUST do the same for your LVM2 volumes for them to see a comparab=
le=20
> performance boost.
>=20
> blockdev --setra 65536 /dev/mapper/raid10-testvol
>=20
> Otherwise, your LVM will default to 256 read-ahead value, which stink=
s.=20
> I increased my read performance by 3.5x with this one change! See bel=
ow:
>=20
> root@b410:~# dd if=3D/dev/raid10twelve256k/testvol of=3D/dev/null bs=3D=
1M=20
> count=3D10000
> 10000+0 records in
> 10000+0 records out
> 10485760000 bytes (10 GB) copied, 50.8923 s, 206 MB/s
>=20
> root@b410:~# blockdev --setra 65536 /dev/mapper/raid10twelve256k-test=
vol
>=20
> root@b410:~# dd if=3D/dev/raid10twelve256k/testvol of=3D/dev/null bs=3D=
1M=20
> count=3D10000
> 10000+0 records in
> 10000+0 records out
> 10485760000 bytes (10 GB) copied, 14.4057 s, 728 MB/s
>=20
>=20
> Enjoy!
> -Thomas
>=20
> -----Original Message-----
> From: Michal Soltys <soltys@ziu.info>
> To: Holger Mauermann <mauermann@gmail.com>
> Cc: Keld J=F8rn Simonsen <keld@dkuug.dk>; linux-raid@vger.kernel.org
> Sent: Wed, 3 Dec 2008 1:43 am
> Subject: Re: LVM on raid10,f2 performance issues
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
> Holger Mauermann wrote:=A0
>=20
> >Keld J=F8rn Simonsen schrieb:=A0
>=20
> >>How is it if you use t
> he raid10,f2 without lvm?=A0
>=20
> >>What are the numbers?=A0
>=20
> >
> >After a fresh installation LVM performance is now somewhat better. I=
=A0
>=20
> >don't know what was wrong before. However, it is still not as fast a=
s=A0
>=20
> >the raid10...=A0
>=20
> >
> >dd on raw devices=A0
>=20
> >-----------------=A0
>=20
> >
> >raid10,f2:=A0
>=20
> >  read : 409 MB/s=A0
>=20
> >  write: 212 MB/s=A0
>=20
> >
> >raid10,f2 + lvm:=A0
>=20
> >  read : 249 MB/s=A0
>=20
> >  write: 158 MB/s=A0
>=20
> >
> >
> >sda:  sdb:  sdc:  sdd:=A0
>=20
> >----------------------=A0
>=20
> >YYYY  ....  ....  XXXX=A0
>=20
> >....  ....  ....  ....=A0
>=20
> >XXXX  YYYY  ....  ....=A0
>=20
> >....  ....  ....  ....=A0
> =A0
>=20
> =A0
>=20
> Regarding the layout from your first mail - this is how it's supposed=
=20
> to
> be. LVM's header took 3*64KB (you can control that with --metadatasiz=
e,
> and verify with e.g. pvs -o+pe_start), and then the first 4MB extent
> (controlled with --physicalextentsize) of the first logical volume
> started - on sdd and continued on sda. Mirrored data was set "far" fr=
om
> that, and shifted one disk to the right - as expected from raid10,f2.=
=A0
> =A0
>=20
> As for performance, hmmm. Overally - there're few things to consider
> when doing lvm on top of the raid:=A0
> =A0
>=20
> - stripe vs. extent alignment=A0
>=20
> - stride vs. stripe vs. extent size=A0
>=20
> - filesystem's awareness=20
> that there's also raid a layer below=A0
>=20
> - lvm's readahead (iirc, only uppermost layer matters - functioning a=
s=20
> a
> hint for the filesystem)=A0
> =A0
>=20
> But this is particulary important for raid with parities. Here
> everything is aligned already, and parity doesn't exist.=A0
> =A0
>=20
> But the last point can be relevant - and you did test with filesystem
> after all. Try setting readahead with blockdev or lvchange (the latte=
r
> will be permananet across lv activations). E.g.=A0
> =A0
>=20
> #lvchange -r 2048 /dev/mapper...=A0
> =A0
>=20
> and compare to raw raid10:=A0
> =A0
>=20
> #blockedv --setra 2048 /dev/md...=A0
> =A0
>=20
> If you did your tests with ext2/3, also try to create it with -E=20
> stride=3D
> stripe-width=3D option in both cases. Similary to sunit/swidth if you=
=20
> used
> xfs.=A0
> =A0
>=20
> You might also create volume group with larger extent - such as 512MB
> (as 4MB granularity is often an overkill). Performance wise it=20
> shouldn't
> matter in this case though.=A0
> =A0
>=20
> --=A0
>=20
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
=20
> in=A0
>=20
> the body of a message to majordomo@vger.kernel.org=A0
>=20
> More majordomo info at  http://vger.kernel.org/majordomo-info.html=A0
>=20
>=20
>=20
>=20
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
