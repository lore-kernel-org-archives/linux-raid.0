From: "Donghui Wen" <dhwen@protegonetworks.com>
Subject: software raid hangs.
Date: Tue, 8 Jul 2003 14:23:18 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <003401c34597$26521e40$df01010a@moon>
References: <4D618F6493CE064A844A5D496733D667031A01@freedom.icomedias.com> <200307072029.14998.bernd-schubert@web.de> <200307071142330484.8AF6968B@shargaas.coreyfro.com> <200307081851.31385.bernd-schubert@web.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
     I am testing software-raid with 3ware-7500 controller on a
hot-swappable chassis.
I found out that software-raid 5 could not even sustain 1 disk failure in
this case.
May be it is the limitation of linux scsi driver or 3ware driver. Do your
guys have
any ideas what it is going on? Here is what I did:
    * setup 3ware-7500 as jbod mode with 7 ide disks.
    * make raid 5  (md0) with sdb1 ~ sdh1
    * mount /dev/md0 /u02
    * cd /u02 and run bonnie++
    * when bonnie++ is running, I pulled out one disk (sda). bonnie++ will
switch to state 'D'
      and hangs there.
    * Any disk operation in /u02 will hangs, for example : echo "Hello,
world" > aaa.txt

    If the whole operating system is installed on a software-raid 5
partition, in this case,
the system hangs since disk io will cause a process switch to state 'D'.
    I think these is the limitation of linux scsi driver( scsi itself does
not support hotplug),
but if it is true, software-raid is not a real raid solutions, because if
one disk  is pulled out,
the whole system hangs.

Thanks!

Donghui



