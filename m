From: "David Wasylciw" <mailinglists-david@wasylciw.com>
Subject: Problem with RAID5 + ext3 expansion
Date: Sat, 23 Oct 2004 02:25:07 -0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <0MKz1m-1CLEOr1JV2-0003x7@mrelay.perfora.net>
Reply-To: <mailinglists-david@wasylciw.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Alright, so, I'm not sure if this is the right place to come to about this
problem but here's a overview of my setup:
6 x 250Gb IDE Hard Drives, generally I use evms and have a RAID5 array
built, with a lvm container on top of it and then my volumes. What I had
been trying to do was expand one of my ext3 volumes on top of the lvm, I had
taken it offline and evms was proceeding with the expansion, but then the
server locked up. Now, the reason I think this list might be the right spot
is that whenever I boot up it hangs after detecting the arraying and
beginning a sync. To troubleshoot I attempted to remove the md0 device and
recreate it with mdadm. Upon doing this it hung immediately. Mdadm reported
that the array still existed and that it would try to bring it online, at
that point it just hung. I didn't get a kernel panic error or anything just
a blank line.  Are there any logs that I should send along to the list or if
perhaps anyone has any ideas on what might have gone wrong/how to fix it?

Thanks,
David


