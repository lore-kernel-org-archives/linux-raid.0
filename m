From: "Uher Marek" <Marek.Uher@t-mobile.cz>
Subject: Problem with multipath in 2.6.x kernel
Date: Mon, 14 Jun 2004 15:03:41 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <D18A13F01D850B409793C6C3FA5E038917E127@SRVRE02.rdm.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
To: linux-raid@vger.kernel.org
Cc: neilb@cse.unsw.edu.au, christophe.varoqui@free.fr
List-Id: linux-raid.ids


	Hello,

I have serious problem with Linux multipath connection to our SAN. I th=
ink that
there is probably a bug in the multipath kernel code. First of all, the=
re is a
short hardware and software environment description:


	Hardware configuration:

		IBM ESS 2105 SAN storage
		IBM eServer xSeries x445 (this is Intel based NUMA server)
			4 x Xeon MP CPU 2.80GHz
			8 GB RAM
			2 x QLogic QLA2312 fibre channel adapters


	Software configuration:

		Debian GNU/Linux 3.1/testing (sarge)
		Linux kernel v2.6.6 (plus DM / LVM2 patches)
		glibc v 2.3.2
		mdadm v1.4.0
		raidtools2 v1.00.3


I am able to activate Linux multipath connection properly only for firs=
 time.
Every time when I try to activate the multipath device(s) again, the sy=
stem is
not able to assemble the multipath device correctly. The result is a mu=
ltipath
device with one path only.

Step-by-step description and system diagnostic:

1) Set up a set of block devices into a multipath device:

	mkraid /dev/md0
	handling MD device /dev/md0
	analyzing super-block
	disk 0: /dev/scsi/host2/bus0/target0/lun0/part1, 102534831kB, raid sup=
erblock at 102534720kB
	disk 1: /dev/scsi/host3/bus0/target0/lun0/part1, 102534831kB, raid sup=
erblock at 102534720kB

   Syslog:

	md: md driver 0.90.0 MAX_MD_DEVS=3D256, MD_SB_DISKS=3D27
	md: multipath personality registered as nr 7
	md: bind<sdb1>
	md: bind<sdf1>
	multipath: array md0 active with 1 out of 1 IO paths
	MULTIPATH conf printout:
	 --- wd:1 rd:1
	 disk0, o:1, dev:sdb1
	MULTIPATH conf printout:
	 --- wd:1 rd:1
	 disk0, o:1, dev:sdb1

2) Display details of a multipath device:

	mdadm --detail /dev/md0
	/dev/md0:
	        Version : 00.90.01
	  Creation Time : Mon Jun 14 12:25:04 2004
	     Raid Level : multipath
	     Array Size : 102534720 (97.78 GiB 105.00 GB)
	   Raid Devices : 1
	  Total Devices : 2
	Preferred Minor : 0
	    Persistence : Superblock is persistent

	    Update Time : Mon Jun 14 12:25:04 2004
	          State : clean, no-errors
	 Active Devices : 1
	Working Devices : 2
	 Failed Devices : 0
	  Spare Devices : 1

	    Number   Major   Minor   RaidDevice State
	       0       8       17        0      active sync   /dev/scsi/host2/=
bus0/target0/lun0/part1
	       1       8       81       -1      spare   	/dev/scsi/host3/bus0/=
target0/lun0/part1
	           UUID : 1611fd4d:f42482f8:49143747:eee27eff
	         Events : 0.1

3) Turns off an multipath device and unconfigures it:

	raidstop /dev/md0

   Syslog:

	md: md0 stopped.
	md: unbind<sdf1>
	md: export_rdev(sdf1)
	md: unbind<sdb1>
	md: export_rdev(sdb1)

4) Activating an existing multipath device:

	raidstart /dev/md0

   Syslog:

	md: raidstart(pid 1866) used deprecated START_ARRAY ioctl. This will n=
ot be supported beyond 2.6
	md: autorun ...
	md: considering sdf1 ...
	md:  adding sdf1 ...
	md:  adding sdb1 ...
	md: created md0
	md: bind<sdb1>
	md: export_rdev(sdf1)
	md: running: <sdb1>
	multipath: array md0 active with 1 out of 1 IO paths
	md: ... autorun DONE.


5) Display details of a multipath device:
	mdadm --detail /dev/md0
	/dev/md0:
	        Version : 00.90.01
	  Creation Time : Mon Jun 14 12:25:04 2004
	     Raid Level : multipath
	     Array Size : 102534720 (97.78 GiB 105.00 GB)
	   Raid Devices : 1
	  Total Devices : 1
	Preferred Minor : 0
	    Persistence : Superblock is persistent

	    Update Time : Mon Jun 14 14:21:42 2004
	          State : clean, no-errors
	 Active Devices : 1
	Working Devices : 1
	 Failed Devices : 0
	  Spare Devices : 0

	    Number   Major   Minor   RaidDevice State
	       0       8       17        0      active sync   /dev/scsi/host2/=
bus0/target0/lun0/part1
	           UUID : 1611fd4d:f42482f8:49143747:eee27eff
	         Events : 0.2

I have tried to test this configuration with kernel from version 2.6.2 =
to 2.6.6
but with the same error. Any idea?

Best regards

Marek
 --
Ing. Marek Uher
Linux System Specialist
Technology Division
T-Mobile Czech Republic a.s.
Tomickova 2144/1
149 00 Praha 4
Czech Republic
Mobile:	(+420) 603 400 728
Office:	(+420) 603 607 128
=46ax:		(+420) 603 600 796
E-mail:	marek.uher@t-mobile.cz
Web:		http://www.t-mobile.cz/
=20


---------- Disclaimer ----------
Informace obsa=BEen=E9 v tomto e-mailu jsou ur=E8eny v=FDlu=E8n=EC pro =
pot=F8eby jeho adres=E1ta. Text nebo p=F8=EDlohy mohou obsahovat utajov=
an=E9 informace, informace pova=BEovan=E9 spole=E8nost=ED T-Mobile za o=
bchodn=ED tajemstv=ED, p=F8=EDpadn=EC jin=E9 informace podl=E9haj=EDc=ED=
 ochran=EC dle p=F8=EDslu=B9n=FDch pr=E1vn=EDch p=F8edpis=F9. Pokud V=E1=
m tento e-mail byl omylem doru=E8en, zdr=BEte se, pros=EDm, jak=E9koli =
manipulace s textem =E8i p=F8=EDlohami, jako je kop=EDrov=E1n=ED, p=F8e=
sm=ECrov=E1n=ED, zp=F8=EDstupn=ECn=ED dal=B9=ED osob=EC a podobn=EC. O =
chybn=E9m doru=E8en=ED informujte odes=EDlatele a e-mail v=E8etn=EC p=F8=
=EDloh vyma=BEte ze sv=E9ho po=E8=EDta=E8e.
The information contained within this e-mail is intended only for the p=
erson or entity to which it is addressed. The text or attachments may c=
ontain confidential information, information considered a trade secret =
by T-Mobile or, as the case may be, other information subject to protec=
tion under the relevant legal regulations. If you receive this e-mail b=
y mistake, please refrain from copying, forwarding or disclosing the te=
xt or attachments to other persons, etc. Inform the sender of the mista=
ken delivery and delete the e-mail, including all attachments, from you=
r computer.

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
