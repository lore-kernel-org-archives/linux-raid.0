From: Ray Van Dolson <rayvd@digitalpath.net>
Subject: dptapps and Engine connect failed: COMPATIBILITY number
Date: Tue, 24 Aug 2004 20:45:05 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040825034505.GA1286@digitalpath.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is somewhat related to my previous post. :-)  I decided to try out the
Adaptec Storage Manager utilities, even though they are from May 31, 2001 and
seem to be for Red Hat 7.0/6.2 (the box I'm on is RH 8.0).

I installed the rpm with rpm -ivh --nodeps since it wanted the dptdrivers RPM,
but the dpt_i2o driver was already installed on my system.

I started upt the dpt daemons -- no problems there.  Also verified that the
dpt_i2o driver was working:

[root@pop adaptec]# cat /proc/scsi/dpt_i2o/0
Adaptec I2O RAID Driver Version: 2.4 Build 5

Vendor: Adaptec  Model: 2100S            FW:370F
SCSI Host=scsi0  Control Node=/dev/dpti0  irq=11
        post fifo size  = 255
        reply fifo size = 255
        sg table size   = 56

Devices:
        ADAPTEC RAID-5           Rev: 370F
        TID=519, (Channel=0, Target=0, Lun=0)  (online)

Looks good so far, right?  Now I try:

[root@pop adaptec]# /usr/dpt/raidutil -d 0 -L physical
Engine connect failed: COMPATIBILITY number

:-(

Stumped here.  Any suggestions?  I tried without -d 0 and with -L array and
simply got the same error.  A google on the string brings up a few FreeBSD folks
having the same issue which turned out to be shared memory related.  No idea if
this is the case on my system or not, or if it would even translate the same way
between FreeBSD / Linux...
