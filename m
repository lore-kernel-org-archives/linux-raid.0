From: "Majed B." <majedb@gmail.com>
Subject: Re: raid5: cannot start dirty degraded array
Date: Wed, 23 Dec 2009 16:25:38 +0300
Message-ID: <70ed7c3e0912230525h25566bd8jae95ffab149caf65@mail.gmail.com>
References: <579884013.20091223125023@kaneda.iguw.tuwien.ac.at>
	<52151829.20091223135001@kaneda.iguw.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52151829.20091223135001@kaneda.iguw.tuwien.ac.at>
Sender: linux-raid-owner@vger.kernel.org
To: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Give the output of these:

mdadm -E /dev/sd[a-z]

=46rom the errors you show, it seems like one of the disks is dead (sda=
)
or dying. It could be just a bad PCB (the controller board of the
disk) as it refuses to return SMART data, so you might be able to
rescue data by changing the PCB, if it's that important to have that
disk.

As for the array, you can run a degraded array by force assembling it:
mdadm -Af /dev/md0
In the command above, mdadm will search on existing disks and
partitions, which of them belongs to an array and assemble that array,
if possible.

I also suggest you install smartmontools package and run smartctl -a
/dev/sd[a-z] and see the report for each disk to make sure you don't
have bad sectors or bad cables (CRC/ATA read errors) on any of the
disks.

On Wed, Dec 23, 2009 at 3:50 PM, Rainer Fuegenstein
<rfu@kaneda.iguw.tuwien.ac.at> wrote:
> addendum: when going through the logs I found the reason:
>
> Dec 23 02:55:40 alfred kernel: ata1.00: exception Emask 0x0 SAct 0x0 =
SErr 0x0 action 0x6 frozen
> Dec 23 02:55:40 alfred kernel: ata1.00: cmd ea/00:00:00:00:00/00:00:0=
0:00:00/a0 tag 0
> Dec 23 02:55:40 alfred kernel: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0res =
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> Dec 23 02:55:40 alfred kernel: ata1.00: status: { DRDY }
> Dec 23 02:55:45 alfred kernel: ata1: link is slow to respond, please =
be patient (ready=3D0)
> Dec 23 02:55:50 alfred kernel: ata1: device not ready (errno=3D-16), =
forcing hardreset
> Dec 23 02:55:50 alfred kernel: ata1: soft resetting link
> Dec 23 02:55:55 alfred kernel: ata1: link is slow to respond, please =
be patient (ready=3D0)
> Dec 23 02:56:00 alfred kernel: ata1: SRST failed (errno=3D-16)
> Dec 23 02:56:00 alfred kernel: ata1: soft resetting link
> Dec 23 02:56:05 alfred kernel: ata1: link is slow to respond, please =
be patient (ready=3D0)
> Dec 23 02:56:10 alfred kernel: ata1: SRST failed (errno=3D-16)
> Dec 23 02:56:10 alfred kernel: ata1: soft resetting link
> Dec 23 02:56:15 alfred kernel: ata1: link is slow to respond, please =
be patient (ready=3D0)
> Dec 23 02:56:45 alfred kernel: ata1: SRST failed (errno=3D-16)
> Dec 23 02:56:45 alfred kernel: ata1: limiting SATA link speed to 1.5 =
Gbps
> Dec 23 02:56:45 alfred kernel: ata1: soft resetting link
> Dec 23 02:56:50 alfred kernel: ata1: SRST failed (errno=3D-16)
> Dec 23 02:56:50 alfred kernel: ata1: reset failed, giving up
> Dec 23 02:56:50 alfred kernel: ata1.00: disabled
> Dec 23 02:56:50 alfred kernel: sd 0:0:0:0: timing out command, waited=
 30s
> Dec 23 02:56:50 alfred kernel: ata1: EH complete
> Dec 23 02:56:50 alfred kernel: sd 0:0:0:0: SCSI error: return code =3D=
 0x00040000
> Dec 23 02:56:50 alfred kernel: end_request: I/O error, dev sda, secto=
r 1244700223
> Dec 23 02:56:50 alfred kernel: sd 0:0:0:0: SCSI error: return code =3D=
 0x00040000
> Dec 23 02:56:50 alfred kernel: end_request: I/O error, dev sda, secto=
r 1554309191
> Dec 23 02:56:50 alfred kernel: sd 0:0:0:0: SCSI error: return code =3D=
 0x00040000
> Dec 23 02:56:50 alfred kernel: end_request: I/O error, dev sda, secto=
r 1554309439
> Dec 23 02:56:50 alfred kernel: sd 0:0:0:0: SCSI error: return code =3D=
 0x00040000
> Dec 23 02:56:50 alfred kernel: end_request: I/O error, dev sda, secto=
r 572721343
> Dec 23 02:56:50 alfred kernel: raid5: Disk failure on sda1, disabling=
 device. Operation continuing on 3 devices
