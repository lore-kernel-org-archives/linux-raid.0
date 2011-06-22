From: william L'Heureux <wil_c_will@hotmail.com>
Subject: RE: reaid problem at reboot
Date: Tue, 21 Jun 2011 21:00:49 -0400
Message-ID: <BAY158-w3076B56F0F37E7F3DA4866C0500@phx.gbl>
References: <BAY158-W207004CCDC35695F84D5B4C0510@phx.gbl>,<4E00FC8A.1050908@turmel.org>
 <BAY158-w388BBEAFF686EAA222B346C0510@phx.gbl>,<4E0113FE.503@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E0113FE.503@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: philip@turmel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


for x in /dev/sd[abcdefghijkm] ; do echo "**** $=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 x ****" ; dd if=3D$x skip=3D2056 count=3D2 2>/dev=
/null |strings ; done
**** /dev/sda ****
-BILLSSHACK:0
/4o.
**** /dev/sdb ****
billsshack:3
**** /dev/sdc ****
-BILLSSHACK:0
**** /dev/sdd ****
-BILLSSHACK:0
CgW:
**** /dev/sde ****
billsshack:3
**** /dev/sdf ****
billsshack:3
**** /dev/sdg ****
billsshack:3
<:=A0=A0=A0=A0=A0 L
**** /dev/sdh ****
-BILLSSHACK:0
**** /dev/sdi ****
-BILLSSHACK:0
**** /dev/sdj ****
-BILLSSHACK:0
**** /dev/sdk ****
billsshack:3
**** /dev/sdm ****
billsshack:3
Zm$8=A0 2


Thanks
 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
