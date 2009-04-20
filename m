From: PGNet <pgnet.trash+raid@gmail.com>
Subject: mdadm "--examine" & "--detail" report different metadata version info
	for same array
Date: Sun, 19 Apr 2009 22:27:47 -0700
Message-ID: <dbd51810904192227k6d0a8796y79156765839c1e84@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

running openSUSE 11.1,

	uname -ri
		2.6.27.21-27-xen x86_64

with,

	mdadm --version
		mdadm - v3.0-devel2 - 5th November 2008

creating a raid array with mdadm, e.g.

	mdadm -v --create /dev/md0 --level=raid10 --raid-devices=2
--layout=f2 --chunk=1024 --metadata=1.2 --bitmap=internal /dev/sda1
/dev/sdb1


checking array data from superblocks,

	mdadm --examine --scan
		ARRAY /dev/md/0 level=raid10 metadata=1.2 num-devices=2 UUID=138... name=nas:0

and active array,

	mdadm --detail --scan
		ARRAY /dev/md0 level=raid10 num-devices=2 metadata=1.02 name=nas:0 UUID=138...

reports two different metadata versions -- "1.02" and "1.2"

why are the two #s different?  convention, or bug?

thanks.
