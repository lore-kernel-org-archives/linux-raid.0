From: "Ross S. W. Walker" <rwalker@medallion.com>
Subject: RE: [Iscsitarget-devel] Abort Task ?
Date: Fri, 19 Oct 2007 10:51:36 -0400
Message-ID: <E2BB8074E5500C42984D980D4BD78EF9017A2964@MFG-NYC-EXCH2.mfg.prv>
References: <471720F1.40409@systella.fr> <471727F3.2080500@systella.fr> <471734C5.8090405@systella.fr> <E2BB8074E5500C42984D980D4BD78EF9017A2958@MFG-NYC-EXCH2.mfg.prv> <1192721909.3596.15.camel@dhcp-117.ibrix.com> <47178ABF.1040500@systella.fr> <47179492.4000109@systella.fr> <E2BB8074E5500C42984D980D4BD78EF9017A295C@MFG-NYC-EXCH2.mfg.prv> <47186137.2030906@systella.fr> <1192802144.3593.2.camel@dhcp-117.ibrix.com> <4718BF6A.6080905@systella.fr> <1192804659.3593.7.camel@dhcp-117.ibrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <1192804659.3593.7.camel@dhcp-117.ibrix.com>
Sender: linux-raid-owner@vger.kernel.org
To: blackmagic02881@gmail.com, =?iso-8859-1?Q?BERTRAND_Jo=EBl?= <joel.bertrand@systella.fr>
Cc: iscsitarget-devel@lists.sourceforge.net, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ming Zhang wrote:
>=20
> On Fri, 2007-10-19 at 16:30 +0200, BERTRAND Jo=EBl wrote:
> > Ming Zhang wrote:
> > > On Fri, 2007-10-19 at 09:48 +0200, BERTRAND Jo=EBl wrote:
> > >> Ross S. W. Walker wrote:
> > >>> BERTRAND Jo=EBl wrote:
> > >>>> BERTRAND Jo=EBl wrote:
> > >>>>>     I can format serveral times (mkfs.ext3) a 1.5 TB volume=20
> > >>>> over iSCSI=20
> > >>>>> without any trouble. I can read and write on this virtual=20
> > >>>> disk without=20
> > >>>>> any trouble.
> > >>>>>
> > >>>>>     Now, I have configured ietd with :
> > >>>>>
> > >>>>> Lun 0 Sectors=3D1464725758,Type=3Dnullio
> > >>>>>
> > >>>>> and I run on initiator side :
> > >>>>>
> > >>>>> Root gershwin:[/dev] > dd if=3D/dev/zero of=3D/dev/sdj bs=3D8=
192
> > >>>>> 479482+0 records in
> > >>>>> 479482+0 records out
> > >>>>> 3927916544 bytes (3.9 GB) copied, 153.222 seconds, 25.6 MB/s
> > >>>>>
> > >>>>> Root gershwin:[/dev] > dd if=3D/dev/zero of=3D/dev/sdj bs=3D8=
192
> > >>>>>
> > >>>>>     I'm waitinfor a crash. No one when I write these lines.=20
> > >>>>    I suspect=20
> > >>>>> an interaction between raid and iscsi.
> > >>>> 	I simultanely run :
> > >>>>
> > >>>> Root gershwin:[/dev] > dd if=3D/dev/zero of=3D/dev/sdj bs=3D81=
92
> > >>>> 8397210+0 records in
> > >>>> 8397210+0 records out
> > >>>> 68789944320 bytes (69 GB) copied, 2732.55 seconds, 25.2 MB/s
> > >>>>
> > >>>> and
> > >>>>
> > >>>> Root gershwin:[~] > dd if=3D/dev/sdj of=3D/dev/null bs=3D8192
> > >>>> 739200+0 records in
> > >>>> 739199+0 records out
> > >>>> 6055518208 bytes (6.1 GB) copied, 447.178 seconds, 13.5 MB/s
> > >>>>
> > >>>> 	without any trouble.
> > >>> The speed can definitely be improved. Look at your network setu=
p
> > >>> and use ping to try and get the network latency to a minimum.
> > >>>
> > >>> # ping -A -s 8192 172.16.24.140
> > >>> ....
> > >>> --- 172.16.24.140 ping statistics ---
> > >>> 14058 packets transmitted, 14057 received, 0% packet=20
> loss, time 9988ms
> > >>> rtt min/avg/max/mdev =3D 0.234/0.268/2.084/0.041 ms,=20
> ipg/ewma 0.710/0.260 ms
> > >> gershwin:[~] > ping -A -s 8192 192.168.0.2
> > >> PING 192.168.0.2 (192.168.0.2) 8192(8220) bytes of data.
> > >> 8200 bytes from 192.168.0.2: icmp_seq=3D1 ttl=3D64 time=3D0.693 =
ms
> > >> 8200 bytes from 192.168.0.2: icmp_seq=3D2 ttl=3D64 time=3D0.595 =
ms
> > >> 8200 bytes from 192.168.0.2: icmp_seq=3D3 ttl=3D64 time=3D0.583 =
ms
> > >> 8200 bytes from 192.168.0.2: icmp_seq=3D4 ttl=3D64 time=3D0.589 =
ms
> > >> 8200 bytes from 192.168.0.2: icmp_seq=3D5 ttl=3D64 time=3D0.580 =
ms
> > >> 8200 bytes from 192.168.0.2: icmp_seq=3D6 ttl=3D64 time=3D0.594 =
ms
> > >> 8200 bytes from 192.168.0.2: icmp_seq=3D7 ttl=3D64 time=3D0.580 =
ms
> > >> 8200 bytes from 192.168.0.2: icmp_seq=3D8 ttl=3D64 time=3D0.592 =
ms
> > >> 8200 bytes from 192.168.0.2: icmp_seq=3D9 ttl=3D64 time=3D0.589 =
ms
> > >> 8200 bytes from 192.168.0.2: icmp_seq=3D10 ttl=3D64 time=3D0.571=
 ms
