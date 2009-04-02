From: "David Lethe" <david@santools.com>
Subject: RE:
Date: Wed, 1 Apr 2009 23:22:24 -0500
Message-ID: <F2C688D6A021E34CB81C0E631EF4C093017A43D1@34093-C4-EVS1.exchange.rackspace.com>
References: <20090402041606.HVVA17102.cdptpa-omta03.mail.rr.com@Leslie>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <20090402041606.HVVA17102.cdptpa-omta03.mail.rr.com@Leslie>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Lelsie Rhorer
> Sent: Wednesday, April 01, 2009 11:16 PM
> To: linux-raid@vger.kernel.org
> Subject:
> 
> I'm having a severe problem whose root cause I cannot determine.  I
> have a
> RAID 6 array managed by mdadm running on Debian "Lenny" with a 3.2GHz
> AMD
> Athlon 64 x 2 processor and 8G of RAM.  There are ten 1 Terabyte SATA
> drives, unpartitioned, fully allocated to the /dev/md0 device. The
> drive
> are served by 3 Silicon Image SATA port multipliers and a Silicon
Image
> 4
> port eSATA controller.  The /dev/md0 device is also unpartitioned, and
> all
> 8T of active space is formatted as a single Reiserfs file system.  The
> entire volume is mounted to /RAID.  Various directories on the volume
> are
> shared using both NFS and SAMBA.
> 
> Performance of the RAID system is very good.  The array can read and
> write
> at over 450 Mbps, and I don't know if the limit is the array itself or
> the
> network, but since the performance is more than adequate I really am
> not
> concerned which is the case.
> 
> The issue is the entire array will occasionally pause completely for
> about
> 40 seconds when a file is created.  This does not always happen, but
> the
> situation is easily reproducible.  The frequency at which the symptom
> occurs seems to be related to the transfer load on the array.  If no
> other
> transfers are in process, then the failure seems somewhat more rare,
> perhaps accompanying less than 1 file creation in 10..  During heavy
> file
> transfer activity, sometimes the system halts with every other file
> creation.  Although I have observed many dozens of these events, I
have
> never once observed it to happen except when a file creation occurs.
> Reading and writing existing files never triggers the event, although
> any
> read or write occurring during the event is halted for the duration.
> (There is one cron jog which runs every half-hour that creates a tiny
> file;
> this is the most common failure vector.)  There are other drives
> formatted
> with other file systems on the machine, but the issue has never been
> seen
> on any of the other drives.  When the array runs its regularly
> scheduled
> health check, the problem is much worse.  Not only does it lock up
with
> almost every single file creation, but the lock-up time is much longer
> -
> sometimes in excess of 2 minutes.
> 
> Transfers via Linux based utilities (ftp, NFS, cp, mv, rsync, etc) all
> recover after the event, but SAMBA based transfers frequently fail,
> both
> reads and writes.
> 
> How can I troubleshoot and more importantly resolve this issue?
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I would try to first run hardware diagnostics.  Maybe you will get
"lucky" and one or more disks will fail diagnostics, which at least
means it will be easy to repair the problem.

This could very well be situation where you have a lot of bad blocks
that have to get restriped, and parity has to be regenerated.   Are
these the cheap consumer SATA disk drives, or enterprise class disks? 

David