> Dec 23 02:56:50 alfred kernel: RAID5 conf printout:
> Dec 23 02:56:50 alfred kernel: =C2=A0--- rd:4 wd:3 fd:1
> Dec 23 02:56:50 alfred kernel: =C2=A0disk 0, o:1, dev:sdb1
> Dec 23 02:56:50 alfred kernel: =C2=A0disk 1, o:1, dev:sdd1
> Dec 23 02:56:50 alfred kernel: =C2=A0disk 2, o:0, dev:sda1
> Dec 23 02:56:50 alfred kernel: =C2=A0disk 3, o:1, dev:sdc1
> Dec 23 02:56:50 alfred kernel: RAID5 conf printout:
> Dec 23 02:56:50 alfred kernel: =C2=A0--- rd:4 wd:3 fd:1
> Dec 23 02:56:50 alfred kernel: =C2=A0disk 0, o:1, dev:sdb1
> Dec 23 02:56:50 alfred kernel: =C2=A0disk 1, o:1, dev:sdd1
> Dec 23 02:56:50 alfred kernel: =C2=A0disk 3, o:1, dev:sdc1
> Dec 23 03:22:57 alfred smartd[2692]: Device: /dev/sda, not capable of=
 SMART self-check
> Dec 23 03:22:57 alfred smartd[2692]: Sending warning via mail to root=
 ...
> Dec 23 03:22:58 alfred smartd[2692]: Warning via mail to root: succes=
sful
> Dec 23 03:22:58 alfred smartd[2692]: Device: /dev/sda, failed to read=
 SMART Attribute Data
> Dec 23 03:22:58 alfred smartd[2692]: Sending warning via mail to root=
 ...
> Dec 23 03:22:58 alfred smartd[2692]: Warning via mail to root: succes=
sful
> Dec 23 03:52:57 alfred smartd[2692]: Device: /dev/sda, not capable of=
 SMART self-check
> Dec 23 03:52:57 alfred smartd[2692]: Device: /dev/sda, failed to read=
 SMART Attribute Data
> Dec 23 04:22:57 alfred smartd[2692]: Device: /dev/sda, not capable of=
 SMART self-check
> Dec 23 04:22:57 alfred smartd[2692]: Device: /dev/sda, failed to read=
 SMART Attribute Data
> Dec 23 04:52:57 alfred smartd[2692]: Device: /dev/sda, not capable of=
 SMART self-check
> =C2=A0[...]
> Dec 23 09:52:57 alfred smartd[2692]: Device: /dev/sda, not capable of=
 SMART self-check
> Dec 23 09:52:57 alfred smartd[2692]: Device: /dev/sda, failed to read=
 SMART Attribute Data
> =C2=A0(crash here)
>
>
> RF> hi,
>
> RF> got a "nice" early christmas present this morning: after a crash,=
 the raid5
