From: "Rechenberg, Andrew" <ARechenberg@shermanfinancialgroup.com>
Subject: Global spare disks
Date: Tue, 4 Mar 2003 16:20:03 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <8075D5C3061B9441944E137377645118012E7A@cinshrexc03.shermfin.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good day,

I was wondering if there is any way to assign the same spare disk to
multiple software RAID arrays.  With hardware controllers you can assign
a disk as a "global hot spare."  When any disk connected to the
controller goes south (no matter which array it is in), the global spare
disk picks up the slack.

If there is no way to do this with raidtools, could I possibly use mdadm
to monitor for a failure and then hotadd a disk that is not part of any
array?

Thanks for your help.

Regards,
Andy.

Andrew Rechenberg
Infrastructure Team, Sherman Financial Group.
arechenberg@shermfin.com
