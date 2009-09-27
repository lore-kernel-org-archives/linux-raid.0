From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Remote NAS
Date: Sun, 27 Sep 2009 15:09:21 -0500
Message-ID: <20090927200900727.HPDY1442@cdptpa-omta01.mail.rr.com>
References: <92388.79363.qm@web38807.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <92388.79363.qm@web38807.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Using the array to store MythTV recordings (very large files), but when it
> does commercial flagging (lots of writes) the array is so busy that GUI
> response is very slow.  I've set readahead cache to optimal (4096, after
> testing most sizes), so read should be OK.  I know far is optimized for
> read, so I chose offset in hopes it would bring up write speed.  Is there
> a way to speed up writes?

	Oh, on a follow up to my previous message, if you do create a
separate drive system for your database, and drive write performance is
still an issue, you might consider a non redundant striped array (RAID0 or
perhaps an LVM volume) for the database partition.  Two or three small,
relatively inexpensive, fairly high performance disks can be glued together
into a rather small array with a very small chunk size for absolute maximum
read and write capability of database files.  Note the video and backup
arrays can employ port multipliers and fairly inexpensive drive controllers
for maximum economy, while the database array should probably be a multilane
solution with a fairly high performance drive controller.

