From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: "failed-disk" ?
Date: Thu, 20 Mar 2003 22:29:51 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030320212951.GA30142@marowsky-bree.de>
References: <20030320212250.GO13201@rdlg.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030320212250.GO13201@rdlg.net>
To: "Robert L. Harris" <Robert.L.Harris@rdlg.net>, Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 2003-03-20T16:22:50,
   "Robert L. Harris" <Robert.L.Harris@rdlg.net> said:

> I'm trying to "mkraid /dev/md1" with the following:
>=20
> raiddev /dev/md1
>   raid-level 1
>   nr-raid-disks 2
>   nr-spare-disks 0
>   chunk-size 16
>   persistent-superblock 1
>   device failed-disk
>   raid-disk 0
>   device /dev/sdb1
>   raid-disk 1
>=20
> I'm trying to convert this machine to raid1 on root.  Don't ask about
> the md1, long story.  At any rate when I do the mkraid I get this:
>=20
> root@rharris-build2:~# mkraid /dev/md1
> handling MD device /dev/md1
> analyzing super-block
> couldn't call stat() on device failed-disk -- No such file or directo=
ry
> mkraid: aborted, see the syslog and /proc/mdstat for potential clues.

Does your system have a device named 'failed-disk' ? I would assume not=
 ;-)


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
SuSE Labs - Research & Development, SuSE Linux AG
 =20
"If anything can go wrong, it will." "Chance favors the prepared (mind)=
=2E"
  -- Capt. Edward A. Murphy            -- Louis Pasteur
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
