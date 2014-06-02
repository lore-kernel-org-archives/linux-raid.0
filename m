From: =?UTF-8?B?S8WRdsOhcmkgUMOpdGVy?= <peter@kovari.priv.hu>
Subject: RE: Recovering RAID set after OS disk failed
Date: Mon, 2 Jun 2014 14:36:50 +0200
Message-ID: <000801cf7e5f$53ffce20$fbff6a60$@kovari.priv.hu>
References: <7C19F7E4-7354-4C2C-A53E-DA546B569201@sbcglobal.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7C19F7E4-7354-4C2C-A53E-DA546B569201@sbcglobal.net>
Content-Language: hu
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Davide,

Open / ssh a console on your NAS box, and issue the following command a=
nd send us the results:=20
$ cat /proc/mdstat

Please also issue the following commands

mdadm --examine /dev/sdX[Y]

Where X is one of the raid drive's name and Y is the partition number, =
if you created the raid set on partitions. (If not, then leave the numb=
er.) So, for example (assuming that your OS drive is /dev/sda, so your =
raid drives are /dev/sdb, /dev/sdc and so on) issue the following comma=
nds:

$ mdadm --examine /dev/sdb
or
$ mdadm --examine /dev/sdb1

and so on for all 4 drives. And send back the results.

p.s.
Before everything else,  you might try  auto assembling th eset by:
$ mdadm -v --assemble --scan

It might assemble your raid set for you successfully out of the box.  (=
If not, send here the output.)
If this assembles your set successfully, then you just need to save you=
r config in /etc/mdam/mdadm.conf, do an initramfs update and you are go=
od to go.
So to save the config issue:
$ mdadm --examine --scan >> /etc/mdadm/mdadm.conf

then update initramfs so th eset will auto assmble on next boot:
$ update-initramfs -k all -u

Best regards,
Peter
-----------------------------------------------------------------------=
----------------------------------------
=EF=82=9B: peter@kovari.priv.hu
=EF=82=9B: pkovari@gmail.com
=EF=83=BC:  www.kovari.priv.hu

-----Original Message-----
=46rom: linux-raid-owner@vger.kernel.org [mailto:linux-raid-owner@vger.=
kernel.org] On Behalf Of Davide Guarisco
Sent: Monday, June 2, 2014 7:38 AM
To: linux-raid@vger.kernel.org
Subject: Recovering RAID set after OS disk failed

Hello and sorry if this is not the place for a relatively =E2=80=9Cnewb=
ie=E2=80=9D question.

=46ive years ago I built a NAS box running on Ubuntu server then-curren=
t version. The NAS has 4 SATA drives (the RAID set) and a PATA system d=
rive (for the OS). Now the system drive has failed (click of death). I =
believe the that RAID data is still safe and sound, but my question is =
how to proceed in such a scenario. (I do have a backup but it=E2=80=99s=
 fairly old). I do not remember exactly how I created the RAID set, oth=
er than being with mdadm and probably RAID 5.=20

I have now replaced the failed PATA drive with a new 32 GB PATA SSD, an=
d installed Ubuntu Server 14.04. The system is up and running and it se=
es the four SATA drives. I have installed Webmin and I am ready to reco=
ver the RAID set.=20


I read the Wiki and it suggests running a =E2=80=9Cpermutation=E2=80=9D=
 Perl script. Is this a reasonable thing to do?=20
I could not find much information on a case like this in a Goole search=
, so any help appreciated.=20




--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
