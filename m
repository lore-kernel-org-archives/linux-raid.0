From: "Miguel Angel Martinez Ezquerro" <scsmaezm@sc.ehu.es>
Subject: Booting a disk (mirrored) in other system
Date: Thu, 3 Jul 2003 09:14:15 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <00cd01c34132$b70dc8d0$6296e39e@sc.ehu.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have installed RedHat 9.0 in a system with RAID1 (mirror). I have a
SCSI AIC-7899 controller and a System Pentium III Xeon and two disks of
36 Gb. Each disk has 3 partitions /, /var and /users and its
corresponding mirror in the other disk. =20
 =20
I have acquired another identical system to the previous one, with the
same processor and disks, with the exception that the  SCSI controller
in the new system is AIC-7902. If I attempt to boot RedHat in this new
system with the disks of the previous one it doesn't work at all. =20
 =20
Has somebody had this problem? Is it possible to define the two  SCSI
drivers in oneself Kernel in order to be able to pull up the system wit=
h
the same disks in any it schemes? =20
 =20
Thanks in advance and  greetings

Saludos,
                M.A.

------------------------------------------------------------------
Miguel =C1ngel Mart=EDnez Ezquerro      |   Universidad del Pa=EDs Vasc=
o
CIDIR Guip=FAzcoa (UPV/EHU)           |   E-mail: scsmaezm@sc.ehu.es
P.M Lardiz=E1bal,1 (Ed. F.Inform=E1tica)|   Tel...: +34 943 018005
20018 San Sebasti=E1n (SPAIN )        |   Fax...: +34 943 219306
------------------------------------------------------------------=20

=20


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
