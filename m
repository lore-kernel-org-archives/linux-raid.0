From: =?ISO-8859-1?Q?Edouard_Gaulu=E9?= <edouard.gaulue@ensg.ign.fr>
Subject: I travelled twice in the past !!
Date: Mon, 24 Jul 2006 15:10:22 +0200
Message-ID: <44C4C6BE.9030305@ensg.ign.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear all,

I'm sory I didn't get the time to read the whole list and my Internet=20
researchs kept sending me to linux soft-raid howtos. So I send a mail t=
o=20
this list.

This is the second time I travelled in the past due to my linux soft=20
RAID 1 system (mis)configuration.

Here is what I can say :
- I've got plenty of production servers configured in RAID 1 using the=20
2.4.24 debian patched linux kernel.
- I often go on those machines and a cat /proc/mstat seems to report me=
=20
that disks are synchronized. Should I trust this kind of information ?
- Those machines often turn more than a year long without being reboot.
- Sometime due to hardware problems, or a need for a kernel change I=20
have to reboot them.
- Sometime this reboot fail.
- This morning, it failled and I needed to use a Knoppix CD to get back=
=20
to my system, chroot, repair the problem and reboot.
- I needed to assemble my array before to mount it, what I did with :=20
mdadm --assemble /dev/md0 /dev/sda1 /dev/sdb1.
- The system answered it had to resynchronize the disks.
- After this, the data I got were about one year ago...

My opinion and questions :
- I thought that in RAID 1, writes were made on the 2 disks and reads=20
half/half on the first and the second. Am I wrong ?
- I've got the feeling that starting a certain day  (don't know which=20
one), it stopped behave this way. Is this happening often ? Is it a bug=
=20
? How to detect this behaviour ?
- When I re-assembled the disk : no luck, it resynchronized the older=20
with the knew one, so I get in the past.

Please help me, telling me if it's a misunderstanding on the way RAID 1=
=20
should work, if I had to make more control with special tools, if it's =
a=20
bug, if it depends on the kernel version...

EG

--=20
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=C9douard GAULU=C9
ENSG - IGN                             R=E9seau et Syst=E8mes Informati=
ques
6-8 avenue Blaise Pascal               Activit=E9 IGS & DORIS
=46-77455 MARNE LA VALLEE CEDEX 2        Master MSIAG
Tel : +33 (0) 1 64 15 32 43
Mail : Edouard.Gaulue@ensg.ign.fr

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
