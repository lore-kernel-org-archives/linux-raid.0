From: danci@agenda.si
Subject: PDC202xx with 130GB+ disk
Date: Tue, 10 Jun 2003 13:59:14 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.53.0306101349300.4820@duplo.agenda.si>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello!

I have a problem with PDC202xx controller and WDC WD1800JB hard drives.
The PDC202xx shows only 130GB for this disks, while they should be 180GB.

Since I have no physical access to the system (I'm administering it
remotly), I've instructed the local sysadmin to update the controller BIOS
to the lates revision which is supposed to support 42 bit LBA.

That had no effect, fdisk still shows only 130GB available:

Command (m for help): p

Disk /dev/hde: 16 heads, 63 sectors, 266305 cylinders
Units = cylinders of 1008 * 512 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/hde1             1    266305 134217719+  83  Linux

Right now I have 2.4.18 kernel with (I think) no extra IDE or Promise
related patches.

Is the PDC202xx driver in 2.4.18 too old to recognize more than 130GB???
Would kernel upgrade help?

 Thanks, D.


 --
___________________________________________________________________
|    Danilo Godec    |     Agenda d.o.o.    |   ISP for business  |
|  jr. Syst. Admin   |    Gosposvetska 84   |     WAN networks    |
|  danci@agenda.si   |    si-2000 Maribor   |  Internet/Intranet  |
| tel:+386.2.2340860 |       Slovenija      | Application servers |
| fax:+386.2.2340854 | http://www.agenda.si |  Caldera OpenLinux  |
