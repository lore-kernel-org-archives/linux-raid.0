From: "Glatzel Tino" <tino.glatzel@badenIT.de>
Subject: Linux-System installed from tar.gz with a Live-CD
Date: Thu, 20 Dec 2007 09:12:47 +0100
Message-ID: <763363C6C69C5A4B9735E3907164812A01148FEC@bit123.badenit.intern>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,
I have installed my Linux-System, Debian Etch, whith a Live-CD from a t=
ar.gz-file.
I have created the partitions of the disc with the type "fd" and made t=
he MD-devices=20
with the Live-CD. After mounting the required md-devices, I have extrac=
t the System from the tar.gz-Archiv.
The System works fine. After some tests with madam, I stopped a MD-Devi=
ce.
After this, the stopped MD-devices was not in the /proc/mdstat. --> Tha=
ts OK
After this, I have created the Raid new:
mdadm --create /dev/md8 --raid-devices=3D2 --level=3D1 /dev/sda10 missi=
ng
mdadm: /dev/sda10 appears to be part of a raid array:
    level=3Draid1 devices=3D2 ctime=3DTue Dec 18 17:42:58 2007
Continue creating array? y
mdadm: array /dev/md8 started.
=20
After the next reboot, the System can't mount the md8 !
If the md8 is in the /etc/mdadm/mdadm.conf, mdadm is starting the devic=
e,
but previus the stopping and the (re)creating of the md8-device, the de=
vice comes
up without the entry in the /etc/mdadm/mdadm.conf.
Why ????
What can I do to start the md8 without the entry in the file ??
Can anyone help me ????

Tino

Mit freundlichen Gr=FC=DFen

badenIT GmbH
Innovationstechnologie

Tino Glatzel
Tullastra=DFe 70

D-79108 Freiburg

Tel.: 0761 279-2804
=46ax: 0761 279-572804

e-Mail: tino.glatzel@badenit.de
URL: www.badenIT.de
-----------------------------------------
 =BB Zertifiziert nach ISO 20000
----------------------------------------
badenIT GmbH
Sitz der Gesellschaft: Freiburg im Breisgau
Registergericht: Amtsgericht Freiburg
Registernummer: HRB 5535
Gesch=E4ftsf=FChrer: Peter Lais
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
