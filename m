From: Norman Schmidt <norman.schmidt@chemie.uni-erlangen.de>
Subject: Re: new raid system for home use
Date: Mon, 19 Apr 2004 18:01:26 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4083F7D6.1060200@chemie.uni-erlangen.de>
References: <200404182048.i3IKm9b00691@dns1.watkins-home.com>
Reply-To: schmidt@naa.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200404182048.i3IKm9b00691@dns1.watkins-home.com>
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Guy schrieb:

> You said:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
>>  * hot swap
>=20
> I think I have read that Linux does not support hot swap SATA disks.
> Not yet.

I don=B4t know how exactly you define "hot swap". But the following wor=
ks=20
(I tried it):

3* Samsung Spinpoint 160G SATA disk
Promise SATA 150 TX4 controller
sw raid 5 over the three disks

promise driver module with 2.4.23 or so kernel

The drives are accessed as sd[something]. If you Plug and pull other=20
scsi devices, you should use uuids for mdadm, not drive letters (becaus=
e=20
they change).

I set faulty one drive and removed it with mdadm. Then I unplugged it=20
(first SATA plug, then current plug). The drive was gone in=20
/proc/scsi/something. Then I reattached it vice versa. The drive was=20
back in /proc/. Thenn=B4added the drive back to the raid with mdadm -=20
resync - everything was fine.

So for changing the drive, you don=B4t have to power down the server, n=
ot=20
even stop any server daemons.

> I think SCSI is the only hot swap option unless he goes with hardware=
 RAID.
> Also, hardware RAID does real hot swap (remove bad disk, insert good =
disk,
> back to computer games).  With software RAID you must issue magic
> incantations to swap a disk.  Some would argue against software RAID =
because
> of this.

Yes, that=B4s right, that=B4s a con. But I had massive problemns with t=
wo=20
Mylex DAC960 hardware raid controllers - I would never use them again=20
(were bought by my predecessors).

> Guy

Norman.


--=20
Norman Schmidt          Institut fuer Physikal. u. Theoret. Chemie
Dipl.-Chem. Univ.       Friedrich-Alexander-Universitaet
schmidt@naa.net         Erlangen-Nuernberg
                         IT-Systembetreuer Physikalische Chemie

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
