From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: fsck problems.  Can't restore raid
Date: Sun, 27 Dec 2009 00:13:21 -0600
Message-ID: <07.C2.04641.40BF63B4@cdptpa-omtalb.mail.rr.com>
References: <1261875695.10448.1335.camel@vibe>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1261875695.10448.1335.camel@vibe>
Sender: linux-raid-owner@vger.kernel.org
To: 'Rick Bragg' <lists@gmnet.net>, 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> # mdadm --examine /dev/sdb1
> mdadm: No md superblock detected on /dev/sdb1.
> 
> (Does this mean that sdb1 is bad? or is that OK?)

	It doesn't necessarily mean the drive is bad, but the superblock is
gone.  Are you having mdadm monitor your array(s) and send informational
messages to you upon RAID events?  If not, then what may have happened is
you lost the superblock on sdb1 and at some other time - before or after -
lost the sda drive.  Once both events had taken place, your array is toast.

	All may not be lost, however.  First of all, take care when
re-arranging not to lose track of which drive was which at the outset.  In
fact, other than the sda drive, you might be best served not to move
anything.  Take special care if the system re-assigns drive letters, as it
can easily do.

	When you created your array, one of the steps you should have taken
was to put the drive configuration into /etc/mdadm.conf.  In particular, you
may need to attempt to re-create the array by mimicking the original command
used to create the array, basically zeroing out the superblocks and starting
again from scratch.  If you do it correctly, and are careful, it may be
possible to recover the array.  Note, however, the array parameters must
match the original configuration exactly, including the role each drive
plays in the array.  If you get them out of line, you can really destroy all
the data.

	What are the contents of /etc/mdadm.conf?


