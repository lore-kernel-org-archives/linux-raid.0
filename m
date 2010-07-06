From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: Worrisome rebuild
Date: Tue, 6 Jul 2010 04:09:52 -0500
Message-ID: <83.AC.05585.CC2F23C4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


	The monthly rebuild for my servers took place over the weekend, and
I got some worrisome results from one of them.  I have never before had
mismatches on any array except those on which some sort of drive event -
like a kicked drive or read failure - had occurred.  This time, however,
there were mismatches on 3 out of 4 arrays on one of the servers.  Two of
the arrays have drives in common, but the third does not.  What's more,
there is a third array that did not report any mismatches with the same
members as the first two.  Specifically, md0 is a RAID6 array comprised of
12 complete, unpartitioned drives, all unrelated to md1, md2, or md3.
Arrays md1, md2, and md3 are all RAID1 arrays comprised of a pair of
partitions on a single pair of drives.  Md1 is comprised of sda1 and hda1,
md2 is sda2 and hda2, and md3 is sda3 and hda3.  Md1 did not report any
mismatches.  It is different than the other arrays in that it has a 0.9
superblock and its second member (hda1) is set wrote-mostly.  The other two
arrays with hdaX as a member are supposed to have hdaX set as write-mostly,
but the setting does not seem to have stuck (or at least mdadm is not
reporting them as write-mostly).  Here was the report from the rebuild:

syslog:Jul  4 21:12:14 RAID-Server mdadm[4171]: RebuildFinished event
detected on md device /dev/md0, component device  mismatches found: 40
syslog.1:Jul  4 02:16:13 RAID-Server mdadm[4171]: RebuildFinished event
detected on md device /dev/md3, component device  mismatches found: 37632
syslog.1:Jul  4 05:14:35 RAID-Server mdadm[4171]: RebuildFinished event
detected on md device /dev/md2, component device  mismatches found: 128

	Does anyone have any idea what is going on, here?  These arrays have
been apparently rock stable for several months.  I had some troubles with
the drives on the backup server (which is almost a mirror of this server),
and upgrading the backup to GRUB2 was a bit painful, but this one hasn't
reported so much as a hiccough.  SMART doesn't seem to have had anything of
interest to say about the drives recently, although the information provided
by SMART on the PATA drive is rather limited in any case.

