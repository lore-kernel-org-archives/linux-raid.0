From: Mike Viau <viaum@sheridanc.on.ca>
Subject: RE: Removed drive from mdadm raid 5 array after reboot
Date: Sat, 26 Feb 2011 22:13:42 -0500
Message-ID: <BAY148-w284BF16B173BA4A44C61D3EFDF0@phx.gbl>
References: <BAY148-w38CAE450FEC67644025E33EFD40@phx.gbl>,<BAY148-w4658B4D2C63A5B2ADAEDBEFD40@phx.gbl>,<BAY148-w245C4F3B070F5743631EA9EFD40@phx.gbl>,<1298062156.4497.7.camel@michal-laptop.sawicz.net>,<BAY148-w63B278D088E2A88E2D3544EFD40@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BAY148-w63B278D088E2A88E2D3544EFD40@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> > Date: Fri, 18 Feb 2011 21:49:16 +0100
> >
> > > Dnia 2011-02-18, pi=B1 o godzinie 15:08 -0500, Mike Viau pisze:
> > > I was wondering if anyone had come across an issue where after
> > > rebooting the system, mdadm fails to reassemble an entire raid 5 =
array
> > > with all the drives. I am getting the array up with just /dev/sda=
 and
> > > /dev/sdb, but the array is degraded as a consequence to missing
> > > /dev/sdd (which I assume has become the parity drive).
> >
> > There is no such thing as a parity drive in raid5, everything (pari=
ty
> > data, too) is spread out evenly over all of the disks.
> >
>
> Hmm, that makes more sense hence distributed parity).
>
> > Please post the output of `mdadm --examine /dev/sd{a,b,d}1` and che=
ck
> > your logs to see if there are any mentions of why the array isn't
> > assembled on boot.
> >
>
> mdadm --examine /dev/sd{a,b,d}1
> /dev/sda1:
> Magic : a92b4efc
> Version : 1.2
> Feature Map : 0x0
> Array UUID : 7d8a7c68:95a230d0:0a8f6e74:4c8f81e9
> Name : XEN-HOST:0 (local to host XEN-HOST)
> Creation Time : Mon Dec 20 09:48:07 2010
> Raid Level : raid5
> Raid Devices : 3
>
> Avail Dev Size : 1953517954 (931.51 GiB 1000.20 GB)
> Array Size : 3907035136 (1863.02 GiB 2000.40 GB)
> Used Dev Size : 1953517568 (931.51 GiB 1000.20 GB)
> Data Offset : 2048 sectors
> Super Offset : 8 sectors
> State : clean
> Device UUID : 25f4baf0:9a378d2c:16a87f0c:ff89b2c8
>
> Update Time : Fri Feb 18 16:32:19 2011
> Checksum : 37383bee - correct
> Events : 32184
>
> Layout : left-symmetric
> Chunk Size : 512K
>
> Device Role : Active device 0
> Array State : AAA ('A' =3D=3D active, '.' =3D=3D missing)
> /dev/sdb1:
> Magic : a92b4efc
> Version : 1.2
> Feature Map : 0x0
> Array UUID : 7d8a7c68:95a230d0:0a8f6e74:4c8f81e9
> Name : XEN-HOST:0 (local to host XEN-HOST)
> Creation Time : Mon Dec 20 09:48:07 2010
> Raid Level : raid5
> Raid Devices : 3
>
> Avail Dev Size : 1953517954 (931.51 GiB 1000.20 GB)
> Array Size : 3907035136 (1863.02 GiB 2000.40 GB)
> Used Dev Size : 1953517568 (931.51 GiB 1000.20 GB)
> Data Offset : 2048 sectors
> Super Offset : 8 sectors
> State : clean
> Device UUID : f20ab5fd:1f141cae:e0547278:d6cf063e
>
> Update Time : Fri Feb 18 16:32:19 2011
> Checksum : a70821e2 - correct
> Events : 32184
>
> Layout : left-symmetric
> Chunk Size : 512K
>
> Device Role : Active device 1
> Array State : AAA ('A' =3D=3D active, '.' =3D=3D missing)
> /dev/sdd1:
> Magic : a92b4efc
> Version : 1.2
> Feature Map : 0x2
> Array UUID : 7d8a7c68:95a230d0:0a8f6e74:4c8f81e9
> Name : XEN-HOST:0 (local to host XEN-HOST)
> Creation Time : Mon Dec 20 09:48:07 2010
> Raid Level : raid5
> Raid Devices : 3
>
> Avail Dev Size : 1953521072 (931.51 GiB 1000.20 GB)
> Array Size : 3907035136 (1863.02 GiB 2000.40 GB)
> Used Dev Size : 1953517568 (931.51 GiB 1000.20 GB)
> Data Offset : 2048 sectors
> Super Offset : 8 sectors
> Recovery Offset : 610474280 sectors
> State : clean
> Device UUID : 33d70114:ffdc4fcc:2c8d65ba:ab50bab2
>
> Update Time : Fri Feb 18 16:32:19 2011
> Checksum : b692957e - correct
> Events : 32184
>
> Layout : left-symmetric
> Chunk Size : 512K
>
> Device Role : Active device 2
> Array State : AAA ('A' =3D=3D active, '.' =3D=3D missing)
>
>
>
> The array actually does assemble on boot, but the /dev/sdd1 partition
> is not added automatically, and I am not sure why?
>
> >
> > Have you tried booting in single user mode (I assume this drive isn=
't
> > your boot drive?) and try to assemble the array by hand? Have you s=
een
> > any errors?
> >
>


