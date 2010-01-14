From: Brett Russ <bruss@netezza.com>
Subject: non-fresh data unavailable bug
Date: Thu, 14 Jan 2010 10:10:57 -0500
Message-ID: <hinc60$fnh$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Slightly related to my last message here Re:non-fresh behavior, we have 
seen cases where the following happens:
* healthy 2 disk raid1 (disks A & B) incurs a problem with disk B
* disk B is removed, unit is now degraded
* replacement disk C is added; recovery from A to C begins
* during recovery, disk A incurs a brief lapse in connectivity.  At this 
point C is still up yet only has a partial copy of the data.
* a subsequent assemble operation on the raid1 results in disk A being 
kicked out as non-fresh, yet C is allowed in.

This presents quite a data-unavailability problem and basically requires 
recognizing the situation and hand assembling the array with disk A 
(only) first, then adding C back in.  Unfortunately this situation is 
hard to reproduce and we don't have a dump of the 'mdadm --examine' 
output for it yet.

Any thoughts on this while we try to get a better reproduction case?

Thanks,
Brett


