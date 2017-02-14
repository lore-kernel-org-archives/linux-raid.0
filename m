From: Tim Small <tim@buttersideup.com>
Subject: Which API for md state monitoring - sysfs vs. /proc/mdstat vs.
 GET_DISK_INFO ioctl
Date: Tue, 14 Feb 2017 14:43:32 +0000
Message-ID: <994ffd50-9041-a5e0-bbd9-1db704f6ad63@buttersideup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@kernel.org
List-Id: linux-raid.ids

Hello,

A design question for a user-space RAID monitoring tool.  The tool is
intended to export machine-readable md state so that the system owners
can creating automated alert policies etc.

Should it get its information on md device state from /proc/mdstat, or
/sys/block/*/md/ as a data source, or should it use the ioctl interface
that mdadm uses (on the basis that this is more complete / heavily tested).

I assume the issues are:

. usability (/proc/mdstat is intended to be human-readable so machine
parsing it seems bleugh - it's also incomplete?)

. stability (perhaps /sys/block/*/md/ is less stable than the ioctl or
proc interface?  Or perhaps it's just fine and won't break in
backward-incompatible ways?).

Any thoughts?

Should I see which way the recent "add bad block flag to disk state"
patch-set thread goes?

Tim.