What specific command should I use to assemble the array by hand? I see=
 that there are assemble and incremental assemble commands. I'd also as=
sume I should increase the verbosity to see what is going on.

Does anyone think that trying to re-build this raid 5 array would be a =
possible way to fix the removed drive problem on boot?

I read in the man page under the section for build:

"cannot differentiate between initial creation and subsequent assembly =
of=A0 an=A0 array.=A0=20
It also=A0 cannot=A0 perform=A0 any=A0 checks that appropriate componen=
ts have been requested.=A0 Because of
this, the Build mode should only be used together with a complete under=
standing of what you are doing."


Therefor I am cautious to proceed without some advice first...

Thanks.



> The array was initially created about a month ago, below are the mdad=
m
> events in my syslog. A couple questions arise:
>
> 1) If mdadm initially created the array as md127, and then I declared
> it as md0 in mdadm.conf as:
>
> # definitions of existing MD arrays
> ARRAY /dev/md/0 metadata=3D1.2 UUID=3D7d8a7c68:95a230d0:0a8f6e74:4c8f=
81e9
> name=3DXEN-HOST:0
>
>
> 2) If sdd was an always connected usb enclosure connected hard drive =
as
> apposed to /dev/sda and /dev/sdb being directly connected SATA drives=
=2E
>
>
> Would either of these cause the problem such as the subject of this t=
hread?
>
>
> cat /var/log/syslog | grep mdadm
> Jan 30 00:57:01 XEN-HOST /USR/SBIN/CRON[6944]: (root) CMD (if [ -x
> /usr/share/mdadm/checkarray ] && [ $(date +%d) -le 7 ]; then
> /usr/share/mdadm/checkarray --cron --all --idle --quiet; fi)
> Jan 30 22:33:48 XEN-HOST mdadm[25684]: NewArray event detected on md
> device /dev/md127
> Jan 30 22:33:48 XEN-HOST mdadm[25684]: DegradedArray event detected o=
n
> md device /dev/md127
> Jan 30 22:45:13 XEN-HOST mdadm[1883]: NewArray event detected on md
> device /dev/md127
> Jan 30 22:45:15 XEN-HOST mdadm[1883]: DegradedArray event detected on
> md device /dev/md127
> Jan 30 23:29:31 XEN-HOST mdadm[1930]: DegradedArray event detected on
> md device /dev/md/0
> Jan 30 23:33:51 XEN-HOST mdadm[1889]: DegradedArray event detected on
> md device /dev/md/0
> Jan 30 23:38:32 XEN-HOST mdadm[1889]: RebuildStarted event detected o=
n
> md device /dev/md/0
> Jan 31 01:51:53 XEN-HOST mdadm[1889]: Rebuild20 event detected on md
> device /dev/md/0
> Jan 31 04:05:13 XEN-HOST mdadm[1889]: Rebuild41 event detected on md
> device /dev/md/0
> Jan 31 06:18:34 XEN-HOST mdadm[1889]: Rebuild62 event detected on md
> device /dev/md/0
> Jan 31 08:15:15 XEN-HOST mdadm[1889]: Rebuild80 event detected on md
> device /dev/md/0
> Jan 31 10:15:50 XEN-HOST mdadm[1889]: RebuildFinished event detected =
on
> md device /dev/md/0
> Jan 31 10:15:50 XEN-HOST mdadm[1889]: SpareActive event detected on m=
d
> device /dev/md/0
> Feb 6 00:57:01 XEN-HOST /USR/SBIN/CRON[13578]: (root) CMD (if [ -x
> /usr/share/mdadm/checkarray ] && [ $(date +%d) -le 7 ]; then
> /usr/share/mdadm/checkarray --cron --all --idle --quiet; fi)
> Feb 6 00:57:01 XEN-HOST mdadm[1889]: RebuildStarted event detected on
> md device /dev/md/0
> Feb 6 02:37:02 XEN-HOST mdadm[1889]: Rebuild21 event detected on md
> device /dev/md/0
> Feb 6 04:17:02 XEN-HOST mdadm[1889]: Rebuild42 event detected on md
> device /dev/md/0
> Feb 6 05:40:23 XEN-HOST mdadm[1889]: Rebuild60 event detected on md
> device /dev/md/0
> Feb 6 07:20:23 XEN-HOST mdadm[1889]: Rebuild81 event detected on md
> device /dev/md/0
> Feb 6 08:44:40 XEN-HOST mdadm[1889]: RebuildFinished event detected o=
n
> md device /dev/md/0
> Feb 6 23:11:07 XEN-HOST mdadm[1887]: DegradedArray event detected on
> md device /dev/md/0
> Feb 8 08:51:53 XEN-HOST mdadm[1887]: RebuildStarted event detected on
> md device /dev/md/0
> Feb 8 11:05:13 XEN-HOST mdadm[1887]: Rebuild20 event detected on md
> device /dev/md/0
> Feb 8 13:18:34 XEN-HOST mdadm[1887]: Rebuild41 event detected on md
> device /dev/md/0
> Feb 8 15:15:14 XEN-HOST mdadm[1887]: Rebuild60 event detected on md
> device /dev/md/0
> Feb 8 17:28:35 XEN-HOST mdadm[1887]: Rebuild81 event detected on md
> device /dev/md/0
> Feb 8 19:26:32 XEN-HOST mdadm[1887]: RebuildFinished event detected o=
n
> md device /dev/md/0
> Feb 8 19:26:32 XEN-HOST mdadm[1887]: SpareActive event detected on md
> device /dev/md/0
> Feb 13 00:57:01 XEN-HOST /USR/SBIN/CRON[12933]: (root) CMD (if [ -x
> /usr/share/mdadm/checkarray ] && [ $(date +%d) -le 7 ]; then
> /usr/share/mdadm/checkarray --cron --all --idle --quiet; fi)
> Feb 18 12:19:31 XEN-HOST mdadm[1864]: DegradedArray event detected on
> md device /dev/md/0
> Feb 18 12:23:07 XEN-HOST mdadm[1613]: DegradedArray event detected on
> md device /dev/md/0
> Feb 18 12:26:24 XEN-HOST mdadm[1767]: DegradedArray event detected on
> md device /dev/md/0
> Feb 18 12:50:53 XEN-HOST mdadm[1767]: RebuildStarted event detected o=
n
> md device /dev/md/0
> Feb 18 15:04:14 XEN-HOST mdadm[1767]: Rebuild21 event detected on md
> device /dev/md/0
>
 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