> RF> (consisting of 4*1.5TB WD caviar green SATA disks) won't start :-=
(
>
> RF> the history:
> RF> sometimes, the raid kicked out one disk, started a resync (which
> RF> lasted for about 3 days) and was fine after that. a few days ago =
I
> RF> replaced drive sdd (which seemed to cause the troubles) and synce=
d the
> RF> raid again which finished yesterday in the early afternoon. at 10=
am
> RF> today the system crashed and the raid won't start:
>
> RF> OS is Centos 5
> RF> mdadm - v2.6.9 - 10th March 2009
> RF> Linux alfred 2.6.18-164.6.1.el5xen #1 SMP Tue Nov 3 17:53:47 EST =
2009 i686 athlon i386 GNU/Linux
>
>
> RF> Dec 23 12:30:19 alfred kernel: md: Autodetecting RAID arrays.
> RF> Dec 23 12:30:19 alfred kernel: md: autorun ...
> RF> Dec 23 12:30:19 alfred kernel: md: considering sdd1 ...
> RF> Dec 23 12:30:19 alfred kernel: md: =C2=A0adding sdd1 ...
> RF> Dec 23 12:30:19 alfred kernel: md: =C2=A0adding sdc1 ...
> RF> Dec 23 12:30:19 alfred kernel: md: =C2=A0adding sdb1 ...
> RF> Dec 23 12:30:19 alfred kernel: md: =C2=A0adding sda1 ...
> RF> Dec 23 12:30:19 alfred kernel: md: created md0
> RF> Dec 23 12:30:19 alfred kernel: md: bind<sda1>
> RF> Dec 23 12:30:19 alfred kernel: md: bind<sdb1>
> RF> Dec 23 12:30:19 alfred kernel: md: bind<sdc1>
> RF> Dec 23 12:30:19 alfred kernel: md: bind<sdd1>
> RF> Dec 23 12:30:19 alfred kernel: md: running: <sdd1><sdc1><sdb1><sd=
a1>
> RF> Dec 23 12:30:19 alfred kernel: md: kicking non-fresh sda1 from ar=
ray!
> RF> Dec 23 12:30:19 alfred kernel: md: unbind<sda1>
> RF> Dec 23 12:30:19 alfred kernel: md: export_rdev(sda1)
> RF> Dec 23 12:30:19 alfred kernel: md: md0: raid array is not clean -=
- starting background reconstruction
> RF> =C2=A0 =C2=A0 (no reconstruction is actually started, disks are i=
dle)
> RF> Dec 23 12:30:19 alfred kernel: raid5: automatically using best ch=
ecksumming function: pIII_sse
> RF> Dec 23 12:30:19 alfred kernel: =C2=A0 =C2=A0pIII_sse =C2=A0: =C2=A0=
7085.000 MB/sec
> RF> Dec 23 12:30:19 alfred kernel: raid5: using function: pIII_sse (7=
085.000 MB/sec)
> RF> Dec 23 12:30:19 alfred kernel: raid6: int32x1 =C2=A0 =C2=A0896 MB=
/s
> RF> Dec 23 12:30:19 alfred kernel: raid6: int32x2 =C2=A0 =C2=A0972 MB=
/s
> RF> Dec 23 12:30:19 alfred kernel: raid6: int32x4 =C2=A0 =C2=A0893 MB=
/s
> RF> Dec 23 12:30:19 alfred kernel: raid6: int32x8 =C2=A0 =C2=A0934 MB=
/s
> RF> Dec 23 12:30:19 alfred kernel: raid6: mmxx1 =C2=A0 =C2=A0 1845 MB=
/s
> RF> Dec 23 12:30:19 alfred kernel: raid6: mmxx2 =C2=A0 =C2=A0 3250 MB=
/s
> RF> Dec 23 12:30:19 alfred kernel: raid6: sse1x1 =C2=A0 =C2=A01799 MB=
/s
> RF> Dec 23 12:30:19 alfred kernel: raid6: sse1x2 =C2=A0 =C2=A03067 MB=
/s
> RF> Dec 23 12:30:19 alfred kernel: raid6: sse2x1 =C2=A0 =C2=A02980 MB=
/s
> RF> Dec 23 12:30:19 alfred kernel: raid6: sse2x2 =C2=A0 =C2=A04015 MB=
/s
> RF> Dec 23 12:30:19 alfred kernel: raid6: using algorithm sse2x2 (401=
5 MB/s)
> RF> Dec 23 12:30:19 alfred kernel: md: raid6 personality registered f=
or level 6
> RF> Dec 23 12:30:19 alfred kernel: md: raid5 personality registered f=
or level 5
> RF> Dec 23 12:30:19 alfred kernel: md: raid4 personality registered f=
or level 4
> RF> Dec 23 12:30:19 alfred kernel: raid5: device sdd1 operational as =
raid disk 1
> RF> Dec 23 12:30:19 alfred kernel: raid5: device sdc1 operational as =
raid disk 3
> RF> Dec 23 12:30:19 alfred kernel: raid5: device sdb1 operational as =
raid disk 0
> RF> Dec 23 12:30:19 alfred kernel: raid5: cannot start dirty degraded=
 array for md0
> RF> Dec 23 12:30:19 alfred kernel: RAID5 conf printout:
> RF> Dec 23 12:30:19 alfred kernel: =C2=A0--- rd:4 wd:3 fd:1
> RF> Dec 23 12:30:19 alfred kernel: =C2=A0disk 0, o:1, dev:sdb1
> RF> Dec 23 12:30:19 alfred kernel: =C2=A0disk 1, o:1, dev:sdd1
> RF> Dec 23 12:30:19 alfred kernel: =C2=A0disk 3, o:1, dev:sdc1
> RF> Dec 23 12:30:19 alfred kernel: raid5: failed to run raid set md0
> RF> Dec 23 12:30:19 alfred kernel: md: pers->run() failed ...
> RF> Dec 23 12:30:19 alfred kernel: md: do_md_run() returned -5
> RF> Dec 23 12:30:19 alfred kernel: md: md0 stopped.
> RF> Dec 23 12:30:19 alfred kernel: md: unbind<sdd1>
> RF> Dec 23 12:30:19 alfred kernel: md: export_rdev(sdd1)
> RF> Dec 23 12:30:19 alfred kernel: md: unbind<sdc1>
> RF> Dec 23 12:30:19 alfred kernel: md: export_rdev(sdc1)
> RF> Dec 23 12:30:19 alfred kernel: md: unbind<sdb1>
> RF> Dec 23 12:30:19 alfred kernel: md: export_rdev(sdb1)
> RF> Dec 23 12:30:19 alfred kernel: md: ... autorun DONE.
> RF> Dec 23 12:30:19 alfred kernel: device-mapper: multipath: version =
1.0.5 loaded
>
> RF> # cat /proc/mdstat
> RF> Personalities : [raid6] [raid5] [raid4]
> RF> unused devices: <none>
>
> RF> filesystem used on top of md0 is xfs.
>
> RF> please advice what to do next and let me know if you need further
> RF> information. really don't want to lose 3TB worth of data :-(
>
>
> RF> tnx in advance.
>
> RF> --
> RF> To unsubscribe from this list: send the line "unsubscribe linux-r=
aid" in
> RF> the body of a message to majordomo@vger.kernel.org
> RF> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-inf=
o.html
>
>
> ---------------------------------------------------------------------=
---------
> Unix gives you just enough rope to hang yourself -- and then a couple=
 of more
> feet, just to be sure.
> (Eric Allman)
> ---------------------------------------------------------------------=
---------
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
