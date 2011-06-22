From: william L'Heureux <wil_c_will@hotmail.com>
Subject: RE: reaid problem at reboot
Date: Tue, 21 Jun 2011 23:34:21 -0400
Message-ID: <BAY158-w1B10F98EB9026A0F3D50CC0500@phx.gbl>
References: <BAY158-W207004CCDC35695F84D5B4C0510@phx.gbl>,<4E00FC8A.1050908@turmel.org>
 <BAY158-w388BBEAFF686EAA222B346C0510@phx.gbl>,<4E0113FE.503@turmel.org>
 <BAY158-w3076B56F0F37E7F3DA4866C0500@phx.gbl>,<4E0146B6.40101@turmel.org>
 <BAY158-w9526A91B9B67956C12924C0500@phx.gbl>,<4E0153C1.1040708@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E0153C1.1040708@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: philip@turmel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


/dev/sdj1 cant be first, its /dev/sda1.

My friend made a python script. take a look.

cat rebuild.py
#!/usr/bin/env python

#=A0 /dev/sdj1 /dev/sdc1 /dev/sda1 /dev/sdd1 /dev/sdh1 /dev/sdi1

import os;
import time;
from itertools import permutations;

#aLetters =3D ( 'a', 'c', 'd', 'h', 'i', 'j' );
aLetters =3D ( 'j', 'c', 'h' );
j =3D [];
for i in permutations(aLetters):
=A0=A0=A0=A0=A0=A0=A0 if i[0:3] =3D=3D j[0:3]: continue;
=A0=A0=A0=A0=A0=A0=A0 j =3D i;
=A0=A0=A0=A0=A0=A0=A0 time.sleep(0.1);
=A0=A0=A0=A0=A0=A0=A0 os.system("vgchange -an vgRAID60 2>/dev/null >/de=
v/null");
=A0=A0=A0=A0=A0=A0=A0 os.system("mdadm -S /dev/md127 2>/dev/null >/dev/=
null");
=A0=A0=A0=A0=A0=A0=A0 os.system("mdadm -S /dev/md126 2>/dev/null >/dev/=
null");
=A0=A0=A0=A0=A0=A0=A0 os.system("mdadm -S /dev/md0 2>/dev/null >/dev/nu=
ll");
=A0=A0=A0=A0=A0=A0=A0 (hStdin, hStdout) =3D os.popen4("mdadm --create /=
dev/md0 --level=3D6 --raid-devices=3D6 --assume-clean --chunk=3D128 /de=
v/sda1 /dev/sd%s1 /dev/sd%s1 /dev/sd%s1 missing missing" % (i[0:3]));
=A0=A0=A0=A0=A0=A0=A0 hStdin.write("y\n");
=A0=A0=A0=A0=A0=A0=A0 hStdin.close();
=A0=A0=A0=A0=A0=A0=A0 hStdout.close();
=A0=A0=A0=A0=A0=A0=A0 time.sleep(0.5);
=A0=A0=A0=A0=A0=A0=A0 (hStdin, hStdout) =3D os.popen4("pvck /dev/md0");
=A0=A0=A0=A0=A0=A0=A0 sOutput =3D hStdout.read();
=A0=A0=A0=A0=A0=A0=A0 hStdin.close();
=A0=A0=A0=A0=A0=A0=A0 hStdout.close();
=A0=A0=A0=A0=A0=A0=A0 print("/dev/sdj1 /dev/sd%s1 /dev/sd%s1 /dev/sd%s1=
 missing missing" % (i[0:3]));
=A0=A0=A0=A0=A0=A0=A0 fRAID =3D open("/dev/md0", 'r');
=A0=A0=A0=A0=A0=A0=A0 try:
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fRAID.seek(4608);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sLVM =3D fRAID.read(128);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fRAID.close();
=A0=A0=A0=A0=A0=A0=A0 except:
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fRAID.close();
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 continue;
=A0=A0=A0=A0=A0=A0=A0 print(sLVM);
=A0=A0=A0=A0=A0=A0=A0 if sOutput.find("Found label") !=3D -1:
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 os.system("/bin/bash");
#=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 os.system("vgchange -ay vgR=
AID60 2>/dev/null >/dev/null");
#=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 os.system("vgmknodes");
#=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 iExit =3D os.system("e2fsck=
 -n /dev/vgRAID60/data0");
#=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if iExit =3D=3D 0:
#=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pri=
nt("/dev/sd%s1 /dev/sd%s1 /dev/sd%s1 /dev/sd%s1 missing missing" % (i))=
;

i can see the data with the combinatin below, but there is a lot of err=
ors, sounds like a rebuild was started(beghining of the disk) then was =
canceled

we made a snapshot, run a e2fsck on it and im still(not now, gotta slee=
p) add 1 missing or 2. after the e2fsck i mount the snap, look at the d=
ata, check corruption, rince and repeat with another combination of mis=
sing and not. i rate the ones with less corruption



the only e2fsck working is with --->>> a,j,c,h,i,d
 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
