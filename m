From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: Nested RAID and booting
Date: Wed, 8 Jun 2011 00:54:44 -0500
Message-ID: <D1.7A.00666.3AE0FED4@cdptpa-omtalb.mail.rr.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


	For financial reasons, I have had to temporarily create two members
of a RAID6 array by first creating a pair of RAID0 arrays from four member
disks.  The RAID6 array is currently re-shaping, and so far all seems well.
I do have a concern about what will happen when the system reboots, however.
In order to properly assemble the RAID6 array, the two RAID0 arrays will
first need to be assembled and running, correct?  How do I guarantee the two
RAID0 arrays will be up before mdadm attempts to assemble the RAID6 array?
Will simply putting them in the mdadm.conf file prior to the RAID6 array do
the trick?