> > >> 8200 bytes from 192.168.0.2: icmp_seq=3D11 ttl=3D64 time=3D0.588=
 ms
> > >> 8200 bytes from 192.168.0.2: icmp_seq=3D12 ttl=3D64 time=3D0.580=
 ms
> > >> 8200 bytes from 192.168.0.2: icmp_seq=3D13 ttl=3D64 time=3D0.587=
 ms
> > >>
> > >> --- 192.168.0.2 ping statistics ---
> > >> 13 packets transmitted, 13 received, 0% packet loss, time 2400ms
> > >> rtt min/avg/max/mdev =3D 0.571/0.593/0.693/0.044 ms,=20
> ipg/ewma 200.022/0.607 ms
> > >> gershwin:[~] >
> > >>
> > >> 	Both initiator and target are alone on a gigabit NIC=20
> (Tigon3). On=20
> > >> target server, istd1 takes 100% of a CPU (and only one=20
> CPU, even my=20
> > >> T1000 can simultaneous run 32 threads). I think the=20
> limitation comes=20
> > >> from istd1.
> > >=20
> > > usually istdx will not take 100% cpu with 1G network,=20
> especially when
> > > using disk as back storage, some kind of profiling work=20
> might be helpful
> > > to tell what happened...
> > >=20
> > > forgot to ask, your sparc64 platform cpu spec.
> >=20
> > Root gershwin:[/mnt/solaris] > cat /proc/cpuinfo
> > cpu             : UltraSparc T1 (Niagara)
> > fpu             : UltraSparc T1 integrated FPU
> > prom            : OBP 4.23.4 2006/08/04 20:45
> > type            : sun4v
> > ncpus probed    : 24
> > ncpus active    : 24
> > D$ parity tl1   : 0
> > I$ parity tl1   : 0
> >=20
> > 	Both servers are built with 1 GHz T1 processors (6=20
> cores, 24 threads).
> >=20
>=20
> as Ross pointed out, many io pattern only have 1 outstanding io at an=
y
> time, so there is only one work thread actively to serve it. so it ca=
n
> not exploit the multiple core here.
>=20
>=20
> you see 100% at nullio or fileio? with disk, most time should spend o=
n
> iowait and cpu utilization should not high at all.

Maybe it has to do with the endian-ness fix?

Look at where the fix was implemented and if there was a simpler way
of implementing it? (If that is the cause)

The network is still slower then expected, I don't know what chipset
the Sparcs use for their interfaces, if it is e1000 then you can set
low-latency interrupt throttling with InterruptThrottleRate=3D1 which
works well. You can explore other interface module options around
Interrupt throttling or coalesence.

-Ross

______________________________________________________________________
This e-mail, and any attachments thereto, is intended only for use by
the addressee(s) named herein and may contain legally privileged
and/or confidential information. If you are not the intended recipient
of this e-mail, you are hereby notified that any dissemination,
distribution or copying of this e-mail, and any attachments thereto,
is strictly prohibited. If you have received this e-mail in error,
please immediately notify the sender and permanently delete the
original and any copy or printout thereof.

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
