From: "Guy" <bugzilla@watkins-home.com>
Subject: Recovered disk error caused disk to go offline.
Date: Thu, 29 Jan 2004 00:00:22 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200401290500.i0T50Mi21963@dns1.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: 
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

As you can see in the log, the write error recovered with auto realloca=
tion!
As I understand it, this is a normal event with today=92s disks.
I don=92t think the disk should have been considered failed.

Comments please?

Thanks,
Guy

The spare disk resynced just fine.=A0 I never knew for over 24 hours!
This is cool stuff!

Jan 27 12:44:06 watkins kernel: SCSI disk error : host 2 channel 0 id 4=
 lun
0 return code =3D 8000002
Jan 27 12:44:06 watkins kernel: Info fld=3D0x7e5c81, Deferred sd08:71: =
sense
key Recovered Error
Jan 27 12:44:06 watkins kernel: Additional sense indicates Write error =
-
recovered with auto reallocation
Jan 27 12:44:06 watkins kernel:=A0 I/O error: dev 08:71, sector 8280704
Jan 27 12:44:06 watkins kernel: raid5: Disk failure on sdh1, disabling
device. Operation continuing on 13 devices
Jan 27 12:44:06 watkins kernel: md: updating md2 RAID superblock on dev=
ice
Jan 27 12:44:06 watkins kernel: md: sdc1 [events: 00000009]<6>(write) s=
dc1's
sb offset: 17767744
Jan 27 12:44:06 watkins kernel: md: recovery thread got woken up ...
Jan 27 12:44:06 watkins kernel: md2: resyncing spare disk sdc1 to repla=
ce
failed disk
Jan 27 12:44:06 watkins kernel: RAID5 conf printout:
Jan 27 12:44:06 watkins kernel:=A0 --- rd:14 wd:13 fd:1

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
