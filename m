From: "Michael Daskalov" <MDaskalov@technologica.biz>
Subject: Problems with root-raid shutdown.
Date: Fri, 9 May 2003 14:27:15 +0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15F26D0D9E18E24583D912511D668FF8017F87@exchange.ad.tlogica.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,
I have SuSE 7.2 on a machine with 4 HDDs.
I have configured my root and boot to be on RAID1.
 
I installed the machine with he latest available kernel as a patch to
SuSE 7.2
(ftp://ftp.suse.com/pub/suse/i386/update/7.2/kernel/2.4.18-20030324/k_de
flt-2.4.18-262.i386.rpm)
I had a problem with the IDE devices. Two blocks on two different disk
were reported as bad and my raid5 was broken. Testing the IBM 120GB
disks with the software provided by IBM/Hitachi revealed there were no
problems in the disks.
 
Hoping that this was due to a problem with the IDE driver in the last
kernel, I tried
ftp://ftp.suse.com/pub/people/mantel/next/RPM/kernel-source-2.4.20.SuSE-
62.i586.rpm
 
I compiled it myself including md,raid1,raid5 in the kernel (not as
modules)
 
and there exists the following problem:

After every shutdown or reboot my /dev/md1 (rootfs) device needs
recyncing.
It's because it's not stopped cleanly on shutdown or reboot.
 
All other /dev/md? devices are stopped on shutdown, only this one is
not.
On the console I see messages like
....skip....
/dev/md0: switching to read-only mode
....skip....
/dev/md2: switching to read-only mode
....skip....
/dev/md3: switching to read-only mode
....skip....
/dev/md4: switching to read-only mode
 
but I don't see that message for /dev/md0. Instead I see a message
saying that
/dev/md1 is still in use.

Anyone know why this happens on newer kernels? How can I fix the
problem?
 
I didn't have this problem on k_deflt-2.4.18-262.i386.rpm . Does this
version have any known problems with Intel 845 PESV motherboards?

Should I try a stock kernel from www.kernel.org ? Which one supports
LVM?
 
Thanks in advance,
 
Mihail Daskalov
MDaskalov@technologica.biz 
