From: Andrew Dunn <andrew.g.dunn@gmail.com>
Subject: RAID, ext4, barriers
Date: Sun, 08 Nov 2009 12:01:41 -0500
Message-ID: <4AF6F975.8030903@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I noticed this in my dmesg:

[ 7089.116953] JBD: barrier-based sync failed on md0:8 - disabling barriers
[ 9296.850098] JBD: barrier-based sync failed on md1:8 - disabling barriers

I was wondering if this is a problem. I saw some links where people were
listing this as a bug report for ext[2,3,4] partitions. I don't know if
it will be a problem for me, any experience?

-- 
Andrew Dunn
http://agdunn.net

