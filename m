From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Recovered disk error caused disk to go offline.
Date: Thu, 29 Jan 2004 16:05:31 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16408.38043.428074.518488@notabene.cse.unsw.edu.au>
References: <200401290500.i0T50Mi21963@dns1.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Guy on Thursday January 29
To: Guy <bugzilla@watkins-home.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday January 29, bugzilla@watkins-home.com wrote:
> As you can see in the log, the write error recovered with auto reallo=
cation!
> As I understand it, this is a normal event with today=92s disks.
> I don=92t think the disk should have been considered failed.
>=20
> Comments please?

You need to talk to linux-scsi about this.
The scsi subsystem told the raid subsystem that there was an error, so
the raid subsystem stopped using the device.

If the write error was recovered, scsi shouldn't have reported an
error to raid.

NeilBrown

>=20
> Thanks,
> Guy
>=20
> The spare disk resynced just fine.=1B,A =1B(B I never knew for over 2=
4 hours!
> This is cool stuff!
>=20
> Jan 27 12:44:06 watkins kernel: SCSI disk error : host 2 channel 0 id=
 4 lun
> 0 return code =3D 8000002
> Jan 27 12:44:06 watkins kernel: Info fld=3D0x7e5c81, Deferred sd08:71=
: sense
> key Recovered Error
> Jan 27 12:44:06 watkins kernel: Additional sense indicates Write erro=
r -
> recovered with auto reallocation
> Jan 27 12:44:06 watkins kernel:=1B,A =1B(B I/O error: dev 08:71, sect=
or 8280704
> Jan 27 12:44:06 watkins kernel: raid5: Disk failure on sdh1, disablin=
g
> device. Operation continuing on 13 devices
> Jan 27 12:44:06 watkins kernel: md: updating md2 RAID superblock on d=
evice
> Jan 27 12:44:06 watkins kernel: md: sdc1 [events: 00000009]<6>(write)=
 sdc1's
> sb offset: 17767744
> Jan 27 12:44:06 watkins kernel: md: recovery thread got woken up ...
> Jan 27 12:44:06 watkins kernel: md2: resyncing spare disk sdc1 to rep=
lace
> failed disk
> Jan 27 12:44:06 watkins kernel: RAID5 conf printout:
> Jan 27 12:44:06 watkins kernel:=1B,A =1B(B --- rd:14 wd:13 fd:1
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
